{ environment =
    [] : List
         { name :
             Text
         , value :
             ./../types/EnvironmentVariable.dhall ./../types/Derivation.dhall
         }
, args =
    [] : List (./../types/DerivationArgument.dhall ./../types/Derivation.dhall)
, outputs =
    [ "out" ]
, preferLocalBuild =
    False
, outputHashMode =
    [] : Optional ./../types/OutputHashMode.dhall
, url =
    [] : Optional Text
, executable =
    False
, outputHash =
    [] : Optional Text
, outputHashAlgo =
    [] : Optional ./../types/HashAlgorithm.dhall
}
