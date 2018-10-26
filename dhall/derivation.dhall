    let mk-derivation
        :   ((./types/Derivation.dhall → Text) → ./types/Args.dhall)
          → ./types/Derivation.dhall
        =   λ(mk-args : (./types/Derivation.dhall → Text) → ./types/Args.dhall)
          → λ(Derivation : Type)
          → λ(Mk-Derivation : ./types/Args.dhall → Text)
          → Mk-Derivation
            ( mk-args
              (   λ(derivation : ./types/Derivation.dhall)
                → derivation Derivation Mk-Derivation
              )
            )

in  mk-derivation
