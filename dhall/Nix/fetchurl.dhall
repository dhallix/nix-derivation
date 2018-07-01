    let derivation = ./derivation.dhall 

in  let systems = constructors ./types/System.dhall 

in  let HashAlgorithms = constructors ./types/HashAlgorithm.dhall 

in  let builders =
          constructors (./types/Builder.dhall  ./types/Derivation.dhall )

in  let outputHashModes = constructors ./types/OutputHashMode.dhall 

in    λ(args : { name : Text, url : Text, sha256 : Text })
    → derivation
      { name =
          args.name
      , system =
          systems.builtin {=}
      , args =
          [] : List Text
      , builder =
          builders.FetchUrl {=}
      , environment =
          [] : List
               { name :
                   Text
               , value :
                   ./types/EnvironmentVariable.dhall  ./types/Derivation.dhall 
               }
      , preferLocalBuild =
          True
      , outputs =
          [ "out" ]
      , outputHashMode =
          [ outputHashModes.flat {=} ] : Optional ./types/OutputHashMode.dhall 
      , outputHash =
          [ args.sha256 ] : Optional Text
      , outputHashAlgo =
          [ HashAlgorithms.SHA256 {=} ] : Optional ./types/HashAlgorithm.dhall 
      , url =
          [ args.url ] : Optional Text
      , executable =
          True
      }
