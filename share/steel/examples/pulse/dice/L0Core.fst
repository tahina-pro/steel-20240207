module L0Core
module R = Steel.ST.Reference
module A = Steel.ST.Array
module T = FStar.Tactics
module PM = Pulse.Main
open Steel.ST.Util 
open Steel.ST.Array
open Steel.FractionalPermission
open FStar.Ghost
open Pulse.Steel.Wrapper
module A = Steel.ST.Array
module US = FStar.SizeT
module U8 = FStar.UInt8
module U32 = FStar.UInt32
open L0Types

let l0_pre
  // (#a:Type)
  (l0: l0_record)
  (vl0: l0_repr)
  : vprop = 
    admit()
  //  (* Pre: labels have enough length for HKDF *)
  //  valid_hkdf_lbl_len deviceID_label_len /\
  //  valid_hkdf_lbl_len aliasKey_label_len /\
  //  deviceIDCRI_pre deviceIDCSR_ingredients /\
  //  deviceIDCSR_pre deviceIDCSR_ingredients deviceIDCSR_len /\
  //  aliasKeyCRT_pre aliasKeyCRT_ingredients aliasKeyCRT_len

let l0_post
  (l0: l0_record)
  (vl0: l0_repr)
  : vprop
  = admit()
//     aliasKey_post cdi (B.as_seq h0 fwid) aliasKey_label_len (B.as_seq h0 aliasKey_label) aliasKey_pub aliasKey_priv h0 h1 /\
//     deviceIDCSR_post cdi deviceID_label_len (B.as_seq h0 deviceID_label)
//       deviceIDCSR_ingredients deviceIDCSR_len deviceIDCSR_buf h0 h1 /\
//     aliasKeyCRT_post cdi (B.as_seq h0 fwid) deviceID_label_len (B.as_seq h0 deviceID_label)
//       aliasKeyCRT_ingredients aliasKeyCRT_len aliasKeyCRT_buf aliasKey_pub h0 h1 /\
// True

```pulse
fn l0
  (l0: l0_record)
  (vl0: l0_repr)
  // (#pcdi #pfwid #pdeviceID_label #paliasKey_label: perm)
  requires (l0_perm l0 vl0 `star`
            l0_pre l0 vl0)
   ensures exists (vl0': l0_repr). (
                      l0_perm l0 vl0' `star`
                      l0_post l0 vl0)
{
  admit()
//   (**) let h0 = HST.get () in
//   HST.push_frame ();
//   (**) let hs0 = HST.get () in
//   (**) B.fresh_frame_modifies h0 hs0;

// (* Derive DeviceID *)
//   // let deviceID_pub : B.lbuffer byte_pub 32 = B.alloca 0x00uy    32ul in
//   let deviceID_priv: B.lbuffer byte_sec 32 = B.alloca (u8 0x00) 32ul in
//   let hs01 = HST.get () in
//   let authKeyID: B.lbuffer byte_pub 20 = B.alloca 0x00uy 20ul in
//   let hs02 = HST.get () in

//   let _h_step1_pre = HST.get () in
//   (**) B.modifies_buffer_elim cdi  B.loc_none h0 _h_step1_pre;
//   (**) B.modifies_buffer_elim fwid B.loc_none h0 _h_step1_pre;
//   (**) B.modifies_buffer_elim deviceID_label B.loc_none h0 _h_step1_pre;
//   (**) B.modifies_buffer_elim deviceID_label B.loc_none h0 _h_step1_pre;
//   l0_core_step1
//     (cdi) (fwid)
//     (deviceID_label_len) (deviceID_label)
//     (aliasKey_label_len) (aliasKey_label)
//     (deviceID_pub) (deviceID_priv)
//     (aliasKey_pub) (aliasKey_priv)
//     (authKeyID);
//   let _h_step1_post = HST.get () in

//   //assert (aliasKey_post cdi fwid aliasKey_label_len aliasKey_label aliasKey_pub aliasKey_priv h0 _h_step1_post);

//   (**) B.modifies_trans B.loc_none h0 _h_step1_pre (
//     B.loc_buffer deviceID_pub  `B.loc_union`
//     B.loc_buffer deviceID_priv `B.loc_union`
//     B.loc_buffer aliasKey_pub  `B.loc_union`
//     B.loc_buffer aliasKey_priv `B.loc_union`
//     B.loc_buffer authKeyID
//   ) _h_step1_post;

//   let _h_step2_pre = _h_step1_post in

//   l0_core_step2
//     (* version   *) deviceIDCSR_ingredients.deviceIDCSR_version
//                     deviceIDCSR_ingredients.deviceIDCSR_s_common
//                     deviceIDCSR_ingredients.deviceIDCSR_s_org
//                     deviceIDCSR_ingredients.deviceIDCSR_s_country
//     (* key usage *) deviceIDCSR_ingredients.deviceIDCSR_ku
//     (* DeviceID  *) deviceID_pub
//                     deviceID_priv
//     (*DeviceIDCRI*) deviceIDCSR_len
//                     deviceIDCSR_buf;
//   let _h_step2_post = HST.get () in

//   (**) B.modifies_trans (
//     B.loc_buffer deviceID_pub  `B.loc_union`
//     B.loc_buffer deviceID_priv `B.loc_union`
//     B.loc_buffer aliasKey_pub  `B.loc_union`
//     B.loc_buffer aliasKey_priv `B.loc_union`
//     B.loc_buffer authKeyID
//   ) h0 _h_step2_pre (
//     B.loc_buffer deviceIDCSR_buf
//   ) _h_step2_post;

//   // assert (
//   //   deviceIDCSR_post
//   //     (cdi) (deviceID_label_len) (deviceID_label)
//   //     (deviceIDCSR_ingredients)
//   //     (deviceIDCSR_len) (deviceIDCSR_buf)
//   //     (h0) (_h_step2_post)
//   // );

//   let _h_step3_pre = _h_step2_post in

//   (**) B.modifies_buffer_elim fwid (
//          B.loc_buffer deviceID_pub  `B.loc_union`
//          B.loc_buffer deviceID_priv `B.loc_union`
//          B.loc_buffer aliasKey_pub  `B.loc_union`
//          B.loc_buffer aliasKey_priv `B.loc_union`
//          B.loc_buffer authKeyID     `B.loc_union`
//          B.loc_buffer deviceIDCSR_buf
//   ) h0 _h_step3_pre;
//   (**) B.modifies_buffer_elim authKeyID     (B.loc_buffer deviceIDCSR_buf) _h_step1_post _h_step3_pre;
//   (**) B.modifies_buffer_elim deviceID_pub  (B.loc_buffer deviceIDCSR_buf) _h_step1_post _h_step3_pre;
//   (**) B.modifies_buffer_elim deviceID_priv (B.loc_buffer deviceIDCSR_buf) _h_step1_post _h_step3_pre;
//   (**) B.modifies_buffer_elim aliasKey_pub  (B.loc_buffer deviceIDCSR_buf) _h_step1_post _h_step3_pre;

//   l0_core_step3
//     (aliasKeyCRT_ingredients.aliasKeyCrt_version)
//     (aliasKeyCRT_ingredients.aliasKeyCrt_serialNumber)
//     (aliasKeyCRT_ingredients.aliasKeyCrt_i_common)
//     (aliasKeyCRT_ingredients.aliasKeyCrt_i_org)
//     (aliasKeyCRT_ingredients.aliasKeyCrt_i_country)
//     (aliasKeyCRT_ingredients.aliasKeyCrt_notBefore)
//     (aliasKeyCRT_ingredients.aliasKeyCrt_notAfter)
//     (aliasKeyCRT_ingredients.aliasKeyCrt_s_common)
//     (aliasKeyCRT_ingredients.aliasKeyCrt_s_org)
//     (aliasKeyCRT_ingredients.aliasKeyCrt_s_country)
//     (fwid)
//     (aliasKeyCRT_ingredients.aliasKeyCrt_ku)
//     (authKeyID)
//     (aliasKeyCRT_ingredients.aliasKeyCrt_l0_version)
//     (* DeviceID  *) deviceID_pub
//                     deviceID_priv
//     (* AliasKey  *) aliasKey_pub
//     (*AliasKeyTBS*) aliasKeyCRT_len
//                     aliasKeyCRT_buf;
//   let _h_step3_post = HST.get () in

//   (**) B.modifies_trans (
//     B.loc_buffer deviceID_pub  `B.loc_union`
//     B.loc_buffer deviceID_priv `B.loc_union`
//     B.loc_buffer aliasKey_pub  `B.loc_union`
//     B.loc_buffer aliasKey_priv `B.loc_union`
//     B.loc_buffer authKeyID     `B.loc_union`
//     B.loc_buffer deviceIDCSR_buf
//   ) h0 _h_step3_pre (
//     B.loc_buffer aliasKeyCRT_buf
//   ) _h_step3_post;

//   (**) B.modifies_buffer_elim aliasKey_pub (
//          B.loc_buffer deviceIDCSR_buf `B.loc_union`
//          B.loc_buffer aliasKeyCRT_buf
//   ) _h_step1_post _h_step3_post;
//   // assert (
//   //   aliasKeyCRT_post
//   //     (cdi) (fwid) (deviceID_label_len) (deviceID_label)
//   //     (aliasKeyCRT_ingredients)
//   //     (aliasKeyCRT_len) (aliasKeyCRT_buf)
//   //     (aliasKey_pub)
//   //     (h0) (_h_step3_post)
//   // );

// (* hsf *) let hsf = HST.get () in
//   HST.pop_frame ();
// (* hf *) let hf = HST.get () in
//   (**) B.popped_modifies hsf hf;
//   (**) B.modifies_buffer_elim deviceID_pub    (B.loc_region_only false (HS.get_tip hsf)) hsf hf;
//   (**) B.modifies_buffer_elim aliasKey_pub    (B.loc_region_only false (HS.get_tip hsf)) hsf hf;
//   (**) B.modifies_buffer_elim aliasKey_priv   (B.loc_region_only false (HS.get_tip hsf)) hsf hf;
//   (**) B.modifies_buffer_elim deviceIDCSR_buf (B.loc_region_only false (HS.get_tip hsf)) hsf hf;
//   (**) B.modifies_buffer_elim aliasKeyCRT_buf (B.loc_region_only false (HS.get_tip hsf)) hsf hf;
//   lemma_l0_modifies
//     (byte_pub) (byte_sec)
//     (0x00uy) (u8 0x00)
//     (h0) (hf)
//     (deviceID_pub) (aliasKey_pub) (aliasKey_priv)
//     (deviceIDCSR_buf) (aliasKeyCRT_buf)
//     (hs0) (hs01) (hs02) (_h_step1_post) (_h_step2_post) (_h_step3_post) (hsf)
//     (deviceID_priv) (authKeyID);
//   // (**) B.modifies_fresh_frame_popped h0 hs0 (
//   //   B.loc_buffer deviceID_pub    `B.loc_union`
//   //   B.loc_buffer aliasKey_pub    `B.loc_union`
//   //   B.loc_buffer aliasKey_priv   `B.loc_union`
//   //   B.loc_buffer deviceIDCSR_buf `B.loc_union`
//   //   B.loc_buffer aliasKeyCRT_buf
//   // ) hsf hf;
//   assert (HST.equal_domains h0 hf)

//   // assert (aliasKey_post cdi fwid aliasKey_label_len aliasKey_label aliasKey_pub aliasKey_priv h0 hf);

//   // assert (
//   //   deviceIDCSR_post
//   //     (cdi) (deviceID_label_len) (deviceID_label)
//   //     (deviceIDCSR_ingredients)
//   //     (deviceIDCSR_len) (deviceIDCSR_buf)
//   //     (h0) (hf)
//   // );

//   // assert (
//   //   aliasKeyCRT_post
//   //     (cdi) (fwid) (deviceID_label_len) (deviceID_label)
//   //     (aliasKeyCRT_ingredients)
//   //     (aliasKeyCRT_len) (aliasKeyCRT_buf)
//   //     (aliasKey_pub)
//   //     (h0) (hf)
//   // )
}
```