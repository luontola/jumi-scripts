#!/bin/bash
set -eu

contains-line() {
    grep --line-regexp --quiet --fixed-strings -e "$1"
}

contains-line-matching() {
    grep --line-regexp --quiet -e "$1"
}
