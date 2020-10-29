let dhallix = ../dhall/package.dhall

let Derivation = dhallix.Derivation

let Args = dhallix.Args

let Builder = dhallix.Builder

let Environment-Variable = dhallix.Environment-Variable

let System = dhallix.System

let derivation = dhallix.derivation

let bootstrap-tools = ./bootstrap-tools.dhall

in  λ(source : Text) →
      derivation
        ( λ(store-path : Derivation → Text) →
            Args::{
            , builder = Builder.Exe "${store-path bootstrap-tools}/bin/bash"
            , args =
              [ "-c"
              , "${store-path bootstrap-tools}/bin/cp \$sourcePath \$out"
              ]
            , name = "source"
            , system = System.x86_64-linux
            , environment =
              [ { name = "source", value = Environment-Variable.Text source }
              , { name = "passAsFile"
                , value = Environment-Variable.Text "source"
                }
              ]
            }
        )
