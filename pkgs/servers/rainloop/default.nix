{ stdenv, fetchurl, unzip, dataPath ? "/etc/rainloop" }: let
  common = { edition, sha256 }:
    stdenv.mkDerivation (rec {
      name = "rainloop-${edition}-${version}";
      version = "1.13.0";

      buildInputs = [ unzip ];

      unpackPhase = ''
        mkdir rainloop
        unzip -q -d rainloop $src
      '';

      src = fetchurl {
        url = "https://github.com/RainLoop/rainloop-webmail/releases/download/v${version}/rainloop-${edition}${stdenv.lib.optionalString (edition != "") "-"}${version}.zip";
        sha256 = sha256;
      };

      installPhase = ''
        mkdir $out
        cp -r rainloop/* $out
        rm -rf $out/data
        ln -s ${dataPath} $out/data
      '';

      meta = with stdenv.lib; {
        description = "Simple, modern & fast web-based email client";
        homepage = "https://www.rainloop.net";
        downloadPage = https://github.com/RainLoop/rainloop-webmail/releases;
        license = licenses.agpl3;
        platforms = platforms.all;
        maintainers = with maintainers; [ das_j ];
      };
    });
  in {
    rainloop-community = common {
      edition = "community";
      sha256 = "1skwq6bn98142xf8r77b818fy00nb4x0s1ii3mw5849ih94spx40";
    };
    rainloop-standard = common {
      edition = "";
      sha256 = "1fbnpk7l2fbmzn31vx36caqg9xm40g4hh4mv3s8d70slxwhlscw0";
    };
  }
