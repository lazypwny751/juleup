#!/bin/sh

set -e

export VER="1" HELP="false"

# $JULE_DIR/julec/  <- compilers goes here.
# $JULE_DIR/jpkg/   <- jpkg releases goes here.
# $JULE_DIR/bin/    <- binaries goes here. 
# $JULE_DIR/pkg/    <- global package's goes here.
# $JULE_DIR/default <- default compiler information.

die() {
	echo "${0##*/}: fatal: ${1}"
	exit "${2:-1}"
}

while getopts ":a:p:d:r:hvc" opt
do
	case "${opt}" in
		"a")
			export ARCH="${OPTARG}"
		;;
		"p")
			export PLATFORM="${OPTARG}"
		;;
		"d")
			export JULE_DIR="${OPTARG}"
		;;
		"r")
			export RELEASE="${OPTARG}"
		;;
		"h")
			export HELP="true"
		;;
		"v")
			export VERBOSE="$(( VERBOSE + 1 ))"
		;;
		"c")
			export CLEAN="true"
		;;
		*)
			export COMM="${OPTARG}"
		;;
	esac
done

export JULE_DIR="${JULE_DIR:-${HOME}/.local/share/julelang}" RELEASE="${RELEASE:-0.1.5}" CLEAN="${CLEAN:-false}"

shift $((OPTIND - 1))
if [ "${#}" -gt 0 ]
then
	for arg in "${@}"; do
	    last="${arg}"
	done
	export COPT="${last}"
fi

case "${COPT:-help}" in
	"get"|"install"|"update"|"up")
		export NEXT="true"

		# check dependencies.
		for c in "unzip" "curl" "uname" "rm" "mkdir" "cp" "ln"
		do
			if ! command -vV "${c}"
			then
				export NEXT="false"
			fi
		done

		# Architecture.
		if [ -z "${ARCH}" ]
		then
			case "$(uname -m)" in
				"x86_64"|"amd64")
					export ARCH="amd64"
				;;
				"aarch64")
					export ARCH="arm64"
				;;
			esac
		fi

		# Platform.
		if [ -z "${PLATFORM}" ]
		then
			case "$(uname)" in
				"Linux")
					export PLATFORM="linux"
				;;
			esac
		fi

		if "${NEXT:-false}"
		then
			if "${CLEAN}" && [ -d "/tmp/tmp.juleup" ]
			then
				rm -rf "/tmp/tmp.juleup"
			fi

			mkdir -p "/tmp/tmp.juleup"
			echo "downloading prerelease for ${PLATFORM}-${ARCH} with release ${RELEASE}."

			if [ ! -f "/tmp/tmp.juleup/${PLATFORM}-${ARCH}v${RELEASE}.zip" ]
			then
				curl -sSL "https://github.com/julelang/jule/releases/download/jule${RELEASE}/jule-${PLATFORM}-${ARCH}.zip" -o "/tmp/tmp.juleup/${PLATFORM}-${ARCH}v${RELEASE}.zip"
			fi

			if [ ! -f "/tmp/tmp.juleup/${PLATFORM}-${ARCH}v${RELEASE}.zip" ]
			then
				die "0: can't get the pre-release, are you connected to internet? is the machine name correct or architecture is true?" 
			fi

			[ ! -d "/tmp/tmp.juleup/${RELEASE}" ] && mkdir "/tmp/tmp.juleup/${RELEASE}"

			unzip "/tmp/tmp.juleup/${PLATFORM}-${ARCH}v${RELEASE}.zip" -d "/tmp/tmp.juleup/${RELEASE}"

			if [ ! -d "/tmp/tmp.juleup/${RELEASE}/jule" ]
			then
				die "1: can't get the pre-release, are you connected to internet? is the machine name correct or architecture is true?"
			fi

			# Set up jule's home directory.
			echo "set up jule's home directory."
			mkdir -p "${JULE_DIR}/julec" "${JULE_DIR}/julec/${PLATFORM}"

			# check if exist's
			if [ -d "${JULE_DIR}/julec/${PLATFORM}/julec-${ARCH}v${RELEASE}" ]
			then
				unset opt
				printf "Do you want to replace the installation? (y/N)"
				read -r opt
				case "${opt}" in
					[yY])
						cp -r "/tmp/tmp.juleup/${RELEASE}/jule" "${JULE_DIR}/julec/${PLATFORM}/julec-${ARCH}v${RELEASE}"
						echo "recopied."
					;;
					*)
						echo "nothing to do, source is ready."
					;;
				esac
			else
				cp -r "/tmp/tmp.juleup/${RELEASE}/jule" "${JULE_DIR}/julec/${PLATFORM}/julec-${ARCH}v${RELEASE}"
			fi

			# This field forheck required current release of Jule compiler files.
			# and JCD stands for JuleC Directory.
			export JCD="${JULE_DIR}/julec/${PLATFORM}/julec-${ARCH}v${RELEASE}"

			for f in "${JCD}/bin/julec" "${JCD}/std" "${JCD}/src/julec" "${JCD}/src/julec/main.jule"
			do
				# Superficial file integration control.
				if [ -e "${f}" ]
				then
					echo "${f##*/} found.."
				else
					echo "${f##*/} doesn't exists!"
					export NEXT="false"
				fi
			done

			# Compile self hosted compiler.
			if "${NEXT:-false}"
			then
				if [ -f "${JCD}/bin/julec_dev" ]
				then
					unset opt
					printf "It seems to be like the Jule Compiler already exists, do you want to recompile it? (y/N)"
					read -r opt
					case "${opt}" in
						[yY])
							echo "recompiling JuleC v${RELEASE}."
							"${JCD}/bin/julec" --opt-deadcode -o "${JCD}/bin/julec_dev" "${JCD}/src/julec"	
							echo "julec v${RELEASE} is recompiled for ${PLATFORM}-${ARCH}."
						;;
						*)
							echo "julec v${RELEASE} is ready for ${PLATFORM}-${ARCH}."
						;;
					esac
				else
					echo "compiling julec v${RELEASE}.."
					"${JCD}/bin/julec" --opt-deadcode -o "${JCD}/bin/julec_dev" "${JCD}/src/julec"
					echo "julec v${RELEASE} is compiled for ${PLATFORM}-${ARCH}."
				fi

				# So close, set up if default compiler never exists.
				if [ ! -f "${JULE_DIR}/default" ]
				then
					printf "RELEASE=\"%s\"\nPLATFORM=\"%s\"\nARCH=\"%s\"\n" "${RELEASE}" "${PLATFORM}" "${ARCH}" > "${JULE_DIR}/default"
					[ ! -d "${JULE_DIR}/bin" ] && mkdir "${JULE_DIR}/bin"
					[ -f "${JULE_DIR}/bin/julec" ] && rm -rf "${JULE_DIR}/bin/julec"
					ln -s "${JCD}/bin/julec_dev" "${JULE_DIR}/bin/julec"
					echo "now JuleC v${RELEASE} is the default compiler."
				fi

				# Last thing check the path for jule's bin dir.
				case ":${PATH}:" in
				  *":${JULE_DIR}/bin:"*) 
					echo "already added to path."
				  ;;
				  *)
					case "${SHELL##*/}" in
						"bash")
							echo "PATH=\"\${PATH}:${JULE_DIR}/bin\"" >> "${HOME}/.bashrc"
							echo "added to path, please source again your .bashrc file or start new bash session."
						;;
					esac
				  ;;
				esac
			else
				die "your installation goes wrong, please open an issue: https://github.com/lazypwny751/juleup/issues/new"
			fi
		else
			die "you have unresolved packages, please install that dependencies."
		fi
	;;
	"default"|"current"|"info")
		if [ -f "${JULE_DIR}/default" ]
		then
			unset RELEASE PLATFORM ARCH

			# shellcheck disable=SC1091
			. "${JULE_DIR}/default"
			printf "default JuleC v%s on %s-%s.\n" "${RELEASE}" "${PLATFORM}" "${ARCH}"
		else
			die "default file doesn't exists, you're trying to use wrong path or you haven't make the setup(you can try \"${0##*/} up\")."
		fi
	;;
	"list"|"available")
		# check dependencies.
		export NEXT="true"

		if ! command -v uname > /dev/null; then
			export NEXT="false"
		fi

		# Architecture.
		if [ -z "${ARCH}" ]
		then
			case "$(uname -m)" in
				"x86_64"|"amd64")
					export ARCH="amd64"
				;;
				"aarch64")
					export ARCH="arm64"
				;;
			esac
		fi

		# Platform.
		if [ -z "${PLATFORM}" ]
		then
			case "$(uname)" in
				"Linux")
					export PLATFORM="linux"
				;;
			esac
		fi

		if "${NEXT:-false}"
		then
			export JCDIR="${JULE_DIR}/julec/${PLATFORM}"
			if [ -d "${JCDIR}" ]
			then
				for i in "${JCDIR}/"*
				do
					echo "${i##*/}"
				done
			else
				echo "no compilers found for ${PLATFORM:-unknown}."
			fi
		fi
	;;
	"set")
		# check dependencies.
		export NEXT="true"

		if ! command -v uname > /dev/null; then
			export NEXT="false"
		fi

		# Architecture.
		if [ -z "${ARCH}" ]
		then
			case "$(uname -m)" in
				"x86_64"|"amd64")
					export ARCH="amd64"
				;;
				"aarch64")
					export ARCH="arm64"
				;;
			esac
		fi

		# Platform.
		if [ -z "${PLATFORM}" ]
		then
			case "$(uname)" in
				"Linux")
					export PLATFORM="linux"
				;;
			esac
		fi
	;;
	"version")
		echo "${VER}"
	;;
	*)
		! "${HELP}" && echo "error: \"${COMM:-unknown}\" is an unknown option."
		printf "An Elegant Jule toolchain installer %s:\n\tversion: print's current juleup version.\n\t-h: get this helper text.\n" "${0##*/}"
		! "${HELP}" && exit 1
	;;
esac
