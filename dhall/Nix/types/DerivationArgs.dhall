  λ(Derivation : Type)
→ { system :
      ./System.dhall
  , name :
      Text
  , builder :
      ./Builder.dhall Derivation
  , environment :
      List { name : Text, value : ./EnvironmentVariable.dhall Derivation }
  , args :
      List (./DerivationArgument.dhall Derivation)
  , outputs :
      List Text
  , preferLocalBuild :
      Bool
  , outputHashMode :
      Optional ./OutputHashMode.dhall
  , url :
      Optional Text
  , executable :
      Bool
  , outputHash :
      Optional Text
  , outputHashAlgo :
      Optional ./HashAlgorithm.dhall
  }
