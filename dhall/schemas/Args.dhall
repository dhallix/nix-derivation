let types = ../types.dhall

in  { Type = ../types/Args.dhall
    , default =
      { name = ""
      , system = types.System.x86_64-linux
      , environment =
          [] : List { name : Text, value : types.Environment-Variable }
      , args = [] : List Text
      , outputs = [ "out" ]
      , output-hash = None types.Output-Hash
      }
    }
