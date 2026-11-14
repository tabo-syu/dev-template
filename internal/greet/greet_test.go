package greet

import (
	"errors"
	"testing"
)

func TestMessage(t *testing.T) {
	tests := []struct {
		name    string
		in      string
		want    string
		wantErr error
	}{
		{name: "simple", in: "Gopher", want: "Hello, Gopher!"},
		{name: "trims whitespace", in: "  Gopher \n", want: "Hello, Gopher!"},
		{name: "keeps inner spaces", in: "Go Pher", want: "Hello, Go Pher!"},
		{name: "empty", in: "", wantErr: ErrEmptyName},
		{name: "only whitespace", in: " \t", wantErr: ErrEmptyName},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := Message(tt.in)

			if !errors.Is(err, tt.wantErr) {
				t.Fatalf("err = %v, want %v", err, tt.wantErr)
			}
			if got != tt.want {
				t.Errorf("Message(%q) = %q, want %q", tt.in, got, tt.want)
			}
		})
	}
}
