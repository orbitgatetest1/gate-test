---
id: testing/readme-check
kind: brief
title: Add a shell test that checks README.md structure
description: Add tests/check_readme.sh, a dependency-free POSIX shell test that fails when README.md is missing, has the wrong title, or lacks a trailing newline, and fix README.md so it passes.
status: active
cluster: testing
effort: 1h
priority: immediate_blocker
category: quality
tier: null
captured: 2026-11-06
trigger: null
dependencies: []
done_when:
  - sh tests/check_readme.sh
  - test "$(tail -c 1 README.md | od -An -c | tr -d ' ')" = '\n'
  - git diff --name-only origin/main...HEAD | grep -v -E '^(tests/check_readme\.sh|README\.md)$' | wc -l | grep -qx ' *0'
schema_version: 1
qa_capability_score: 15
scorer_used: api
scored_at: '2026-11-06T16:29:08.962199+00:00'
score: 0.89
qa_score: 20
---

## Why
orbitgatetest1/gate-test has one tracked file, README.md, and no tests. README.md changed in 100% of commits (1 of 1 in the last 90 days) and nothing checks it. Today README.md is 11 bytes, `# gate-test`, with no trailing newline. A small test gives the repo its first automated check and a command CI can run (see ci/github-actions-baseline).

## Pre-flight (report, then continue)
1. Run `git ls-files` and report the list. Expected: only `README.md`. If other files exist, report them and continue; do not test them.
2. Run `xxd README.md` and report whether the last byte is `0a` (newline). Expected today: it is not.
3. Confirm `/bin/sh` exists. No other tool may be required.

## Scope
1. Create `tests/check_readme.sh` (POSIX sh, `#!/bin/sh`, `set -eu`, executable bit set with `git update-index --chmod=+x`). It runs from the repo root and checks, in order, printing `FAIL: <reason>` to stderr and exiting 1 on the first failure, or printing `ok` and exiting 0:
   a. `README.md` exists and is non-empty.
   b. The first line of `README.md` is exactly `# gate-test`.
   c. The last byte of `README.md` is a newline (`tail -c 1 README.md | od -An -c` contains `\n`).
2. Edit `README.md`: append a single trailing newline. Change no other byte.

## Out of scope
- Any CI configuration (covered by ci/github-actions-baseline).
- Rewriting README.md content or adding sections (covered by docs/readme-baseline).
- Adding any test framework, package manager, or dependency beyond /bin/sh and coreutils.

## Tests
1. Before the change to README.md, `sh tests/check_readme.sh` exits 1 and prints `FAIL: README.md must end with a newline` (fails first, because README.md currently has no trailing newline).
2. After the README.md fix, `sh tests/check_readme.sh` exits 0 and prints `ok`.
3. Temporarily change the first line of README.md to `# other`; the script exits 1 with `FAIL: first line must be '# gate-test'`. Revert.
4. Temporarily move README.md away; the script exits 1 with `FAIL: README.md missing or empty`. Restore.

## Hand steps after merge
None.
