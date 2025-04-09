package model

import "time"

// Book represents the structure for a book in the database
type Book struct {
	ID          int64     `json:"id,omitempty" db:"id"`
	Title       string    `json:"title" db:"title"`
	Author      string    `json:"author" db:"author"`
	ISBN        *string   `json:"isbn,omitempty" db:"isbn"`
	Publisher   *string   `json:"publisher,omitempty" db:"publisher"`
	Description *string   `json:"description,omitempty" db:"description"`
	CreatedAt   time.Time `json:"created_at" db:"created_at"`
	UpdatedAt   time.Time `json:"updated_at" db:"updated_at"`
}
