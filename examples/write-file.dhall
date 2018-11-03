    let dhallix = ./../dhall/package.dhall

in  let T = ./../dhall/types.dhall

in  let bootstrap-tools = ./bootstrap-tools.dhall

in    λ(source : Text)
    → derivation
      (   dhallix.defaults.Args
        ⫽ { builder =
              dhallix.Builder.Exe "${bootstrap-tools}/bin/bash"
          , args =
              [ "-c", "${bootstrap-tools}/bin/cp \$sourcePath \$out" ]
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
