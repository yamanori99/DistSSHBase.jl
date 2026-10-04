#!/usr/bin/env julia
# Test double for `DISTSSHKIT_TEST_SSH`. Host talking only: `uname` and `command -v julia`.

function main()
    script = length(ARGS) >= 2 ? ARGS[2] : ""
    logp = get(ENV, "DISTSSHKIT_TEST_SSH_LOG", "")
    if !isempty(logp)
        open(logp, "a") do io
            println(io, script)
        end
    end
    if occursin("uname -s", script)
        get(ENV, "DISTSSHKIT_TEST_UNAME_FAIL", "") == "1" && exit(1)
        exit(0)
    end
    if occursin("command -v julia", script) || occursin("which julia", script)
        w = get(ENV, "DISTSSHKIT_TEST_JULIA_WHICH", "")
        isempty(w) || println(w)
        exit(0)
    end
    if occursin("--version", script)
        ver = strip(get(ENV, "DISTSSHKIT_TEST_JULIA_VERSION", ""))
        println(isempty(ver) ? "julia version $VERSION" : ver)
        exit(0)
    end
    return exit(1)
end

main()
