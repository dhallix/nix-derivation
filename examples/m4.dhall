    let dhallix = ./../dhall/package.dhall

in  let T = ./../dhall/types.dhall

in  let bootstrap-tools = ./bootstrap-tools.dhall

in  let `m4-1.4.18.tar.xz` =
          dhallix.fetch-url
          { url =
              "ftp://ftp.gnu.org/gnu/m4/m4-1.4.18.tar.xz"
          , sha256 =
              "01sfjd5a4waqw83bibvmn522g69qfqvwig9i2qlgy154l1nfihgj"
          , name =
              "m4-1.4.18.tar.xz"
          , executable =
              False
          }

in  let write-file = ./write-file.dhall

in  derivation
    (   dhallix.defaults.Args
      ⫽ { builder =
            dhallix.Builder.Exe "${bootstrap-tools}/bin/bash"
        , args =
            [ write-file
              ''
              export PATH="${bootstrap-tools}/bin"
              tar xJf "${`m4-1.4.18.tar.xz`}"
              cd m4-1.4.18
              ./configure CPPFLAGS="-idirafter ${bootstrap-tools}/include-glibc -idirafter ${bootstrap-tools}/lib/gcc/x86_64-unknown-linux-gnu/5.3.0/include-fixed" LDFLAGS="-Wl,-dynamic-linker -Wl,${bootstrap-tools}/lib/ld-linux-x86-64.so.2 -Wl,-rpath -Wl,${bootstrap-tools}/lib" --prefix="$out"
              make
              make check
              make install
              ''
            ]
        , name =
            "m4-1.4.18"
        , system =
            dhallix.System.x86_64-linux
        }
    )
