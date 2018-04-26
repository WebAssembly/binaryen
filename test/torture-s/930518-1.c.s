	.text
	.file	"930518-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push8=, 0
	i32.load	$2=, bar($pop8)
	block   	
	i32.const	$push7=, 1
	i32.gt_s	$push0=, $2, $pop7
	br_if   	0, $pop0        # 0: down to label0
# %bb.1:                                # %while.body.lr.ph
	i32.const	$push12=, 2
	i32.sub 	$1=, $pop12, $2
	i32.store	0($0), $1
	i32.const	$push11=, 0
	i32.const	$push10=, 1
	i32.store	bar($pop11), $pop10
	i32.const	$push9=, 2
	i32.lt_s	$push1=, $1, $pop9
	br_if   	0, $pop1        # 0: down to label0
# %bb.2:                                # %while.body.preheader
	i32.const	$push13=, 4
	i32.add 	$0=, $0, $pop13
	i32.const	$push2=, 3
	i32.sub 	$2=, $pop2, $2
.LBB0_3:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push17=, -2
	i32.add 	$push3=, $2, $pop17
	i32.store	0($0), $pop3
	i32.const	$push16=, 4
	i32.add 	$0=, $0, $pop16
	i32.const	$push15=, -1
	i32.add 	$2=, $2, $pop15
	i32.const	$push14=, 2
	i32.gt_s	$push4=, $2, $pop14
	br_if   	0, $pop4        # 0: up to label1
# %bb.4:                                # %while.end.loopexit
	end_loop
	i32.const	$push6=, 0
	i32.const	$push5=, 1
	i32.store	bar($pop6), $pop5
.LBB0_5:                                # %while.end
	end_block                       # label0:
	copy_local	$push18=, $2
                                        # fallthrough-return: $pop18
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push13=, 0
	i32.load	$push12=, __stack_pointer($pop13)
	i32.const	$push14=, 16
	i32.sub 	$3=, $pop12, $pop14
	i32.const	$push15=, 0
	i32.store	__stack_pointer($pop15), $3
	i64.const	$push0=, 0
	i64.store	8($3):p2align=2, $pop0
	i32.const	$push19=, 0
	i32.load	$0=, bar($pop19)
	block   	
	i32.const	$push18=, 1
	i32.gt_s	$push1=, $0, $pop18
	br_if   	0, $pop1        # 0: down to label2
# %bb.1:                                # %while.body.lr.ph.i
	i32.const	$push23=, 0
	i32.const	$push22=, 1
	i32.store	bar($pop23), $pop22
	i32.const	$push21=, 2
	i32.sub 	$2=, $pop21, $0
	i32.store	8($3), $2
	i32.const	$push20=, 2
	i32.lt_s	$push2=, $2, $pop20
	br_if   	0, $pop2        # 0: down to label2
# %bb.2:                                # %while.body.i.preheader
	i32.const	$push3=, 3
	i32.sub 	$2=, $pop3, $0
	i32.const	$push16=, 8
	i32.add 	$push17=, $3, $pop16
	i32.const	$push24=, 4
	i32.add 	$1=, $pop17, $pop24
.LBB1_3:                                # %while.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	i32.const	$push28=, -2
	i32.add 	$push4=, $2, $pop28
	i32.store	0($1), $pop4
	i32.const	$push27=, 4
	i32.add 	$1=, $1, $pop27
	i32.const	$push26=, -1
	i32.add 	$2=, $2, $pop26
	i32.const	$push25=, 2
	i32.gt_s	$push5=, $2, $pop25
	br_if   	0, $pop5        # 0: up to label3
# %bb.4:                                # %f.exit
	end_loop
	i32.const	$push7=, 0
	i32.const	$push29=, 1
	i32.store	bar($pop7), $pop29
	br_if   	0, $0           # 0: down to label2
# %bb.5:                                # %f.exit
	i32.const	$push8=, 12
	i32.add 	$push9=, $3, $pop8
	i32.load	$push6=, 0($pop9)
	i32.const	$push30=, 1
	i32.ne  	$push10=, $pop6, $pop30
	br_if   	0, $pop10       # 0: down to label2
# %bb.6:                                # %if.end
	i32.const	$push11=, 0
	call    	exit@FUNCTION, $pop11
	unreachable
.LBB1_7:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	bar                     # @bar
	.type	bar,@object
	.section	.bss.bar,"aw",@nobits
	.globl	bar
	.p2align	2
bar:
	.int32	0                       # 0x0
	.size	bar, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
