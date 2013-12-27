(* ****** ****** *)

#include
"../share/utfpl_symintr.hats"

(* ****** ****** *)

fun fcopy
  (inp, out) = let
  val c = fgetc (inp)
in
  if c >= 0
    then (fputc (c, out); fcopy (inp, out)) else ()
  // end of [if]
end // end of [fcopy]

(* ****** ****** *)

val () = fcopy (stdin, stdout)

(* ****** ****** *)

(* end of [test06.dats] *)
