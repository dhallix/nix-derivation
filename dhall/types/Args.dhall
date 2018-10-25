{ name :
    Text
, builder :
    ./Builder.dhall
, system :
    ./System.dhall
, environment :
    List { name : Text, value : ./Environment-Variable.dhall }
, args :
    List Text
, outputs :
    List Text
, output-hash-mode :
    Optional ./Output-Hash-Mode.dhall
, output-hash :
    Optional Text
, output-hash-algorithm :
    Optional ./Output-Hash-Algorithm.dhall
}
