{ nixpkgs ? import <nixpkgs> {}, compiler ? "default", doBenchmark ? false }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, aeson, attoparsec, base, blaze-html
      , bytestring, conduit, containers, exceptions, hspec, hspec-core
      , lib, monad-logger, mtl, mysql, mysql-simple, persistent
      , persistent-mysql, persistent-postgresql, persistent-sqlite
      , postgresql-simple, QuickCheck, resourcet, tagged
      , template-haskell, text, time, transformers, unliftio
      , unordered-containers
      }:
      mkDerivation {
        pname = "esqueleto";
        version = "3.5.8.1";
        src = ./.;
        libraryHaskellDepends = [
          aeson attoparsec base blaze-html bytestring conduit containers
          monad-logger persistent resourcet tagged template-haskell text time
          transformers unliftio unordered-containers
        ];
        testHaskellDepends = [
          aeson attoparsec base blaze-html bytestring conduit containers
          exceptions hspec hspec-core monad-logger mtl mysql mysql-simple
          persistent persistent-mysql persistent-postgresql persistent-sqlite
          postgresql-simple QuickCheck resourcet tagged template-haskell text
          time transformers unliftio unordered-containers
        ];
        homepage = "https://github.com/bitemyapp/esqueleto";
        description = "Type-safe EDSL for SQL queries on persistent backends";
        license = lib.licenses.bsd3;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  variant = if doBenchmark then pkgs.haskell.lib.doBenchmark else pkgs.lib.id;

  drv = variant (haskellPackages.callPackage f {});

in

  if pkgs.lib.inNixShell then drv.env else drv
