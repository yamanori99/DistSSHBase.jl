# Contributing

Internals of this repo.

- Users: [README.md](README.md), [README.ja.md](README.ja.md), [NEWS.md](NEWS.md)
- API docs: [stable](https://yamanori99.github.io/DistSSHBase.jl/stable/) ([docs/README.md](docs/README.md))

This package is how a DistSSHKit family package names a host, reaches it over SSH, and prints help. Users add DistSSHKit.

CI names Julia **1.13** in the job. SSH E2E is this repo's `testenv/docker-ssh`. CI is `Pkg.test` (unit), JETLS, Aqua, Linux SSH E2E on Julia **1.13** (`test/e2e.jl`) on path-filtered PRs / **main** / a `Project.toml` version increase / dispatch, Gitleaks, light **Runic** `--check` (soft on PRs; monthly on `main`), and schedule-only **E2E weekly** (macOS Intel pulls the Linux worker image).

## Requirements

macOS, Linux, or WSL2 Ubuntu. Not native Windows (the kit shells out to `ssh` / `rsync`).

| What | Need |
| --- | --- |
| Library, `Pkg.test()`, docs | Julia **1.13+** |

Prefer [juliaup](https://github.com/JuliaLang/juliaup).

## Setup

```bash
git clone https://github.com/yamanori99/DistSSHBase.jl.git
cd DistSSHBase.jl
julia --project=. -e 'using Pkg; Pkg.instantiate()'
```

## Test

```bash
julia --project=. -e 'using Pkg; Pkg.test()'
```

Run this on Julia **1.13**. Layout: [test/README.md](test/README.md). When adding a file under `test/runtests.jl`, bump `_RUNTEST_N` so `[i/N]` stays honest.

```bash
julia -e 'using Pkg; Pkg.Apps.add("Runic")'   # once
runic --inplace src test docs testenv   # before push; not `.` (markdown out of scope)
./.github/jetls-check.sh    # hint+; same files as CI
./.github/aqua-check.sh     # latest registry Aqua; not part of Pkg.test()
./testenv/docker-ssh/scripts/up.sh --e2e
julia --project=docs -e 'using Pkg; Pkg.instantiate()'
julia --project=docs --color=yes docs/make.jl
gitleaks detect --source .
```

[Runic](https://github.com/fredrikekre/Runic.jl) CI
(`fredrikekre/runic-action@v1`, `version: '1'`) runs `--check` on every
tracked `.jl`. A Runic minor may make `--check` red: re-run
`runic --inplace src test docs testenv` and push.
Optional: after a bulk format squash, add the landed SHA to
[`.git-blame-ignore-revs`](.git-blame-ignore-revs) if blame is noisy.

VS Code: recommend the extensions in [`.vscode/extensions.json`](.vscode/extensions.json). User `settings.json` (do not commit):

```json
"customLocalFormatters.formatters": [
    {
      "command": "runic",
      "languages": ["julia"]
    }
]
```

JETLS CI uses [`.github/actions/jetls-check`](.github/actions/jetls-check/action.yml). Do not commit `.vscode/settings.json` to silence the Language Server.

### Julia versions

Workflows pass the version to `julia-actions/setup-julia`. The job name is that version. The floor is the line in [`.github/julia-slots.env`](.github/julia-slots.env) that matches `Project.toml`.

| Version | Role | Required |
| --- | --- | --- |
| **1.13** | `Project.toml` julia floor. Pkg.test, Aqua, JETLS, Documenter, E2E. Codecov `pkgtest` on **main push** only | yes |

When the floor moves, rename the **1.13** jobs and the `main` ruleset in the same PR.

### PR CI

These run as jobs of the `Test` workflow
([`.github/workflows/CI.yml`](.github/workflows/CI.yml)). Ubuntu:
`Pkg.test` 1.13, JETLS 1.13, Aqua 1.13, Gitleaks.
Documenter 1.13 is
[`.github/workflows/Documentation.yml`](.github/workflows/Documentation.yml).
Linux E2E (1.13) uses the path filter
(`src/**`, `test/**`, `testenv/**` minus markdown under those trees,
`Project.toml`, `.github/julia-slots.env`, `.github/workflows/CI.yml`). It also
runs on a **version increase** and `workflow_dispatch`.

[Runic](https://github.com/fredrikekre/Runic.jl) is a separate light
workflow ([`.github/workflows/runic.yml`](.github/workflows/runic.yml)).
It is not a required PR check. Monthly cron on `main` opens Issue
`Runic monthly failed` (`alert`) when `--check` is red.

These files **alone** skip the heavy jobs (UI: skipping; Pkg.test /
JETLS / Aqua do not start). Documenter still runs when `docs/**`, README,
`NEWS.md`, `src/**`, or `Project.toml` changed:

- `README.md`, `README.ja.md`, `CONTRIBUTING.md`, `NEWS.md`,
  `SECURITY.md`, `LICENSE`
- `.gitignore`, `.git-blame-ignore-revs`,
  `.github/pull_request_template.md`, `.coderabbit.yaml`
- `docs/**`, and markdown under `test/` / `testenv/`

A new root markdown file stays heavy until listed in
[`.github/actions/ci-heavy/action.yml`](.github/actions/ci-heavy/action.yml).
A `Project.toml` version increase skips none of this.

CI uploads Codecov on **main push** only (`Pkg.test` on 1.13, flag `pkgtest`). Public repo + Codecov OIDC (`id-token: write`). Status checks are informational (`codecov.yml`).

Required to merge (ruleset `main` uses these names):

- `Pkg.test - 1.13 - ubuntu-latest`
- `JETLS - 1.13 - ubuntu-latest`
- `Aqua - 1.13 - ubuntu-latest`
- `Documenter - 1.13 - ubuntu-latest`
- `Gitleaks`
- `ubuntu-latest → ubuntu-24.04`
- `PR label`

`ubuntu-latest → ubuntu-24.04` is the Linux kit parent (`runs-on: ubuntu-latest`) talking to SSH workers built `FROM ubuntu:24.04`. The worker tag stays `24.04`.

| When | Workflow | What |
| --- | --- | --- |
| Sunday 04:00 JST, Run workflow, or a version-increase push to `main` | `E2E weekly` | Build the worker image, then `macos-15-intel` + Colima runs the suite (`macos-15-intel → ubuntu-24.04`). Not a PR check. |

## Pull requests

- Branch from `main`. Squash-merge only. Merged heads are deleted.
- One reviewable change per PR.

Path labels come from [`.github/labeler.yml`](.github/labeler.yml) (`./.github/gen-labeler.sh`).

| Paths | Label |
| --- | --- |
| `src/**`, `test/unit/**`, package meta (`Project.toml`, `LICENSE`, `.gitignore`, `.gitattributes`, `.vscode/**`) | `area:base` |
| Harness under `test/` (not `unit/`) and `testenv/**` | `area:test` |
| `docs/**` | `area:docs` |
| `README.md`, `README.ja.md`, `NEWS.md`, `CONTRIBUTING.md`, `SECURITY.md` | `area:project-docs` |
| `.github/**`, `codecov.yml`, `.coderabbit.yaml` | `area:ci` |

Every PR also needs one type label: `bug`, `enhancement`, `breaking`, or `chore`. The Type workflow applies one from a closing issue, else from the branch prefix.

### CodeRabbit (experimental)

Open PRs may get an optional [CodeRabbit](https://docs.coderabbit.ai) pass.
Config is [`.coderabbit.yaml`](.coderabbit.yaml) on the **PR head** (not a
merge gate). JETLS / tests / e2e stay the gate.

## Release

| Label | Meaning |
| --- | --- |
| `breaking` | Incompatible behavior. May land **without** a version bump. |
| version cut | `Project.toml` `version` went up. CI compares that file with the base (`version-cut.sh`). There is no `cut` label. |

On a breaking line bump `x` in `0.x.y`; otherwise bump `y`. Do not ship an empty cut. Do not automate the bump or `@JuliaRegistrator register`.

Day-to-day users add DistSSHKit. Cut when [NEWS.md](NEWS.md) **Unreleased** has something General users of this package should get.
