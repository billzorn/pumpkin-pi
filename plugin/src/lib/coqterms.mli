(*
 * Coq term and environment management
 *)

open Environ
open Term
open Evd
open Constrexpr
open Names

(* --- Constants --- *)
                                     
val sigT : types
val existT : types
val sigT_rect : types
val projT1 : types
val projT2 : types

(* --- Representations --- *)

(*
 * Intern a term (for now, ignore the resulting evar_map)
 *)
val intern : env -> evar_map -> constr_expr -> types

(*
 * Extern a term
 *)
val extern : env -> evar_map -> types -> constr_expr

(* --- Constructing terms --- *)

(*
 * mkApp with a list (instead of an array) of arguments
 *)
val mkAppl : (types * types list) -> types

(*
 * Ornament between products and lambdas, without changing anything else
 *)
val prod_to_lambda : types -> types
val lambda_to_prod : types -> types
                                           
(* --- Environments --- *)

(*
 * Return a list of all indexes in env as ints, starting with 1
 *)
val all_rel_indexes : env -> int list                              

(*
 * Push to an environment
 *)
val push_local : (name * types) -> env -> env
val push_let_in : (name * types * types) -> env -> env

(*
 * Lookup from an environment
 *)
val lookup_definition : env -> types -> types
val unwrap_definition : env -> types -> types
