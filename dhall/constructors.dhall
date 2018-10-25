    let T = ./types.dhall

in  { Env =
        constructors T.Environment-Variable
    , Builder =
        constructors T.Builder
    , System =
        { builtin =
            (constructors T.System).builtin {=}
        , x86_64-linux =
            (constructors T.System).x86_64-linux {=}
        }
    , Builtin =
        { Fetch-Url = (constructors T.Builtin).Fetch-Url {=} }
    , Environment-Variable =
        constructors T.Environment-Variable
    , Output-Hash-Algorithm =
        { SHA256 = (constructors T.Output-Hash-Algorithm).SHA256 {=} }
    , Output-Hash-Mode =
        { Flat =
            (constructors T.Output-Hash-Mode).Flat {=}
        , Recursive =
            (constructors T.Output-Hash-Mode).Recursive {=}
        }
    }
