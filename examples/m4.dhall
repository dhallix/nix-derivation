let dhallix = ../dhall/package.dhall

let Builder = dhallix.Builder

let Derivation = dhallix.Derivation

let Environment-Variable = dhallix.Environment-Variable

let Args = dhallix.Args

let System = dhallix.System

let Fetch-Url = dhallix.Fetch-Url

let derivation = dhallix.derivation

let fetch-url = dhallix.fetch-url

let bootstrap-tools = ./bootstrap-tools.dhall

let `m4-1.4.18.tar.xz` =
      Fetch-Url::{
      , url = "ftp://ftp.gnu.org/gnu/m4/m4-1.4.18.tar.xz"
      , sha256 = "0mdqa9w1p6cmli6976v4wi0sw9r4p5prkj7lzfd1877wk11c9c73"
      , name = "m4-1.4.18.tar.xz"
      }

let write-file = ./write-file.dhall

in  derivation
      ( λ(store-path : Derivation → Text) →
          Args::{
          , builder = Builder.Exe "${store-path bootstrap-tools}/bin/bash"
          , args =
            [ store-path
                ( write-file
                    ''
                    tar xJf "${store-path (fetch-url `m4-1.4.18.tar.xz`)}"
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
          , environment =
            [ { name = "PATH"
              , value =
                  Environment-Variable.Text "${store-path bootstrap-tools}/bin"
              }
            ]
          , name = "m4-1.4.18"
          , system = System.x86_64-linux
          }
      )
