# Tests

How this repo tests DistSSHBase. Maintainer checklist:
[CONTRIBUTING.md](../CONTRIBUTING.md).

## Run

From the package root:

```bash
julia --project=. -e 'using Pkg; Pkg.test()'
```

That is `test/runtests.jl`. Aqua is a separate CI job, not `Pkg.test()`.

`test/runtests.jl` prints `[i/N]` before each included file. `N` is `_RUNTEST_N`. When you add or remove an `include`, bump `_RUNTEST_N` so the count stays honest.

Real SSH (not part of `Pkg.test()`):

```bash
./testenv/docker-ssh/scripts/up.sh --e2e
```

`test/e2e.jl` is that suite. Details: [`testenv/docker-ssh/README.md`](../testenv/docker-ssh/README.md).
