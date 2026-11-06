---
id: ci/github-actions-baseline
kind: brief
title: Add a GitHub Actions workflow that runs the README check on every push and pull request
description: Add .github/workflows/ci.yml that runs sh tests/check_readme.sh on pushes to main and on every pull request, so changes no longer ship without an automated check.
status: active
cluster: ci
effort: 1h
priority: immediate_blocker
category: infra
tier: null
captured: 2026-11-06
trigger: null
dependencies:
  - testing/readme-check
done_when:
  - test -f .github/workflows/ci.yml
  - grep -q 'sh tests/check_readme.sh' .github/workflows/ci.yml
  - grep -q 'pull_request' .github/workflows/ci.yml
  - git diff --name-only origin/main...HEAD | grep -v -E '^\.github/workflows/ci\.yml$' | wc -l | grep -qx ' *0'
schema_version: 1
qa_capability_score: 15
scorer_used: api
scored_at: '2026-11-06T16:29:43.522030+00:00'
score: 0.88
qa_score: 20
---

## Why
The first read found no CI configuration in orbitgatetest1/gate-test: changes reach main with no automated check. testing/readme-check adds the repo's first test, `tests/check_readme.sh`. This brief runs it on GitHub for every push to main and every pull request, so a broken README.md shows a red check before merge.

## Pre-flight (report, then continue)
1. Confirm `tests/check_readme.sh` exists on main (dependency testing/readme-check is merged). If it does not, stop and report that the dependency is not shipped.
2. Run `ls .github/workflows 2>/dev/null` and report. Expected: no directory. If a workflow exists, report its name and stop.
3. Run `sh tests/check_readme.sh` locally and report the exit code. Expected: 0.

## Scope
1. Create `.github/workflows/ci.yml` with:
   - `name: ci`
   - `on:` `push` to branch `main`, and `pull_request` (all branches).
   - `permissions: contents: read`
   - one job `check` on `ubuntu-latest` with steps: `actions/checkout@v4`, then `run: sh tests/check_readme.sh`.
2. No other file changes.

## Out of scope
- Linters, markdownlint, or any tool that must be installed.
- Branch protection or required-check settings (a hand step for the owner).
- Changes to tests/check_readme.sh or README.md.

## Tests
1. Before the change, `test -f .github/workflows/ci.yml` exits 1 (fails first).
2. After the change, every `done_when` command exits 0.
3. On the pull request for this brief, the `ci / check` job runs and passes (visible in the PR's checks tab).
4. Negative check: on a scratch branch (not merged), remove the trailing newline from README.md and push; the `ci / check` job fails. Delete the scratch branch afterwards.

## Hand steps after merge
1. Optional: in GitHub settings for orbitgatetest1/gate-test, add `ci / check` as a required status check on main. Patrick does not change branch protection.
