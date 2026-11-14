package cli

import (
	"bytes"
	"strings"
	"testing"
)

func TestRun(t *testing.T) {
	tests := []struct {
		name       string
		args       []string
		wantCode   int
		wantStdout string
		wantStderr string // substring; empty means stderr must be empty
	}{
		{name: "default", args: nil, wantCode: 0, wantStdout: "Hello, world!\n"},
		{name: "with name", args: []string{"-name", "Gopher"}, wantCode: 0, wantStdout: "Hello, Gopher!\n"},
		{name: "version", args: []string{"-version"}, wantCode: 0, wantStdout: "dev\n"},
		{name: "help", args: []string{"-h"}, wantCode: 0, wantStderr: "Usage of app"},
		{name: "empty name", args: []string{"-name", " "}, wantCode: 1, wantStderr: "error: name must not be empty"},
		{name: "unknown flag", args: []string{"-nope"}, wantCode: 2, wantStderr: "flag provided but not defined"},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			var stdout, stderr bytes.Buffer

			got := Run(tt.args, &stdout, &stderr)

			if got != tt.wantCode {
				t.Errorf("exit code = %d, want %d", got, tt.wantCode)
			}
			if stdout.String() != tt.wantStdout {
				t.Errorf("stdout = %q, want %q", stdout.String(), tt.wantStdout)
			}
			if tt.wantStderr == "" && stderr.Len() != 0 {
				t.Errorf("stderr = %q, want empty", stderr.String())
			}
			if !strings.Contains(stderr.String(), tt.wantStderr) {
				t.Errorf("stderr = %q, want it to contain %q", stderr.String(), tt.wantStderr)
			}
		})
	}
}
