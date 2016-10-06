	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-2c.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block   	
	i32.eqz 	$push12=, $0
	br_if   	0, $pop12       # 0: down to label0
# BB#1:                                 # %for.body.preheader
	i32.const	$push0=, 2
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, a-4
	i32.add 	$2=, $pop1, $pop2
	i32.const	$push3=, 3
	i32.mul 	$push4=, $0, $pop3
	i32.add 	$push5=, $1, $pop4
	i32.const	$push6=, -3
	i32.add 	$1=, $pop5, $pop6
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.store	0($2), $1
	i32.const	$push11=, -4
	i32.add 	$2=, $2, $pop11
	i32.const	$push10=, -3
	i32.add 	$1=, $1, $pop10
	i32.const	$push9=, -1
	i32.add 	$push8=, $0, $pop9
	tee_local	$push7=, $0=, $pop8
	br_if   	0, $pop7        # 0: up to label1
.LBB0_3:                                # %for.end
	end_loop
	end_block                       # label0:
	copy_local	$push13=, $2
                                        # fallthrough-return: $pop13
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.g,"ax",@progbits
	.hidden	g
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	block   	
	i32.eqz 	$push11=, $0
	br_if   	0, $pop11       # 0: down to label2
# BB#1:                                 # %for.body.preheader.i
	i32.const	$push0=, 2
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, a-4
	i32.add 	$1=, $pop1, $pop2
	i32.const	$push3=, 3
	i32.mul 	$push4=, $0, $pop3
	i32.const	$push5=, a-3
	i32.add 	$2=, $pop4, $pop5
.LBB1_2:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	i32.store	0($1), $2
	i32.const	$push10=, -4
	i32.add 	$1=, $1, $pop10
	i32.const	$push9=, -3
	i32.add 	$2=, $2, $pop9
	i32.const	$push8=, -1
	i32.add 	$push7=, $0, $pop8
	tee_local	$push6=, $0=, $pop7
	br_if   	0, $pop6        # 0: up to label3
.LBB1_3:                                # %f.exit
	end_loop
	end_block                       # label2:
	copy_local	$push12=, $1
                                        # fallthrough-return: $pop12
	.endfunc
.Lfunc_end1:
	.size	g, .Lfunc_end1-g

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push1=, 0
	i32.const	$push0=, a
	i32.store	a($pop1), $pop0
	i32.const	$push4=, 0
	i32.const	$push2=, a+3
	i32.store	a+4($pop4), $pop2
	i32.const	$push3=, 0
	call    	exit@FUNCTION, $pop3
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

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
