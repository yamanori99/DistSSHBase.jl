"""
DistSSHBase — how DistSSHKit talks to a host.

Placement tokens, SSH, paths, help chrome, and where Julia and juliaup are.
Users add DistSSHKit. This package is the trial cut held by DistSSHRun `trial/base-up` and is not registered.
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

end
