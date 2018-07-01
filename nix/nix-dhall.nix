let
  build = drv:
    drv
      null
      (args: builtins.derivation ({
        inherit (args) name url executable;

        builder =
          args.builder
            { FetchUrl = _: "builtin:fetchurl";
              Derivation = d: d;
            };

        system =
          args.system
            { x86_64-linux = _: "x86_64-linux";
              builtin = _: "builtin";
            };

        args =
          map
            (arg: arg { Text = t: t;
                        LocalPath = p: builtins.path { path = p; };
                      })
            args.args;
      } // (if args.outputHashMode != null then
              { outputHashMode =
                  args.outputHashMode
                    { flat = _: "flat";
                      recursive = _: "recursive";
                    };
              }
            else
              {})
        // (builtins.listToAttrs
              (map
                ({ name, value }: {
                   inherit name;
                   value = value { Derivation = d: d; };
                 })
                args.environment))
           )
      );

in build
