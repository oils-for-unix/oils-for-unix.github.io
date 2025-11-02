#!/usr/bin/env bash
#
# Usage:
#   ./run.sh <function name>

set -o nounset
set -o pipefail
set -o errexit

readonly HTML_DIR=oils-vim

readonly OILS_REPO=../oils

cmark() {
  # A filter to making reports
  PYTHONPATH=$OILS_REPO:$OILS_REPO/vendor $OILS_REPO/doctools/cmark.py "$@"
}

html-head() {
  # python3 because we're outside containers
  PYTHONPATH=$OILS_REPO python3 $OILS_REPO/doctools/html_head.py "$@"
}

index-html() {
  local title='pages.oils.pub'

  html-head --title "$title" \
    "web/base.css"

  echo '
  <body class="width35">
    <style>
      code { color: green; }
    </style>

    <p id="home-link">
      <a href="https://oils.pub/">oils.pub</a>
    </p>
  '

  cmark <<EOF
# $title

## Vim Highlighter

- [oils-for-unix/oils.vim](https://github.com/oils-for-unix/oils.vim/) on Github
  - [oils.vim Test Output](oils-vim/index.html)


## test/spec-compat

- [2025-06-15](spec-compat/2025-06-15/renamed-tmp/spec/compat/TOP.html)
- [2025-06-19](spec-compat/2025-06-19/renamed-tmp/spec/compat/TOP.html)
- [2025-06-26](spec-compat/2025-06-26/renamed-tmp/spec/compat/TOP.html)
- [2025-07-28](spec-compat/2025-07-28/renamed-tmp/spec/compat/TOP.html)
- [2025-09-14](spec-compat/2025-09-14/renamed-tmp/spec/compat/TOP.html)
- [2025-11-02](spec-compat/2025-11-02/renamed-tmp/spec/compat/TOP.html)

## regtest/aports

- List of runs: <https://op.oils.pub/aports-build/published.html>

## About This Site

- Source Code: <https://github.com/oils-for-unix/oils-for-unix.github.io/>
  - Mirror: <https://codeberg.org/oils/pages/>

EOF

  echo '
  </body>
</html>
'
}

write-index-html() {
  index-html > index.html

  mkdir -p web
  cp -v $OILS_REPO/web/base.css web/
}

write-vim-index() {
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
