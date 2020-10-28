let dhallix = ./../dhall/package.dhall

let T = ./../dhall/types.dhall

let bootstrap-tools = ./bootstrap-tools.dhall

in  λ(source : Text) →
      dhallix.derivation
        ( λ(store-path : T.Derivation → Text) →
              dhallix.defaults.Args
            ⫽ { builder = T.Builder.Exe "${store-path bootstrap-tools}/bin/bash"
              , args =
                [ "-c"
                , "${store-path bootstrap-tools}/bin/cp \$sourcePath \$out"
                ]
              , name = "source"
              , system = T.System.x86_64-linux
              , environment =
                [ { name = "source"
                  , value = T.Environment-Variable.Text source
                  }
                , { name = "passAsFile"
                  , value = T.Environment-Variable.Text "source"
                  }
                ]
              }
        )
