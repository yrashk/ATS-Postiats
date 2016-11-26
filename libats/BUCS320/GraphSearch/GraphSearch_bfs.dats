(*
For Effective ATS
*)

(* ****** ****** *)
//
#include
"./GraphSearch.dats"
//
(* ****** ****** *)
//
staload
"libats/ML/SATS/qlistref.sats"
staload
"libats/ML/SATS/stream_vt.sats"
//
(* ****** ****** *)
//
extern
fun{}
node_mark(node): void
extern
fun{}
node_unmark(node): void
//
extern
fun{}
node_is_marked(node): bool
overload
.is_marked with node_is_marked
//
(* ****** ****** *)
//
extern
fun{}
theSearchStore_get
  ((*void*)): qlistref(node)
//
(* ****** ****** *)
//
implement
theSearchStore_insert<>
  (nx) = let
//
val
theStore = theSearchStore_get()
//
in
//
if
~(nx.is_marked())
then
(
  node_mark(nx);
  qlistref_insert(theStore, nx)
)
//
end (* end of [theSearchStore_insert] *)
//
implement
theSearchStore_choose<>
  ((*void*)) = let
//
val
theStore = theSearchStore_get()
//
in
  qlistref_takeout_opt(theStore)
end // end of [theSearchStore_choose]
//
(* ****** ****** *)
//
(*
extern
fun{}
GraphSearch_bfs(): void
implement
{}(*tmp*)
GraphSearch_bfs() = GraphSearch<>()
*)
//
(* ****** ****** *)

(* end of [GraphSearch_bfs.dats] *)
