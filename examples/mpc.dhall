let dhallix = ../dhall/package.dhall

let derivation = dhallix.derivation

let Derivation = dhallix.Derivation

let Builder = dhallix.Builder

let System = dhallix.System

let fetch-url = dhallix.fetch-url

let Fetch-Url = dhallix.Fetch-Url

let Args = dhallix.Args

let Environment-Variable = dhallix.Environment-Variable

let bootstrap-tools = ./bootstrap-tools.dhall

let `mpc-1.1.0.tar.gz` =
      dhallix.fetch-url
        Fetch-Url::{
        , url = "https://ftp.gnu.org/gnu/mpc/mpc-1.1.0.tar.gz"
        , sha256 = "0biwnhjm3rx3hc0rfpvyniky4lpzsvdcwhmcn7f0h4iw2hwcb1b9"
        , name = "mpc-1.1.0.tar.xz"
        }

let gmp = ./gmp.dhall

let mpfr = ./mpfr.dhall

let write-file = ./write-file.dhall

in  derivation
      ( λ(store-path : Derivation → Text) →
          Args::{
          , builder = Builder.Exe "${store-path bootstrap-tools}/bin/bash"
          , args =
            [ store-path
                ( write-file
                    ''
                    tar xzf "${store-path `mpc-1.1.0.tar.gz`}"
                    cd mpc-1.1.0
                    ./configure --with-gmp="${store-path
                                                gmp}" --with-mpfr="${store-path
                                                                       mpfr}" CPPFLAGS="-idirafter ${store-path
                                                                                                       bootstrap-tools}/include-glibc -idirafter ${store-path
                                                                                                                                                     bootstrap-tools}/lib/gcc/x86_64-unknown-linux-gnu/5.3.0/include-fixed -Wl,-dynamic-linker -Wl,${store-path
                                                                                                                                                                                                                                                       bootstrap-tools}/lib/ld-linux-x86-64.so.2 -Wl,-rpath -Wl,${store-path
                                                                                                                                                                                                                                                                                                                    bootstrap-tools}/lib" --prefix="$out"
                    make
                    make check
                    make install
                    ''
                )
            ]
          , name = "mpc-1.1.0"
          , system = System.x86_64-linux
          , environment =
            [ { name = "PATH"
              , value =
                  Environment-Variable.Text "${store-path bootstrap-tools}/bin"
              }
            ]
          }
      )
