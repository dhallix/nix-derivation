x:
x ( args:
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
              f: f { Fetch-Url = "builtin:fetchurl"; };
            Exe = str: str;
          };

      system =
        args.system
          { builtin = "builtin";
            x86_64-linux = "x86_64-linux";
          };
    } //
    ( if args.output-hash != null then
        { outputHashMode =
            args.output-hash.mode
              { Flat = "flat";
                Recursive = "recursive";
              };

          outputHash =
            args.output-hash.hash;

          outputHashAlgo =
            args.output-hash.algorithm
              ( { SHA256 = "sha256"; } );
        }
      else
        {}
    )
    )
  )
