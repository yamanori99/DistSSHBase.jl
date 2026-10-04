using Test

@testset "juliaup where" begin
    @test DistSSHBase.remote_juliaup_candidates("Darwin") == [
        raw"$HOME/.juliaup/bin/juliaup",
        "/opt/homebrew/bin/juliaup",
        "/usr/local/bin/juliaup",
    ]
    @test DistSSHBase.remote_juliaup_candidates("Linux") == [raw"$HOME/.juliaup/bin/juliaup"]
    @test DistSSHBase._juliaup_candidate_sh_word(raw"$HOME/.juliaup/bin/juliaup") ==
        "\"\$HOME/.juliaup/bin/juliaup\""
    @test occursin(".juliaup", DistSSHBase.local_juliaup_candidates()[1])
    @test DistSSHBase.find_local_juliaup(String[]) === nothing
    _with_tempdir() do tmp
        ju = joinpath(tmp, "juliaup")
        write(ju, "#!/bin/sh\nexit 0\n")
        chmod(ju, 0o755)
        withenv("DISTSSHKIT_TEST_LOCAL_JULIAUP" => ju) do
            @test DistSSHBase.find_local_juliaup() == ju
            @test DistSSHBase._local_julia_beside_juliaup(ju) == joinpath(tmp, "julia")
        end
    end
end
