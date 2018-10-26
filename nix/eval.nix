x:
x
  null
  ( args:
    derivation (
    ( builtins.mapAttrs
        ( _: v:
          v
            { Text = t: t;
              Bool = b: b;
            }
        )
        ( builtins.listToAttrs args.environment )
    )
    //
    {
      inherit ( args ) args name outputs;

      builder =
        args.builder
          { Builtin =
              f: f { Fetch-Url = _: "builtin:fetchurl"; };
            Exe = str: str;
          };

      system =
        args.system
          { builtin = _: "builtin";
            x86_64-linux = _: "x86_64-linux";
          };
    } //
    ( if args.output-hash-mode != null then
        { outputHashMode =
            args.output-hash-mode
              { Flat = _: "flat";
                Recursive = _: "recursive";
              };
        }
      else
        {}
    ) //
    ( if args.output-hash != null then
        { outputHash = args.output-hash; }
      else
        {}
    ) //
    ( if args.output-hash-algorithm != null then
        { outputHashAlgo =
            args.output-hash-algorithm
              ( { SHA256 = _: "sha256"; } );
        }
      else
        {}
    )
    )
  )
