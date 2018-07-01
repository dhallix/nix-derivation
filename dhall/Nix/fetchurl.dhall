    let derivation = ./derivation.dhall

in  let systems = constructors ./types/System.dhall

in  let HashAlgorithms = constructors ./types/HashAlgorithm.dhall

in  let builders = constructors (./types/Builder.dhall ./types/Derivation.dhall)

in  let outputHashModes = constructors ./types/OutputHashMode.dhall

in    λ(args : { name : Text, url : Text, sha256 : Text, executable : Bool })
    → derivation
      (   ./defaults/DerivationArgs.dhall
        ⫽ args.{ executable, name }
        ⫽ { system =
              systems.builtin {=}
          , builder =
              builders.FetchUrl {=}
          , preferLocalBuild =
              True
          , outputHashMode =
              [ outputHashModes.flat {=} ] : Optional
                                             ./types/OutputHashMode.dhall
          , outputHash =
              [ args.sha256 ] : Optional Text
          , outputHashAlgo =
              [ HashAlgorithms.SHA256 {=} ] : Optional
                                              ./types/HashAlgorithm.dhall
          , url =
              [ args.url ] : Optional Text
          }
      )
