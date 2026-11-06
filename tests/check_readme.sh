#!/bin/sh
# Checks README.md structure. Run from the repository root.
set -eu

fail() {
  echo "FAIL: $1" >&2
  exit 1
}

[ -s README.md ] || fail "README.md missing or empty"

first_line=$(head -n 1 README.md)
[ "$first_line" = "# gate-test" ] || fail "first line must be '# gate-test'"

last_byte=$(tail -c 1 README.md | od -An -c | tr -d ' ')
[ "$last_byte" = '\n' ] || fail "README.md must end with a newline"

echo ok
