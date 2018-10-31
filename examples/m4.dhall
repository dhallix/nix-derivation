    let dhallix = ./../dhall/package.dhall

in  let T = ./../dhall/types.dhall

in  let bootstrap-tools = ./bootstrap-tools.dhall

in  let `m4-1.4.18.tar.xz` =
          dhallix.fetch-url
          { url =
              "ftp://ftp.gnu.org/gnu/m4/m4-1.4.18.tar.xz"
          , sha256 =
              "01sfjd5a4waqw83bibvmn522g69qfqvwig9i2qlgy154l1nfihgj"
          , name =
              "m4-1.4.18.tar.xz"
          , executable =
              False
          }

in  let write-file =
            λ(source : Text)
          → dhallix.derivation
            (   λ(store-path : T.Derivation → Text)
              →   dhallix.defaults.Args
                ⫽ { builder =
                      dhallix.Builder.Exe
                      "${store-path bootstrap-tools}/bin/bash"
                  , args =
                      [ "-c"
                      , "${store-path
                           bootstrap-tools}/bin/cp \$sourcePath \$out"
                      ]
                  , name =
                      "source"
                  , system =
                      dhallix.System.x86_64-linux
                  , environment =
                      [ { name =
                            "source"
                        , value =
                            dhallix.Environment-Variable.`Text` source
                        }
                      , { name =
                            "passAsFile"
                        , value =
                            dhallix.Environment-Variable.`Text` "source"
                        }
                      ]
                  }
            )

in  dhallix.derivation
    (   λ ( store-path
          : T.Derivation → Text
          )
      →   dhallix.defaults.Args
        ⫽ { builder =
              dhallix.Builder.Exe "${store-path bootstrap-tools}/bin/bash"
          , args =
              [ store-path
                ( write-file
                  ''
                  export PATH="${store-path bootstrap-tools}/bin"
                  tar xJf "${store-path `m4-1.4.18.tar.xz`}"
                  cd m4-1.4.18
                  ./configure CPPFLAGS="-idirafter ${store-path
                                                     bootstrap-tools}/include-glibc -idirafter ${store-path
                                                                                                 bootstrap-tools}/lib/gcc/x86_64-unknown-linux-gnu/5.3.0/include-fixed" LDFLAGS="-Wl,-dynamic-linker -Wl,${store-path
                                                                                                                                                                                                           bootstrap-tools}/lib/ld-linux-x86-64.so.2 -Wl,-rpath -Wl,${store-path
                                                                                                                                                                                                                                                                      bootstrap-tools}/lib" --prefix="$out"
                  make
                  make check
                  make install
                  ''
                )
              ]
          , name =
              "m4-1.4.18"
          , system =
              dhallix.System.x86_64-linux
          }
    )
