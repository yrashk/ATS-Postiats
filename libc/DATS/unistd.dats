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
** the terms of the GNU LESSER GENERAL PUBLIC LICENSE as published by the
** Free Software Foundation; either version 2.1, or (at your option)  any
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
// Author: Hongwei Xi (gmhwxi AT gmail DOT com)
// Start Time: March, 2013
//
(* ****** ****** *)

#define ATS_DYNLOADFLAG 0 // no need for dynloading at run-time
#define ATS_EXTERN_PREFIX "atslib_" // prefix for external names

(* ****** ****** *)

staload "libc/SATS/unistd.sats"

(* ****** ****** *)

%{
atstype_strptr
atslib_getcwd_gc (
) {
  char *p_cwd ;
//
// HX: [32] is chosen nearly randomly
//
  size_t bsz = 32 ;
  char *p2_cwd ;
  p_cwd = (char*)0 ;
  while (1) {
    p_cwd = atspre_malloc_gc(bsz) ;
    p2_cwd = atslib_getcwd(p_cwd, bsz) ;
    if (p2_cwd != 0) return p_cwd ; else atspre_mfree_gc(p_cwd) ;
    bsz = 2 * bsz ;
  }
  return (char*)0 ; // HX: deadcode
} // end of [atslib_getcwd_gc]
%}

(* ****** ****** *)

%{
extern
atsvoid_t0ype
atslib_link_exn
(
  atstype_string old, atstype_string new
) {
  int err ;
  err = atslib_link(old, new) ;
  if (0 > err) ATSLIBfailexit("link") ;
  return ;
} /* end of [atslib_link_exn] */
%}

(* ****** ****** *)

%{
extern
atsvoid_t0ype
atslib_symlink_exn
(
  atstype_string old, atstype_string new
) {
  int err ;
  err = atslib_symlink(old, new) ;
  if (0 > err) ATSLIBfailexit("symlink") ;
  return ;
} /* end of [atslib_symlink_exn] */
%}

(* ****** ****** *)

%{
extern
atsvoid_t0ype
atslib_unlink_exn
(
  atstype_string path
) {
  int err ;
  err = atslib_unlink(path) ;
  if (0 > err) ATSLIBfailexit("unlink") ;
  return ;
} /* end of [atslib_unlink_exn] */
%}

(* ****** ****** *)

%{
atstype_strptr
atslib_readlink_gc
(
  atstype_string path
) {
  char *bfp ;
//
// HX: [32] is chosen nearly randomly
//
  size_t bsz = 32 ;
  ssize_t bsz2 ;
  bfp = (char*)0 ;
  while (1) {
    bfp = atspre_malloc_gc(bsz) ;
    bsz2 = atslib_readlink(path, bfp, bsz) ;
    if (bsz2 < 0) {
      atspre_mfree_gc(bfp) ; break ;
    }
    if (bsz2 < bsz) {
      bfp[bsz2] = '\000' ; return bfp ;
    }
    atspre_mfree_gc(bfp) ; bsz *= 2 ;
  }
  return (char*)0 ; // HX: deadcode
} // end of [atslib_readlink_gc]
%}

(* ****** ****** *)

(* end of [unistd.dats] *)
