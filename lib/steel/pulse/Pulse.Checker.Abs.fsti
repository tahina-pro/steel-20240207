module Pulse.Checker.Abs

module T = FStar.Tactics

open Pulse.Syntax
open Pulse.Typing
open Pulse.Checker.Common

val check_abs
  (g:env)
  (t:st_term{Tm_Abs? t.term})
  (pre:term)
  (pre_typing:tot_typing g pre Tm_VProp)
  (post_hint:post_hint_opt g)
  (check:check_t)
  : T.Tac (checker_result_t g pre post_hint)