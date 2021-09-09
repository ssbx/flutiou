#!/bin/sh

#set -e

FLUTIOU_LIB=$(dirname $(readlink -f $0))
FLUTIOU_HOME=${HOME}/.flutio
FLUTIOU_INTERACTIVE="flutio -I"

usage () {
    echo "Usage: flutiou help | bincom"
    echo
    echo "Command:"
    echo "  -c <command>"
    echo "          The command to use to connect to the flutio player."
    echo "          The default is \"flutio -C\" but can be anything that "
    echo "          forward \"flutio -C\" stdin/stdout to the current process."
    echo
    echo "          Example to connect to a distant flutio process via ssh:"
    echo "              $ flutiou -c \"ssh someuser@somehost flutio -C\""
    echo "  -h      Print this message"
}

if $(test ${#} -gt 0); then

    case "${1}" in
        -h)
            usage; exit 0;;
        -p)
            if $(test ${#} -eq 2); then
                FLUTIOU_INTERACTIVE="${2}"
            else
                usage; exit 1
            fi;;

        ?)
            usage; exit 1;;
    esac
fi

if $(test ! -d ${FLUTIOU_HOME}); then
    mkdir ${FLUTIOU_HOME};
fi

wish ${FLUTIOU_LIB}/flutiou.tcl "${FLUTIOU_INTERACTIVE}"
