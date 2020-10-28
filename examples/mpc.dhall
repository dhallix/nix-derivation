
let dhallix = ./../dhall/package.dhall

let T = ./../dhall/types.dhall

let bootstrap-tools = ./bootstrap-tools.dhall

let `mpc-1.1.0.tar.gz` =
      dhallix.fetch-url
      { url =
          "https://ftp.gnu.org/gnu/mpc/mpc-1.1.0.tar.gz"
      , sha256 =
          "0biwnhjm3rx3hc0rfpvyniky4lpzsvdcwhmcn7f0h4iw2hwcb1b9"
      , name =
          "mpc-1.1.0.tar.xz"
      , executable =
          False
      }

let gmp = ./gmp.dhall

let mpfr = ./mpfr.dhall

let write-file = ./write-file.dhall

in  dhallix.derivation
    (   λ ( store-path
          : T.Derivation → Text
          )
      →   dhallix.defaults.Args
        ⫽ { builder =
              T.Builder.Exe "${store-path bootstrap-tools}/bin/bash"
          , args =
              [ store-path
                ( write-file
                  ''
                  export PATH="${store-path bootstrap-tools}/bin"
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
          , name =
              "mpc-1.1.0"
          , system =
              T.System.x86_64-linux
          }
    )
