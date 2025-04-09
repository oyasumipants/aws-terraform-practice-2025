package main

import (
	"fmt"
	"log/slog"
	"os"

	"github.com/go-sql-driver/mysql"
	"github.com/jmoiron/sqlx"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
	"github.com/oyasumipants/terraform-practice-2025/api/internal/config"
	"github.com/oyasumipants/terraform-practice-2025/api/internal/handler"
	slogecho "github.com/samber/slog-echo"
)

func main() {
	logger := slog.New(slog.NewJSONHandler(os.Stderr, nil))
	slog.SetDefault(logger)

	cfg, err := config.LoadConfig("internal/config")
	if err != nil {
		slog.Error("Failed to load configuration", slog.Any("error", err))
		os.Exit(1)
	}
	slog.Info("Configuration loaded successfully")

	dbCfg := cfg.Database

	mysqlConfig := mysql.Config{
		User:                 dbCfg.User,
		Passwd:               dbCfg.Password,
		Net:                  "tcp",
		Addr:                 fmt.Sprintf("%s:%s", dbCfg.Host, dbCfg.Port),
		DBName:               dbCfg.Name,
		ParseTime:            true,
		AllowNativePasswords: true,
	}

	dsn := mysqlConfig.FormatDSN()

	db, err := sqlx.Connect("mysql", dsn)
	if err != nil {
		slog.Error("Failed to connect to database", slog.Any("error", err), slog.String("host", dbCfg.Host), slog.String("port", dbCfg.Port), slog.String("user", dbCfg.User))
		os.Exit(1)
	}
	defer db.Close()
	slog.Info("Database connection successful")

	e := echo.New()

	e.Use(slogecho.New(logger))
	e.Use(middleware.Recover())

	// Create handlers
	bookHandler := handler.NewBookHandler(db)
	healthHandler := handler.NewHealthHandler()

	// Health check endpoint
	e.GET("/live", healthHandler.Live)

	apiV1 := e.Group("/api/v1")

	apiV1.POST("/books", bookHandler.CreateBook)
	apiV1.GET("/books", bookHandler.GetBooks)
	apiV1.GET("/books/:book_id", bookHandler.GetBook)
	apiV1.PUT("/books/:book_id", bookHandler.UpdateBook)
	apiV1.DELETE("/books/:book_id", bookHandler.DeleteBook)

	serverPort := cfg.Server.Port
	if serverPort == "" {
		serverPort = "8080"
		slog.Warn("Server port not configured, using default", slog.String("port", serverPort))
	}

	slog.Info("Starting server", slog.String("port", serverPort))

	if err := e.Start(":" + serverPort); err != nil {
		e.Logger.Error(err)
		os.Exit(1)
	}
}
