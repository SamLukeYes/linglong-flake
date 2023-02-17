{ runCommand
, linglong
, ostree
, repo ? "https://repo-dev.linglong.space/repos/repo"
}:

runCommand "linglong-root" {
  nativeBuildInputs = [ ostree ];
} ''
  mkdir -p $out/layers
  ostree --repo=$out/repo init --mode=bare-user-only
  ostree --repo=$out/repo config set --group core min-free-space-size 600MB
  ostree --repo=$out/repo remote add --no-gpg-verify repo ${repo}
  cp ${linglong}/share/linglong/config.json $out/config.json
''