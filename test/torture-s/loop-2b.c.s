	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-2b.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, 2147483647
	i32.eq  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %for.body.preheader
	i32.const	$push2=, 2147483646
	i32.sub 	$2=, $pop2, $0
	i32.const	$push3=, 2
	i32.shl 	$push4=, $0, $pop3
	i32.const	$push5=, a
	i32.add 	$0=, $pop4, $pop5
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push10=, -2
	i32.store	0($0), $pop10
	copy_local	$push9=, $2
	tee_local	$push8=, $1=, $pop9
	i32.const	$push7=, 2147483645
	i32.eq  	$push6=, $pop8, $pop7
	br_if   	1, $pop6        # 1: down to label0
# BB#3:                                 # %for.body
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push12=, -1
	i32.add 	$2=, $1, $pop12
	i32.const	$push11=, 4
	i32.add 	$0=, $0, $pop11
	br_if   	0, $1           # 0: up to label1
.LBB0_4:                                # %for.end
	end_loop
	end_block                       # label0:
	copy_local	$push13=, $0
                                        # fallthrough-return: $pop13
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push1=, 0
	i64.const	$push0=, -4294967298
	i64.store	a($pop1):p2align=2, $pop0
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.skip	8
	.size	a, 8


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
