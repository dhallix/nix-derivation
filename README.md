# `nix-dhall` - Drive Nix with Dhall expressions

`nix-dhall` providse infrastructure to drive [Nix](https://nixos.org/nix) using
[Dhall](https://dhall-lang.org) expressions. This repository provides the core
primitives, namely:

* `dhall/Nix/derivation.dhall` provides a function to create Nix derivations.

* `dhall/Nix/fetchurl.dhall` provides a function to create Nix derivations that fetch
  a specified URL.

* `nix/nix-dhall.nix` provides a top-level expression that transforms
  `nix-dhall` Dhall expressions to Nix forms that can be used with `nix-build`,
  etc.

## Usage

1. To use `nix-dhall`, write a Dhall expression of type
   [`Derivation`](./dhall/Nix/types/Derivation.dhall).

2. Next, compile this Dhall expression into a Nix expression with
   [`dhall-to-nix`](https://github.com/dhall-lang/dhall-nix):
   
    ```
    dhall-to-nix <<< './your-expression.dhall' > your-expression.nix
    ```
   
3. Build the resulting Nix file using `nix-dhall.nix`:

    ```
    nix-build -E 'import ./nix/nix-dhall.nix (import ./your-expression.nix)'
    ```
