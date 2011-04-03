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

(* ****** ****** *)

staload UN = "prelude/SATS/unsafe.sats"

(* ****** ****** *)

staload "pats_symbol.sats"
staload "pats_label.sats"
staload "pats_syntax.sats"

(* ****** ****** *)

staload "pats_lexing.sats" // for tokens
staload "pats_tokbuf.sats" // for tokenizing

(* ****** ****** *)

staload "pats_parsing.sats"

(* ****** ****** *)

#define l2l list_of_list_vt

(* ****** ****** *)

fun
i0nt_make_base_rep_sfx (
  loc: location, base: int, rep: string, sfx: uint
) : i0nt = '{
  i0nt_loc= loc
, i0nt_bas= base
, i0nt_rep= rep
, i0nt_sfx= sfx
} // end of [i0nt_make_base_rep_sfx]

implement
p_i0nt (buf, bt, err) = let
  val tok = tokbuf_get_token (buf)
  val loc = tok.token_loc
  macdef incby1 () = tokbuf_incby1 (buf)
in
//
case+ tok.token_node of
| T_INTEGER (base, str, sfx) => let
    val () = incby1 ()
  in
    i0nt_make_base_rep_sfx (loc, base, str, sfx)
  end
| _ => let
    val () = err := err + 1
    val () = the_parerrlst_add_ifnbt (bt, loc, PE_i0nt)
  in
    synent_null ()
  end // end of [_]
//
end // end of [p_i0nt]

(* ****** ****** *)

implement
p_s0tring
  (buf, bt, err) = let
  val tok = tokbuf_get_token (buf)
  val loc = tok.token_loc
  macdef incby1 () = tokbuf_incby1 (buf)
in
//
case+ tok.token_node of
| T_STRING _ => let
    val () = incby1 () in tok
  end
| _ => let
    val () = err := err + 1
    val () = the_parerrlst_add_ifnbt (bt, loc, PE_s0tring)
  in
    synent_null ()
  end // end of [_]
//
end // end of [p_s0tring]

(* ****** ****** *)

(*
i0de
  : IDENTIFIER_alp
  | IDENTIFIER_sym
  | EQ
  | GT
  | LT
  | AMPERSAND
  | BACKSLASH
  | BANG
  | TILDE
  | MINUSGT
  | MINUSLTGT
  | GTLT
; /* i0de */
*)

implement
p_i0de
  (buf, bt, err) = let
  val tok = tokbuf_get_token (buf)
  val loc = tok.token_loc
  macdef incby1 () = tokbuf_incby1 (buf)
in
//
case+ tok.token_node of
| T_IDENT_alp (x) => let
    val () = incby1 () in i0de_make_string (loc, x)
  end
| T_IDENT_sym (x) => let
    val () = incby1 () in i0de_make_string (loc, x)
  end
//
| T_EQ () => let
    val () = incby1 () in i0de_make_string (loc, "=")
  end
| T_GT () => let
    val () = incby1 () in i0de_make_string (loc, ">")
  end
| T_LT () => let
    val () = incby1 () in i0de_make_string (loc, "<")
  end
//
| T_AMPERSAND () => let
    val () = incby1 () in i0de_make_string (loc, "&")
  end
| T_BACKSLASH () => let
    val () = incby1 () in i0de_make_string (loc, "\\")
  end
| T_BANG () => let
    val () = incby1 () in i0de_make_string (loc, "!")
  end
| T_TILDE () => let
    val () = incby1 () in i0de_make_string (loc, "~")
  end
//
| T_MINUSGT () => let
    val () = incby1 () in i0de_make_string (loc, "->")
  end
| T_MINUSLTGT () => let
    val () = incby1 () in i0de_make_string (loc, "-<>")
  end
//
| T_GTLT () => let
    val () = incby1 () in i0de_make_string (loc, "><")
  end
//
| _ => let
    val () = err := err + 1
    val () = the_parerrlst_add_ifnbt (bt, loc, PE_i0de)
  in
    synent_null ()
  end // end of [_]
//
end // end of [p_i0de]

(*
i0deseq1 := {i0de}+
*)
implement
p_i0deseq1
  (buf, bt, err) = let
  val xs = pstar1_fun (buf, bt, err, p_i0de)
in
  list_of_list_vt (xs)
end // end of [p_i0deseq1]

(* ****** ****** *)

implement
p_i0de_dlr
  (buf, bt, err) = let
  val tok = tokbuf_get_token (buf)
  val loc = tok.token_loc
  macdef incby1 () = tokbuf_incby1 (buf)
in
//
case+ tok.token_node of
| T_IDENT_dlr (x) => let
    val () = incby1 () in i0de_make_string (loc, x)
  end
| _ => let
    val () = err := err + 1
    val () = the_parerrlst_add_ifnbt (bt, loc, PE_i0de_dlr)
  in
    synent_null ()
  end // end of [_] 
//
end // end of [p_i0de_dlr]

(* ****** ****** *)

(*
l0ab :=
  | i0de
  | i0nt
/*
  | LPAREN l0ab RPAREN // HX: this is removed for now
*/
*)
implement
p_l0ab
  (buf, bt, err) = let
  var ent: synent?
  val tok = tokbuf_get_token (buf)
in
//
case+ 0 of
| _ when
    ptest_fun (
      buf, p_i0de, ent
    ) => l0ab_make_i0de (synent_decode {i0de} (ent))
| _ when
    ptest_fun (
      buf, p_i0nt, ent
    ) => l0ab_make_i0nt (synent_decode {i0nt} (ent))
//
| _ => let
    val () = err := err + 1
    val () = the_parerrlst_add_ifnbt (bt, tok.token_loc, PE_l0ab)
  in
    synent_null ()
  end
//
end // end of [p_l0ab]

(* ****** ****** *)

(*
p0rec
  : /*(empty)*/
  | LITERAL_int
  | LPAREN i0de RPAREN
  | LPAREN i0de IDENTIFIER_sym LITERAL_int RPAREN
; /* p0rec */
*)
fun
p_p0rec_tok (
  buf: &tokbuf, bt: int, err: &int, tok: token
) : p0rec = let
  var ent: synent?
  val err0 = err
  macdef incby1 () = tokbuf_incby1 (buf)
in
//
case+ tok.token_node of
| _ when
    ptest_fun (
      buf, p_i0nt, ent
    ) => p0rec_i0nt (synent_decode {i0nt} (ent))
| T_LPAREN () => let
    val bt = 0
    val () = incby1 ()
    val ent2 = p_i0de (buf, bt, err)
  in
    if err = err0 then let
      val tok2 = tokbuf_get_token (buf)
    in
      case+ tok2.token_node of
      | T_RPAREN () => let
          val () = incby1 () in p0rec_i0de (ent2)
        end
      | T_IDENT_sym _ => let
          val () = incby1 ()
          val ent4 = p_i0nt (buf, bt, err)
          val ent5 = pif_fun (buf, bt, err, p_RPAREN, err0)
        in
          if err = err0 then
            p0rec_i0de_adj (ent2, tok2, ent4) else synent_null ()
          // end of [if]
        end
      | _ => synent_null ()
    end else
      synent_null ()
    // end of [if]
  end (* T_LPAREN *)
| _ => p0rec_emp ()
//
end // end of [p_p0rec_tok]

implement
p_p0rec
  (buf, bt, err) =
  ptokwrap_fun (buf, bt, err, p_p0rec_tok, PE_p0rec)
// end of [p_p0rec]

(* ****** ****** *)

fun
p_effi0de (
  buf: &tokbuf, bt: int, err: &int
) : i0de = let
  val tok = tokbuf_get_token (buf)
  val loc = tok.token_loc
  macdef incby1 () = tokbuf_incby1 (buf)
in
//
case+ tok.token_node of
| T_IDENT_alp name => let
    val () = incby1 () in i0de_make_string (loc, name)
  end
| _ => let
    val () = err := err + 1 in synent_null ()
  end
//
end // end of [p_effi0de]

(*
e0fftag ::=
  | FUN
  | BANG effi0de
  | TILDE effi0de
  | effi0de
  | LITERAL_int
*)
implement
p_e0fftag
  (buf, bt, err) = let
  val err0 = err
  val n0 = tokbuf_get_ntok (buf)
  val tok = tokbuf_get_token (buf)
  var ent: synent?
  macdef incby1 () = tokbuf_incby1 (buf)
in
//
case+ tok.token_node of
| T_FUN _ => let
    val () = incby1 () in e0fftag_var_fun (tok)
  end
| T_BANG () => let
    val bt = 0
    val () = incby1 ()
    val ent2 = p_effi0de (buf, bt, err)
  in
    if err = err0 then
      e0fftag_cst (0, ent2) else tokbuf_set_ntok_null (buf, n0)
    // end of [if]
  end
| T_TILDE () => let
    val bt = 0
    val () = incby1 ()
    val ent2 = p_effi0de (buf, bt, err)
  in
    if err = err0 then
      e0fftag_cst (0, ent2) else tokbuf_set_ntok_null (buf, n0)
    // end of [if]
  end
| _ when
    ptest_fun (
    buf, p_effi0de, ent
  ) => e0fftag_i0de (synent_decode {i0de} (ent))
| _ when
    ptest_fun (
    buf, p_i0nt, ent
  ) => e0fftag_i0nt (synent_decode {i0nt} (ent))
| _ => let
    val () = err := err + 1 in synent_null ()
  end
//
end // end of [p_e0fftag]

(* ****** ****** *)

(*
colonwith
  | COLON
  | COLONLTGT
  | COLONLT e0fftagseq GT
*)
implement
p_colonwith
  (buf, bt, err) = let
  val err0 = err
  val n0 = tokbuf_get_ntok (buf)
  val tok = tokbuf_get_token (buf)
  val loc = tok.token_loc
//
(*
  val () = println! ("p_colonwith: bt = ", bt)
  val () = println! ("p_colonwith: tok = ", tok)
*)
//
  macdef incby1 () = tokbuf_incby1 (buf)
in
//
case+ tok.token_node of
| T_COLON () => let
    val () = incby1 () in None ()
  end
| T_COLONLT () => let
    val bt = 0
    val () = incby1 ()
    val ent2 = pstar_fun0_COMMA {e0fftag} (buf, bt, p_e0fftag)
    val ent3 = p_GT (buf, bt, err) // err = err0
  in
    if err = err0 then
      Some ((l2l)ent2)
    else let
      val () = list_vt_free (ent2) in tokbuf_set_ntok_null (buf, n0)
    end (* end of [if] *)
  end
| _ => let
    val () = err := err + 1
    val () = the_parerrlst_add_ifnbt (bt, loc, PE_colonwith)
  in
    synent_null ()
  end (* end of [_] *)
//
end // end of [p_colonwith]

(* ****** ****** *)

implement
p_dcstkind
  (buf, bt, err) = let
  val tok = tokbuf_get_token (buf)
  macdef incby1 () = tokbuf_incby1 (buf)
in
//
case+ tok.token_node of
| T_FUN _ => let
    val () = incby1 () in tok
  end
| T_VAL _ => let
    val () = incby1 () in tok
  end
| _ => let
    val () = err := err + 1 in synent_null ()
  end
//
end // end of [p_dcstkind]

(* ****** ****** *)

#define s2s string1_of_string

implement
p_extnamopt
  (buf, bt, err) = let
  val n0 = tokbuf_get_ntok (buf)
  val tok = tokbuf_get_token (buf)
  macdef incby1 () = tokbuf_incby1 (buf)
in
//
case+ tok.token_node of
| T_EQ () => let
    val bt = 0
    val () = incby1 ()
    val ent2 = p_s0tring (buf, bt, err)
  in
    if synent_is_null (ent2) then let
      val () = tokbuf_set_ntok (buf, n0) in stropt_none
    end else let
      val- T_STRING (name) = ent2.token_node in stropt_some ((s2s)name)
    end (* end of [if] *)
  end
| _ => stropt_none
//
end // end of [p_extnamopt]

(* ****** ****** *)

(*
m0acarg ::=
  | pi0de
  | LPAREN pi0deseq RPAREN
  | LBRACE si0deseq RBRACE
*)

implement
p_m0acarg
  (buf, bt, err) = let
  val err0 = err
  val n0 = tokbuf_get_ntok (buf)
  val tok = tokbuf_get_token (buf)
  macdef incby1 () = tokbuf_incby1 (buf)
in
//
case+ tok.token_node of
| T_LPAREN () => let
    val bt = 0
    val () = incby1 ()
    val ent2 = pstar_fun0_COMMA {i0de} (buf, bt, p_si0de)
    val ent3 = p_RPAREN (buf, bt, err)
  in
    if err = err0 then
      m0acarg_sta (tok, (l2l)ent2, ent3)
    else let
      val () = list_vt_free (ent2) in tokbuf_set_ntok_null (buf, n0)
    end (* end of [if] *)
  end
| T_LBRACE () => let
    val bt = 0
    val () = incby1 ()
    val ent2 = pstar_fun0_COMMA {i0de} (buf, bt, p_pi0de)
    val ent3 = p_RBRACE (buf, bt, err)
  in
    if err = err0 then
      m0acarg_dyn (tok, (l2l)ent2, ent3)
    else let
      val () = list_vt_free (ent2) in tokbuf_set_ntok_null (buf, n0)
    end (* end of [if] *)
  end
| _ => let
    val ent1 = p_pi0de (buf, bt, err)
  in
    if err = err0 then
      m0acarg_sing (ent1) else tokbuf_set_ntok_null (buf, n0)
    // end of [if]
  end
//
end // end of [p_m0acarg]

(* ****** ****** *)

(* end of [pats_parsing_misc.dats] *)
