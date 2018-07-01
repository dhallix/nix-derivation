{ derivation =
    ./Nix/derivation.dhall
, fetchurl =
    ./Nix/fetchurl.dhall
, Builders =
    constructors (./Nix/types/Builder.dhall ./Nix/types/Derivation.dhall)
, DerivationArguments =
    constructors
    (./Nix/types/DerivationArgument.dhall ./Nix/types/Derivation.dhall)
, EnvironmentVariables =
    constructors
    (./Nix/types/EnvironmentVariable.dhall ./Nix/types/Derivation.dhall)
, HashAlgorithms =
    constructors ./Nix/types/HashAlgorithm.dhall
, OutputHashModes =
    constructors ./Nix/types/OutputHashMode.dhall
, Systems =
    constructors ./Nix/types/System.dhall
, defaults =
    { DerivationArgs = ./Nix/defaults/DerivationArgs.dhall }
}
