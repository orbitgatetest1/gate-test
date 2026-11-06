# gate-test

## Purpose

Test repository for Patrick's GitHub App connection and first-read audit.

## Running the check

```sh
sh tests/check_readme.sh
```

The check prints `ok` on success.

## Continuous integration

The check runs on GitHub Actions for pushes to main and for pull requests (workflow `.github/workflows/ci.yml`, added by ci/github-actions-baseline).
