#!/usr/bin/env bash
#
# Usage:
#   ./run.sh <function name>

set -o nounset
set -o pipefail
set -o errexit

readonly HTML_DIR=oils-vim

write-index() {
  tree -H './' -T 'Files in oils-vim/' --charset=ascii $HTML_DIR \
    > $HTML_DIR/index.html
}

"$@"
