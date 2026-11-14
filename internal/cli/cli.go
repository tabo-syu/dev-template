// Package cli parses arguments and runs the command.
package cli

import (
	"errors"
	"flag"
	"fmt"
	"io"

	"example.com/app/internal/greet"
)

// Version is set at build time with -ldflags. See the Makefile.
var Version = "dev"

// Exit codes returned by Run.
const (
	exitOK    = 0
	exitError = 1
	exitUsage = 2
)

// Run executes the CLI and returns the process exit code.
func Run(args []string, stdout, stderr io.Writer) int {
	fs := flag.NewFlagSet("app", flag.ContinueOnError)
	fs.SetOutput(stderr)
	name := fs.String("name", "world", "name to greet")
	showVersion := fs.Bool("version", false, "print version and exit")

	if err := fs.Parse(args); err != nil {
		if errors.Is(err, flag.ErrHelp) {
			return exitOK
		}
		return exitUsage
	}

	if *showVersion {
		fmt.Fprintln(stdout, Version)
		return exitOK
	}

	msg, err := greet.Message(*name)
	if err != nil {
		fmt.Fprintln(stderr, "error:", err)
		return exitError
	}
	fmt.Fprintln(stdout, msg)
	return exitOK
}
