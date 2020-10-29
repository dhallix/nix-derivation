let dhallix = ../dhall/package.dhall

let derivation = dhallix.derivation

let Derivation = dhallix.Derivation

let Builder = dhallix.Builder

let Environment-Variable = dhallix.Environment-Variable

let System = dhallix.System

let Args = dhallix.Args

let fetch-url = dhallix.fetch-url

let Fetch-Url = dhallix.Fetch-Url

let bootstrap-tools = ./bootstrap-tools.dhall

let `mpfr-4.0.1.tar.xz` =
      fetch-url
        Fetch-Url::{
        , url = "https://www.mpfr.org/mpfr-current/mpfr-4.0.1.tar.xz"
        , sha256 = "0vp1lrc08gcmwdaqck6bpzllkrykvp06vz5gnqpyw0v3h9h4m1v7"
        , name = "mpfr-4.0.1.tar.xz"
        }

let gmp = ./gmp.dhall

let write-file = ./write-file.dhall

in  derivation
      ( λ(store-path : Derivation → Text) →
          Args::{
          , builder = Builder.Exe "${store-path bootstrap-tools}/bin/bash"
          , args =
            [ store-path
                ( write-file
                    ''
                    tar xJf "${store-path `mpfr-4.0.1.tar.xz`}"
                    cd mpfr-4.0.1
                    ./configure --with-gmp="${store-path
                                                gmp}" CPPFLAGS="-idirafter ${store-path
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
          , name = "mpfr-4.0.1"
          , system = System.x86_64-linux
          , environment =
            [ { name = "PATH"
              , value =
                  Environment-Variable.Text "${store-path bootstrap-tools}/bin"
              }
            ]
          }
      )
