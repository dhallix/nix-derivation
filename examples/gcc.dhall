let dhallix = ../dhall/package.dhall

let T = ../dhall/types.dhall

let bootstrap-tools = ./bootstrap-tools.dhall

let `gcc-8.2.0.tar.gz` =
      dhallix.fetch-url
        { url =
            "ftp://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-8.2.0/gcc-8.2.0.tar.gz"
        , sha256 = "03q2farmhd099rd1kw0p1y0n1f37af1l6dy8p75mizs522z3c3qv"
        , name = "gcc-8.2.0.tar.gz"
        , executable = False
        }

let `gmp-6.1.2` = ./gmp.dhall

let mpfr = ./mpfr.dhall

let mpc = ./mpc.dhall

let write-file =
      λ(source : Text) →
        dhallix.derivation
          ( λ(store-path : T.Derivation → Text) →
                dhallix.defaults.Args
              ⫽ { builder =
                    T.Builder.Exe "${store-path bootstrap-tools}/bin/bash"
                , args =
                  [ "-c"
                  , "${store-path bootstrap-tools}/bin/cp \$sourcePath \$out"
                  ]
                , name = "source"
                , system = T.System.x86_64-linux
                , environment =
                  [ { name = "source"
                    , value = T.Environment-Variable.Text source
                    }
                  , { name = "passAsFile"
                    , value = T.Environment-Variable.Text "source"
                    }
                  ]
                }
          )

in  dhallix.derivation
      ( λ(store-path : T.Derivation → Text) →
            dhallix.defaults.Args
          ⫽ { builder = T.Builder.Exe "${store-path bootstrap-tools}/bin/bash"
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
            , name = "gcc-8.2.0"
            , system = T.System.x86_64-linux
            }
      )
