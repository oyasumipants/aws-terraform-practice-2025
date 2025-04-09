package handler

import (
	"database/sql"
	"log/slog" // Import slog
	"net/http"
	"strconv"
	"time" // Import time package

	"github.com/jmoiron/sqlx"
	"github.com/labstack/echo/v4"
	"github.com/oyasumipants/terraform-practice-2025/api/internal/model" // Import the book model
)

// BookHandler holds the database connection
type BookHandler struct {
	db *sqlx.DB
}

// NewBookHandler creates a new BookHandler
func NewBookHandler(db *sqlx.DB) *BookHandler {
	return &BookHandler{db: db}
}

// CreateBook implements the CreateBook endpoint
func (h *BookHandler) CreateBook(c echo.Context) error {
	book := new(model.Book)
	slog.Info("CreateBook", slog.Any("book", book))

	if err := c.Bind(book); err != nil {
		slog.Warn("Failed to bind request body", slog.Any("error", err))
		return echo.NewHTTPError(http.StatusBadRequest, "Invalid request body")
	}

	if book.Title == "" || book.Author == "" {
		slog.Warn("Missing required fields: title or author")
		return echo.NewHTTPError(http.StatusBadRequest, "Missing required fields: title or author")
	}

	now := time.Now()
	book.CreatedAt = now
	book.UpdatedAt = now

	query := `INSERT INTO books (title, author, isbn, publisher, description, created_at, updated_at)
	          VALUES (:title, :author, :isbn, :publisher, :description, :created_at, :updated_at)`

	result, err := h.db.NamedExec(query, book)
	if err != nil {
		slog.Error("Database error inserting book", slog.Any("error", err))
		return echo.NewHTTPError(http.StatusInternalServerError, "Failed to create book")
	}

	lastID, err := result.LastInsertId()
	if err != nil {
		slog.Error("Failed to get last insert ID", slog.Any("error", err))
		return echo.NewHTTPError(http.StatusInternalServerError, "Failed to retrieve created book ID")
	}

	book.ID = lastID
	slog.Info("Successfully created book", slog.Int64("book_id", book.ID))

	return c.JSON(http.StatusCreated, book)
}

// PaginationInfo holds pagination details
type PaginationInfo struct {
	CurrentPage int  `json:"current_page"`
	PerPage     int  `json:"per_page"`
	NextPage    *int `json:"next_page,omitempty"`
}

// GetBooksResponse represents the response structure for GetBooks
type GetBooksResponse struct {
	Books      []model.Book   `json:"books"`
	Pagination PaginationInfo `json:"pagination"`
}

// GetBooks implements the GetBooks endpoint
func (h *BookHandler) GetBooks(c echo.Context) error {
	pageStr := c.QueryParam("page")
	perPageStr := c.QueryParam("per_page")

	page, err := strconv.Atoi(pageStr)
	if err != nil || page < 1 {
		page = 1
	}

	perPage, err := strconv.Atoi(perPageStr)
	if err != nil || perPage < 1 {
		perPage = 10
	}
	if perPage > 100 {
		perPage = 100
	}

	offset := (page - 1) * perPage

	limitPlusOne := perPage + 1
	books := []model.Book{}
	listQuery := "SELECT id, title, author, created_at FROM books ORDER BY created_at DESC LIMIT ? OFFSET ?"

	if err = h.db.Select(&books, listQuery, limitPlusOne, offset); err != nil {
		slog.Error("Database error fetching books", slog.Any("error", err))
		return echo.NewHTTPError(http.StatusInternalServerError, "Failed to fetch books")
	}

	var nextPage *int
	hasNextPage := len(books) > perPage

	if hasNextPage {
		nextPageNum := page + 1
		nextPage = &nextPageNum
		books = books[:perPage]
	}

	pagingInfo := PaginationInfo{
		CurrentPage: page,
		PerPage:     perPage,
		NextPage:    nextPage,
	}

	response := GetBooksResponse{
		Books:      books,
		Pagination: pagingInfo,
	}

	return c.JSON(http.StatusOK, response)
}

// GetBook implements the GetBook endpoint
func (h *BookHandler) GetBook(c echo.Context) error {
	bookID := c.Param("book_id")

	book := model.Book{}
	query := "SELECT id, title, author, isbn, publisher, description, created_at, updated_at FROM books WHERE id = ?"

	err := h.db.Get(&book, query, bookID)
	if err != nil {
		if err == sql.ErrNoRows {
			slog.Warn("Book not found", slog.String("book_id", bookID))
			return echo.NewHTTPError(http.StatusNotFound, "Book not found")
		}
		slog.Error("Database error fetching book", slog.String("book_id", bookID), slog.Any("error", err))
		return echo.NewHTTPError(http.StatusInternalServerError, "Failed to fetch book")
	}

	return c.JSON(http.StatusOK, book)
}

// UpdateBook implements the UpdateBook endpoint
func (h *BookHandler) UpdateBook(c echo.Context) error {
	bookIDStr := c.Param("book_id")
	bookID, err := strconv.ParseInt(bookIDStr, 10, 64)
	if err != nil {
		slog.Warn("Invalid book ID format", slog.String("book_id_str", bookIDStr))
		return echo.NewHTTPError(http.StatusBadRequest, "Invalid book ID format")
	}

	updatedBook := new(model.Book)
	if err := c.Bind(updatedBook); err != nil {
		slog.Warn("Failed to bind request body for update", slog.Any("error", err))
		return echo.NewHTTPError(http.StatusBadRequest, "Invalid request body")
	}

	if updatedBook.Title == "" || updatedBook.Author == "" {
		slog.Warn("Missing required fields for update: title or author")
		return echo.NewHTTPError(http.StatusBadRequest, "Missing required fields: title or author")
	}

	updatedBook.ID = bookID
	updatedBook.UpdatedAt = time.Now()

	query := `UPDATE books SET
	            title = :title,
	            author = :author,
	            isbn = :isbn,
	            publisher = :publisher,
	            description = :description,
	            updated_at = :updated_at
	          WHERE id = :id`

	result, err := h.db.NamedExec(query, updatedBook)
	if err != nil {
		slog.Error("Database error updating book", slog.Int64("book_id", bookID), slog.Any("error", err))
		return echo.NewHTTPError(http.StatusInternalServerError, "Failed to update book")
	}

	rowsAffected, err := result.RowsAffected()
	if err != nil {
		slog.Error("Failed to get rows affected after update", slog.Int64("book_id", bookID), slog.Any("error", err))
		return echo.NewHTTPError(http.StatusInternalServerError, "Failed to confirm book update")
	}
	if rowsAffected == 0 {
		slog.Warn("Book not found for update", slog.Int64("book_id", bookID))
		return echo.NewHTTPError(http.StatusNotFound, "Book not found")
	}

	finalBook := model.Book{}
	getQuery := "SELECT id, title, author, isbn, publisher, description, created_at, updated_at FROM books WHERE id = ?"
	err = h.db.Get(&finalBook, getQuery, bookID)
	if err != nil {
		slog.Error("Database error fetching book after update", slog.Int64("book_id", bookID), slog.Any("error", err))
		return echo.NewHTTPError(http.StatusInternalServerError, "Failed to fetch book after update")
	}
	slog.Info("Successfully updated book", slog.Int64("book_id", bookID))

	return c.JSON(http.StatusOK, finalBook)
}

// DeleteBook implements the DeleteBook endpoint
func (h *BookHandler) DeleteBook(c echo.Context) error {
	bookIDStr := c.Param("book_id")
	bookID, err := strconv.ParseInt(bookIDStr, 10, 64)
	if err != nil {
		slog.Warn("Invalid book ID format for delete", slog.String("book_id_str", bookIDStr))
		return echo.NewHTTPError(http.StatusBadRequest, "Invalid book ID format")
	}

	query := "DELETE FROM books WHERE id = ?"
	result, err := h.db.Exec(query, bookID)
	if err != nil {
		slog.Error("Database error deleting book", slog.Int64("book_id", bookID), slog.Any("error", err))
		return echo.NewHTTPError(http.StatusInternalServerError, "Failed to delete book")
	}

	rowsAffected, err := result.RowsAffected()
	if err != nil {
		slog.Error("Failed to get rows affected after delete", slog.Int64("book_id", bookID), slog.Any("error", err))
		return echo.NewHTTPError(http.StatusInternalServerError, "Failed to confirm book deletion")
	}
	if rowsAffected == 0 {
		slog.Warn("Book not found for delete", slog.Int64("book_id", bookID))
		return echo.NewHTTPError(http.StatusNotFound, "Book not found")
	}
	slog.Info("Successfully deleted book", slog.Int64("book_id", bookID))

	return c.NoContent(http.StatusNoContent)
}
