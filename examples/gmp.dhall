let dhallix = ./../dhall/package.dhall

let T = ./../dhall/types.dhall

let bootstrap-tools = ./bootstrap-tools.dhall

let `gmp-6.1.2.tar.xz` =
      dhallix.fetch-url
        { url = "https://gmplib.org/download/gmp/gmp-6.1.2.tar.xz"
        , sha256 = "04hrwahdxyqdik559604r7wrj9ffklwvipgfxgj4ys4skbl6bdc7"
        , name = "gmp-6.1.2.tar.xz"
        , executable = False
        }

let `m4-1.4.18` = ./m4.dhall

let write-file = ./write-file.dhall

in  dhallix.derivation
      ( λ(store-path : T.Derivation → Text) →
            dhallix.defaults.Args
          ⫽ { builder = T.Builder.Exe "${store-path bootstrap-tools}/bin/bash"
            , args =
              [ store-path
                  ( write-file
                      ''
                      export PATH="${store-path
                                       bootstrap-tools}/bin":"${store-path
                                                                  `m4-1.4.18`}/bin"
                      tar xJf "${store-path `gmp-6.1.2.tar.xz`}"
                      cd gmp-6.1.2
                      ./configure CPPFLAGS="-idirafter ${store-path
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
            , name = "gmp-6.1.2"
            , system = T.System.x86_64-linux
            }
      )
