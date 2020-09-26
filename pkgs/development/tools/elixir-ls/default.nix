{ elixir, fetchFromGitHub, buildMix }:

# let
  # inherit (beam) buildMix;

# in
buildMix rec {
  pname = "elixir-ls";
  version = "e50e153977af83238f196f0ab0c5aa0156c7573f";

  # refresh: nix-prefetch-git https://github.com/elixir-lsp/elixir-ls.git [--rev branchName | --rev sha]
  src = fetchFromGitHub {
    owner = "elixir-lsp";
    repo = "elixir-ls";
    rev = version;
    sha256 = "0yak3qd4vclg04lfy2dmn6656ia3x4k0v0r4899wvvy74vfbvab6";
    fetchSubmodules = false;
  };

  dontStrip = true;

  buildPhase = ''
    mix do compile --no-deps-check, elixir_ls.release
    '';

  installPhase = ''
    mkdir -p $out/bin
    cp -Rv release $out/lib
    # Prepare the wrapper script
    substitute release/language_server.sh $out/bin/elixir-ls \
      --replace 'exec "''${dir}/launch.sh"' "exec $out/lib/launch.sh"
    chmod +x $out/bin/elixir-ls
    # prepare the launcher
    substituteInPlace $out/lib/launch.sh \
      --replace "ERL_LIBS=\"\$SCRIPTPATH:\$ERL_LIBS\"" \
                "ERL_LIBS=$out/lib:\$ERL_LIBS" \
      --replace "elixir -e" "${elixir}/bin/elixir -e"
  '';
}
