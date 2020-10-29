let derivation = ./derivation.dhall

let types = ./types.dhall

let Derivation = types.Derivation

let System = types.System

let Builder = types.Builder

let Builtin = types.Builtin

let Output-Hash-Mode = types.Output-Hash-Mode

let Output-Hash-Algorithm = types.Output-Hash-Algorithm

let Environment-Variable = types.Environment-Variable

let Args = ./schemas/Args.dhall

let Fetch-Url = ./schemas/Fetch-Url.dhall

let fetch-url
    : Fetch-Url.Type → Derivation
    = λ(args : Fetch-Url.Type) →
        derivation
          ( λ(_ : Derivation → Text) →
              Args::{
              , name = args.name
              , system = System.builtin
              , builder = Builder.Builtin Builtin.Fetch-Url
              , output-hash = Some
                { mode =
                    if    args.executable
                    then  Output-Hash-Mode.Recursive
                    else  Output-Hash-Mode.Flat
                , hash = args.sha256
                , algorithm = Output-Hash-Algorithm.SHA256
                }
              , environment =
                [ { name = "url", value = Environment-Variable.Text args.url }
                , { name = "preferLocalBuild"
                  , value = Environment-Variable.Bool True
                  }
                , { name = "executable"
                  , value = Environment-Variable.Bool args.executable
                  }
                ]
              }
          )

in  fetch-url
