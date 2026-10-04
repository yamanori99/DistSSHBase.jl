"""
DistSSHBase — how a DistSSHKit family package talks to a host.

Placement tokens, SSH, paths, help chrome, the `julia -m` entry, and where Julia is.
A new package depends on DistSSHBase, calls [`with_cli_entry`](@ref) in `main`, and uses these names instead of copying them.
Users add DistSSHKit.
"""
module DistSSHBase

using SHA

include("DistSSHBase/paths.jl")
include("DistSSHBase/explain.jl")
include("DistSSHBase/argv.jl")
include("DistSSHBase/hosts.jl")
include("DistSSHBase/host_tokens.jl")
include("DistSSHBase/cli_entry.jl")
include("DistSSHBase/help.jl")
include("DistSSHBase/ssh.jl")
include("DistSSHBase/julia_where.jl")
include("DistSSHBase/namespace.jl")

# Public family surface. Leading `_` stays private so 0.1 can still move.
for _n in names(@__MODULE__; all = true, imported = false)
    _s = string(_n)
    isempty(_s) && continue
    _s[1] == '_' && continue
    _s[1] == '#' && continue
    _n in (:DistSSHBase, :eval, :include) && continue
    @eval export $_n
end

end
