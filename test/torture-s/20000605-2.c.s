	.text
	.file	"20000605-2.c"
	.section	.text.f1,"ax",@progbits
	.hidden	f1                      # -- Begin function f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32, i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.load	$2=, 0($0)
	block   	
	block   	
	i32.load	$push0=, 0($1)
	i32.ge_s	$push1=, $2, $pop0
	br_if   	0, $pop1        # 0: down to label1
# %bb.1:                                # %for.body.preheader
	i32.const	$3=, 0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.const	$push8=, 5
	i32.ge_u	$push2=, $3, $pop8
	br_if   	2, $pop2        # 2: down to label0
# %bb.3:                                # %for.inc
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.add 	$push3=, $2, $3
	i32.const	$push10=, 1
	i32.add 	$push4=, $pop3, $pop10
	i32.store	0($0), $pop4
	i32.const	$push9=, 1
	i32.add 	$3=, $3, $pop9
	i32.add 	$push5=, $2, $3
	i32.load	$push6=, 0($1)
	i32.lt_s	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: up to label2
.LBB0_4:                                # %for.end
	end_loop
	end_block                       # label1:
	return
.LBB0_5:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	f1, .Lfunc_end0-f1
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push3=, 0
	i32.load	$push2=, __stack_pointer($pop3)
	i32.const	$push4=, 16
	i32.sub 	$0=, $pop2, $pop4
	i32.const	$push5=, 0
	i32.store	__stack_pointer($pop5), $0
	i32.const	$push0=, 1
	i32.store	0($0), $pop0
	i32.const	$push1=, 0
	i32.store	8($0), $pop1
	i32.const	$push6=, 8
	i32.add 	$push7=, $0, $pop6
	call    	f1@FUNCTION, $pop7, $0
	i32.const	$push8=, 0
	call    	exit@FUNCTION, $pop8
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
