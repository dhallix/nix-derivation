let dhallix = ../dhall/package.dhall

let T = ../dhall/types.dhall

let busybox =
      dhallix.fetch-url
        { name = "busybox"
        , executable = True
        , url =
            "http://tarballs.nixos.org/stdenv-linux/i686/4907fc9e8d0d82b28b3c56e3a478a2882f1d700f/busybox"
        , sha256 =
            "ef4c1be6c7ae57e4f654efd90ae2d2e204d6769364c46469fa9ff3761195cba1"
        }

let `bootstrap-tools.tar.xz` =
      dhallix.fetch-url
        { name = "bootstrap-tools.tar.xz"
        , url =
            "http://tarballs.nixos.org/stdenv-linux/x86_64/4907fc9e8d0d82b28b3c56e3a478a2882f1d700f/bootstrap-tools.tar.xz"
        , sha256 =
            "abe3f0727dd771a60b7922892d308da1bc7b082afc13440880862f0c8823c09f"
        , executable = False
        }

let `unpack-bootstrap-tools.sh` =
      dhallix.fetch-url
        { name = "unpack-bootstrap-tools.sh"
        , url =
            "https://raw.githubusercontent.com/NixOS/nixpkgs/master/pkgs/stdenv/linux/bootstrap-tools/scripts/unpack-bootstrap-tools.sh"
        , sha256 = "0r0knqg97l05r1rrcmzyjl79rfdgmlslam8as8sq2lba54gyxl5k"
        , executable = False
        }

in  dhallix.derivation
      ( λ(store-path : T.Derivation → Text) →
          dhallix.Args::{
          , builder = T.Builder.Exe "${store-path busybox}"
          , args = [ "ash", store-path `unpack-bootstrap-tools.sh` ]
          , name = "bootstrap-tools"
          , system = T.System.x86_64-linux
          , environment =
            [ { name = "tarball"
              , value =
                  T.Environment-Variable.Text
                    (store-path `bootstrap-tools.tar.xz`)
              }
            ]
          }
      )
