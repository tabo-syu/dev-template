// Command app is the entry point. Keep logic in internal/.
package main

import (
	"os"

	"example.com/app/internal/cli"
)

func main() {
	os.Exit(cli.Run(os.Args[1:], os.Stdout, os.Stderr))
}
