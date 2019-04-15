    let dhallix =
            { derivation = ./derivation.dhall }
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
                      T.System.builtin
                  , builder =
                      T.Builder.Builtin T.Builtin.Fetch-Url
                  , output-hash =
                      [ { mode =
                                  if args.executable
                            
                            then  T.Output-Hash-Mode.Recursive
                            
                            else  T.Output-Hash-Mode.Flat
                        , hash =
                            args.sha256
                        , algorithm =
                            T.Output-Hash-Algorithm.SHA256
                        }
                      ] : Optional T.Output-Hash
                  , environment =
                      [ { name =
                            "url"
                        , value =
                            T.Environment-Variable.`Text` args.url
                        }
                      , { name =
                            "preferLocalBuild"
                        , value =
                            T.Environment-Variable.`Bool` True
                        }
                      , { name =
                            "executable"
                        , value =
                            T.Environment-Variable.`Bool` args.executable
                        }
                      ]
                  }
            )

in  fetch-url
