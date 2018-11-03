    let dhallix = ./../dhall/package.dhall

in  let T = ./../dhall/types.dhall

in  let bootstrap-tools = ./bootstrap-tools.dhall

in  let `gcc-8.2.0.tar.gz` =
          dhallix.fetch-url
          { url =
              "ftp://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-8.2.0/gcc-8.2.0.tar.gz"
          , sha256 =
              "03q2farmhd099rd1kw0p1y0n1f37af1l6dy8p75mizs522z3c3qv"
          , name =
              "gcc-8.2.0.tar.gz"
          , executable =
              False
          }

in  let `gmp-6.1.2` = ./gmp.dhall

in  let mpfr = ./mpfr.dhall

in  let mpc = ./mpc.dhall

in  let write-file = ./write-file.dhall

in  derivation
    (   dhallix.defaults.Args
      ⫽ { builder =
            dhallix.Builder.Exe "${bootstrap-tools}/bin/bash"
        , args =
            [ write-file
              ''
              export PATH="${bootstrap-tools}/bin"
              tar xzf "${`gcc-8.2.0.tar.gz`}"
              mkdir objdir
              cd objdir
              export CPPFLAGS="-idirafter ${bootstrap-tools}/include-glibc -idirafter ${bootstrap-tools}/lib/gcc/x86_64-unknown-linux-gnu/5.3.0/include-fixed"
              export LDFLAGS="-Wl,-dynamic-linker -Wl,${bootstrap-tools}/lib/ld-linux-x86-64.so.2 -Wl,-rpath -Wl,${bootstrap-tools}/lib"
              ../gcc-8.2.0/configure --disable-multilib --with-mpc="${mpc}" --with-gmp="${`gmp-6.1.2`}" --with-mpfr="${mpfr}" --prefix="$out"
              make
              make check
              make install
              ''
            ]
        , name =
            "gcc-8.2.0"
        , system =
            dhallix.System.x86_64-linux
        }
    )
