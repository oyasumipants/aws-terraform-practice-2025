package handler

import (
	"net/http"

	"github.com/labstack/echo/v4"
)

// HealthHandler holds the health check handler functionality
type HealthHandler struct{}

// NewHealthHandler creates a new HealthHandler
func NewHealthHandler() *HealthHandler {
	return &HealthHandler{}
}

// Live handles the /live endpoint for health checks
func (h *HealthHandler) Live(c echo.Context) error {
	return c.JSON(http.StatusOK, map[string]string{
		"status": "ok",
	})
}
