let 
  build = drv: 
    drv 
      null 
      (args: builtins.derivation ({
        inherit (args) args name url executable;

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
      } // (if args.outputHashMode != null then 
              { outputHashMode =
                  args.outputHashMode
                    { flat = _: "flat";
                      recursive = _: "recursive";
                    };
              } 
            else 
              {})
        // (builtins.listToAttrs args.environment))
      );

in build
