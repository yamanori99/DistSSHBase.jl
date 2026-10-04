Documenter site for DistSSHBase.jl. Sources live in `docs/src/`.

Kit users follow the [DistSSHKit manual](https://yamanori99.github.io/DistSSHKit.jl/stable/). This site is the shared API.

```bash
julia --project=docs -e 'using Pkg; Pkg.instantiate()'
julia --project=docs --color=yes docs/make.jl
```
