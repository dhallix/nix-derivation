let dhallix = ../dhall/package.dhall

let Fetch-Url = dhallix.Fetch-Url

let Args = dhallix.Args

let Builder = dhallix.Builder

let System = dhallix.System

let Derivation = dhallix.Derivation

let Environment-Variable = dhallix.Environment-Variable

let derivation = dhallix.derivation

let fetch-url = dhallix.fetch-url

let busybox =
      Fetch-Url::{
      , name = "busybox"
      , executable = True
      , url =
          "http://tarballs.nixos.org/stdenv-linux/i686/4907fc9e8d0d82b28b3c56e3a478a2882f1d700f/busybox"
      , sha256 =
          "ef4c1be6c7ae57e4f654efd90ae2d2e204d6769364c46469fa9ff3761195cba1"
      }

let `bootstrap-tools.tar.xz` =
      Fetch-Url::{
      , name = "bootstrap-tools.tar.xz"
      , url =
          "http://tarballs.nixos.org/stdenv-linux/x86_64/4907fc9e8d0d82b28b3c56e3a478a2882f1d700f/bootstrap-tools.tar.xz"
      , sha256 =
          "abe3f0727dd771a60b7922892d308da1bc7b082afc13440880862f0c8823c09f"
      }

let `unpack-bootstrap-tools.sh` =
      Fetch-Url::{
      , name = "unpack-bootstrap-tools.sh"
      , url =
          "https://raw.githubusercontent.com/NixOS/nixpkgs/master/pkgs/stdenv/linux/bootstrap-tools/scripts/unpack-bootstrap-tools.sh"
      , sha256 = "19g9k9dff1bcijdy6slhvgyjlbnwril6rjs2spk4k6nhigpdkkl0"
      }

in  derivation
      ( λ(store-path : Derivation → Text) →
          Args::{
          , name = "bootstrap-tools"
          , builder = Builder.Exe "${store-path (dhallix.fetch-url busybox)}"
          , args = [ "ash", store-path (fetch-url `unpack-bootstrap-tools.sh`) ]
          , system = System.x86_64-linux
          , environment =
            [ { name = "tarball"
              , value =
                  Environment-Variable.Text
                    (store-path (fetch-url `bootstrap-tools.tar.xz`))
              }
            ]
          }
      )
