	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20001009-2.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push3=, 0
	i32.load	$push0=, b($pop3)
	i32.eqz 	$push9=, $pop0
	br_if   	0, $pop9        # 0: down to label0
# BB#1:                                 # %for.body.preheader
	i32.const	$0=, 1
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	#APP
	#NO_APP
	i32.const	$push8=, 0
	i32.const	$push7=, 0
	i32.load	$push1=, b($pop7)
	i32.const	$push6=, -1
	i32.add 	$push5=, $pop1, $pop6
	tee_local	$push4=, $1=, $pop5
	i32.store	b($pop8), $pop4
	br_if   	0, $1           # 0: up to label1
.LBB0_3:                                # %if.end
	end_loop
	end_block                       # label0:
	i32.const	$push2=, -1
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push2=, 0
	i32.load	$push0=, b($pop2)
	i32.eqz 	$push9=, $pop0
	br_if   	0, $pop9        # 0: down to label2
# BB#1:                                 # %for.body.i.preheader
	i32.const	$0=, 1
.LBB1_2:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	#APP
	#NO_APP
	i32.const	$push7=, 0
	i32.const	$push6=, 0
	i32.load	$push1=, b($pop6)
	i32.const	$push5=, -1
	i32.add 	$push4=, $pop1, $pop5
	tee_local	$push3=, $1=, $pop4
	i32.store	b($pop7), $pop3
	br_if   	0, $1           # 0: up to label3
.LBB1_3:                                # %foo.exit
	end_loop
	end_block                       # label2:
	i32.const	$push8=, 0
                                        # fallthrough-return: $pop8
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	b                       # @b
	.type	b,@object
	.section	.data.b,"aw",@progbits
	.globl	b
	.p2align	2
b:
	.int32	1                       # 0x1
	.size	b, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
