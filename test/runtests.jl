#!/usr/bin/env julia

using Test
using DistSSHBase

include(joinpath(@__DIR__, "support.jl"))

const _RUNTEST_N = 11
const _RUNTEST_I = Ref(0)
function _runtest_announce(rel::AbstractString)
    _RUNTEST_I[] += 1
    println("[$(_RUNTEST_I[])/$_RUNTEST_N]  $rel")
    flush(stdout)
    return nothing
end

@testset "DistSSHBase" verbose = true begin
    _runtest_announce("unit/cli_entry.jl")
    include(joinpath(@__DIR__, "unit", "cli_entry.jl"))
    _runtest_announce("unit/argv.jl")
    include(joinpath(@__DIR__, "unit", "argv.jl"))
    _runtest_announce("unit/explain.jl")
    include(joinpath(@__DIR__, "unit", "explain.jl"))
    _runtest_announce("unit/help.jl")
    include(joinpath(@__DIR__, "unit", "help.jl"))
    _runtest_announce("unit/hosts.jl")
    include(joinpath(@__DIR__, "unit", "hosts.jl"))
    _runtest_announce("unit/julia_where.jl")
    include(joinpath(@__DIR__, "unit", "julia_where.jl"))
    _runtest_announce("unit/namespace.jl")
    include(joinpath(@__DIR__, "unit", "namespace.jl"))
    _runtest_announce("unit/paths.jl")
    include(joinpath(@__DIR__, "unit", "paths.jl"))
    _runtest_announce("unit/pkg_env.jl")
    include(joinpath(@__DIR__, "unit", "pkg_env.jl"))
    _runtest_announce("unit/remote.jl")
    include(joinpath(@__DIR__, "unit", "remote.jl"))
    _runtest_announce("unit/surface.jl")
    include(joinpath(@__DIR__, "unit", "surface.jl"))
end
