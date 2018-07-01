    let Prelude =
          https://raw.githubusercontent.com/dhall-lang/Prelude/master/package.dhall 

in  let derivation =
            λ(args : ./types/DerivationArgs.dhall  ./types/Derivation.dhall )
          → λ(Derivation : Type)
          → λ ( derivation
              : ./types/DerivationArgs.dhall  Derivation → Derivation
              )
          → derivation
            (   args
              ⫽ { builder =
                    merge
                    { Derivation =
                          λ(d : ./types/Derivation.dhall )
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
                        ./types/EnvironmentVariable.dhall  Derivation
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
                                  λ(d : ./types/Derivation.dhall )
                                → < Derivation = d Derivation derivation >
                            }
                            kv.value
                        }
                    )
                    args.environment
                }
            )

in  derivation
