(*
   Copyright 2023 Microsoft Research

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*)

module Pulse.Elaborate.Pure
module RT = FStar.Reflection.Typing
module R = FStar.Reflection.V2
module L = FStar.List.Tot
module RU = Pulse.RuntimeUtils
open FStar.List.Tot
open Pulse.Syntax.Base

open Pulse.Reflection.Util

let (let!) (f:option 'a) (g: 'a -> option 'b) : option 'b = 
  match f with
  | None -> None
  | Some x -> g x

let elab_qual = function
  | None -> R.Q_Explicit
  | Some Implicit -> R.Q_Implicit

let elab_observability =
  let open R in
  function
  | Neutral ->  pack_ln (Tv_FVar (pack_fv neutral_lid))
  | Unobservable -> pack_ln (Tv_FVar (pack_fv unobservable_lid))
  | Observable ->  pack_ln (Tv_FVar (pack_fv observable_lid))
  
let rec elab_term (top:term)
  : R.term
  = let open R in
    let w t' = RU.set_range t' top.range in
    match top.t with
    | Tm_VProp ->
      w (pack_ln (Tv_FVar (pack_fv vprop_lid)))

    | Tm_Emp ->
      w (pack_ln (Tv_FVar (pack_fv emp_lid)))
      
    | Tm_Inv p ->
      let p = elab_term p in
      let head = pack_ln (Tv_FVar (pack_fv inv_lid)) in
      w (pack_ln (Tv_App head (p, Q_Explicit)))

    | Tm_Pure p ->
      let p = elab_term p in
      let head = pack_ln (Tv_FVar (pack_fv pure_lid)) in
      w (pack_ln (Tv_App head (p, Q_Explicit)))

    | Tm_Star l r ->
      let l = elab_term l in
      let r = elab_term r in
      w (mk_star l r)
      
    | Tm_ExistsSL u b body
    | Tm_ForallSL u b body ->
      let t = elab_term b.binder_ty in
      let body = elab_term body in
      let t = set_range_of t b.binder_ppname.range in
      if Tm_ExistsSL? top.t
      then w (mk_exists u t (mk_abs_with_name_and_range b.binder_ppname.name b.binder_ppname.range t R.Q_Explicit body))
      else w (mk_forall u t (mk_abs_with_name_and_range b.binder_ppname.name b.binder_ppname.range t R.Q_Explicit body))

    | Tm_Inames ->
      w (pack_ln (Tv_FVar (pack_fv inames_lid)))

    | Tm_EmpInames ->
      w (emp_inames_tm)

    | Tm_AddInv i is ->
      let i = elab_term i in
      let is = elab_term is in
      w (add_inv_tm (`_) is i) // Careful on the order flip

    | Tm_Unknown ->
      w (pack_ln R.Tv_Unknown)

    | Tm_FStar t ->
      w t
      

let rec elab_pat (p:pattern) : Tot R.pattern =
  let elab_fv (f:fv) : R.fv =
    R.pack_fv f.fv_name
  in
  match p with
  | Pat_Constant c -> R.Pat_Constant c
  | Pat_Var v ty -> R.Pat_Var RT.sort_default v
  | Pat_Cons fv vs ->
    R.Pat_Cons (elab_fv fv) None (Pulse.Common.map_dec p vs elab_sub_pat)
  | Pat_Dot_Term None ->
    R.Pat_Dot_Term None
  | Pat_Dot_Term (Some t) ->
    R.Pat_Dot_Term (Some (elab_term t))
and elab_sub_pat (pi : pattern & bool) : R.pattern & bool =
  let (p, i) = pi in
  elab_pat p, i

let elab_pats (ps:list pattern) : Tot (list R.pattern) = L.map elab_pat ps

let elab_st_comp (c:st_comp)
  : R.universe & R.term & R.term & R.term
  = let res = elab_term c.res in
    let pre = elab_term c.pre in
    let post = elab_term c.post in
    c.u, res, pre, post

let elab_comp (c:comp)
  : R.term
  = match c with
    | C_Tot t ->
      elab_term t

    | C_ST c ->
      let u, res, pre, post = elab_st_comp c in
      mk_stt_comp u res pre (mk_abs res R.Q_Explicit post)

    | C_STAtomic inames obs c ->
      let inames = elab_term inames in
      let u, res, pre, post = elab_st_comp c in
      let post = mk_abs res R.Q_Explicit post in
      mk_stt_atomic_comp (elab_observability obs) u res inames pre post

    | C_STGhost c ->
      let u, res, pre, post = elab_st_comp c in
      mk_stt_ghost_comp u res pre (mk_abs res R.Q_Explicit post)

let elab_stt_equiv (g:R.env) (c:comp{C_ST? c}) (pre:R.term) (post:R.term)
  (eq_pre:RT.equiv g pre (elab_term (comp_pre c)))
  (eq_post:RT.equiv g post
                      (mk_abs (elab_term (comp_res c)) R.Q_Explicit (elab_term (comp_post c))))
  : RT.equiv g
      (let C_ST {u;res} = c in
       mk_stt_comp u
                   (elab_term res)
                   pre
                   post)
      (elab_comp c) =
  
  mk_stt_comp_equiv _
    (comp_u c)
    (elab_term (comp_res c))
    _ _ _ _ _ (RT.Rel_refl _ _ _) eq_pre eq_post
#push-options "--query_stats"
let elab_statomic_equiv (g:R.env) (c:comp{C_STAtomic? c}) (pre:R.term) (post:R.term)
  (eq_pre:RT.equiv g pre (elab_term (comp_pre c)))
  (eq_post:RT.equiv g post
                    (mk_abs (elab_term (comp_res c)) R.Q_Explicit (elab_term (comp_post c))))
  : RT.equiv g
      (let C_STAtomic inames obs {u;res} = c in
       mk_stt_atomic_comp (elab_observability obs) u
                          (elab_term res)
                          (elab_term inames)
                          pre
                          post)
      (elab_comp c) =
  
  let C_STAtomic inames obs {u;res} = c in
  let c' =
    mk_stt_atomic_comp (elab_observability obs) u
                       (elab_term res)
                       (elab_term inames)
                       pre
                       post
  in
    mk_stt_atomic_comp_equiv _ (elab_observability obs)
      (comp_u c)
      (elab_term (comp_res c))
      (elab_term inames)
      _ _ _ _ eq_pre eq_post

let elab_stghost_equiv (g:R.env) (c:comp{C_STGhost? c}) (pre:R.term) (post:R.term)
  (eq_pre:RT.equiv g pre (elab_term (comp_pre c)))
  (eq_post:RT.equiv g post
                    (mk_abs (elab_term (comp_res c)) R.Q_Explicit (elab_term (comp_post c))))
  : RT.equiv g
      (let C_STGhost {u;res} = c in
       mk_stt_ghost_comp u
                         (elab_term res)
                         pre
                         post)
      (elab_comp c) =
  
  let C_STGhost _ = c in
  mk_stt_ghost_comp_equiv _
    (comp_u c)
    (elab_term (comp_res c))
    _ _ _ _ eq_pre eq_post
