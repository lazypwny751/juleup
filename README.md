# juleup

> An elegant, POSIX-compliant toolchain installer for the [Jule programming language](https://jule.dev)

`juleup` is a minimal, POSIX-compliant shell script that simplifies the installation, management, and configuration of Jule compilers across platforms and architectures.

---

## 🛠 Features

- ✅ POSIX-compliant shell interface  
- 🎯 Target-specific installs (platform, arch, release)  
- 🧼 Clean setup support  
- 🔧 Default compiler switching  
- 🔍 Verbose debug output  
- 📦 List and fetch multiple compiler versions  

---

## 📦 Installation

Clone this repository and make the script executable:

```sh
git clone https://github.com/lazypwny751/juleup.git
cd juleup
chmod u+x juleup.sh
```

(Optionally move it to your `$PATH` for global usage:)

```sh
sudo mv juleup.sh /usr/local/bin/juleup
```

---

## 🚀 Usage

```sh
sh juleup.sh <command> [options]
```

### Commands

| Command   | Description                                           |
|-----------|-------------------------------------------------------|
| `version` | Show the current juleup version                       |
| `list`    | List installed Jule toolchains                        |
| `get`     | Fetch and configure a toolchain (-a, -p, -r optional) |
| `set`     | Set default toolchain (-a, -p, -r optional)           |

---

### Options

| Option | Argument     | Description                                 |
|--------|--------------|---------------------------------------------|
| `-a`   | `<arch>`     | Architecture (e.g. `x86_64`, `aarch64`)     |
| `-p`   | `<platform>` | Platform (e.g. `linux`, `windows`, `macos`) |
| `-d`   | `<dir>`      | Installation directory                      |
| `-r`   | `<release>`  | Release version (e.g. `0.1.4`, `0.1.5`)  |
| `-c`   |              | Clean setup — removes existing installation |
| `-v`   |              | Enable verbose output                        |
| `-h`   |              | Show this help message                      |

---

## 🧪 Examples

Install the latest stable Jule toolchain for Linux/x86_64:

```sh
sh juleup.sh -a x86_64 -p linux -r "0.1.5" get
```

Set a previously installed toolchain as the default:

```sh
sh juleup.sh -a x86_64 -p linux -r "0.1.5" set
```

List installed toolchains:

```sh
sh juleup.sh list
```

Get help:

```sh
sh juleup.sh -h
```

---

## ⚠️ Requirements

- POSIX-compliant shell (`sh`, `dash`, `bash`, etc.)
- `curl` or `wget` for downloading
- `tar` or `unzip` for extracting archives

# Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
Please ensure your changes stay POSIX-compliant and shell-portable.

# License
[GPL3](https://choosealicense.com/licenses/gpl-3.0/)
