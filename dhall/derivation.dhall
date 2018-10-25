    let mk-derivation
        :   ((./types/Derivation.dhall → Text) → ./types/Args.dhall)
          → ./types/Derivation.dhall
        =   λ(mk-args : (./types/Derivation.dhall → Text) → ./types/Args.dhall)
          → λ(Derivation : Type)
          → λ(store-path : Derivation → Text)
          → λ(Mk-Derivation : ./types/Args.dhall → Derivation)
          → Mk-Derivation
            ( mk-args
              (   λ(derivation : ./types/Derivation.dhall)
                → store-path (derivation Derivation store-path Mk-Derivation)
              )
            )

in  mk-derivation
