// Package greet builds greeting messages. It is sample logic: replace it with your own.
package greet

import (
	"errors"
	"strings"
)

// ErrEmptyName is returned when the name is empty or only whitespace.
var ErrEmptyName = errors.New("name must not be empty")

// Message returns a greeting for name. Surrounding whitespace is trimmed.
func Message(name string) (string, error) {
	name = strings.TrimSpace(name)
	if name == "" {
		return "", ErrEmptyName
	}
	return "Hello, " + name + "!", nil
}
