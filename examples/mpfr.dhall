
    let dhallix = ./../dhall/package.dhall

in  let T = ./../dhall/types.dhall

in  let bootstrap-tools = ./bootstrap-tools.dhall

in  let `mpfr-4.0.1.tar.xz` =
          dhallix.fetch-url
          { url =
              "https://www.mpfr.org/mpfr-current/mpfr-4.0.1.tar.xz"
          , sha256 =
              "0vp1lrc08gcmwdaqck6bpzllkrykvp06vz5gnqpyw0v3h9h4m1v7"
          , name =
              "mpfr-4.0.1.tar.xz"
          , executable =
              False
          }

in  let gmp = ./gmp.dhall

in  let write-file = ./write-file.dhall

in  derivation
    (   dhallix.defaults.Args
      ⫽ { builder =
            dhallix.Builder.Exe "${bootstrap-tools}/bin/bash"
        , args =
            [ write-file
              ''
              export PATH="${bootstrap-tools}/bin"
              tar xJf "${`mpfr-4.0.1.tar.xz`}"
              cd mpfr-4.0.1
              ./configure --with-gmp="${gmp}" CPPFLAGS="-idirafter ${bootstrap-tools}/include-glibc -idirafter ${bootstrap-tools}/lib/gcc/x86_64-unknown-linux-gnu/5.3.0/include-fixed -Wl,-dynamic-linker -Wl,${bootstrap-tools}/lib/ld-linux-x86-64.so.2 -Wl,-rpath -Wl,${bootstrap-tools}/lib" --prefix="$out"
              make
              make check
              make install
              ''
            ]
        , name =
            "mpfr-4.0.1"
        , system =
            dhallix.System.x86_64-linux
        }
    )
