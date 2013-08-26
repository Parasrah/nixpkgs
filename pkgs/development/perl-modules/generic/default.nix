perl:

{ buildInputs ? [], name, ... } @ attrs:

perl.stdenv.mkDerivation (
  {
    outputs = [ "out" "man" ];

    doCheck = true;

    checkTarget = "test";

    # Prevent CPAN downloads.
    PERL_AUTOINSTALL = "--skipdeps";

    # From http://wiki.cpantesters.org/wiki/CPANAuthorNotes: "allows
    # authors to skip certain tests (or include certain tests) when
    # the results are not being monitored by a human being."
    AUTOMATED_TESTING = true;
  }
  //
  attrs
  //
  {
    name = "perl-" + name;
    builder = ./builder.sh;
    buildInputs = buildInputs ++ [ perl ];
  }
)
