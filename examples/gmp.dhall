
    let dhallix = ./../dhall/package.dhall

in  let T = ./../dhall/types.dhall

in  let bootstrap-tools = ./bootstrap-tools.dhall

in  let `gmp-6.1.2.tar.xz` =
          dhallix.fetch-url
          { url =
              "https://gmplib.org/download/gmp/gmp-6.1.2.tar.xz"
          , sha256 =
              "04hrwahdxyqdik559604r7wrj9ffklwvipgfxgj4ys4skbl6bdc7"
          , name =
              "gmp-6.1.2.tar.xz"
          , executable =
              False
          }

in  let `m4-1.4.18` = ./m4.dhall

in  let write-file = ./write-file.dhall

in  derivation
    (   dhallix.defaults.Args
      ⫽ { builder =
            dhallix.Builder.Exe "${bootstrap-tools}/bin/bash"
        , args =
            [ write-file
              ''
              export PATH="${bootstrap-tools}/bin":"${`m4-1.4.18`}/bin"
              tar xJf "${`gmp-6.1.2.tar.xz`}"
              cd gmp-6.1.2
              ./configure CPPFLAGS="-idirafter ${bootstrap-tools}/include-glibc -idirafter ${bootstrap-tools}/lib/gcc/x86_64-unknown-linux-gnu/5.3.0/include-fixed -Wl,-dynamic-linker -Wl,${bootstrap-tools}/lib/ld-linux-x86-64.so.2 -Wl,-rpath -Wl,${bootstrap-tools}/lib" --prefix="$out"
              make
              make check
              make install
              ''
            ]
        , name =
            "gmp-6.1.2"
        , system =
            dhallix.System.x86_64-linux
        }
    )
