    let dhallix = ./../dhall/package.dhall

in  let T = ./../dhall/types.dhall

in  let bootstrap-tools = ./bootstrap-tools.dhall

in    λ(source : Text)
    → dhallix.derivation
      (   λ(store-path : T.Derivation → Text)
        →   dhallix.defaults.Args
          ⫽ { builder =
                dhallix.Builder.Exe "${store-path bootstrap-tools}/bin/bash"
            , args =
                [ "-c"
                , "${store-path bootstrap-tools}/bin/cp \$sourcePath \$out"
                ]
            , name =
                "source"
            , system =
                dhallix.System.x86_64-linux
            , environment =
                [ { name =
                      "source"
                  , value =
                      dhallix.Environment-Variable.`Text` source
                  }
                , { name =
                      "passAsFile"
                  , value =
                      dhallix.Environment-Variable.`Text` "source"
                  }
                ]
            }
      )
