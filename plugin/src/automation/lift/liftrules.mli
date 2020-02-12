open Liftconfig
open Constr
open Environ
open Evd
open Indutils
open Stateutils
open Reducers
      
(*
 * This module takes in a Coq term that we are lifting and determines
 * the appropriate lifting rule to run
 *)

(* --- Datatypes --- *)

(*
 * When an optimization may be possible, we return one of these.
 * Sometimes, we need more information to determine if the optimization is
 * definitely possible. This just makes it very explicit in the code what
 * is an attempt at an optimization, as opposed to what is needed for
 * correctness only.
 *
 * See the implementation for an explanation of each of these.
 *)
type lift_optimization =
| GlobalCaching of constr
| LocalCaching of constr
| OpaqueConstant
| SimplifyProjectPacked of reducer * (constr * constr array)
| LazyEta of constr
| AppLazyDelta of constr * constr array
| ConstLazyDelta of Names.Constant.t Univ.puniverses
| SmartLiftConstr of constr * constr list

(*
 * We compile Gallina to a language that matches our premises for the rules
 * in our lifting algorithm. Each of these rules carries more information
 * that is essentially cached for efficiency.
 *
 * See the implementation for an explanation of each of these.
 *)
type lift_rule =
| Equivalence of constr list
| LiftConstr of constr * constr list
| LiftPack
| Coherence of constr * constr * constr list
| LiftElim of elim_app * constr list
| Section
| Retraction
| Internalize
| Optimization of lift_optimization
| CIC of (constr, types, Sorts.t, Univ.Instance.t) kind_of_term

(*
 * Determine which lift rule to run
 *)
val determine_lift_rule :
  lift_config -> env -> constr -> evar_map -> lift_rule state