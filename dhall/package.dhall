let types = ./types.dhall

let schemas = ./schemas.dhall

let derivation = ./derivation.dhall

let fetch-url = ./fetch-url.dhall

in  types ⫽ schemas ⫽ { derivation, fetch-url }
