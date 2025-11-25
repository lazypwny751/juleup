# juleup

> [!WARNING]
> This project is being rewritten in its native language (Jule) on the [`dev`](https://github.com/lazypwny751/juleup/tree/dev) branch.

A POSIX-compliant toolchain installer for the Jule programming language.

juleup is a shell script that helps you install, manage, and configure Jule compilers. It supports different platforms and architectures.

## Installation

Clone the repository and make the script executable:

```sh
git clone https://github.com/lazypwny751/juleup.git
cd juleup
chmod +x juleup.sh
```

You can also move it to your path:

```sh
sudo mv juleup.sh /usr/local/bin/juleup
```

## Usage

Run the script with a command and optional flags:

```sh
sh juleup.sh [options] <command>
```

### Commands

- `version`: Show the current version.
- `list`: List installed toolchains.
- `get`: Download and configure a toolchain.
- `set`: Set the default toolchain.

### Options

- `-a <arch>`: Architecture (e.g. `amd64`, `arm64`).
- `-p <platform>`: Platform (e.g. `linux`).
- `-d <dir>`: Installation directory.
- `-r <release>`: Release version (e.g. `0.1.6`).
- `-c`: Clean setup (removes existing installation).
- `-v`: Enable verbose output.
- `-h`: Show help message.

## Examples

Install the latest Jule toolchain for Linux/amd64:

```sh
sh juleup.sh -a amd64 -p linux -r "0.1.6" get
```

Set a specific toolchain as default:

```sh
sh juleup.sh -a amd64 -p linux -r "0.1.6" set
```

List installed toolchains:

```sh
sh juleup.sh list
```

## Requirements

- A POSIX-compliant shell (`sh`, `bash`, etc.)
- `curl`
- `unzip`

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
Please ensure your changes stay POSIX-compliant and shell-portable.

## License

Distributed under the [GPL3 License](https://choosealicense.com/licenses/gpl-3.0/).
