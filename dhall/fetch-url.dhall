    let dhallix =
            ./constructors.dhall
          ⫽ { derivation = ./derivation.dhall }
          ⫽ ./defaults.dhall

in  let T = ./types.dhall

in  let Args = { name : Text, url : Text, sha256 : Text, executable : Bool }

in  let fetch-url
        : Args → T.Derivation
        =   λ(args : Args)
          → dhallix.derivation
            (   λ(_ : T.Derivation → Text)
              →   dhallix.defaults.Args
                ⫽ args.{ name }
                ⫽ { system =
                      dhallix.System.builtin
                  , builder =
                      dhallix.Builder.Builtin dhallix.Builtin.Fetch-Url
                  , output-hash =
                      [ { mode =
                                  if args.executable
                            
                            then  dhallix.Output-Hash-Mode.Recursive
                            
                            else  dhallix.Output-Hash-Mode.Flat
                        , hash =
                            args.sha256
                        , algorithm =
                            dhallix.Output-Hash-Algorithm.SHA256
                        }
                      ] : Optional T.Output-Hash
                  , environment =
                      [ { name =
                            "url"
                        , value =
                            dhallix.Environment-Variable.`Text` args.url
                        }
                      , { name =
                            "preferLocalBuild"
                        , value =
                            dhallix.Environment-Variable.`Bool` True
                        }
                      , { name =
                            "executable"
                        , value =
                            dhallix.Environment-Variable.`Bool` args.executable
                        }
                      ]
                  }
            )

in  fetch-url
