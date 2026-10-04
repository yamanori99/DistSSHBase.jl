@testset "public surface" begin
    pubs = names(DistSSHBase)
    for n in pubs
        @test !startswith(string(n), "_")
    end
    for n in (
        :with_cli_entry,
        :cli_m,
        :run_on_host,
        :resolve_remote_julia,
        :parse_placement_token,
        :print_help_chrome,
        :canonical_local_path,
        :ssh_opts,
        :is_parent_host_name,
    )
        @test n in pubs
    end
end
