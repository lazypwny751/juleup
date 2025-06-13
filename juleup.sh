#!/bin/sh

set -e

export VER="1" HELP="false"

# d - set up dir.

die() {
	echo "${0##*/}: fatal: ${1}"
	exit "${2:-1}"
}

while getopts ":d:r:hv" opt
do
	case "${opt}" in
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
			export VERBOSE="$(( ${VERBOSE} + 1 ))"
		;;
		*)
			export COMM="${OPTARG}"
		;;
	esac
done

export JULE_DIR="${JULE_DIR:-~/.local/share/julelang}" RELEASE="${RELEASE:-0.1.5}"

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
		for c in "unzip" "curl" "uname"
		do
			if ! command -vV "${c}"
			then
				export NEXT="false"
			fi
		done

		if [ -z "${PLATFORM}" ]
		then
			case "$(uname)" in
				"Linux")
					export PLATFORM="linux"
				;;
			esac
		fi

		if "${NEXT}"
		then
			:
		else
			die "you have unresolved packages, please install that dependencies."
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
