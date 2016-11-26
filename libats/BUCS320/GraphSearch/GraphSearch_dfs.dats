(*
For Effective ATS
*)

(* ****** ****** *)
//
staload
"./GraphSearch.dats"
//
(* ****** ****** *)
//
staload
"libats/ML/SATS/slistref.sats"
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
  ((*void*)): slistref(node)
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
  slistref_insert(theStore, nx)
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
  slistref_takeout_opt(theStore)
end // end of [theSearchStore_choose]
//
(* ****** ****** *)
//
(*
extern
fun{}
GraphSearch_dfs(): void
implement
{}(*tmp*)
GraphSearch_dfs() = GraphSearch<>()
*)
//
(* ****** ****** *)

(* end of [GraphSearch_dfs.dats] *)
