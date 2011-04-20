(***********************************************************************)
(*                                                                     *)
(*                         Applied Type System                         *)
(*                                                                     *)
(*                              Hongwei Xi                             *)
(*                                                                     *)
(***********************************************************************)

(*
** ATS/Postiats - Unleashing the Potential of Types!
** Copyright (C) 2011-20?? Hongwei Xi, Boston University
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
// Start Time: March, 2011
//
(* ****** ****** *)

staload _(*anon*) = "prelude/DATS/list_vt.dats"
staload _(*anon*) = "prelude/DATS/option_vt.dats"

(* ****** ****** *)

staload "pats_lexing.sats"
staload "pats_tokbuf.sats"
staload "pats_syntax.sats"

(* ****** ****** *)

staload "pats_parsing.sats"

(* ****** ****** *)

#define l2l list_of_list_vt
#define t2t option_of_option_vt

(* ****** ****** *)

(*
e0xpseq ::= /*(empty)*/ | e0xp {COMMA e0xpseq}*
*)

fun
p_e0xpseq_vt (
  buf: &tokbuf
, bt: int
, err: &int
) : List_vt (e0xp) =
  pstar_fun0_COMMA {e0xp} (buf, bt, p_e0xp)
// end of [p_e0xpseq_vt]

(* ****** ****** *)

(*
atme0xp ::=
  | i0de
  | LITERAL_char
  | LITERAL_float
  | LITERAL_int
  | LITERAL_string
  | LPAREN e0xpseq RPAREN
  | PERCENTLPAREN e0xp RPAREN
; /* atme0xp */
*)
fun
p_atme0xp_tok (
  buf: &tokbuf, bt: int, err: &int, tok: token
) : e0xp = let
  val err0 = err
  val loc = tok.token_loc
  var ent: synent?
  macdef incby1 () = tokbuf_incby1 (buf)
in
//
case+ tok.token_node of
//
| _ when
    ptest_fun (buf, p_i0de, ent) =>
    e0xp_i0de (synent_decode (ent))
//
| T_INTEGER _ => let
    val () = incby1 () in e0xp_i0nt (tok)
  end
| T_CHAR _ => let
    val () = incby1 () in e0xp_c0har (tok)
  end
| T_FLOAT _ => let
    val () = incby1 () in e0xp_f0loat (tok)
  end
| T_STRING _ => let
    val () = incby1 () in e0xp_s0tring (tok)
  end
//
| T_LPAREN () => let
    val bt = 0
    val () = incby1 ()
    val ent2 = p_e0xpseq_vt (buf, bt, err)
    val ent3 = p_RPAREN (buf, bt, err) // err = err0
  in
    if err = err0 then
      e0xp_list (tok, (l2l)ent2, ent3)
    else let
      val () = list_vt_free (ent2) in synent_null ()
    end (* end of [if] *)
  end // end of [T_LPAREN]
| T_PERCENTLPAREN () => let
    val bt = 0
    val () = incby1 ()
    val ent2 = p_e0xp (buf, bt, err)
    val ent3 = pif_fun (buf, bt, err, p_RPAREN, err0)
  in
    if err = err0 then
      e0xp_eval (tok, ent2, ent3) else synent_null ()
    // end of [if]
  end // end of [T_PERCENTLPAREN]
//
| _ => let
    val () = err := err + 1 in synent_null ()
  end (* end of [_] *)
//
end // end of [p_atme0xp_tok]

fun
p_atme0xp (
  buf: &tokbuf, bt: int, err: &int
) : e0xp =
  ptokwrap_fun (buf, bt, err, p_atme0xp_tok, PE_atme0xp)
// end of [p_atme0xp]

(* ****** ****** *)

(*
e0xp ::= {atme0xp}+
*)

implement
p_e0xp (buf, bt, err) = let
  val xs = pstar1_fun (buf, bt, err, p_atme0xp)
  fun loop (
    x0: e0xp, xs1: List_vt (e0xp)
  ) : e0xp =
    case+ xs1 of
    | ~list_vt_cons (x1, xs1) => let
        val x0 = e0xp_app (x0, x1) in loop (x0, xs1)
      end // end of [list_vt_cons]
    | ~list_vt_nil () => x0
  // end of [loop]
in
//
case+ xs of
| ~list_vt_cons (x, xs) => loop (x, xs)
| ~list_vt_nil () => synent_null () // HX: [err] changed
//
end // end of [p_e0xp]

(* ****** ****** *)

(*
datsval ::= i0de
  | LITERAL_char | LITERAL_float | LITERAL_int | LITERAL_string
*)

fun
p_datsval (
  buf: &tokbuf, bt: int, err: &int
) : e0xp = let
  val err0 = err
  val n0 = tokbuf_get_ntok (buf)
  val tok = tokbuf_get_token (buf)
  val loc = tok.token_loc
  var ent: synent?
  macdef incby1 () = tokbuf_incby1 (buf)
in
//
case+ tok.token_node of
| T_IDENT_alp (id) => let
    val () = incby1 () in e0xp_make_stringid (loc, id)
  end // end of [T_IDENT_alp]
| T_INTEGER _ => let
    val () = incby1 () in e0xp_i0nt (tok)
  end
| T_CHAR _ => let
    val () = incby1 () in e0xp_c0har (tok)
  end
| T_FLOAT _ => let
    val () = incby1 () in e0xp_f0loat (tok)
  end
| T_STRING _ => let
    val () = incby1 () in e0xp_s0tring (tok)
  end
| _ => e0xp_make_stringid (loc, "")
//
end // end of [p_datsval]

(*
datsdef ::= i0de [EQ = datsval] // for use in a command-line
*)

implement
p_datsdef
  (buf, bt, err) = let
  val err0 = err
  val n0 = tokbuf_get_ntok (buf)
  val ent1 = p_i0de (buf, bt, err)
  val ent2 = (
    if err = err0 then
      ptokentopt_fun (buf, is_EQ, p_datsval)
    else None_vt ()
  ) : Option_vt (e0xp)
in
  if err = err0 then
    datsdef_make (ent1, (t2t)ent2)
  else let
    val () = option_vt_free (ent2) in tokbuf_set_ntok_null (buf, n0)
  end // end of [if]
end // end of [p_datsdef]

(* ****** ****** *)

(* end of [pats_parsing_e0xp.dats] *)
