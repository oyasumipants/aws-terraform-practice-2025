package config

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"github.com/spf13/viper"
)

// Config represents the application configuration.
type Config struct {
	Database DatabaseConfig `mapstructure:"database"`
	Server   ServerConfig   `mapstructure:"server"`
}

// DatabaseConfig represents the database configuration.
type DatabaseConfig struct {
	User     string `mapstructure:"user"`
	Password string `mapstructure:"password"`
	Host     string `mapstructure:"host"`
	Port     string `mapstructure:"port"`
	Name     string `mapstructure:"name"`
}

// ServerConfig represents the server configuration.
type ServerConfig struct {
	Port string `mapstructure:"port"`
}

// LoadConfig loads the configuration from file or environment variables.
func LoadConfig(path string) (config *Config, err error) {
	v := viper.New()

	configName := os.Getenv("CONFIG")
	if configName == "" {
		configName = "config"
	}

	configDirPath := filepath.Join(path, "yaml")

	v.AddConfigPath(configDirPath)
	v.SetConfigName(configName)
	v.SetConfigType("yaml")

	v.SetEnvKeyReplacer(strings.NewReplacer(".", "_"))
	v.AutomaticEnv()

	if err = v.ReadInConfig(); err != nil {
		return nil, fmt.Errorf("failed to read config file '%s.yaml': %w", configName, err)
	}

	var cfg Config

	err = v.Unmarshal(&cfg)
	if err != nil {
		return nil, fmt.Errorf("failed to unmarshal config: %w", err)
	}

	return &cfg, nil
}
