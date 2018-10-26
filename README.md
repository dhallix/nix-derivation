# `nix-derivation`

The `nix-derivation` project provides Dhall types to
[Nix](https://nixos.org/nix/) derivations. On top of this, there is also a a Nix
"evaluator" that can take the the Nix encoding of a Dhall derivation and
transform it into something that `nix-build` can understand. To clarify, let's
consider the example for [unpacking x86_64-linux bootstrap
tools](./examples/bootstrap-tools.dhall).

In this `.dhall` file we are fetching three remote files - the `busybox` binary,
`bootstrap-tools.tar.xz` and `unpack-bootstrap-tools.sh` (these are all files
used to bootstrap `nixpkgs` - thanks!). All these `fetchurl` invocations are
`Derivation`s. We can inspect just `busybox` for example, and see that it's
normal form is:

``` dhall
  λ ( Mk-Derivation
    :   { args :
            List Text
        , builder :
            < Builtin : < Fetch-Url : {} > | Exe : Text >
        , environment :
            List { name : Text, value : < `Bool` : Bool | `Text` : Text > }
        , name :
            Text
        , output-hash :
            Optional
            { algorithm :
                < SHA256 : {} >
            , hash :
                Text
            , mode :
                < Flat : {} | Recursive : {} >
            }
        , outputs :
            List Text
        , system :
            < builtin : {} | x86_64-linux : {} >
        }
      → Text
    )
→ Mk-Derivation
  { args =
      [] : List Text
  , builder =
      < Builtin = < Fetch-Url = {=} > | Exe : Text >
  , environment =
      [ { name =
            "url"
        , value =
            < `Text` =
                "http://tarballs.nixos.org/stdenv-linux/i686/4907fc9e8d0d82b28b3c56e3a478a2882f1d700f/busybox"
            | `Bool` :
                Bool
            >
        }
      , { name = "preferLocalBuild", value = < `Bool` = True | `Text` : Text > }
      , { name = "executable", value = < `Bool` = True | `Text` : Text > }
      ]
  , name =
      "busybox"
  , output-hash =
      Some
      { algorithm =
          < SHA256 = {=} >
      , hash =
          "ef4c1be6c7ae57e4f654efd90ae2d2e204d6769364c46469fa9ff3761195cba1"
      , mode =
          < Recursive = {=} | Flat : {} >
      }
  , outputs =
      [ "out" ]
  , system =
      < builtin = {=} | x86_64-linux : {} >
  }
```

As you can see, there's quite a lot going on! Essentially, this is the "assembly
level" view of a derivation - but you won't normally be working at quite this
level.

Continuing with the example file, we see that these three fetched files are then
*composed* into a new derivation, using `dhallix.derivation`.
`dhallix.derivation` gives you a special function that lets you look at the
store-path of a derivation (the location of it's output when built), and you can
use that to build a new derivation. In this case, we look at the `store-path` of
the files we've downloaded to essentially invoke `busybox ash
unpack-bootstrap-tools.sh`, with the environment
`tarball=bootstrap-tools.tar.xz`. When we realise this derivation, Nix will
produce a new store path with the contents of this tar file unpacked. Neat!
