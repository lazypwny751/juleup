#!/bin/sh

set -e

export VERSION="0.0.1" CURROPT="help" UNKNOWN="0"

while getopts ":hvba:" opt
do
	case "${opt}" in
		"a")
			export ARCH="${OPTARG}"
		;;
		"b")
			export CURROPT="build"
		;;
		"v")
			export CURROPT="version"
		;;
		"h")
			export UNKNOWN="0" CURROPT="help"					
		;;
		*)
			export UNKNOWN="1" CURROPT="help" COMM="${OPTARG}"
		;;
	esac
done

case "${CURROPT:-help}" in
	"build")
		export ARCH="${ARCH:-unknown}"
		echo "${ARCH}"
	;;
	"version")
		echo "${VERSION}"
	;;
	"help")
		[ "${UNKNOWN}" -gt 0 ] && echo "error: \"${COMM:-unknown}\" is an unknown option."
		echo "An Elegant Jule toolchain installer ${0##*/}:\n\t-v: print's current juleup version.\n\t-h: get this helper text."
		[ "${UNKNOWN}" -gt 0 ] && exit 1
	;;
esac
