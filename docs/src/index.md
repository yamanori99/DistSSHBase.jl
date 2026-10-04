```@meta
CurrentModule = DistSSHBase
```

# DistSSHBase

Shared names for a DistSSHKit family package: placement tokens, SSH, paths, help text, and which package the user typed after `julia -m`.

Kit users add DistSSHKit. A new family package depends on this one and calls these names instead of copying them.

## Install

```julia
using Pkg
Pkg.add("DistSSHBase")
```

Julia 1.13 or later. The host still needs `ssh`. `rsync` and `git` are required only for the kit commands that call them. This package does not install those tools.

## Record the CLI entry

The outermost `main` records the package name. An inner `main` does not replace it.

```julia
using DistSSHBase

function julia_main()
    with_cli_entry(:DistSSHRun) do
        println(cli_heading("up"))   # DistSSHRun up
        println(cli_m())              # julia -m DistSSHRun
    end
end
```

Until that call, [`cli_entry`](@ref) is `DistSSHKit`, and queue-host titles keep the word `qhost` ([`cli_qhost`](@ref)).

## Name a host

A placement token is `parent`, `parent:N`, `child:NAME`, or `child:NAME:N`. `parent` is this job's DistSSHRun parent, not an SSH host. `NAME` is the SSH host. `:N` is a worker count for go / drive / ride. `setup` and `size` keep the hostname and ignore `:N`.

```jldoctest
julia> using DistSSHBase

julia> p = parse_placement_token("child:worker1:2");

julia> (p.role, p.name, p.n)
(:child, "worker1", 2)

julia> format_placement_token(:parent, "parent", 1)
"parent:1"
```

`local`, `localhost`, and `l` are ordinary SSH children (`child:local`), not the parent.

## Reach a host

[`run_on_host`](@ref) runs a Julia argv on an SSH host. With `julia=nothing` or `"auto"` it probes the same candidates as [`detect_julia_path`](@ref), then `exec`s that Julia. A non-zero `ssh` or remote exit returns the `Process`. A missing local `ssh` throws `ArgumentError`.

Remote paths that start with `~` are resolved on the host ([`ensure_remote_abs_path`](@ref)). Do not pass those strings through Julia's `expanduser`.

## Where files live

[`resolve_pkg_env`](@ref) splits a project into the directory of `Project.toml` and the directory of the active manifest. Setup rsyncs the manifest directory. A job's `--project` stays the project directory.

[`ns_path`](@ref) resolves a relative path under `DISTRIBUTED_OUTPUT_DIR` when that variable is set and the path exists there, otherwise under the project. [`cache_file`](@ref) stores a blob at `.distsshkit/cache/sha256/<digest>`. Project rsync excludes `.distsshkit/`.

## Help text

Family `--help` starts with [`print_help_chrome`](@ref): a cyan title and a rule. Section labels go through [`print_help_section`](@ref). Color is off when `NO_COLOR` is set or stdout is not a TTY.

The words for a missing hosts file, a missing `ssh` / `rsync` / `git`, or a bare placement token come from the `explain_*` functions. Pass `surface=:cli` or `surface=:api` so the hint matches the caller.
