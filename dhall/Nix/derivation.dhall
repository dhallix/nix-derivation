    let Prelude =
          https://raw.githubusercontent.com/dhall-lang/Prelude/master/package.dhall

in  let derivation =
            λ(args : ./types/DerivationArgs.dhall ./types/Derivation.dhall)
          → λ(Derivation : Type)
          → λ(derivation : ./types/DerivationArgs.dhall Derivation → Derivation)
          → derivation
            (   args
              ⫽ { builder =
                    merge
                    { Derivation =
                          λ(d : ./types/Derivation.dhall)
                        → < Derivation =
                              d Derivation derivation
                          | FetchUrl :
                              {}
                          >
                    , FetchUrl =
                        λ(_ : {}) → < FetchUrl = {=} | Derivation : Derivation >
                    }
                    args.builder
                , environment =
                    Prelude.`List`.map
                    { name :
                        Text
                    , value :
                        ./types/EnvironmentVariable.dhall
                        ./types/Derivation.dhall
                    }
                    { name :
                        Text
                    , value :
                        ./types/EnvironmentVariable.dhall Derivation
                    }
                    (   λ ( kv
                          : { name :
                                Text
                            , value :
                                ./types/EnvironmentVariable.dhall
                                ./types/Derivation.dhall
                            }
                          )
                      → { name =
                            kv.name
                        , value =
                            merge
                            { Derivation =
                                  λ(d : ./types/Derivation.dhall)
                                → < Derivation = d Derivation derivation >
                            }
                            kv.value
                        }
                    )
                    args.environment
                , args =
                    Prelude.`List`.map
                    (./types/DerivationArgument.dhall ./types/Derivation.dhall)
                    (./types/DerivationArgument.dhall Derivation)
                    (   λ ( arg
                          : ./types/DerivationArgument.dhall
                            ./types/Derivation.dhall
                          )
                      → merge
                        { Derivation =
                              λ(d : ./types/Derivation.dhall)
                            → < Derivation =
                                  d Derivation derivation
                              | `Text` :
                                  Text
                              | LocalPath :
                                  Text
                              >
                        , `Text` =
                              λ(t : Text)
                            → < `Text` =
                                  t
                              | LocalPath :
                                  Text
                              | Derivation :
                                  Derivation
                              >
                        , LocalPath =
                              λ(p : Text)
                            → < LocalPath =
                                  p
                              | `Text` :
                                  Text
                              | Derivation :
                                  Derivation
                              >
                        }
                        arg
                    )
                    args.args
                }
            )

in  derivation
