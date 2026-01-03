-- import Mathlib.Topology.Category.TopCat.Basic
-- import Mathlib.Topology.Category.TopCat.Limits.Pullbacks
import Mathlib.Topology.Category.Profinite.Basic
import Mathlib.Data.Set.Basic
import Mathlib.Data.Set.BooleanAlgebra
import Mathlib.Topology.Constructions
import Mathlib.Topology.Compactification.OnePoint.Basic

def hello := "world"

-- Define the Cantor set as the product space `ℕ → Bool`
def Cantor : Profinite :=
  Profinite.of (ℕ → Bool)

#check Cantor
-- Cantor : Profinite

open Set

-- Predicate for membership in the subalgebra:
def FinCof (S : Set ℕ) : Prop := S.Finite ∨ Sᶜ.Finite

-- define the finite-cofinite subalgebra using the predicate
def FinCofSet : Set (Set ℕ) := { S | FinCof S }

open TopologicalSpace

-- The one‑point compactification of a type α is `OnePoint α`
-- Here we take α = ℕ (with the discrete topology)
def OnePointN : Profinite :=
  Profinite.of (OnePoint ℕ)

  #check OnePointN
-- OnePointN : Profinite
