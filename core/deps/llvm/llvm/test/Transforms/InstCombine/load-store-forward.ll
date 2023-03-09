; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -passes=instcombine < %s | FileCheck %s --check-prefixes=CHECK,LITTLE
; RUN: opt -S -passes=instcombine -data-layout="E" < %s | FileCheck %s --check-prefixes=CHECK,BIG

define i8 @load_smaller_int(i16* %p) {
; LITTLE-LABEL: @load_smaller_int(
; LITTLE-NEXT:    store i16 258, i16* [[P:%.*]], align 2
; LITTLE-NEXT:    ret i8 2
;
; BIG-LABEL: @load_smaller_int(
; BIG-NEXT:    store i16 258, i16* [[P:%.*]], align 2
; BIG-NEXT:    ret i8 1
;
  store i16 258, i16* %p
  %p2 = bitcast i16* %p to i8*
  %load = load i8, i8* %p2
  ret i8 %load
}

; This case can *not* be forwarded, as we only see part of the stored value.
define i32 @load_larger_int(i16* %p) {
; CHECK-LABEL: @load_larger_int(
; CHECK-NEXT:    store i16 258, i16* [[P:%.*]], align 2
; CHECK-NEXT:    [[P2:%.*]] = bitcast i16* [[P]] to i32*
; CHECK-NEXT:    [[LOAD:%.*]] = load i32, i32* [[P2]], align 4
; CHECK-NEXT:    ret i32 [[LOAD]]
;
  store i16 258, i16* %p
  %p2 = bitcast i16* %p to i32*
  %load = load i32, i32* %p2
  ret i32 %load
}

define i32 @vec_store_load_first(i32* %p) {
; CHECK-LABEL: @vec_store_load_first(
; CHECK-NEXT:    [[P2:%.*]] = bitcast i32* [[P:%.*]] to <2 x i32>*
; CHECK-NEXT:    store <2 x i32> <i32 1, i32 2>, <2 x i32>* [[P2]], align 8
; CHECK-NEXT:    ret i32 1
;
  %p2 = bitcast i32* %p to <2 x i32>*
  store <2 x i32> <i32 1, i32 2>, <2 x i32>* %p2
  %load = load i32, i32* %p
  ret i32 %load
}

define i17 @vec_store_load_first_odd_size(i17* %p) {
; CHECK-LABEL: @vec_store_load_first_odd_size(
; CHECK-NEXT:    [[P2:%.*]] = bitcast i17* [[P:%.*]] to <2 x i17>*
; CHECK-NEXT:    store <2 x i17> <i17 1, i17 2>, <2 x i17>* [[P2]], align 8
; CHECK-NEXT:    [[LOAD:%.*]] = load i17, i17* [[P]], align 4
; CHECK-NEXT:    ret i17 [[LOAD]]
;
  %p2 = bitcast i17* %p to <2 x i17>*
  store <2 x i17> <i17 1, i17 2>, <2 x i17>* %p2
  %load = load i17, i17* %p
  ret i17 %load
}

define i32 @vec_store_load_first_constexpr(i32* %p) {
; CHECK-LABEL: @vec_store_load_first_constexpr(
; CHECK-NEXT:    [[P2:%.*]] = bitcast i32* [[P:%.*]] to <2 x i32>*
; CHECK-NEXT:    store <2 x i32> bitcast (i64 ptrtoint (i32 (i32*)* @vec_store_load_first to i64) to <2 x i32>), <2 x i32>* [[P2]], align 8
; CHECK-NEXT:    [[LOAD:%.*]] = load i32, i32* [[P]], align 4
; CHECK-NEXT:    ret i32 [[LOAD]]
;
  %p2 = bitcast i32* %p to <2 x i32>*
  store <2 x i32> bitcast (i64 ptrtoint (i32 (i32*)* @vec_store_load_first to i64) to <2 x i32>), <2 x i32>* %p2, align 8
  %load = load i32, i32* %p, align 4
  ret i32 %load
}

define i32 @vec_store_load_second(i32* %p) {
; CHECK-LABEL: @vec_store_load_second(
; CHECK-NEXT:    [[P2:%.*]] = bitcast i32* [[P:%.*]] to <2 x i32>*
; CHECK-NEXT:    store <2 x i32> <i32 1, i32 2>, <2 x i32>* [[P2]], align 8
; CHECK-NEXT:    [[P3:%.*]] = getelementptr i32, i32* [[P]], i64 1
; CHECK-NEXT:    [[LOAD:%.*]] = load i32, i32* [[P3]], align 4
; CHECK-NEXT:    ret i32 [[LOAD]]
;
  %p2 = bitcast i32* %p to <2 x i32>*
  store <2 x i32> <i32 1, i32 2>, <2 x i32>* %p2
  %p3 = getelementptr i32, i32* %p, i64 1
  %load = load i32, i32* %p3
  ret i32 %load
}

define i64 @vec_store_load_whole(i32* %p) {
; LITTLE-LABEL: @vec_store_load_whole(
; LITTLE-NEXT:    [[P2:%.*]] = bitcast i32* [[P:%.*]] to <2 x i32>*
; LITTLE-NEXT:    store <2 x i32> <i32 1, i32 2>, <2 x i32>* [[P2]], align 8
; LITTLE-NEXT:    ret i64 8589934593
;
; BIG-LABEL: @vec_store_load_whole(
; BIG-NEXT:    [[P2:%.*]] = bitcast i32* [[P:%.*]] to <2 x i32>*
; BIG-NEXT:    store <2 x i32> <i32 1, i32 2>, <2 x i32>* [[P2]], align 8
; BIG-NEXT:    ret i64 4294967298
;
  %p2 = bitcast i32* %p to <2 x i32>*
  store <2 x i32> <i32 1, i32 2>, <2 x i32>* %p2
  %p3 = bitcast i32* %p to i64*
  %load = load i64, i64* %p3
  ret i64 %load
}

define i32 @vec_store_load_overlap(i32* %p) {
; CHECK-LABEL: @vec_store_load_overlap(
; CHECK-NEXT:    [[P2:%.*]] = bitcast i32* [[P:%.*]] to <2 x i32>*
; CHECK-NEXT:    store <2 x i32> <i32 1, i32 2>, <2 x i32>* [[P2]], align 8
; CHECK-NEXT:    [[P3:%.*]] = bitcast i32* [[P]] to i8*
; CHECK-NEXT:    [[P4:%.*]] = getelementptr i8, i8* [[P3]], i64 2
; CHECK-NEXT:    [[P5:%.*]] = bitcast i8* [[P4]] to i32*
; CHECK-NEXT:    [[LOAD:%.*]] = load i32, i32* [[P5]], align 2
; CHECK-NEXT:    ret i32 [[LOAD]]
;
  %p2 = bitcast i32* %p to <2 x i32>*
  store <2 x i32> <i32 1, i32 2>, <2 x i32>* %p2
  %p3 = bitcast i32* %p to i8*
  %p4 = getelementptr i8, i8* %p3, i64 2
  %p5 = bitcast i8* %p4 to i32*
  %load = load i32, i32* %p5, align 2
  ret i32 %load
}

define i32 @load_i32_store_nxv4i32(i32* %a) {
; CHECK-LABEL: @load_i32_store_nxv4i32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i32* [[A:%.*]] to <vscale x 4 x i32>*
; CHECK-NEXT:    store <vscale x 4 x i32> shufflevector (<vscale x 4 x i32> insertelement (<vscale x 4 x i32> poison, i32 1, i64 0), <vscale x 4 x i32> poison, <vscale x 4 x i32> zeroinitializer), <vscale x 4 x i32>* [[TMP0]], align 16
; CHECK-NEXT:    [[TMP1:%.*]] = load i32, i32* [[A]], align 4
; CHECK-NEXT:    ret i32 [[TMP1]]
;
entry:
  %0 = bitcast i32* %a to <vscale x 4 x i32>*
  store <vscale x 4 x i32> shufflevector (<vscale x 4 x i32> insertelement (<vscale x 4 x i32> poison, i32 1, i64 0), <vscale x 4 x i32> poison, <vscale x 4 x i32> zeroinitializer), <vscale x 4 x i32>* %0, align 16
  %1 = load i32, i32* %a, align 4
  ret i32 %1
}

define i64 @load_i64_store_nxv8i8(i8* %a) {
; CHECK-LABEL: @load_i64_store_nxv8i8(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i8* [[A:%.*]] to <vscale x 8 x i8>*
; CHECK-NEXT:    store <vscale x 8 x i8> shufflevector (<vscale x 8 x i8> insertelement (<vscale x 8 x i8> poison, i8 1, i32 0), <vscale x 8 x i8> poison, <vscale x 8 x i32> zeroinitializer), <vscale x 8 x i8>* [[TMP0]], align 16
; CHECK-NEXT:    [[A2:%.*]] = bitcast i8* [[A]] to i64*
; CHECK-NEXT:    [[LOAD:%.*]] = load i64, i64* [[A2]], align 8
; CHECK-NEXT:    ret i64 [[LOAD]]
;
entry:
  %0 = bitcast i8* %a to <vscale x 8 x i8>*
  store <vscale x 8 x i8> shufflevector (<vscale x 8 x i8> insertelement (<vscale x 8 x i8> poison, i8 1, i32 0), <vscale x 8 x i8> poison, <vscale x 8 x i32> zeroinitializer), <vscale x 8 x i8>* %0, align 16
  %a2 = bitcast i8* %a to i64*
  %load = load i64, i64* %a2, align 8
  ret i64 %load
}

define i64 @load_i64_store_nxv4i32(i32* %a) {
; CHECK-LABEL: @load_i64_store_nxv4i32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i32* [[A:%.*]] to <vscale x 4 x i32>*
; CHECK-NEXT:    store <vscale x 4 x i32> shufflevector (<vscale x 4 x i32> insertelement (<vscale x 4 x i32> poison, i32 1, i64 0), <vscale x 4 x i32> poison, <vscale x 4 x i32> zeroinitializer), <vscale x 4 x i32>* [[TMP0]], align 16
; CHECK-NEXT:    [[A2:%.*]] = bitcast i32* [[A]] to i64*
; CHECK-NEXT:    [[LOAD:%.*]] = load i64, i64* [[A2]], align 8
; CHECK-NEXT:    ret i64 [[LOAD]]
;
entry:
  %0 = bitcast i32* %a to <vscale x 4 x i32>*
  store <vscale x 4 x i32> shufflevector (<vscale x 4 x i32> insertelement (<vscale x 4 x i32> poison, i32 1, i64 0), <vscale x 4 x i32> poison, <vscale x 4 x i32> zeroinitializer), <vscale x 4 x i32>* %0, align 16
  %a2 = bitcast i32* %a to i64*
  %load = load i64, i64* %a2, align 8
  ret i64 %load
}

define i8 @load_i8_store_nxv4i32(i32* %a) {
; CHECK-LABEL: @load_i8_store_nxv4i32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i32* [[A:%.*]] to <vscale x 4 x i32>*
; CHECK-NEXT:    store <vscale x 4 x i32> shufflevector (<vscale x 4 x i32> insertelement (<vscale x 4 x i32> poison, i32 1, i64 0), <vscale x 4 x i32> poison, <vscale x 4 x i32> zeroinitializer), <vscale x 4 x i32>* [[TMP0]], align 16
; CHECK-NEXT:    [[A2:%.*]] = bitcast i32* [[A]] to i8*
; CHECK-NEXT:    [[LOAD:%.*]] = load i8, i8* [[A2]], align 1
; CHECK-NEXT:    ret i8 [[LOAD]]
;
entry:
  %0 = bitcast i32* %a to <vscale x 4 x i32>*
  store <vscale x 4 x i32> shufflevector (<vscale x 4 x i32> insertelement (<vscale x 4 x i32> poison, i32 1, i64 0), <vscale x 4 x i32> poison, <vscale x 4 x i32> zeroinitializer), <vscale x 4 x i32>* %0, align 16
  %a2 = bitcast i32* %a to i8*
  %load = load i8, i8* %a2, align 1
  ret i8 %load
}

define float @load_f32_store_nxv4f32(float* %a) {
; CHECK-LABEL: @load_f32_store_nxv4f32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast float* [[A:%.*]] to <vscale x 4 x float>*
; CHECK-NEXT:    store <vscale x 4 x float> shufflevector (<vscale x 4 x float> insertelement (<vscale x 4 x float> poison, float 1.000000e+00, i64 0), <vscale x 4 x float> poison, <vscale x 4 x i32> zeroinitializer), <vscale x 4 x float>* [[TMP0]], align 16
; CHECK-NEXT:    [[TMP1:%.*]] = load float, float* [[A]], align 4
; CHECK-NEXT:    ret float [[TMP1]]
;
entry:
  %0 = bitcast float* %a to <vscale x 4 x float>*
  store <vscale x 4 x float> shufflevector (<vscale x 4 x float> insertelement (<vscale x 4 x float> poison, float 1.0, i64 0), <vscale x 4 x float> poison, <vscale x 4 x i32> zeroinitializer), <vscale x 4 x float>* %0, align 16
  %1 = load float, float* %a, align 4
  ret float %1
}

define i32 @load_i32_store_nxv4f32(float* %a) {
; CHECK-LABEL: @load_i32_store_nxv4f32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast float* [[A:%.*]] to <vscale x 4 x float>*
; CHECK-NEXT:    store <vscale x 4 x float> shufflevector (<vscale x 4 x float> insertelement (<vscale x 4 x float> poison, float 1.000000e+00, i64 0), <vscale x 4 x float> poison, <vscale x 4 x i32> zeroinitializer), <vscale x 4 x float>* [[TMP0]], align 16
; CHECK-NEXT:    [[A2:%.*]] = bitcast float* [[A]] to i32*
; CHECK-NEXT:    [[LOAD:%.*]] = load i32, i32* [[A2]], align 4
; CHECK-NEXT:    ret i32 [[LOAD]]
;
entry:
  %0 = bitcast float* %a to <vscale x 4 x float>*
  store <vscale x 4 x float> shufflevector (<vscale x 4 x float> insertelement (<vscale x 4 x float> poison, float 1.0, i64 0), <vscale x 4 x float> poison, <vscale x 4 x i32> zeroinitializer), <vscale x 4 x float>* %0, align 16
  %a2 = bitcast float* %a to i32*
  %load = load i32, i32* %a2, align 4
  ret i32 %load
}

define <4 x i32> @load_v4i32_store_nxv4i32(i32* %a) {
; CHECK-LABEL: @load_v4i32_store_nxv4i32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i32* [[A:%.*]] to <vscale x 4 x i32>*
; CHECK-NEXT:    store <vscale x 4 x i32> shufflevector (<vscale x 4 x i32> insertelement (<vscale x 4 x i32> poison, i32 1, i64 0), <vscale x 4 x i32> poison, <vscale x 4 x i32> zeroinitializer), <vscale x 4 x i32>* [[TMP0]], align 16
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i32* [[A]] to <4 x i32>*
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x i32>, <4 x i32>* [[TMP1]], align 16
; CHECK-NEXT:    ret <4 x i32> [[TMP2]]
;
entry:
  %0 = bitcast i32* %a to <vscale x 4 x i32>*
  store <vscale x 4 x i32> shufflevector (<vscale x 4 x i32> insertelement (<vscale x 4 x i32> poison, i32 1, i64 0), <vscale x 4 x i32> poison, <vscale x 4 x i32> zeroinitializer), <vscale x 4 x i32>* %0, align 16
  %1 = bitcast i32* %a to <4 x i32>*
  %2 = load <4 x i32>, <4 x i32>* %1, align 16
  ret <4 x i32> %2
}

define <4 x i16> @load_v4i16_store_nxv4i32(i32* %a) {
; CHECK-LABEL: @load_v4i16_store_nxv4i32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i32* [[A:%.*]] to <vscale x 4 x i32>*
; CHECK-NEXT:    store <vscale x 4 x i32> shufflevector (<vscale x 4 x i32> insertelement (<vscale x 4 x i32> poison, i32 1, i64 0), <vscale x 4 x i32> poison, <vscale x 4 x i32> zeroinitializer), <vscale x 4 x i32>* [[TMP0]], align 16
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i32* [[A]] to <4 x i16>*
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x i16>, <4 x i16>* [[TMP1]], align 16
; CHECK-NEXT:    ret <4 x i16> [[TMP2]]
;
entry:
  %0 = bitcast i32* %a to <vscale x 4 x i32>*
  store <vscale x 4 x i32> shufflevector (<vscale x 4 x i32> insertelement (<vscale x 4 x i32> poison, i32 1, i64 0), <vscale x 4 x i32> poison, <vscale x 4 x i32> zeroinitializer), <vscale x 4 x i32>* %0, align 16
  %1 = bitcast i32* %a to <4 x i16>*
  %2 = load <4 x i16>, <4 x i16>* %1, align 16
  ret <4 x i16> %2
}

; Loaded data type exceeds the known minimum size of the store.
define i64 @load_i64_store_nxv4i8(i8* %a) {
; CHECK-LABEL: @load_i64_store_nxv4i8(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i8* [[A:%.*]] to <vscale x 4 x i8>*
; CHECK-NEXT:    store <vscale x 4 x i8> shufflevector (<vscale x 4 x i8> insertelement (<vscale x 4 x i8> poison, i8 1, i32 0), <vscale x 4 x i8> poison, <vscale x 4 x i32> zeroinitializer), <vscale x 4 x i8>* [[TMP0]], align 16
; CHECK-NEXT:    [[A2:%.*]] = bitcast i8* [[A]] to i64*
; CHECK-NEXT:    [[LOAD:%.*]] = load i64, i64* [[A2]], align 8
; CHECK-NEXT:    ret i64 [[LOAD]]
;
entry:
  %0 = bitcast i8* %a to <vscale x 4 x i8>*
  store <vscale x 4 x i8> shufflevector (<vscale x 4 x i8> insertelement (<vscale x 4 x i8> poison, i8 1, i32 0), <vscale x 4 x i8> poison, <vscale x 4 x i32> zeroinitializer), <vscale x 4 x i8>* %0, align 16
  %a2 = bitcast i8* %a to i64*
  %load = load i64, i64* %a2, align 8
  ret i64 %load
}

; Loaded data size is unknown - we cannot guarantee it won't
; exceed the store size.
define <vscale x 4 x i8> @load_nxv4i8_store_nxv4i32(i32* %a) {
; CHECK-LABEL: @load_nxv4i8_store_nxv4i32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i32* [[A:%.*]] to <vscale x 4 x i32>*
; CHECK-NEXT:    store <vscale x 4 x i32> shufflevector (<vscale x 4 x i32> insertelement (<vscale x 4 x i32> poison, i32 1, i64 0), <vscale x 4 x i32> poison, <vscale x 4 x i32> zeroinitializer), <vscale x 4 x i32>* [[TMP0]], align 16
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i32* [[A]] to <vscale x 4 x i8>*
; CHECK-NEXT:    [[TMP2:%.*]] = load <vscale x 4 x i8>, <vscale x 4 x i8>* [[TMP1]], align 16
; CHECK-NEXT:    ret <vscale x 4 x i8> [[TMP2]]
;
entry:
  %0 = bitcast i32* %a to <vscale x 4 x i32>*
  store <vscale x 4 x i32> shufflevector (<vscale x 4 x i32> insertelement (<vscale x 4 x i32> poison, i32 1, i64 0), <vscale x 4 x i32> poison, <vscale x 4 x i32> zeroinitializer), <vscale x 4 x i32>* %0, align 16
  %1 = bitcast i32* %a to <vscale x 4 x i8>*
  %2 = load <vscale x 4 x i8>, <vscale x 4 x i8>* %1, align 16
  ret <vscale x 4 x i8> %2
}

define i8 @load_i8_store_i1(i1* %a) {
; CHECK-LABEL: @load_i8_store_i1(
; CHECK-NEXT:    store i1 true, i1* [[A:%.*]], align 1
; CHECK-NEXT:    [[A_I8:%.*]] = bitcast i1* [[A]] to i8*
; CHECK-NEXT:    [[V:%.*]] = load i8, i8* [[A_I8]], align 1
; CHECK-NEXT:    ret i8 [[V]]
;
  store i1 true, i1* %a
  %a.i8 = bitcast i1* %a to i8*
  %v = load i8, i8* %a.i8
  ret i8 %v
}

define i1 @load_i1_store_i8(i8* %a) {
; CHECK-LABEL: @load_i1_store_i8(
; CHECK-NEXT:    store i8 1, i8* [[A:%.*]], align 1
; CHECK-NEXT:    ret i1 true
;
  store i8 1, i8* %a
  %a.i1 = bitcast i8* %a to i1*
  %v = load i1, i1* %a.i1
  ret i1 %v
}