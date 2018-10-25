{ environment =
    [] : List { name : Text, value : ./../types/Environment-Variable.dhall }
, args =
    [] : List Text
, outputs =
    [ "out" ]
, output-hash =
    [] : Optional Text
, output-hash-algorithm =
    [] : Optional ./../types/Output-Hash-Algorithm.dhall
, output-hash-mode =
    [] : Optional ./../types/Output-Hash-Mode.dhall
}
