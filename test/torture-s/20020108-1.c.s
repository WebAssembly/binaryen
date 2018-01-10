	.text
	.file	"20020108-1.c"
	.section	.text.ashift_qi_0,"ax",@progbits
	.hidden	ashift_qi_0             # -- Begin function ashift_qi_0
	.globl	ashift_qi_0
	.type	ashift_qi_0,@function
ashift_qi_0:                            # @ashift_qi_0
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	copy_local	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	ashift_qi_0, .Lfunc_end0-ashift_qi_0
                                        # -- End function
	.section	.text.ashift_qi_1,"ax",@progbits
	.hidden	ashift_qi_1             # -- Begin function ashift_qi_1
	.globl	ashift_qi_1
	.type	ashift_qi_1,@function
ashift_qi_1:                            # @ashift_qi_1
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 1
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, 254
	i32.and 	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end1:
	.size	ashift_qi_1, .Lfunc_end1-ashift_qi_1
                                        # -- End function
	.section	.text.ashift_qi_2,"ax",@progbits
	.hidden	ashift_qi_2             # -- Begin function ashift_qi_2
	.globl	ashift_qi_2
	.type	ashift_qi_2,@function
ashift_qi_2:                            # @ashift_qi_2
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 2
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, 252
	i32.and 	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end2:
	.size	ashift_qi_2, .Lfunc_end2-ashift_qi_2
                                        # -- End function
	.section	.text.ashift_qi_3,"ax",@progbits
	.hidden	ashift_qi_3             # -- Begin function ashift_qi_3
	.globl	ashift_qi_3
	.type	ashift_qi_3,@function
ashift_qi_3:                            # @ashift_qi_3
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 3
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, 248
	i32.and 	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end3:
	.size	ashift_qi_3, .Lfunc_end3-ashift_qi_3
                                        # -- End function
	.section	.text.ashift_qi_4,"ax",@progbits
	.hidden	ashift_qi_4             # -- Begin function ashift_qi_4
	.globl	ashift_qi_4
	.type	ashift_qi_4,@function
ashift_qi_4:                            # @ashift_qi_4
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 4
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, 240
	i32.and 	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end4:
	.size	ashift_qi_4, .Lfunc_end4-ashift_qi_4
                                        # -- End function
	.section	.text.ashift_qi_5,"ax",@progbits
	.hidden	ashift_qi_5             # -- Begin function ashift_qi_5
	.globl	ashift_qi_5
	.type	ashift_qi_5,@function
ashift_qi_5:                            # @ashift_qi_5
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 5
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, 224
	i32.and 	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end5:
	.size	ashift_qi_5, .Lfunc_end5-ashift_qi_5
                                        # -- End function
	.section	.text.ashift_qi_6,"ax",@progbits
	.hidden	ashift_qi_6             # -- Begin function ashift_qi_6
	.globl	ashift_qi_6
	.type	ashift_qi_6,@function
ashift_qi_6:                            # @ashift_qi_6
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 6
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, 192
	i32.and 	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end6:
	.size	ashift_qi_6, .Lfunc_end6-ashift_qi_6
                                        # -- End function
	.section	.text.ashift_qi_7,"ax",@progbits
	.hidden	ashift_qi_7             # -- Begin function ashift_qi_7
	.globl	ashift_qi_7
	.type	ashift_qi_7,@function
ashift_qi_7:                            # @ashift_qi_7
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 7
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, 128
	i32.and 	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end7:
	.size	ashift_qi_7, .Lfunc_end7-ashift_qi_7
                                        # -- End function
	.section	.text.lshiftrt_qi_0,"ax",@progbits
	.hidden	lshiftrt_qi_0           # -- Begin function lshiftrt_qi_0
	.globl	lshiftrt_qi_0
	.type	lshiftrt_qi_0,@function
lshiftrt_qi_0:                          # @lshiftrt_qi_0
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	copy_local	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end8:
	.size	lshiftrt_qi_0, .Lfunc_end8-lshiftrt_qi_0
                                        # -- End function
	.section	.text.lshiftrt_qi_1,"ax",@progbits
	.hidden	lshiftrt_qi_1           # -- Begin function lshiftrt_qi_1
	.globl	lshiftrt_qi_1
	.type	lshiftrt_qi_1,@function
lshiftrt_qi_1:                          # @lshiftrt_qi_1
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 1
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end9:
	.size	lshiftrt_qi_1, .Lfunc_end9-lshiftrt_qi_1
                                        # -- End function
	.section	.text.lshiftrt_qi_2,"ax",@progbits
	.hidden	lshiftrt_qi_2           # -- Begin function lshiftrt_qi_2
	.globl	lshiftrt_qi_2
	.type	lshiftrt_qi_2,@function
lshiftrt_qi_2:                          # @lshiftrt_qi_2
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 2
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end10:
	.size	lshiftrt_qi_2, .Lfunc_end10-lshiftrt_qi_2
                                        # -- End function
	.section	.text.lshiftrt_qi_3,"ax",@progbits
	.hidden	lshiftrt_qi_3           # -- Begin function lshiftrt_qi_3
	.globl	lshiftrt_qi_3
	.type	lshiftrt_qi_3,@function
lshiftrt_qi_3:                          # @lshiftrt_qi_3
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 3
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end11:
	.size	lshiftrt_qi_3, .Lfunc_end11-lshiftrt_qi_3
                                        # -- End function
	.section	.text.lshiftrt_qi_4,"ax",@progbits
	.hidden	lshiftrt_qi_4           # -- Begin function lshiftrt_qi_4
	.globl	lshiftrt_qi_4
	.type	lshiftrt_qi_4,@function
lshiftrt_qi_4:                          # @lshiftrt_qi_4
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 4
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end12:
	.size	lshiftrt_qi_4, .Lfunc_end12-lshiftrt_qi_4
                                        # -- End function
	.section	.text.lshiftrt_qi_5,"ax",@progbits
	.hidden	lshiftrt_qi_5           # -- Begin function lshiftrt_qi_5
	.globl	lshiftrt_qi_5
	.type	lshiftrt_qi_5,@function
lshiftrt_qi_5:                          # @lshiftrt_qi_5
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 5
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end13:
	.size	lshiftrt_qi_5, .Lfunc_end13-lshiftrt_qi_5
                                        # -- End function
	.section	.text.lshiftrt_qi_6,"ax",@progbits
	.hidden	lshiftrt_qi_6           # -- Begin function lshiftrt_qi_6
	.globl	lshiftrt_qi_6
	.type	lshiftrt_qi_6,@function
lshiftrt_qi_6:                          # @lshiftrt_qi_6
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 6
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end14:
	.size	lshiftrt_qi_6, .Lfunc_end14-lshiftrt_qi_6
                                        # -- End function
	.section	.text.lshiftrt_qi_7,"ax",@progbits
	.hidden	lshiftrt_qi_7           # -- Begin function lshiftrt_qi_7
	.globl	lshiftrt_qi_7
	.type	lshiftrt_qi_7,@function
lshiftrt_qi_7:                          # @lshiftrt_qi_7
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 7
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end15:
	.size	lshiftrt_qi_7, .Lfunc_end15-lshiftrt_qi_7
                                        # -- End function
	.section	.text.ashiftrt_qi_0,"ax",@progbits
	.hidden	ashiftrt_qi_0           # -- Begin function ashiftrt_qi_0
	.globl	ashiftrt_qi_0
	.type	ashiftrt_qi_0,@function
ashiftrt_qi_0:                          # @ashiftrt_qi_0
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	copy_local	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end16:
	.size	ashiftrt_qi_0, .Lfunc_end16-ashiftrt_qi_0
                                        # -- End function
	.section	.text.ashiftrt_qi_1,"ax",@progbits
	.hidden	ashiftrt_qi_1           # -- Begin function ashiftrt_qi_1
	.globl	ashiftrt_qi_1
	.type	ashiftrt_qi_1,@function
ashiftrt_qi_1:                          # @ashiftrt_qi_1
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 1
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end17:
	.size	ashiftrt_qi_1, .Lfunc_end17-ashiftrt_qi_1
                                        # -- End function
	.section	.text.ashiftrt_qi_2,"ax",@progbits
	.hidden	ashiftrt_qi_2           # -- Begin function ashiftrt_qi_2
	.globl	ashiftrt_qi_2
	.type	ashiftrt_qi_2,@function
ashiftrt_qi_2:                          # @ashiftrt_qi_2
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 2
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end18:
	.size	ashiftrt_qi_2, .Lfunc_end18-ashiftrt_qi_2
                                        # -- End function
	.section	.text.ashiftrt_qi_3,"ax",@progbits
	.hidden	ashiftrt_qi_3           # -- Begin function ashiftrt_qi_3
	.globl	ashiftrt_qi_3
	.type	ashiftrt_qi_3,@function
ashiftrt_qi_3:                          # @ashiftrt_qi_3
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 3
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end19:
	.size	ashiftrt_qi_3, .Lfunc_end19-ashiftrt_qi_3
                                        # -- End function
	.section	.text.ashiftrt_qi_4,"ax",@progbits
	.hidden	ashiftrt_qi_4           # -- Begin function ashiftrt_qi_4
	.globl	ashiftrt_qi_4
	.type	ashiftrt_qi_4,@function
ashiftrt_qi_4:                          # @ashiftrt_qi_4
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 4
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end20:
	.size	ashiftrt_qi_4, .Lfunc_end20-ashiftrt_qi_4
                                        # -- End function
	.section	.text.ashiftrt_qi_5,"ax",@progbits
	.hidden	ashiftrt_qi_5           # -- Begin function ashiftrt_qi_5
	.globl	ashiftrt_qi_5
	.type	ashiftrt_qi_5,@function
ashiftrt_qi_5:                          # @ashiftrt_qi_5
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 5
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end21:
	.size	ashiftrt_qi_5, .Lfunc_end21-ashiftrt_qi_5
                                        # -- End function
	.section	.text.ashiftrt_qi_6,"ax",@progbits
	.hidden	ashiftrt_qi_6           # -- Begin function ashiftrt_qi_6
	.globl	ashiftrt_qi_6
	.type	ashiftrt_qi_6,@function
ashiftrt_qi_6:                          # @ashiftrt_qi_6
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 6
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end22:
	.size	ashiftrt_qi_6, .Lfunc_end22-ashiftrt_qi_6
                                        # -- End function
	.section	.text.ashiftrt_qi_7,"ax",@progbits
	.hidden	ashiftrt_qi_7           # -- Begin function ashiftrt_qi_7
	.globl	ashiftrt_qi_7
	.type	ashiftrt_qi_7,@function
ashiftrt_qi_7:                          # @ashiftrt_qi_7
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 7
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end23:
	.size	ashiftrt_qi_7, .Lfunc_end23-ashiftrt_qi_7
                                        # -- End function
	.section	.text.ashift_hi_0,"ax",@progbits
	.hidden	ashift_hi_0             # -- Begin function ashift_hi_0
	.globl	ashift_hi_0
	.type	ashift_hi_0,@function
ashift_hi_0:                            # @ashift_hi_0
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	copy_local	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end24:
	.size	ashift_hi_0, .Lfunc_end24-ashift_hi_0
                                        # -- End function
	.section	.text.ashift_hi_1,"ax",@progbits
	.hidden	ashift_hi_1             # -- Begin function ashift_hi_1
	.globl	ashift_hi_1
	.type	ashift_hi_1,@function
ashift_hi_1:                            # @ashift_hi_1
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 1
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, 65534
	i32.and 	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end25:
	.size	ashift_hi_1, .Lfunc_end25-ashift_hi_1
                                        # -- End function
	.section	.text.ashift_hi_2,"ax",@progbits
	.hidden	ashift_hi_2             # -- Begin function ashift_hi_2
	.globl	ashift_hi_2
	.type	ashift_hi_2,@function
ashift_hi_2:                            # @ashift_hi_2
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 2
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, 65532
	i32.and 	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end26:
	.size	ashift_hi_2, .Lfunc_end26-ashift_hi_2
                                        # -- End function
	.section	.text.ashift_hi_3,"ax",@progbits
	.hidden	ashift_hi_3             # -- Begin function ashift_hi_3
	.globl	ashift_hi_3
	.type	ashift_hi_3,@function
ashift_hi_3:                            # @ashift_hi_3
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 3
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, 65528
	i32.and 	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end27:
	.size	ashift_hi_3, .Lfunc_end27-ashift_hi_3
                                        # -- End function
	.section	.text.ashift_hi_4,"ax",@progbits
	.hidden	ashift_hi_4             # -- Begin function ashift_hi_4
	.globl	ashift_hi_4
	.type	ashift_hi_4,@function
ashift_hi_4:                            # @ashift_hi_4
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 4
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, 65520
	i32.and 	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end28:
	.size	ashift_hi_4, .Lfunc_end28-ashift_hi_4
                                        # -- End function
	.section	.text.ashift_hi_5,"ax",@progbits
	.hidden	ashift_hi_5             # -- Begin function ashift_hi_5
	.globl	ashift_hi_5
	.type	ashift_hi_5,@function
ashift_hi_5:                            # @ashift_hi_5
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 5
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, 65504
	i32.and 	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end29:
	.size	ashift_hi_5, .Lfunc_end29-ashift_hi_5
                                        # -- End function
	.section	.text.ashift_hi_6,"ax",@progbits
	.hidden	ashift_hi_6             # -- Begin function ashift_hi_6
	.globl	ashift_hi_6
	.type	ashift_hi_6,@function
ashift_hi_6:                            # @ashift_hi_6
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 6
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, 65472
	i32.and 	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end30:
	.size	ashift_hi_6, .Lfunc_end30-ashift_hi_6
                                        # -- End function
	.section	.text.ashift_hi_7,"ax",@progbits
	.hidden	ashift_hi_7             # -- Begin function ashift_hi_7
	.globl	ashift_hi_7
	.type	ashift_hi_7,@function
ashift_hi_7:                            # @ashift_hi_7
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 7
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, 65408
	i32.and 	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end31:
	.size	ashift_hi_7, .Lfunc_end31-ashift_hi_7
                                        # -- End function
	.section	.text.ashift_hi_8,"ax",@progbits
	.hidden	ashift_hi_8             # -- Begin function ashift_hi_8
	.globl	ashift_hi_8
	.type	ashift_hi_8,@function
ashift_hi_8:                            # @ashift_hi_8
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 8
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, 65280
	i32.and 	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end32:
	.size	ashift_hi_8, .Lfunc_end32-ashift_hi_8
                                        # -- End function
	.section	.text.ashift_hi_9,"ax",@progbits
	.hidden	ashift_hi_9             # -- Begin function ashift_hi_9
	.globl	ashift_hi_9
	.type	ashift_hi_9,@function
ashift_hi_9:                            # @ashift_hi_9
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 9
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, 65024
	i32.and 	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end33:
	.size	ashift_hi_9, .Lfunc_end33-ashift_hi_9
                                        # -- End function
	.section	.text.ashift_hi_10,"ax",@progbits
	.hidden	ashift_hi_10            # -- Begin function ashift_hi_10
	.globl	ashift_hi_10
	.type	ashift_hi_10,@function
ashift_hi_10:                           # @ashift_hi_10
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 10
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, 64512
	i32.and 	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end34:
	.size	ashift_hi_10, .Lfunc_end34-ashift_hi_10
                                        # -- End function
	.section	.text.ashift_hi_11,"ax",@progbits
	.hidden	ashift_hi_11            # -- Begin function ashift_hi_11
	.globl	ashift_hi_11
	.type	ashift_hi_11,@function
ashift_hi_11:                           # @ashift_hi_11
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 11
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, 63488
	i32.and 	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end35:
	.size	ashift_hi_11, .Lfunc_end35-ashift_hi_11
                                        # -- End function
	.section	.text.ashift_hi_12,"ax",@progbits
	.hidden	ashift_hi_12            # -- Begin function ashift_hi_12
	.globl	ashift_hi_12
	.type	ashift_hi_12,@function
ashift_hi_12:                           # @ashift_hi_12
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 12
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, 61440
	i32.and 	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end36:
	.size	ashift_hi_12, .Lfunc_end36-ashift_hi_12
                                        # -- End function
	.section	.text.ashift_hi_13,"ax",@progbits
	.hidden	ashift_hi_13            # -- Begin function ashift_hi_13
	.globl	ashift_hi_13
	.type	ashift_hi_13,@function
ashift_hi_13:                           # @ashift_hi_13
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 13
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, 57344
	i32.and 	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end37:
	.size	ashift_hi_13, .Lfunc_end37-ashift_hi_13
                                        # -- End function
	.section	.text.ashift_hi_14,"ax",@progbits
	.hidden	ashift_hi_14            # -- Begin function ashift_hi_14
	.globl	ashift_hi_14
	.type	ashift_hi_14,@function
ashift_hi_14:                           # @ashift_hi_14
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 14
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, 49152
	i32.and 	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end38:
	.size	ashift_hi_14, .Lfunc_end38-ashift_hi_14
                                        # -- End function
	.section	.text.ashift_hi_15,"ax",@progbits
	.hidden	ashift_hi_15            # -- Begin function ashift_hi_15
	.globl	ashift_hi_15
	.type	ashift_hi_15,@function
ashift_hi_15:                           # @ashift_hi_15
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 15
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, 32768
	i32.and 	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end39:
	.size	ashift_hi_15, .Lfunc_end39-ashift_hi_15
                                        # -- End function
	.section	.text.lshiftrt_hi_0,"ax",@progbits
	.hidden	lshiftrt_hi_0           # -- Begin function lshiftrt_hi_0
	.globl	lshiftrt_hi_0
	.type	lshiftrt_hi_0,@function
lshiftrt_hi_0:                          # @lshiftrt_hi_0
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	copy_local	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end40:
	.size	lshiftrt_hi_0, .Lfunc_end40-lshiftrt_hi_0
                                        # -- End function
	.section	.text.lshiftrt_hi_1,"ax",@progbits
	.hidden	lshiftrt_hi_1           # -- Begin function lshiftrt_hi_1
	.globl	lshiftrt_hi_1
	.type	lshiftrt_hi_1,@function
lshiftrt_hi_1:                          # @lshiftrt_hi_1
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 1
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end41:
	.size	lshiftrt_hi_1, .Lfunc_end41-lshiftrt_hi_1
                                        # -- End function
	.section	.text.lshiftrt_hi_2,"ax",@progbits
	.hidden	lshiftrt_hi_2           # -- Begin function lshiftrt_hi_2
	.globl	lshiftrt_hi_2
	.type	lshiftrt_hi_2,@function
lshiftrt_hi_2:                          # @lshiftrt_hi_2
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 2
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end42:
	.size	lshiftrt_hi_2, .Lfunc_end42-lshiftrt_hi_2
                                        # -- End function
	.section	.text.lshiftrt_hi_3,"ax",@progbits
	.hidden	lshiftrt_hi_3           # -- Begin function lshiftrt_hi_3
	.globl	lshiftrt_hi_3
	.type	lshiftrt_hi_3,@function
lshiftrt_hi_3:                          # @lshiftrt_hi_3
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 3
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end43:
	.size	lshiftrt_hi_3, .Lfunc_end43-lshiftrt_hi_3
                                        # -- End function
	.section	.text.lshiftrt_hi_4,"ax",@progbits
	.hidden	lshiftrt_hi_4           # -- Begin function lshiftrt_hi_4
	.globl	lshiftrt_hi_4
	.type	lshiftrt_hi_4,@function
lshiftrt_hi_4:                          # @lshiftrt_hi_4
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 4
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end44:
	.size	lshiftrt_hi_4, .Lfunc_end44-lshiftrt_hi_4
                                        # -- End function
	.section	.text.lshiftrt_hi_5,"ax",@progbits
	.hidden	lshiftrt_hi_5           # -- Begin function lshiftrt_hi_5
	.globl	lshiftrt_hi_5
	.type	lshiftrt_hi_5,@function
lshiftrt_hi_5:                          # @lshiftrt_hi_5
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 5
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end45:
	.size	lshiftrt_hi_5, .Lfunc_end45-lshiftrt_hi_5
                                        # -- End function
	.section	.text.lshiftrt_hi_6,"ax",@progbits
	.hidden	lshiftrt_hi_6           # -- Begin function lshiftrt_hi_6
	.globl	lshiftrt_hi_6
	.type	lshiftrt_hi_6,@function
lshiftrt_hi_6:                          # @lshiftrt_hi_6
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 6
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end46:
	.size	lshiftrt_hi_6, .Lfunc_end46-lshiftrt_hi_6
                                        # -- End function
	.section	.text.lshiftrt_hi_7,"ax",@progbits
	.hidden	lshiftrt_hi_7           # -- Begin function lshiftrt_hi_7
	.globl	lshiftrt_hi_7
	.type	lshiftrt_hi_7,@function
lshiftrt_hi_7:                          # @lshiftrt_hi_7
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 7
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end47:
	.size	lshiftrt_hi_7, .Lfunc_end47-lshiftrt_hi_7
                                        # -- End function
	.section	.text.lshiftrt_hi_8,"ax",@progbits
	.hidden	lshiftrt_hi_8           # -- Begin function lshiftrt_hi_8
	.globl	lshiftrt_hi_8
	.type	lshiftrt_hi_8,@function
lshiftrt_hi_8:                          # @lshiftrt_hi_8
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 8
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end48:
	.size	lshiftrt_hi_8, .Lfunc_end48-lshiftrt_hi_8
                                        # -- End function
	.section	.text.lshiftrt_hi_9,"ax",@progbits
	.hidden	lshiftrt_hi_9           # -- Begin function lshiftrt_hi_9
	.globl	lshiftrt_hi_9
	.type	lshiftrt_hi_9,@function
lshiftrt_hi_9:                          # @lshiftrt_hi_9
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 9
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end49:
	.size	lshiftrt_hi_9, .Lfunc_end49-lshiftrt_hi_9
                                        # -- End function
	.section	.text.lshiftrt_hi_10,"ax",@progbits
	.hidden	lshiftrt_hi_10          # -- Begin function lshiftrt_hi_10
	.globl	lshiftrt_hi_10
	.type	lshiftrt_hi_10,@function
lshiftrt_hi_10:                         # @lshiftrt_hi_10
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 10
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end50:
	.size	lshiftrt_hi_10, .Lfunc_end50-lshiftrt_hi_10
                                        # -- End function
	.section	.text.lshiftrt_hi_11,"ax",@progbits
	.hidden	lshiftrt_hi_11          # -- Begin function lshiftrt_hi_11
	.globl	lshiftrt_hi_11
	.type	lshiftrt_hi_11,@function
lshiftrt_hi_11:                         # @lshiftrt_hi_11
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 11
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end51:
	.size	lshiftrt_hi_11, .Lfunc_end51-lshiftrt_hi_11
                                        # -- End function
	.section	.text.lshiftrt_hi_12,"ax",@progbits
	.hidden	lshiftrt_hi_12          # -- Begin function lshiftrt_hi_12
	.globl	lshiftrt_hi_12
	.type	lshiftrt_hi_12,@function
lshiftrt_hi_12:                         # @lshiftrt_hi_12
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 12
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end52:
	.size	lshiftrt_hi_12, .Lfunc_end52-lshiftrt_hi_12
                                        # -- End function
	.section	.text.lshiftrt_hi_13,"ax",@progbits
	.hidden	lshiftrt_hi_13          # -- Begin function lshiftrt_hi_13
	.globl	lshiftrt_hi_13
	.type	lshiftrt_hi_13,@function
lshiftrt_hi_13:                         # @lshiftrt_hi_13
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 13
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end53:
	.size	lshiftrt_hi_13, .Lfunc_end53-lshiftrt_hi_13
                                        # -- End function
	.section	.text.lshiftrt_hi_14,"ax",@progbits
	.hidden	lshiftrt_hi_14          # -- Begin function lshiftrt_hi_14
	.globl	lshiftrt_hi_14
	.type	lshiftrt_hi_14,@function
lshiftrt_hi_14:                         # @lshiftrt_hi_14
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 14
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end54:
	.size	lshiftrt_hi_14, .Lfunc_end54-lshiftrt_hi_14
                                        # -- End function
	.section	.text.lshiftrt_hi_15,"ax",@progbits
	.hidden	lshiftrt_hi_15          # -- Begin function lshiftrt_hi_15
	.globl	lshiftrt_hi_15
	.type	lshiftrt_hi_15,@function
lshiftrt_hi_15:                         # @lshiftrt_hi_15
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 15
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end55:
	.size	lshiftrt_hi_15, .Lfunc_end55-lshiftrt_hi_15
                                        # -- End function
	.section	.text.ashiftrt_hi_0,"ax",@progbits
	.hidden	ashiftrt_hi_0           # -- Begin function ashiftrt_hi_0
	.globl	ashiftrt_hi_0
	.type	ashiftrt_hi_0,@function
ashiftrt_hi_0:                          # @ashiftrt_hi_0
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	copy_local	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end56:
	.size	ashiftrt_hi_0, .Lfunc_end56-ashiftrt_hi_0
                                        # -- End function
	.section	.text.ashiftrt_hi_1,"ax",@progbits
	.hidden	ashiftrt_hi_1           # -- Begin function ashiftrt_hi_1
	.globl	ashiftrt_hi_1
	.type	ashiftrt_hi_1,@function
ashiftrt_hi_1:                          # @ashiftrt_hi_1
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 1
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end57:
	.size	ashiftrt_hi_1, .Lfunc_end57-ashiftrt_hi_1
                                        # -- End function
	.section	.text.ashiftrt_hi_2,"ax",@progbits
	.hidden	ashiftrt_hi_2           # -- Begin function ashiftrt_hi_2
	.globl	ashiftrt_hi_2
	.type	ashiftrt_hi_2,@function
ashiftrt_hi_2:                          # @ashiftrt_hi_2
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 2
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end58:
	.size	ashiftrt_hi_2, .Lfunc_end58-ashiftrt_hi_2
                                        # -- End function
	.section	.text.ashiftrt_hi_3,"ax",@progbits
	.hidden	ashiftrt_hi_3           # -- Begin function ashiftrt_hi_3
	.globl	ashiftrt_hi_3
	.type	ashiftrt_hi_3,@function
ashiftrt_hi_3:                          # @ashiftrt_hi_3
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 3
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end59:
	.size	ashiftrt_hi_3, .Lfunc_end59-ashiftrt_hi_3
                                        # -- End function
	.section	.text.ashiftrt_hi_4,"ax",@progbits
	.hidden	ashiftrt_hi_4           # -- Begin function ashiftrt_hi_4
	.globl	ashiftrt_hi_4
	.type	ashiftrt_hi_4,@function
ashiftrt_hi_4:                          # @ashiftrt_hi_4
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 4
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end60:
	.size	ashiftrt_hi_4, .Lfunc_end60-ashiftrt_hi_4
                                        # -- End function
	.section	.text.ashiftrt_hi_5,"ax",@progbits
	.hidden	ashiftrt_hi_5           # -- Begin function ashiftrt_hi_5
	.globl	ashiftrt_hi_5
	.type	ashiftrt_hi_5,@function
ashiftrt_hi_5:                          # @ashiftrt_hi_5
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 5
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end61:
	.size	ashiftrt_hi_5, .Lfunc_end61-ashiftrt_hi_5
                                        # -- End function
	.section	.text.ashiftrt_hi_6,"ax",@progbits
	.hidden	ashiftrt_hi_6           # -- Begin function ashiftrt_hi_6
	.globl	ashiftrt_hi_6
	.type	ashiftrt_hi_6,@function
ashiftrt_hi_6:                          # @ashiftrt_hi_6
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 6
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end62:
	.size	ashiftrt_hi_6, .Lfunc_end62-ashiftrt_hi_6
                                        # -- End function
	.section	.text.ashiftrt_hi_7,"ax",@progbits
	.hidden	ashiftrt_hi_7           # -- Begin function ashiftrt_hi_7
	.globl	ashiftrt_hi_7
	.type	ashiftrt_hi_7,@function
ashiftrt_hi_7:                          # @ashiftrt_hi_7
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 7
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end63:
	.size	ashiftrt_hi_7, .Lfunc_end63-ashiftrt_hi_7
                                        # -- End function
	.section	.text.ashiftrt_hi_8,"ax",@progbits
	.hidden	ashiftrt_hi_8           # -- Begin function ashiftrt_hi_8
	.globl	ashiftrt_hi_8
	.type	ashiftrt_hi_8,@function
ashiftrt_hi_8:                          # @ashiftrt_hi_8
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 8
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end64:
	.size	ashiftrt_hi_8, .Lfunc_end64-ashiftrt_hi_8
                                        # -- End function
	.section	.text.ashiftrt_hi_9,"ax",@progbits
	.hidden	ashiftrt_hi_9           # -- Begin function ashiftrt_hi_9
	.globl	ashiftrt_hi_9
	.type	ashiftrt_hi_9,@function
ashiftrt_hi_9:                          # @ashiftrt_hi_9
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 9
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end65:
	.size	ashiftrt_hi_9, .Lfunc_end65-ashiftrt_hi_9
                                        # -- End function
	.section	.text.ashiftrt_hi_10,"ax",@progbits
	.hidden	ashiftrt_hi_10          # -- Begin function ashiftrt_hi_10
	.globl	ashiftrt_hi_10
	.type	ashiftrt_hi_10,@function
ashiftrt_hi_10:                         # @ashiftrt_hi_10
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 10
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end66:
	.size	ashiftrt_hi_10, .Lfunc_end66-ashiftrt_hi_10
                                        # -- End function
	.section	.text.ashiftrt_hi_11,"ax",@progbits
	.hidden	ashiftrt_hi_11          # -- Begin function ashiftrt_hi_11
	.globl	ashiftrt_hi_11
	.type	ashiftrt_hi_11,@function
ashiftrt_hi_11:                         # @ashiftrt_hi_11
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 11
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end67:
	.size	ashiftrt_hi_11, .Lfunc_end67-ashiftrt_hi_11
                                        # -- End function
	.section	.text.ashiftrt_hi_12,"ax",@progbits
	.hidden	ashiftrt_hi_12          # -- Begin function ashiftrt_hi_12
	.globl	ashiftrt_hi_12
	.type	ashiftrt_hi_12,@function
ashiftrt_hi_12:                         # @ashiftrt_hi_12
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 12
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end68:
	.size	ashiftrt_hi_12, .Lfunc_end68-ashiftrt_hi_12
                                        # -- End function
	.section	.text.ashiftrt_hi_13,"ax",@progbits
	.hidden	ashiftrt_hi_13          # -- Begin function ashiftrt_hi_13
	.globl	ashiftrt_hi_13
	.type	ashiftrt_hi_13,@function
ashiftrt_hi_13:                         # @ashiftrt_hi_13
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 13
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end69:
	.size	ashiftrt_hi_13, .Lfunc_end69-ashiftrt_hi_13
                                        # -- End function
	.section	.text.ashiftrt_hi_14,"ax",@progbits
	.hidden	ashiftrt_hi_14          # -- Begin function ashiftrt_hi_14
	.globl	ashiftrt_hi_14
	.type	ashiftrt_hi_14,@function
ashiftrt_hi_14:                         # @ashiftrt_hi_14
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 14
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end70:
	.size	ashiftrt_hi_14, .Lfunc_end70-ashiftrt_hi_14
                                        # -- End function
	.section	.text.ashiftrt_hi_15,"ax",@progbits
	.hidden	ashiftrt_hi_15          # -- Begin function ashiftrt_hi_15
	.globl	ashiftrt_hi_15
	.type	ashiftrt_hi_15,@function
ashiftrt_hi_15:                         # @ashiftrt_hi_15
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 15
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end71:
	.size	ashiftrt_hi_15, .Lfunc_end71-ashiftrt_hi_15
                                        # -- End function
	.section	.text.ashift_si_0,"ax",@progbits
	.hidden	ashift_si_0             # -- Begin function ashift_si_0
	.globl	ashift_si_0
	.type	ashift_si_0,@function
ashift_si_0:                            # @ashift_si_0
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	copy_local	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end72:
	.size	ashift_si_0, .Lfunc_end72-ashift_si_0
                                        # -- End function
	.section	.text.ashift_si_1,"ax",@progbits
	.hidden	ashift_si_1             # -- Begin function ashift_si_1
	.globl	ashift_si_1
	.type	ashift_si_1,@function
ashift_si_1:                            # @ashift_si_1
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 1
	i32.shl 	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end73:
	.size	ashift_si_1, .Lfunc_end73-ashift_si_1
                                        # -- End function
	.section	.text.ashift_si_2,"ax",@progbits
	.hidden	ashift_si_2             # -- Begin function ashift_si_2
	.globl	ashift_si_2
	.type	ashift_si_2,@function
ashift_si_2:                            # @ashift_si_2
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 2
	i32.shl 	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end74:
	.size	ashift_si_2, .Lfunc_end74-ashift_si_2
                                        # -- End function
	.section	.text.ashift_si_3,"ax",@progbits
	.hidden	ashift_si_3             # -- Begin function ashift_si_3
	.globl	ashift_si_3
	.type	ashift_si_3,@function
ashift_si_3:                            # @ashift_si_3
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 3
	i32.shl 	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end75:
	.size	ashift_si_3, .Lfunc_end75-ashift_si_3
                                        # -- End function
	.section	.text.ashift_si_4,"ax",@progbits
	.hidden	ashift_si_4             # -- Begin function ashift_si_4
	.globl	ashift_si_4
	.type	ashift_si_4,@function
ashift_si_4:                            # @ashift_si_4
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 4
	i32.shl 	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end76:
	.size	ashift_si_4, .Lfunc_end76-ashift_si_4
                                        # -- End function
	.section	.text.ashift_si_5,"ax",@progbits
	.hidden	ashift_si_5             # -- Begin function ashift_si_5
	.globl	ashift_si_5
	.type	ashift_si_5,@function
ashift_si_5:                            # @ashift_si_5
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 5
	i32.shl 	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end77:
	.size	ashift_si_5, .Lfunc_end77-ashift_si_5
                                        # -- End function
	.section	.text.ashift_si_6,"ax",@progbits
	.hidden	ashift_si_6             # -- Begin function ashift_si_6
	.globl	ashift_si_6
	.type	ashift_si_6,@function
ashift_si_6:                            # @ashift_si_6
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 6
	i32.shl 	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end78:
	.size	ashift_si_6, .Lfunc_end78-ashift_si_6
                                        # -- End function
	.section	.text.ashift_si_7,"ax",@progbits
	.hidden	ashift_si_7             # -- Begin function ashift_si_7
	.globl	ashift_si_7
	.type	ashift_si_7,@function
ashift_si_7:                            # @ashift_si_7
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 7
	i32.shl 	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end79:
	.size	ashift_si_7, .Lfunc_end79-ashift_si_7
                                        # -- End function
	.section	.text.ashift_si_8,"ax",@progbits
	.hidden	ashift_si_8             # -- Begin function ashift_si_8
	.globl	ashift_si_8
	.type	ashift_si_8,@function
ashift_si_8:                            # @ashift_si_8
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 8
	i32.shl 	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end80:
	.size	ashift_si_8, .Lfunc_end80-ashift_si_8
                                        # -- End function
	.section	.text.ashift_si_9,"ax",@progbits
	.hidden	ashift_si_9             # -- Begin function ashift_si_9
	.globl	ashift_si_9
	.type	ashift_si_9,@function
ashift_si_9:                            # @ashift_si_9
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 9
	i32.shl 	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end81:
	.size	ashift_si_9, .Lfunc_end81-ashift_si_9
                                        # -- End function
	.section	.text.ashift_si_10,"ax",@progbits
	.hidden	ashift_si_10            # -- Begin function ashift_si_10
	.globl	ashift_si_10
	.type	ashift_si_10,@function
ashift_si_10:                           # @ashift_si_10
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 10
	i32.shl 	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end82:
	.size	ashift_si_10, .Lfunc_end82-ashift_si_10
                                        # -- End function
	.section	.text.ashift_si_11,"ax",@progbits
	.hidden	ashift_si_11            # -- Begin function ashift_si_11
	.globl	ashift_si_11
	.type	ashift_si_11,@function
ashift_si_11:                           # @ashift_si_11
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 11
	i32.shl 	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end83:
	.size	ashift_si_11, .Lfunc_end83-ashift_si_11
                                        # -- End function
	.section	.text.ashift_si_12,"ax",@progbits
	.hidden	ashift_si_12            # -- Begin function ashift_si_12
	.globl	ashift_si_12
	.type	ashift_si_12,@function
ashift_si_12:                           # @ashift_si_12
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 12
	i32.shl 	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end84:
	.size	ashift_si_12, .Lfunc_end84-ashift_si_12
                                        # -- End function
	.section	.text.ashift_si_13,"ax",@progbits
	.hidden	ashift_si_13            # -- Begin function ashift_si_13
	.globl	ashift_si_13
	.type	ashift_si_13,@function
ashift_si_13:                           # @ashift_si_13
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 13
	i32.shl 	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end85:
	.size	ashift_si_13, .Lfunc_end85-ashift_si_13
                                        # -- End function
	.section	.text.ashift_si_14,"ax",@progbits
	.hidden	ashift_si_14            # -- Begin function ashift_si_14
	.globl	ashift_si_14
	.type	ashift_si_14,@function
ashift_si_14:                           # @ashift_si_14
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 14
	i32.shl 	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end86:
	.size	ashift_si_14, .Lfunc_end86-ashift_si_14
                                        # -- End function
	.section	.text.ashift_si_15,"ax",@progbits
	.hidden	ashift_si_15            # -- Begin function ashift_si_15
	.globl	ashift_si_15
	.type	ashift_si_15,@function
ashift_si_15:                           # @ashift_si_15
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 15
	i32.shl 	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end87:
	.size	ashift_si_15, .Lfunc_end87-ashift_si_15
                                        # -- End function
	.section	.text.ashift_si_16,"ax",@progbits
	.hidden	ashift_si_16            # -- Begin function ashift_si_16
	.globl	ashift_si_16
	.type	ashift_si_16,@function
ashift_si_16:                           # @ashift_si_16
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 16
	i32.shl 	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end88:
	.size	ashift_si_16, .Lfunc_end88-ashift_si_16
                                        # -- End function
	.section	.text.ashift_si_17,"ax",@progbits
	.hidden	ashift_si_17            # -- Begin function ashift_si_17
	.globl	ashift_si_17
	.type	ashift_si_17,@function
ashift_si_17:                           # @ashift_si_17
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 17
	i32.shl 	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end89:
	.size	ashift_si_17, .Lfunc_end89-ashift_si_17
                                        # -- End function
	.section	.text.ashift_si_18,"ax",@progbits
	.hidden	ashift_si_18            # -- Begin function ashift_si_18
	.globl	ashift_si_18
	.type	ashift_si_18,@function
ashift_si_18:                           # @ashift_si_18
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 18
	i32.shl 	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end90:
	.size	ashift_si_18, .Lfunc_end90-ashift_si_18
                                        # -- End function
	.section	.text.ashift_si_19,"ax",@progbits
	.hidden	ashift_si_19            # -- Begin function ashift_si_19
	.globl	ashift_si_19
	.type	ashift_si_19,@function
ashift_si_19:                           # @ashift_si_19
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 19
	i32.shl 	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end91:
	.size	ashift_si_19, .Lfunc_end91-ashift_si_19
                                        # -- End function
	.section	.text.ashift_si_20,"ax",@progbits
	.hidden	ashift_si_20            # -- Begin function ashift_si_20
	.globl	ashift_si_20
	.type	ashift_si_20,@function
ashift_si_20:                           # @ashift_si_20
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 20
	i32.shl 	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end92:
	.size	ashift_si_20, .Lfunc_end92-ashift_si_20
                                        # -- End function
	.section	.text.ashift_si_21,"ax",@progbits
	.hidden	ashift_si_21            # -- Begin function ashift_si_21
	.globl	ashift_si_21
	.type	ashift_si_21,@function
ashift_si_21:                           # @ashift_si_21
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 21
	i32.shl 	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end93:
	.size	ashift_si_21, .Lfunc_end93-ashift_si_21
                                        # -- End function
	.section	.text.ashift_si_22,"ax",@progbits
	.hidden	ashift_si_22            # -- Begin function ashift_si_22
	.globl	ashift_si_22
	.type	ashift_si_22,@function
ashift_si_22:                           # @ashift_si_22
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 22
	i32.shl 	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end94:
	.size	ashift_si_22, .Lfunc_end94-ashift_si_22
                                        # -- End function
	.section	.text.ashift_si_23,"ax",@progbits
	.hidden	ashift_si_23            # -- Begin function ashift_si_23
	.globl	ashift_si_23
	.type	ashift_si_23,@function
ashift_si_23:                           # @ashift_si_23
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 23
	i32.shl 	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end95:
	.size	ashift_si_23, .Lfunc_end95-ashift_si_23
                                        # -- End function
	.section	.text.ashift_si_24,"ax",@progbits
	.hidden	ashift_si_24            # -- Begin function ashift_si_24
	.globl	ashift_si_24
	.type	ashift_si_24,@function
ashift_si_24:                           # @ashift_si_24
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 24
	i32.shl 	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end96:
	.size	ashift_si_24, .Lfunc_end96-ashift_si_24
                                        # -- End function
	.section	.text.ashift_si_25,"ax",@progbits
	.hidden	ashift_si_25            # -- Begin function ashift_si_25
	.globl	ashift_si_25
	.type	ashift_si_25,@function
ashift_si_25:                           # @ashift_si_25
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 25
	i32.shl 	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end97:
	.size	ashift_si_25, .Lfunc_end97-ashift_si_25
                                        # -- End function
	.section	.text.ashift_si_26,"ax",@progbits
	.hidden	ashift_si_26            # -- Begin function ashift_si_26
	.globl	ashift_si_26
	.type	ashift_si_26,@function
ashift_si_26:                           # @ashift_si_26
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 26
	i32.shl 	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end98:
	.size	ashift_si_26, .Lfunc_end98-ashift_si_26
                                        # -- End function
	.section	.text.ashift_si_27,"ax",@progbits
	.hidden	ashift_si_27            # -- Begin function ashift_si_27
	.globl	ashift_si_27
	.type	ashift_si_27,@function
ashift_si_27:                           # @ashift_si_27
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 27
	i32.shl 	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end99:
	.size	ashift_si_27, .Lfunc_end99-ashift_si_27
                                        # -- End function
	.section	.text.ashift_si_28,"ax",@progbits
	.hidden	ashift_si_28            # -- Begin function ashift_si_28
	.globl	ashift_si_28
	.type	ashift_si_28,@function
ashift_si_28:                           # @ashift_si_28
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 28
	i32.shl 	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end100:
	.size	ashift_si_28, .Lfunc_end100-ashift_si_28
                                        # -- End function
	.section	.text.ashift_si_29,"ax",@progbits
	.hidden	ashift_si_29            # -- Begin function ashift_si_29
	.globl	ashift_si_29
	.type	ashift_si_29,@function
ashift_si_29:                           # @ashift_si_29
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 29
	i32.shl 	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end101:
	.size	ashift_si_29, .Lfunc_end101-ashift_si_29
                                        # -- End function
	.section	.text.ashift_si_30,"ax",@progbits
	.hidden	ashift_si_30            # -- Begin function ashift_si_30
	.globl	ashift_si_30
	.type	ashift_si_30,@function
ashift_si_30:                           # @ashift_si_30
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 30
	i32.shl 	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end102:
	.size	ashift_si_30, .Lfunc_end102-ashift_si_30
                                        # -- End function
	.section	.text.ashift_si_31,"ax",@progbits
	.hidden	ashift_si_31            # -- Begin function ashift_si_31
	.globl	ashift_si_31
	.type	ashift_si_31,@function
ashift_si_31:                           # @ashift_si_31
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 31
	i32.shl 	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end103:
	.size	ashift_si_31, .Lfunc_end103-ashift_si_31
                                        # -- End function
	.section	.text.lshiftrt_si_0,"ax",@progbits
	.hidden	lshiftrt_si_0           # -- Begin function lshiftrt_si_0
	.globl	lshiftrt_si_0
	.type	lshiftrt_si_0,@function
lshiftrt_si_0:                          # @lshiftrt_si_0
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	copy_local	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end104:
	.size	lshiftrt_si_0, .Lfunc_end104-lshiftrt_si_0
                                        # -- End function
	.section	.text.lshiftrt_si_1,"ax",@progbits
	.hidden	lshiftrt_si_1           # -- Begin function lshiftrt_si_1
	.globl	lshiftrt_si_1
	.type	lshiftrt_si_1,@function
lshiftrt_si_1:                          # @lshiftrt_si_1
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 1
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end105:
	.size	lshiftrt_si_1, .Lfunc_end105-lshiftrt_si_1
                                        # -- End function
	.section	.text.lshiftrt_si_2,"ax",@progbits
	.hidden	lshiftrt_si_2           # -- Begin function lshiftrt_si_2
	.globl	lshiftrt_si_2
	.type	lshiftrt_si_2,@function
lshiftrt_si_2:                          # @lshiftrt_si_2
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 2
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end106:
	.size	lshiftrt_si_2, .Lfunc_end106-lshiftrt_si_2
                                        # -- End function
	.section	.text.lshiftrt_si_3,"ax",@progbits
	.hidden	lshiftrt_si_3           # -- Begin function lshiftrt_si_3
	.globl	lshiftrt_si_3
	.type	lshiftrt_si_3,@function
lshiftrt_si_3:                          # @lshiftrt_si_3
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 3
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end107:
	.size	lshiftrt_si_3, .Lfunc_end107-lshiftrt_si_3
                                        # -- End function
	.section	.text.lshiftrt_si_4,"ax",@progbits
	.hidden	lshiftrt_si_4           # -- Begin function lshiftrt_si_4
	.globl	lshiftrt_si_4
	.type	lshiftrt_si_4,@function
lshiftrt_si_4:                          # @lshiftrt_si_4
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 4
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end108:
	.size	lshiftrt_si_4, .Lfunc_end108-lshiftrt_si_4
                                        # -- End function
	.section	.text.lshiftrt_si_5,"ax",@progbits
	.hidden	lshiftrt_si_5           # -- Begin function lshiftrt_si_5
	.globl	lshiftrt_si_5
	.type	lshiftrt_si_5,@function
lshiftrt_si_5:                          # @lshiftrt_si_5
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 5
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end109:
	.size	lshiftrt_si_5, .Lfunc_end109-lshiftrt_si_5
                                        # -- End function
	.section	.text.lshiftrt_si_6,"ax",@progbits
	.hidden	lshiftrt_si_6           # -- Begin function lshiftrt_si_6
	.globl	lshiftrt_si_6
	.type	lshiftrt_si_6,@function
lshiftrt_si_6:                          # @lshiftrt_si_6
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 6
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end110:
	.size	lshiftrt_si_6, .Lfunc_end110-lshiftrt_si_6
                                        # -- End function
	.section	.text.lshiftrt_si_7,"ax",@progbits
	.hidden	lshiftrt_si_7           # -- Begin function lshiftrt_si_7
	.globl	lshiftrt_si_7
	.type	lshiftrt_si_7,@function
lshiftrt_si_7:                          # @lshiftrt_si_7
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 7
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end111:
	.size	lshiftrt_si_7, .Lfunc_end111-lshiftrt_si_7
                                        # -- End function
	.section	.text.lshiftrt_si_8,"ax",@progbits
	.hidden	lshiftrt_si_8           # -- Begin function lshiftrt_si_8
	.globl	lshiftrt_si_8
	.type	lshiftrt_si_8,@function
lshiftrt_si_8:                          # @lshiftrt_si_8
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 8
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end112:
	.size	lshiftrt_si_8, .Lfunc_end112-lshiftrt_si_8
                                        # -- End function
	.section	.text.lshiftrt_si_9,"ax",@progbits
	.hidden	lshiftrt_si_9           # -- Begin function lshiftrt_si_9
	.globl	lshiftrt_si_9
	.type	lshiftrt_si_9,@function
lshiftrt_si_9:                          # @lshiftrt_si_9
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 9
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end113:
	.size	lshiftrt_si_9, .Lfunc_end113-lshiftrt_si_9
                                        # -- End function
	.section	.text.lshiftrt_si_10,"ax",@progbits
	.hidden	lshiftrt_si_10          # -- Begin function lshiftrt_si_10
	.globl	lshiftrt_si_10
	.type	lshiftrt_si_10,@function
lshiftrt_si_10:                         # @lshiftrt_si_10
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 10
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end114:
	.size	lshiftrt_si_10, .Lfunc_end114-lshiftrt_si_10
                                        # -- End function
	.section	.text.lshiftrt_si_11,"ax",@progbits
	.hidden	lshiftrt_si_11          # -- Begin function lshiftrt_si_11
	.globl	lshiftrt_si_11
	.type	lshiftrt_si_11,@function
lshiftrt_si_11:                         # @lshiftrt_si_11
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 11
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end115:
	.size	lshiftrt_si_11, .Lfunc_end115-lshiftrt_si_11
                                        # -- End function
	.section	.text.lshiftrt_si_12,"ax",@progbits
	.hidden	lshiftrt_si_12          # -- Begin function lshiftrt_si_12
	.globl	lshiftrt_si_12
	.type	lshiftrt_si_12,@function
lshiftrt_si_12:                         # @lshiftrt_si_12
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 12
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end116:
	.size	lshiftrt_si_12, .Lfunc_end116-lshiftrt_si_12
                                        # -- End function
	.section	.text.lshiftrt_si_13,"ax",@progbits
	.hidden	lshiftrt_si_13          # -- Begin function lshiftrt_si_13
	.globl	lshiftrt_si_13
	.type	lshiftrt_si_13,@function
lshiftrt_si_13:                         # @lshiftrt_si_13
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 13
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end117:
	.size	lshiftrt_si_13, .Lfunc_end117-lshiftrt_si_13
                                        # -- End function
	.section	.text.lshiftrt_si_14,"ax",@progbits
	.hidden	lshiftrt_si_14          # -- Begin function lshiftrt_si_14
	.globl	lshiftrt_si_14
	.type	lshiftrt_si_14,@function
lshiftrt_si_14:                         # @lshiftrt_si_14
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 14
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end118:
	.size	lshiftrt_si_14, .Lfunc_end118-lshiftrt_si_14
                                        # -- End function
	.section	.text.lshiftrt_si_15,"ax",@progbits
	.hidden	lshiftrt_si_15          # -- Begin function lshiftrt_si_15
	.globl	lshiftrt_si_15
	.type	lshiftrt_si_15,@function
lshiftrt_si_15:                         # @lshiftrt_si_15
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 15
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end119:
	.size	lshiftrt_si_15, .Lfunc_end119-lshiftrt_si_15
                                        # -- End function
	.section	.text.lshiftrt_si_16,"ax",@progbits
	.hidden	lshiftrt_si_16          # -- Begin function lshiftrt_si_16
	.globl	lshiftrt_si_16
	.type	lshiftrt_si_16,@function
lshiftrt_si_16:                         # @lshiftrt_si_16
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 16
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end120:
	.size	lshiftrt_si_16, .Lfunc_end120-lshiftrt_si_16
                                        # -- End function
	.section	.text.lshiftrt_si_17,"ax",@progbits
	.hidden	lshiftrt_si_17          # -- Begin function lshiftrt_si_17
	.globl	lshiftrt_si_17
	.type	lshiftrt_si_17,@function
lshiftrt_si_17:                         # @lshiftrt_si_17
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 17
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end121:
	.size	lshiftrt_si_17, .Lfunc_end121-lshiftrt_si_17
                                        # -- End function
	.section	.text.lshiftrt_si_18,"ax",@progbits
	.hidden	lshiftrt_si_18          # -- Begin function lshiftrt_si_18
	.globl	lshiftrt_si_18
	.type	lshiftrt_si_18,@function
lshiftrt_si_18:                         # @lshiftrt_si_18
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 18
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end122:
	.size	lshiftrt_si_18, .Lfunc_end122-lshiftrt_si_18
                                        # -- End function
	.section	.text.lshiftrt_si_19,"ax",@progbits
	.hidden	lshiftrt_si_19          # -- Begin function lshiftrt_si_19
	.globl	lshiftrt_si_19
	.type	lshiftrt_si_19,@function
lshiftrt_si_19:                         # @lshiftrt_si_19
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 19
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end123:
	.size	lshiftrt_si_19, .Lfunc_end123-lshiftrt_si_19
                                        # -- End function
	.section	.text.lshiftrt_si_20,"ax",@progbits
	.hidden	lshiftrt_si_20          # -- Begin function lshiftrt_si_20
	.globl	lshiftrt_si_20
	.type	lshiftrt_si_20,@function
lshiftrt_si_20:                         # @lshiftrt_si_20
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 20
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end124:
	.size	lshiftrt_si_20, .Lfunc_end124-lshiftrt_si_20
                                        # -- End function
	.section	.text.lshiftrt_si_21,"ax",@progbits
	.hidden	lshiftrt_si_21          # -- Begin function lshiftrt_si_21
	.globl	lshiftrt_si_21
	.type	lshiftrt_si_21,@function
lshiftrt_si_21:                         # @lshiftrt_si_21
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 21
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end125:
	.size	lshiftrt_si_21, .Lfunc_end125-lshiftrt_si_21
                                        # -- End function
	.section	.text.lshiftrt_si_22,"ax",@progbits
	.hidden	lshiftrt_si_22          # -- Begin function lshiftrt_si_22
	.globl	lshiftrt_si_22
	.type	lshiftrt_si_22,@function
lshiftrt_si_22:                         # @lshiftrt_si_22
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 22
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end126:
	.size	lshiftrt_si_22, .Lfunc_end126-lshiftrt_si_22
                                        # -- End function
	.section	.text.lshiftrt_si_23,"ax",@progbits
	.hidden	lshiftrt_si_23          # -- Begin function lshiftrt_si_23
	.globl	lshiftrt_si_23
	.type	lshiftrt_si_23,@function
lshiftrt_si_23:                         # @lshiftrt_si_23
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 23
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end127:
	.size	lshiftrt_si_23, .Lfunc_end127-lshiftrt_si_23
                                        # -- End function
	.section	.text.lshiftrt_si_24,"ax",@progbits
	.hidden	lshiftrt_si_24          # -- Begin function lshiftrt_si_24
	.globl	lshiftrt_si_24
	.type	lshiftrt_si_24,@function
lshiftrt_si_24:                         # @lshiftrt_si_24
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 24
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end128:
	.size	lshiftrt_si_24, .Lfunc_end128-lshiftrt_si_24
                                        # -- End function
	.section	.text.lshiftrt_si_25,"ax",@progbits
	.hidden	lshiftrt_si_25          # -- Begin function lshiftrt_si_25
	.globl	lshiftrt_si_25
	.type	lshiftrt_si_25,@function
lshiftrt_si_25:                         # @lshiftrt_si_25
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 25
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end129:
	.size	lshiftrt_si_25, .Lfunc_end129-lshiftrt_si_25
                                        # -- End function
	.section	.text.lshiftrt_si_26,"ax",@progbits
	.hidden	lshiftrt_si_26          # -- Begin function lshiftrt_si_26
	.globl	lshiftrt_si_26
	.type	lshiftrt_si_26,@function
lshiftrt_si_26:                         # @lshiftrt_si_26
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 26
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end130:
	.size	lshiftrt_si_26, .Lfunc_end130-lshiftrt_si_26
                                        # -- End function
	.section	.text.lshiftrt_si_27,"ax",@progbits
	.hidden	lshiftrt_si_27          # -- Begin function lshiftrt_si_27
	.globl	lshiftrt_si_27
	.type	lshiftrt_si_27,@function
lshiftrt_si_27:                         # @lshiftrt_si_27
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 27
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end131:
	.size	lshiftrt_si_27, .Lfunc_end131-lshiftrt_si_27
                                        # -- End function
	.section	.text.lshiftrt_si_28,"ax",@progbits
	.hidden	lshiftrt_si_28          # -- Begin function lshiftrt_si_28
	.globl	lshiftrt_si_28
	.type	lshiftrt_si_28,@function
lshiftrt_si_28:                         # @lshiftrt_si_28
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 28
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end132:
	.size	lshiftrt_si_28, .Lfunc_end132-lshiftrt_si_28
                                        # -- End function
	.section	.text.lshiftrt_si_29,"ax",@progbits
	.hidden	lshiftrt_si_29          # -- Begin function lshiftrt_si_29
	.globl	lshiftrt_si_29
	.type	lshiftrt_si_29,@function
lshiftrt_si_29:                         # @lshiftrt_si_29
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 29
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end133:
	.size	lshiftrt_si_29, .Lfunc_end133-lshiftrt_si_29
                                        # -- End function
	.section	.text.lshiftrt_si_30,"ax",@progbits
	.hidden	lshiftrt_si_30          # -- Begin function lshiftrt_si_30
	.globl	lshiftrt_si_30
	.type	lshiftrt_si_30,@function
lshiftrt_si_30:                         # @lshiftrt_si_30
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 30
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end134:
	.size	lshiftrt_si_30, .Lfunc_end134-lshiftrt_si_30
                                        # -- End function
	.section	.text.lshiftrt_si_31,"ax",@progbits
	.hidden	lshiftrt_si_31          # -- Begin function lshiftrt_si_31
	.globl	lshiftrt_si_31
	.type	lshiftrt_si_31,@function
lshiftrt_si_31:                         # @lshiftrt_si_31
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 31
	i32.shr_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end135:
	.size	lshiftrt_si_31, .Lfunc_end135-lshiftrt_si_31
                                        # -- End function
	.section	.text.ashiftrt_si_0,"ax",@progbits
	.hidden	ashiftrt_si_0           # -- Begin function ashiftrt_si_0
	.globl	ashiftrt_si_0
	.type	ashiftrt_si_0,@function
ashiftrt_si_0:                          # @ashiftrt_si_0
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	copy_local	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end136:
	.size	ashiftrt_si_0, .Lfunc_end136-ashiftrt_si_0
                                        # -- End function
	.section	.text.ashiftrt_si_1,"ax",@progbits
	.hidden	ashiftrt_si_1           # -- Begin function ashiftrt_si_1
	.globl	ashiftrt_si_1
	.type	ashiftrt_si_1,@function
ashiftrt_si_1:                          # @ashiftrt_si_1
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 1
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end137:
	.size	ashiftrt_si_1, .Lfunc_end137-ashiftrt_si_1
                                        # -- End function
	.section	.text.ashiftrt_si_2,"ax",@progbits
	.hidden	ashiftrt_si_2           # -- Begin function ashiftrt_si_2
	.globl	ashiftrt_si_2
	.type	ashiftrt_si_2,@function
ashiftrt_si_2:                          # @ashiftrt_si_2
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 2
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end138:
	.size	ashiftrt_si_2, .Lfunc_end138-ashiftrt_si_2
                                        # -- End function
	.section	.text.ashiftrt_si_3,"ax",@progbits
	.hidden	ashiftrt_si_3           # -- Begin function ashiftrt_si_3
	.globl	ashiftrt_si_3
	.type	ashiftrt_si_3,@function
ashiftrt_si_3:                          # @ashiftrt_si_3
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 3
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end139:
	.size	ashiftrt_si_3, .Lfunc_end139-ashiftrt_si_3
                                        # -- End function
	.section	.text.ashiftrt_si_4,"ax",@progbits
	.hidden	ashiftrt_si_4           # -- Begin function ashiftrt_si_4
	.globl	ashiftrt_si_4
	.type	ashiftrt_si_4,@function
ashiftrt_si_4:                          # @ashiftrt_si_4
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 4
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end140:
	.size	ashiftrt_si_4, .Lfunc_end140-ashiftrt_si_4
                                        # -- End function
	.section	.text.ashiftrt_si_5,"ax",@progbits
	.hidden	ashiftrt_si_5           # -- Begin function ashiftrt_si_5
	.globl	ashiftrt_si_5
	.type	ashiftrt_si_5,@function
ashiftrt_si_5:                          # @ashiftrt_si_5
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 5
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end141:
	.size	ashiftrt_si_5, .Lfunc_end141-ashiftrt_si_5
                                        # -- End function
	.section	.text.ashiftrt_si_6,"ax",@progbits
	.hidden	ashiftrt_si_6           # -- Begin function ashiftrt_si_6
	.globl	ashiftrt_si_6
	.type	ashiftrt_si_6,@function
ashiftrt_si_6:                          # @ashiftrt_si_6
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 6
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end142:
	.size	ashiftrt_si_6, .Lfunc_end142-ashiftrt_si_6
                                        # -- End function
	.section	.text.ashiftrt_si_7,"ax",@progbits
	.hidden	ashiftrt_si_7           # -- Begin function ashiftrt_si_7
	.globl	ashiftrt_si_7
	.type	ashiftrt_si_7,@function
ashiftrt_si_7:                          # @ashiftrt_si_7
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 7
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end143:
	.size	ashiftrt_si_7, .Lfunc_end143-ashiftrt_si_7
                                        # -- End function
	.section	.text.ashiftrt_si_8,"ax",@progbits
	.hidden	ashiftrt_si_8           # -- Begin function ashiftrt_si_8
	.globl	ashiftrt_si_8
	.type	ashiftrt_si_8,@function
ashiftrt_si_8:                          # @ashiftrt_si_8
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 8
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end144:
	.size	ashiftrt_si_8, .Lfunc_end144-ashiftrt_si_8
                                        # -- End function
	.section	.text.ashiftrt_si_9,"ax",@progbits
	.hidden	ashiftrt_si_9           # -- Begin function ashiftrt_si_9
	.globl	ashiftrt_si_9
	.type	ashiftrt_si_9,@function
ashiftrt_si_9:                          # @ashiftrt_si_9
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 9
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end145:
	.size	ashiftrt_si_9, .Lfunc_end145-ashiftrt_si_9
                                        # -- End function
	.section	.text.ashiftrt_si_10,"ax",@progbits
	.hidden	ashiftrt_si_10          # -- Begin function ashiftrt_si_10
	.globl	ashiftrt_si_10
	.type	ashiftrt_si_10,@function
ashiftrt_si_10:                         # @ashiftrt_si_10
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 10
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end146:
	.size	ashiftrt_si_10, .Lfunc_end146-ashiftrt_si_10
                                        # -- End function
	.section	.text.ashiftrt_si_11,"ax",@progbits
	.hidden	ashiftrt_si_11          # -- Begin function ashiftrt_si_11
	.globl	ashiftrt_si_11
	.type	ashiftrt_si_11,@function
ashiftrt_si_11:                         # @ashiftrt_si_11
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 11
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end147:
	.size	ashiftrt_si_11, .Lfunc_end147-ashiftrt_si_11
                                        # -- End function
	.section	.text.ashiftrt_si_12,"ax",@progbits
	.hidden	ashiftrt_si_12          # -- Begin function ashiftrt_si_12
	.globl	ashiftrt_si_12
	.type	ashiftrt_si_12,@function
ashiftrt_si_12:                         # @ashiftrt_si_12
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 12
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end148:
	.size	ashiftrt_si_12, .Lfunc_end148-ashiftrt_si_12
                                        # -- End function
	.section	.text.ashiftrt_si_13,"ax",@progbits
	.hidden	ashiftrt_si_13          # -- Begin function ashiftrt_si_13
	.globl	ashiftrt_si_13
	.type	ashiftrt_si_13,@function
ashiftrt_si_13:                         # @ashiftrt_si_13
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 13
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end149:
	.size	ashiftrt_si_13, .Lfunc_end149-ashiftrt_si_13
                                        # -- End function
	.section	.text.ashiftrt_si_14,"ax",@progbits
	.hidden	ashiftrt_si_14          # -- Begin function ashiftrt_si_14
	.globl	ashiftrt_si_14
	.type	ashiftrt_si_14,@function
ashiftrt_si_14:                         # @ashiftrt_si_14
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 14
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end150:
	.size	ashiftrt_si_14, .Lfunc_end150-ashiftrt_si_14
                                        # -- End function
	.section	.text.ashiftrt_si_15,"ax",@progbits
	.hidden	ashiftrt_si_15          # -- Begin function ashiftrt_si_15
	.globl	ashiftrt_si_15
	.type	ashiftrt_si_15,@function
ashiftrt_si_15:                         # @ashiftrt_si_15
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 15
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end151:
	.size	ashiftrt_si_15, .Lfunc_end151-ashiftrt_si_15
                                        # -- End function
	.section	.text.ashiftrt_si_16,"ax",@progbits
	.hidden	ashiftrt_si_16          # -- Begin function ashiftrt_si_16
	.globl	ashiftrt_si_16
	.type	ashiftrt_si_16,@function
ashiftrt_si_16:                         # @ashiftrt_si_16
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 16
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end152:
	.size	ashiftrt_si_16, .Lfunc_end152-ashiftrt_si_16
                                        # -- End function
	.section	.text.ashiftrt_si_17,"ax",@progbits
	.hidden	ashiftrt_si_17          # -- Begin function ashiftrt_si_17
	.globl	ashiftrt_si_17
	.type	ashiftrt_si_17,@function
ashiftrt_si_17:                         # @ashiftrt_si_17
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 17
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end153:
	.size	ashiftrt_si_17, .Lfunc_end153-ashiftrt_si_17
                                        # -- End function
	.section	.text.ashiftrt_si_18,"ax",@progbits
	.hidden	ashiftrt_si_18          # -- Begin function ashiftrt_si_18
	.globl	ashiftrt_si_18
	.type	ashiftrt_si_18,@function
ashiftrt_si_18:                         # @ashiftrt_si_18
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 18
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end154:
	.size	ashiftrt_si_18, .Lfunc_end154-ashiftrt_si_18
                                        # -- End function
	.section	.text.ashiftrt_si_19,"ax",@progbits
	.hidden	ashiftrt_si_19          # -- Begin function ashiftrt_si_19
	.globl	ashiftrt_si_19
	.type	ashiftrt_si_19,@function
ashiftrt_si_19:                         # @ashiftrt_si_19
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 19
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end155:
	.size	ashiftrt_si_19, .Lfunc_end155-ashiftrt_si_19
                                        # -- End function
	.section	.text.ashiftrt_si_20,"ax",@progbits
	.hidden	ashiftrt_si_20          # -- Begin function ashiftrt_si_20
	.globl	ashiftrt_si_20
	.type	ashiftrt_si_20,@function
ashiftrt_si_20:                         # @ashiftrt_si_20
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 20
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end156:
	.size	ashiftrt_si_20, .Lfunc_end156-ashiftrt_si_20
                                        # -- End function
	.section	.text.ashiftrt_si_21,"ax",@progbits
	.hidden	ashiftrt_si_21          # -- Begin function ashiftrt_si_21
	.globl	ashiftrt_si_21
	.type	ashiftrt_si_21,@function
ashiftrt_si_21:                         # @ashiftrt_si_21
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 21
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end157:
	.size	ashiftrt_si_21, .Lfunc_end157-ashiftrt_si_21
                                        # -- End function
	.section	.text.ashiftrt_si_22,"ax",@progbits
	.hidden	ashiftrt_si_22          # -- Begin function ashiftrt_si_22
	.globl	ashiftrt_si_22
	.type	ashiftrt_si_22,@function
ashiftrt_si_22:                         # @ashiftrt_si_22
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 22
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end158:
	.size	ashiftrt_si_22, .Lfunc_end158-ashiftrt_si_22
                                        # -- End function
	.section	.text.ashiftrt_si_23,"ax",@progbits
	.hidden	ashiftrt_si_23          # -- Begin function ashiftrt_si_23
	.globl	ashiftrt_si_23
	.type	ashiftrt_si_23,@function
ashiftrt_si_23:                         # @ashiftrt_si_23
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 23
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end159:
	.size	ashiftrt_si_23, .Lfunc_end159-ashiftrt_si_23
                                        # -- End function
	.section	.text.ashiftrt_si_24,"ax",@progbits
	.hidden	ashiftrt_si_24          # -- Begin function ashiftrt_si_24
	.globl	ashiftrt_si_24
	.type	ashiftrt_si_24,@function
ashiftrt_si_24:                         # @ashiftrt_si_24
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 24
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end160:
	.size	ashiftrt_si_24, .Lfunc_end160-ashiftrt_si_24
                                        # -- End function
	.section	.text.ashiftrt_si_25,"ax",@progbits
	.hidden	ashiftrt_si_25          # -- Begin function ashiftrt_si_25
	.globl	ashiftrt_si_25
	.type	ashiftrt_si_25,@function
ashiftrt_si_25:                         # @ashiftrt_si_25
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 25
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end161:
	.size	ashiftrt_si_25, .Lfunc_end161-ashiftrt_si_25
                                        # -- End function
	.section	.text.ashiftrt_si_26,"ax",@progbits
	.hidden	ashiftrt_si_26          # -- Begin function ashiftrt_si_26
	.globl	ashiftrt_si_26
	.type	ashiftrt_si_26,@function
ashiftrt_si_26:                         # @ashiftrt_si_26
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 26
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end162:
	.size	ashiftrt_si_26, .Lfunc_end162-ashiftrt_si_26
                                        # -- End function
	.section	.text.ashiftrt_si_27,"ax",@progbits
	.hidden	ashiftrt_si_27          # -- Begin function ashiftrt_si_27
	.globl	ashiftrt_si_27
	.type	ashiftrt_si_27,@function
ashiftrt_si_27:                         # @ashiftrt_si_27
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 27
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end163:
	.size	ashiftrt_si_27, .Lfunc_end163-ashiftrt_si_27
                                        # -- End function
	.section	.text.ashiftrt_si_28,"ax",@progbits
	.hidden	ashiftrt_si_28          # -- Begin function ashiftrt_si_28
	.globl	ashiftrt_si_28
	.type	ashiftrt_si_28,@function
ashiftrt_si_28:                         # @ashiftrt_si_28
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 28
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end164:
	.size	ashiftrt_si_28, .Lfunc_end164-ashiftrt_si_28
                                        # -- End function
	.section	.text.ashiftrt_si_29,"ax",@progbits
	.hidden	ashiftrt_si_29          # -- Begin function ashiftrt_si_29
	.globl	ashiftrt_si_29
	.type	ashiftrt_si_29,@function
ashiftrt_si_29:                         # @ashiftrt_si_29
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 29
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end165:
	.size	ashiftrt_si_29, .Lfunc_end165-ashiftrt_si_29
                                        # -- End function
	.section	.text.ashiftrt_si_30,"ax",@progbits
	.hidden	ashiftrt_si_30          # -- Begin function ashiftrt_si_30
	.globl	ashiftrt_si_30
	.type	ashiftrt_si_30,@function
ashiftrt_si_30:                         # @ashiftrt_si_30
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 30
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end166:
	.size	ashiftrt_si_30, .Lfunc_end166-ashiftrt_si_30
                                        # -- End function
	.section	.text.ashiftrt_si_31,"ax",@progbits
	.hidden	ashiftrt_si_31          # -- Begin function ashiftrt_si_31
	.globl	ashiftrt_si_31
	.type	ashiftrt_si_31,@function
ashiftrt_si_31:                         # @ashiftrt_si_31
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 31
	i32.shr_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end167:
	.size	ashiftrt_si_31, .Lfunc_end167-ashiftrt_si_31
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end1211
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end168:
	.size	main, .Lfunc_end168-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
