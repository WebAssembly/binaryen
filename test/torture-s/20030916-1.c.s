	.text
	.file	"20030916-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
# %bb.0:                                # %entry
	i64.const	$push0=, 0
	i64.store	0($0):p2align=2, $pop0
	i64.const	$push19=, 0
	i64.store	992($0):p2align=2, $pop19
	i32.const	$push1=, 24
	i32.add 	$push2=, $0, $pop1
	i64.const	$push18=, 0
	i64.store	0($pop2):p2align=2, $pop18
	i32.const	$push3=, 16
	i32.add 	$push4=, $0, $pop3
	i64.const	$push17=, 0
	i64.store	0($pop4):p2align=2, $pop17
	i32.const	$push5=, 8
	i32.add 	$push6=, $0, $pop5
	i64.const	$push16=, 0
	i64.store	0($pop6):p2align=2, $pop16
	i32.const	$push7=, 1016
	i32.add 	$push8=, $0, $pop7
	i64.const	$push15=, 0
	i64.store	0($pop8):p2align=2, $pop15
	i32.const	$push9=, 1008
	i32.add 	$push10=, $0, $pop9
	i64.const	$push14=, 0
	i64.store	0($pop10):p2align=2, $pop14
	i32.const	$push11=, 1000
	i32.add 	$push12=, $0, $pop11
	i64.const	$push13=, 0
	i64.store	0($pop12):p2align=2, $pop13
                                        # fallthrough-return
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
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push20=, 0
	i32.load	$push19=, __stack_pointer($pop20)
	i32.const	$push21=, 1024
	i32.sub 	$0=, $pop19, $pop21
	i32.const	$push22=, 0
	i32.store	__stack_pointer($pop22), $0
	i32.const	$1=, 0
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.add 	$push0=, $0, $1
	i32.const	$push25=, 1
	i32.store	0($pop0), $pop25
	i32.const	$push24=, 4
	i32.add 	$1=, $1, $pop24
	i32.const	$push23=, 1024
	i32.ne  	$push1=, $1, $pop23
	br_if   	0, $pop1        # 0: up to label0
# %bb.2:                                # %for.end
	end_loop
	i32.const	$push2=, 24
	i32.add 	$push3=, $0, $pop2
	i64.const	$push4=, 0
	i64.store	0($pop3), $pop4
	i32.const	$push5=, 16
	i32.add 	$push6=, $0, $pop5
	i64.const	$push32=, 0
	i64.store	0($pop6), $pop32
	i32.const	$push7=, 1016
	i32.add 	$push8=, $0, $pop7
	i64.const	$push31=, 0
	i64.store	0($pop8), $pop31
	i32.const	$push9=, 1008
	i32.add 	$push10=, $0, $pop9
	i64.const	$push30=, 0
	i64.store	0($pop10), $pop30
	i32.const	$push11=, 1000
	i32.add 	$push12=, $0, $pop11
	i64.const	$push29=, 0
	i64.store	0($pop12), $pop29
	i64.const	$push28=, 0
	i64.store	8($0), $pop28
	i64.const	$push27=, 0
	i64.store	0($0), $pop27
	i64.const	$push26=, 0
	i64.store	992($0), $pop26
	i32.const	$1=, 0
	copy_local	$0=, $0
.LBB1_3:                                # %for.body3
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label2:
	i32.load	$push15=, 0($0)
	i32.const	$push34=, -8
	i32.add 	$push13=, $1, $pop34
	i32.const	$push33=, 240
	i32.lt_u	$push14=, $pop13, $pop33
	i32.ne  	$push16=, $pop15, $pop14
	br_if   	1, $pop16       # 1: down to label1
# %bb.4:                                # %for.cond1
                                        #   in Loop: Header=BB1_3 Depth=1
	i32.const	$push37=, 1
	i32.add 	$1=, $1, $pop37
	i32.const	$push36=, 4
	i32.add 	$0=, $0, $pop36
	i32.const	$push35=, 255
	i32.le_u	$push17=, $1, $pop35
	br_if   	0, $pop17       # 0: up to label2
# %bb.5:                                # %for.end10
	end_loop
	i32.const	$push18=, 0
	call    	exit@FUNCTION, $pop18
	unreachable
.LBB1_6:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
