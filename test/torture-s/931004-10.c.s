	.text
	.file	"931004-10.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push15=, 0
	i32.load	$push14=, __stack_pointer($pop15)
	i32.const	$push16=, 16
	i32.sub 	$4=, $pop14, $pop16
	i32.const	$push17=, 0
	i32.store	__stack_pointer($pop17), $4
	i32.const	$push22=, 4
	i32.add 	$push1=, $1, $pop22
	i32.store	12($4), $pop1
	block   	
	block   	
	i32.const	$push21=, 1
	i32.lt_s	$push2=, $0, $pop21
	br_if   	0, $pop2        # 0: down to label1
# %bb.1:                                # %for.body.preheader
	i32.const	$2=, 10
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.load8_s	$push3=, 0($1)
	i32.ne  	$push4=, $2, $pop3
	br_if   	2, $pop4        # 2: down to label0
# %bb.3:                                # %if.end
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push24=, 10
	i32.add 	$push5=, $2, $pop24
	i32.const	$push23=, 1
	i32.add 	$push6=, $1, $pop23
	i32.load8_s	$push7=, 0($pop6)
	i32.ne  	$push8=, $pop5, $pop7
	br_if   	2, $pop8        # 2: down to label0
# %bb.4:                                # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push28=, 8
	i32.add 	$push9=, $1, $pop28
	i32.store	12($4), $pop9
	i32.const	$push27=, 4
	i32.add 	$1=, $1, $pop27
	i32.const	$push26=, -9
	i32.add 	$3=, $2, $pop26
	i32.const	$push25=, 1
	i32.add 	$push0=, $2, $pop25
	copy_local	$2=, $pop0
	i32.lt_s	$push10=, $3, $0
	br_if   	0, $pop10       # 0: up to label2
.LBB0_5:                                # %for.end
	end_loop
	end_block                       # label1:
	i32.load	$push11=, 0($1)
	i32.const	$push12=, 123
	i32.ne  	$push13=, $pop11, $pop12
	br_if   	0, $pop13       # 0: down to label0
# %bb.6:                                # %if.end16
	i32.const	$push20=, 0
	i32.const	$push18=, 16
	i32.add 	$push19=, $4, $pop18
	i32.store	__stack_pointer($pop20), $pop19
	return  	$1
.LBB0_7:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
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
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push9=, 0
	i32.load	$push8=, __stack_pointer($pop9)
	i32.const	$push10=, 32
	i32.sub 	$0=, $pop8, $pop10
	i32.const	$push11=, 0
	i32.store	__stack_pointer($pop11), $0
	i32.const	$push0=, 5130
	i32.store16	24($0), $pop0
	i32.const	$push1=, 369890571
	i32.store	26($0):p2align=1, $pop1
	i32.const	$push2=, 123
	i32.store	12($0), $pop2
	i32.load16_u	$push3=, 24($0)
	i32.store16	22($0), $pop3
	i32.load16_u	$push4=, 26($0)
	i32.store16	20($0), $pop4
	i32.load16_u	$push5=, 28($0)
	i32.store16	18($0), $pop5
	i32.const	$push12=, 18
	i32.add 	$push13=, $0, $pop12
	i32.store	8($0), $pop13
	i32.const	$push14=, 20
	i32.add 	$push15=, $0, $pop14
	i32.store	4($0), $pop15
	i32.const	$push16=, 22
	i32.add 	$push17=, $0, $pop16
	i32.store	0($0), $pop17
	i32.const	$push6=, 3
	i32.call	$drop=, f@FUNCTION, $pop6, $0
	i32.const	$push7=, 0
	call    	exit@FUNCTION, $pop7
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
