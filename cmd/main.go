package main

import (
	"flag"
	"fmt"
	"os"
	"os/exec"
)

func main() {

	sync := flag.Bool("sync", false, "to sync the config")

	flag.Parse()
	if *sync {
		fmt.Println("ok")
	}
	cmd := exec.Command("sudo", "pacman", "-Syu")
	cmd.Stderr = os.Stderr
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout

	if err := cmd.Run(); err != nil {
		panic(err)
	}
}
