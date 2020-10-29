let dhallix = ../dhall/package.dhall

let Derivation = dhallix.Derivation

let Builder = dhallix.Builder

let Environment-Variable = dhallix.Environment-Variable

let System = dhallix.System

let Args = dhallix.Args

let fetch-url = dhallix.fetch-url

let Fetch-Url = dhallix.Fetch-Url

let derivation = dhallix.derivation

let bootstrap-tools = ./bootstrap-tools.dhall

let `gcc-8.2.0.tar.gz` =
      fetch-url
        Fetch-Url::{
        , url =
            "ftp://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-8.2.0/gcc-8.2.0.tar.gz"
        , sha256 = "03q2farmhd099rd1kw0p1y0n1f37af1l6dy8p75mizs522z3c3qv"
        , name = "gcc-8.2.0.tar.gz"
        }

let `gmp-6.1.2` = ./gmp.dhall

let mpfr = ./mpfr.dhall

let mpc = ./mpc.dhall

let write-file = ./write-file.dhall

in  derivation
      ( λ(store-path : Derivation → Text) →
          Args::{
          , builder = Builder.Exe "${store-path bootstrap-tools}/bin/bash"
          , args =
            [ store-path
                ( write-file
                    ''
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
          , system = System.x86_64-linux
          , environment =
            [ { name = "PATH"
              , value =
                  Environment-Variable.Text "${store-path bootstrap-tools}/bin"
              }
            ]
          }
      )
