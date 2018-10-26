{ environment =
    [] : List { name : Text, value : ./../types/Environment-Variable.dhall }
, args =
    [] : List Text
, outputs =
    [ "out" ]
, output-hash =
    [] : Optional ./../types/Output-Hash.dhall
}
