---
id: docs/readme-baseline
kind: brief
title: Give README.md a stable baseline with purpose, test and CI sections
description: Replace the one-line README.md with a short stable structure (purpose, how to run the check, CI) so it stops changing in every commit, and keep tests/check_readme.sh passing.
status: active
cluster: docs
effort: 1h
priority: deferred
category: docs
tier: null
captured: 2026-11-06
trigger: null
dependencies:
  - testing/readme-check
done_when:
  - sh tests/check_readme.sh
  - grep -qx '## Purpose' README.md
  - grep -qx '## Running the check' README.md
  - grep -qx '## Continuous integration' README.md
  - git diff --name-only origin/main...HEAD | grep -v -E '^README\.md$' | wc -l | grep -qx ' *0'
schema_version: 1
qa_capability_score: 15
scorer_used: api
scored_at: '2026-11-06T16:29:22.305320+00:00'
score: 0.87
qa_score: 19
---

## Why
README.md is the only file in orbitgatetest1/gate-test and changed in 100% of commits. Today it holds only `# gate-test`. With no structure, every change rewrites it. A fixed set of sections gives later changes a defined place to go, and documents how to run the check added by testing/readme-check.

## Pre-flight (report, then continue)
1. Confirm `tests/check_readme.sh` exists on main and `sh tests/check_readme.sh` exits 0. If not, stop and report that testing/readme-check is not shipped.
2. Ask the repo owner for a one-sentence purpose for the repo. If no answer is available, use exactly: `Test repository for Patrick's GitHub App connection and first-read audit.` and say so in the PR body.

## Scope
1. Rewrite `README.md` to exactly this structure, ending with a newline:
   - Line 1: `# gate-test`
   - `## Purpose` followed by the one-sentence purpose from pre-flight step 2.
   - `## Running the check` followed by a fenced `sh` block containing `sh tests/check_readme.sh` and one sentence saying it prints `ok` on success.
   - `## Continuous integration` followed by one sentence: the check runs on GitHub Actions for pushes to main and for pull requests (workflow `.github/workflows/ci.yml`, added by ci/github-actions-baseline).
2. No other file changes.

## Out of scope
- Changes to tests/check_readme.sh (if a section check is wanted there, that is a separate brief).
- Badges, licence, contribution guidelines.
- Any file other than README.md.

## Tests
1. Before the change, `grep -qx '## Purpose' README.md` exits 1 (fails first).
2. After the change, every `done_when` command exits 0, including `sh tests/check_readme.sh` (title line and trailing newline still valid).

## Hand steps after merge
None.
