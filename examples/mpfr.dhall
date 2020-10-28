let dhallix = ../dhall/package.dhall

let T = ../dhall/types.dhall

let bootstrap-tools = ./bootstrap-tools.dhall

let `mpfr-4.0.1.tar.xz` =
      dhallix.fetch-url
        { url = "https://www.mpfr.org/mpfr-current/mpfr-4.0.1.tar.xz"
        , sha256 = "0vp1lrc08gcmwdaqck6bpzllkrykvp06vz5gnqpyw0v3h9h4m1v7"
        , name = "mpfr-4.0.1.tar.xz"
        , executable = False
        }

let gmp = ./gmp.dhall

let write-file = ./write-file.dhall

in  dhallix.derivation
      ( λ(store-path : T.Derivation → Text) →
          dhallix.Args::{
          , builder = T.Builder.Exe "${store-path bootstrap-tools}/bin/bash"
          , args =
            [ store-path
                ( write-file
                    ''
                    export PATH="${store-path bootstrap-tools}/bin"
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
          , system = T.System.x86_64-linux
          }
      )
