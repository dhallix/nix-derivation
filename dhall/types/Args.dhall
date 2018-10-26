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
, output-hash :
    Optional ./Output-Hash.dhall
}
