module Pulse.Soundness.WithLocalArray

open Pulse.Syntax
open Pulse.Typing
open Pulse.Elaborate.Pure
open Pulse.Elaborate.Core
open Pulse.Soundness.Common

module RT = FStar.Reflection.Typing

val withlocalarray_soundness
  (#g:stt_env)
  (#t:st_term)
  (#c:comp)
  (d:st_typing g t c{T_WithLocalArray? d})
  (soundness:soundness_t d)
  : GTot (RT.tot_typing (elab_env g)
                        (elab_st_typing d)
                        (elab_comp c))
