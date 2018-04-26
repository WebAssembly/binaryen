	.text
	.file	"bcp-1.c"
	.section	.text.bad0,"ax",@progbits
	.hidden	bad0                    # -- Begin function bad0
	.globl	bad0
	.type	bad0,@function
bad0:                                   # @bad0
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	bad0, .Lfunc_end0-bad0
                                        # -- End function
	.section	.text.bad1,"ax",@progbits
	.hidden	bad1                    # -- Begin function bad1
	.globl	bad1
	.type	bad1,@function
bad1:                                   # @bad1
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	bad1, .Lfunc_end1-bad1
                                        # -- End function
	.section	.text.bad2,"ax",@progbits
	.hidden	bad2                    # -- Begin function bad2
	.globl	bad2
	.type	bad2,@function
bad2:                                   # @bad2
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	bad2, .Lfunc_end2-bad2
                                        # -- End function
	.section	.text.bad3,"ax",@progbits
	.hidden	bad3                    # -- Begin function bad3
	.globl	bad3
	.type	bad3,@function
bad3:                                   # @bad3
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end3:
	.size	bad3, .Lfunc_end3-bad3
                                        # -- End function
	.section	.text.bad4,"ax",@progbits
	.hidden	bad4                    # -- Begin function bad4
	.globl	bad4
	.type	bad4,@function
bad4:                                   # @bad4
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end4:
	.size	bad4, .Lfunc_end4-bad4
                                        # -- End function
	.section	.text.bad5,"ax",@progbits
	.hidden	bad5                    # -- Begin function bad5
	.globl	bad5
	.type	bad5,@function
bad5:                                   # @bad5
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end5:
	.size	bad5, .Lfunc_end5-bad5
                                        # -- End function
	.section	.text.bad6,"ax",@progbits
	.hidden	bad6                    # -- Begin function bad6
	.globl	bad6
	.type	bad6,@function
bad6:                                   # @bad6
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end6:
	.size	bad6, .Lfunc_end6-bad6
                                        # -- End function
	.section	.text.bad7,"ax",@progbits
	.hidden	bad7                    # -- Begin function bad7
	.globl	bad7
	.type	bad7,@function
bad7:                                   # @bad7
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end7:
	.size	bad7, .Lfunc_end7-bad7
                                        # -- End function
	.section	.text.bad8,"ax",@progbits
	.hidden	bad8                    # -- Begin function bad8
	.globl	bad8
	.type	bad8,@function
bad8:                                   # @bad8
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end8:
	.size	bad8, .Lfunc_end8-bad8
                                        # -- End function
	.section	.text.bad9,"ax",@progbits
	.hidden	bad9                    # -- Begin function bad9
	.globl	bad9
	.type	bad9,@function
bad9:                                   # @bad9
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end9:
	.size	bad9, .Lfunc_end9-bad9
                                        # -- End function
	.section	.text.bad10,"ax",@progbits
	.hidden	bad10                   # -- Begin function bad10
	.globl	bad10
	.type	bad10,@function
bad10:                                  # @bad10
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end10:
	.size	bad10, .Lfunc_end10-bad10
                                        # -- End function
	.section	.text.good0,"ax",@progbits
	.hidden	good0                   # -- Begin function good0
	.globl	good0
	.type	good0,@function
good0:                                  # @good0
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end11:
	.size	good0, .Lfunc_end11-good0
                                        # -- End function
	.section	.text.good1,"ax",@progbits
	.hidden	good1                   # -- Begin function good1
	.globl	good1
	.type	good1,@function
good1:                                  # @good1
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end12:
	.size	good1, .Lfunc_end12-good1
                                        # -- End function
	.section	.text.good2,"ax",@progbits
	.hidden	good2                   # -- Begin function good2
	.globl	good2
	.type	good2,@function
good2:                                  # @good2
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end13:
	.size	good2, .Lfunc_end13-good2
                                        # -- End function
	.section	.text.opt0,"ax",@progbits
	.hidden	opt0                    # -- Begin function opt0
	.globl	opt0
	.type	opt0,@function
opt0:                                   # @opt0
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end14:
	.size	opt0, .Lfunc_end14-opt0
                                        # -- End function
	.section	.text.opt1,"ax",@progbits
	.hidden	opt1                    # -- Begin function opt1
	.globl	opt1
	.type	opt1,@function
opt1:                                   # @opt1
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end15:
	.size	opt1, .Lfunc_end15-opt1
                                        # -- End function
	.section	.text.opt2,"ax",@progbits
	.hidden	opt2                    # -- Begin function opt2
	.globl	opt2
	.type	opt2,@function
opt2:                                   # @opt2
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end16:
	.size	opt2, .Lfunc_end16-opt2
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	block   	
	block   	
	i32.const	$push35=, 0
	i32.load	$push0=, bad_t0($pop35)
	i32.call_indirect	$push1=, $pop0
	br_if   	0, $pop1        # 0: down to label1
# %bb.1:                                # %for.cond
	i32.const	$push36=, 0
	i32.load	$push2=, bad_t0+4($pop36)
	i32.call_indirect	$push3=, $pop2
	br_if   	0, $pop3        # 0: down to label1
# %bb.2:                                # %for.cond.1
	i32.const	$push37=, 0
	i32.load	$push4=, bad_t0+8($pop37)
	i32.call_indirect	$push5=, $pop4
	br_if   	0, $pop5        # 0: down to label1
# %bb.3:                                # %for.cond.2
	i32.const	$push38=, 0
	i32.load	$push6=, bad_t0+12($pop38)
	i32.call_indirect	$push7=, $pop6
	br_if   	0, $pop7        # 0: down to label1
# %bb.4:                                # %for.cond.3
	i32.const	$push39=, 0
	i32.load	$push8=, bad_t0+16($pop39)
	i32.call_indirect	$push9=, $pop8
	br_if   	0, $pop9        # 0: down to label1
# %bb.5:                                # %for.cond.4
	i32.const	$push40=, 0
	i32.load	$push10=, bad_t0+20($pop40)
	i32.call_indirect	$push11=, $pop10
	br_if   	0, $pop11       # 0: down to label1
# %bb.6:                                # %for.cond.5
	i32.const	$push42=, 1
	i32.const	$push41=, 0
	i32.load	$push12=, bad_t1($pop41)
	i32.call_indirect	$push13=, $pop42, $pop12
	br_if   	0, $pop13       # 0: down to label1
# %bb.7:                                # %for.cond1
	i32.const	$push44=, 1
	i32.const	$push43=, 0
	i32.load	$push14=, bad_t1+4($pop43)
	i32.call_indirect	$push15=, $pop44, $pop14
	br_if   	0, $pop15       # 0: down to label1
# %bb.8:                                # %for.cond1.1
	i32.const	$push17=, 1
	i32.const	$push45=, 0
	i32.load	$push16=, bad_t1+8($pop45)
	i32.call_indirect	$push18=, $pop17, $pop16
	br_if   	0, $pop18       # 0: down to label1
# %bb.9:                                # %for.cond1.2
	i32.const	$push47=, .L.str
	i32.const	$push46=, 0
	i32.load	$push19=, bad_t2($pop46)
	i32.call_indirect	$push20=, $pop47, $pop19
	br_if   	0, $pop20       # 0: down to label1
# %bb.10:                               # %for.cond12
	i32.const	$push49=, .L.str
	i32.const	$push48=, 0
	i32.load	$push21=, bad_t2+4($pop48)
	i32.call_indirect	$push22=, $pop49, $pop21
	br_if   	0, $pop22       # 0: down to label1
# %bb.11:                               # %for.cond12.1
	i32.const	$push50=, 0
	i32.load	$push23=, good_t0($pop50)
	i32.call_indirect	$push24=, $pop23
	i32.eqz 	$push57=, $pop24
	br_if   	0, $pop57       # 0: down to label1
# %bb.12:                               # %for.cond23
	i32.const	$push51=, 0
	i32.load	$push25=, good_t0+4($pop51)
	i32.call_indirect	$push26=, $pop25
	i32.eqz 	$push58=, $pop26
	br_if   	0, $pop58       # 0: down to label1
# %bb.13:                               # %for.cond23.1
	i32.const	$push52=, 0
	i32.load	$push27=, good_t0+8($pop52)
	i32.call_indirect	$push28=, $pop27
	i32.eqz 	$push59=, $pop28
	br_if   	0, $pop59       # 0: down to label1
# %bb.14:                               # %for.cond23.2
	i32.const	$push53=, 0
	i32.load	$push29=, opt_t0($pop53)
	i32.call_indirect	$push30=, $pop29
	i32.eqz 	$push60=, $pop30
	br_if   	0, $pop60       # 0: down to label1
# %bb.15:                               # %for.cond34
	i32.const	$push54=, 0
	i32.load	$push31=, opt_t0+4($pop54)
	i32.call_indirect	$push32=, $pop31
	i32.eqz 	$push61=, $pop32
	br_if   	0, $pop61       # 0: down to label1
# %bb.16:                               # %for.cond34.1
	i32.const	$push55=, 0
	i32.load	$push33=, opt_t0+8($pop55)
	i32.call_indirect	$push34=, $pop33
	br_if   	1, $pop34       # 1: down to label0
.LBB17_17:                              # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB17_18:                              # %for.cond34.2
	end_block                       # label0:
	i32.const	$push56=, 0
	call    	exit@FUNCTION, $pop56
	unreachable
	.endfunc
.Lfunc_end17:
	.size	main, .Lfunc_end17-main
                                        # -- End function
	.hidden	bad_t0                  # @bad_t0
	.type	bad_t0,@object
	.section	.data.bad_t0,"aw",@progbits
	.globl	bad_t0
	.p2align	4
bad_t0:
	.int32	bad0@FUNCTION
	.int32	bad1@FUNCTION
	.int32	bad5@FUNCTION
	.int32	bad7@FUNCTION
	.int32	bad8@FUNCTION
	.int32	bad10@FUNCTION
	.size	bad_t0, 24

	.hidden	bad_t1                  # @bad_t1
	.type	bad_t1,@object
	.section	.data.bad_t1,"aw",@progbits
	.globl	bad_t1
	.p2align	2
bad_t1:
	.int32	bad2@FUNCTION
	.int32	bad3@FUNCTION
	.int32	bad6@FUNCTION
	.size	bad_t1, 12

	.hidden	bad_t2                  # @bad_t2
	.type	bad_t2,@object
	.section	.data.bad_t2,"aw",@progbits
	.globl	bad_t2
	.p2align	2
bad_t2:
	.int32	bad4@FUNCTION
	.int32	bad9@FUNCTION
	.size	bad_t2, 8

	.hidden	good_t0                 # @good_t0
	.type	good_t0,@object
	.section	.data.good_t0,"aw",@progbits
	.globl	good_t0
	.p2align	2
good_t0:
	.int32	good0@FUNCTION
	.int32	good1@FUNCTION
	.int32	good2@FUNCTION
	.size	good_t0, 12

	.hidden	opt_t0                  # @opt_t0
	.type	opt_t0,@object
	.section	.data.opt_t0,"aw",@progbits
	.globl	opt_t0
	.p2align	2
opt_t0:
	.int32	opt0@FUNCTION
	.int32	opt1@FUNCTION
	.int32	opt2@FUNCTION
	.size	opt_t0, 12

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"hi"
	.size	.L.str, 3

	.hidden	global                  # @global
	.type	global,@object
	.section	.bss.global,"aw",@nobits
	.globl	global
	.p2align	2
global:
	.int32	0                       # 0x0
	.size	global, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
