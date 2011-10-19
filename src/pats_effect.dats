(***********************************************************************)
(*                                                                     *)
(*                         Applied Type System                         *)
(*                                                                     *)
(***********************************************************************)

(*
** ATS/Postiats - Unleashing the Potential of Types!
** Copyright (C) 2011-20?? Hongwei Xi, ATS Trustful Software, Inc.
** All rights reserved
**
** ATS is free software;  you can  redistribute it and/or modify it under
** the terms of  the GNU GENERAL PUBLIC LICENSE (GPL) as published by the
** Free Software Foundation; either version 3, or (at  your  option)  any
** later version.
** 
** ATS is distributed in the hope that it will be useful, but WITHOUT ANY
** WARRANTY; without  even  the  implied  warranty  of MERCHANTABILITY or
** FITNESS FOR A PARTICULAR PURPOSE.  See the  GNU General Public License
** for more details.
** 
** You  should  have  received  a  copy of the GNU General Public License
** along  with  ATS;  see the  file COPYING.  If not, please write to the
** Free Software Foundation,  51 Franklin Street, Fifth Floor, Boston, MA
** 02110-1301, USA.
*)

(* ****** ****** *)
//
// Author: Hongwei Xi (hwxi AT cs DOT bu DOT edu)
// Start Time: April, 2011
//
(* ****** ****** *)

staload ERR = "pats_error.sats"

(* ****** ****** *)

staload "pats_effect.sats"

(* ****** ****** *)

fn prerr_interror (): void = prerr "INTERROR(pats_effect)"

(* ****** ****** *)

assume effect_t0ype = uint

(* ****** ****** *)
//
#define EFFexn 0 // exception
#define EFFntm 1 // nontermination
#define EFFref 2 // reference
#define EFFwrt 3 // not supported
//
// HX: the maximal number of effect
//
#define MAX_EFFECT_NUMBER 4
(*
#assert (MAX_EFFECT_NUMBER < __WORDSIZE)
*)
//
(* ****** ****** *)

implement effect_exn = (uint_of)EFFexn
implement effect_ntm = (uint_of)EFFntm
implement effect_ref = (uint_of)EFFref
implement effect_wrt = (uint_of)EFFwrt

implement
effectlst_all = '[
  effect_exn, effect_ntm, effect_ref, effect_wrt
] // end of [effectlst_all]

implement
eq_effect_effect (eff1, eff2) = eq_uint_uint (eff1, eff2)

implement
effect_get_name
  (eff) = (case+ (int_of)eff of
  | EFFexn => "exn"
  | EFFntm => "ntm"
  | EFFref => "ref"
  | EFFwrt => "wrt"
  | _ => let
      val () = prerr_interror () in $ERR.abort ()
    end // end of [_]
) // end of [effect_get_name]

implement
fprint_effect (out, x) = fprint_string (out, effect_get_name (x))

(* ****** ****** *)

assume effset_t0ype = uint

(* ****** ****** *)

implement effset_nil = uint_of_int (0) // 0U
implement effset_all = uint_of ((1 << MAX_EFFECT_NUMBER) - 1)

implement eq_effset_effset (efs1, efs2) = eq_uint_uint (efs1, efs2)

(* ****** ****** *)

implement effset_add (xs, x) = xs lor (1u << x)

implement effset_del (xs, x) = xs land ~(1u << x)

implement effset_ismem (xs, x) = (xs land (1u << x)) > 0u

implement
effset_supset
  (xs1, xs2) = eq_uint_uint (~xs1 land xs2, 0u)
// end of [effset_supset]

implement
effset_subset
  (xs1, xs2) = eq_uint_uint (xs1 land ~xs2, 0u)
// end of [effset_subset]

implement effset_union (xs1, xs2) = xs1 lor xs2

(* ****** ****** *)

implement fprint_effset (out, efs) = fprint_uint (out, efs)

(* ****** ****** *)

(* end of [pats_effect.dats] *)
