module PulseSyntaxWrapper
open FStar.Ident
let range = FStar.Compiler.Range.range
let var = nat
let index = nat

val universe: Type0
val u_zero : universe
val u_succ (u:universe) : universe
val u_var (s:string) : universe
val u_max (u0 u1:universe) : universe
val u_unknown : universe

val bv : Type0
val mk_bv (i:index) (name:string) (r:range) : bv

val nm : Type0
val mk_nm (i:index) (name:string) (r:range) : nm

val fv : Type0
val mk_fv (nm:lident) (r:range) : fv

val term : Type0
val binder : Type0
val comp : Type0
let vprop = term
val mk_binder (x:ident) (t:term) : binder

val tm_bvar (bv:bv) : term
val tm_var (x:nm) : term
val tm_fvar (x:fv) : term
val tm_uinst (l:fv) (us:list universe) : term
val tm_emp : term
val tm_pure (p:term) : term
val tm_star (p0 p1:term) : term
val tm_exists (b:binder) (body:vprop) : term
val tm_arrow (b:binder) (q:FStar.Syntax.Syntax.aqual) (body:comp) : term
val tm_expr (t:FStar.Syntax.Syntax.term) : term
val tm_unknown : term
val mk_comp (pre:term) (ret:binder) (post:term) : comp
val ghost_comp (inames:term) (pre:term) (ret:binder) (post:term) : comp
val atomic_comp (inames:term) (pre:term) (ret:binder) (post:term) : comp

val st_term : Type0
val tm_return (t:term) : st_term
val tm_abs (bs:list binder) (annot:comp) (body:st_term) : st_term
val tm_st_app (head:term) (q:FStar.Syntax.Syntax.aqual) (arg:term) : st_term
val tm_bind (x:option (ident & term)) (e1:st_term) (e2:st_term) : st_term
val tm_let_mut (x:ident) (t:term) (v:term) (k:st_term) : st_term
val tm_while (head:st_term) (invariant: (ident & vprop)) (body:st_term) : st_term 
val tm_if (head:term) (returns_annot:option vprop) (then_ else_:st_term) : st_term

val close_term (t:term) (v:var) : term
val close_st_term (t:st_term) (v:var) : st_term
val close_comp (t:comp) (v:var) : st_term