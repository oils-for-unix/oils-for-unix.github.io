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

trim-each() {
  mkdir -p _tmp
  set -x
  for stage in 1 2 3; do
    # from Claude AI: -fuzz 10% -trim +repage works
    # then use -crop to remove the right
    convert oils-vim/screenshots/stage$stage-demo.png \
      -fuzz 10% -trim +repage -crop '400x0+0+0' _tmp/$stage.png
  done
}

side-by-side() {
  # I tried -resize '80%' 
  # But it makes the image BIGGER and fuzzier
  # Do it in <img> tag instead
  convert _tmp/{1,2,3}.png \
    +append \
    +repage oils-vim/screenshots/side-by-side.png
}

"$@"
