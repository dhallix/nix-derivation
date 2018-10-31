    let dhallix = ./../dhall/package.dhall

in  let T = ./../dhall/types.dhall

in  let bootstrap-tools = ./bootstrap-tools.dhall

in  let `gcc-8.2.0.tar.gz` =
          dhallix.fetch-url
          { url =
              "ftp://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-8.2.0/gcc-8.2.0.tar.gz"
          , sha256 =
              "03q2farmhd099rd1kw0p1y0n1f37af1l6dy8p75mizs522z3c3qv"
          , name =
              "gcc-8.2.0.tar.gz"
          , executable =
              False
          }

in  let `gmp-6.1.2` = ./gmp.dhall

in  let mpfr = ./mpfr.dhall

in  let mpc = ./mpc.dhall

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
                  tar xzf "${store-path `gcc-8.2.0.tar.gz`}"
                  mkdir objdir
                  cd objdir
                  export CPPFLAGS="-idirafter ${store-path
                                                bootstrap-tools}/include-glibc -idirafter ${store-path
                                                                                            bootstrap-tools}/lib/gcc/x86_64-unknown-linux-gnu/5.3.0/include-fixed"
                  export LDFLAGS="-Wl,-dynamic-linker -Wl,${store-path
                                                            bootstrap-tools}/lib/ld-linux-x86-64.so.2 -Wl,-rpath -Wl,${store-path
                                                                                                                       bootstrap-tools}/lib"
                  ../gcc-8.2.0/configure --disable-multilib --with-mpc="${store-path
                                                                          mpc}" --with-gmp="${store-path
                                                                                              `gmp-6.1.2`}" --with-mpfr="${store-path
                                                                                                                           mpfr}" --prefix="$out"
                  make
                  make check
                  make install
                  ''
                )
              ]
          , name =
              "gcc-8.2.0"
          , system =
              dhallix.System.x86_64-linux
          }
    )
