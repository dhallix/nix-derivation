let dhallix = ../dhall/package.dhall

let T = ../dhall/types.dhall

let bootstrap-tools = ./bootstrap-tools.dhall

let `m4-1.4.18.tar.xz` =
      dhallix.fetch-url
        { url = "ftp://ftp.gnu.org/gnu/m4/m4-1.4.18.tar.xz"
        , sha256 = "0mdqa9w1p6cmli6976v4wi0sw9r4p5prkj7lzfd1877wk11c9c73"
        , name = "m4-1.4.18.tar.xz"
        , executable = False
        }

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
          , name = "m4-1.4.18"
          , system = T.System.x86_64-linux
          }
      )
