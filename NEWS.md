# News

User-facing changes.
GitHub Releases may copy these sections (`Release notes:` on
`@JuliaRegistrator register`).

## Unreleased

- `parse_julia_version_full` and `get_remote_julia_version_full` keep the prerelease and the build. `parse_julia_version` and `get_remote_julia_version` stay major.minor.patch.

## 0.1.0

First release. Julia **1.13+**.

- A family package names a host, reaches it over SSH, and prints help
  from this package. Its outermost `main` calls `with_cli_entry`.
- Day-to-day users add DistSSHKit.
