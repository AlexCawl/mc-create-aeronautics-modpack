# Repository Onboarding

This page covers local dependencies for working with the repository.

## Required Tools

- Git
- Docker with Compose support
- Go
- packwiz

Docker is required to run the server locally or on the VPS. Go is required to install packwiz.

## Install Go

On macOS with Homebrew:

```sh
brew install go
go version
```

Without Homebrew, install the official package from `go.dev/dl/`, then verify:

```sh
go version
```

Go installs user binaries into `~/go/bin` by default. It is normal to have a `~/go` directory.

Make Go-installed tools available in every new shell:

```sh
echo 'export PATH="$HOME/go/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

## Install packwiz

```sh
go install github.com/packwiz/packwiz@latest
```

Verify:

```sh
packwiz --version
```

Repository scripts use `packwiz` from `PATH` first and then try Go's default install location at `~/go/bin/packwiz`. Keeping `~/go/bin` on `PATH` is still recommended so manual `packwiz` commands work from any directory.

## Verify the Repository

Build the `.mrpack` artifact:

```sh
scripts/build-mrpack.sh
```

The result is written to `dist/mc-create-aeronautics.mrpack`. The `dist/` directory is ignored by Git.
