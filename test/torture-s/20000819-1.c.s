	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000819-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	
	block   	
	i32.const	$push0=, 0
	i32.sub 	$push10=, $pop0, $1
	tee_local	$push9=, $1=, $pop10
	i32.const	$push8=, 0
	i32.gt_s	$push1=, $pop9, $pop8
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %for.body.preheader
	i32.const	$push2=, 2
	i32.shl 	$push3=, $1, $pop2
	i32.add 	$1=, $0, $pop3
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.load	$push4=, 0($1)
	i32.const	$push11=, 1
	i32.le_s	$push5=, $pop4, $pop11
	br_if   	2, $pop5        # 2: down to label0
# BB#3:                                 # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push14=, 4
	i32.add 	$push13=, $1, $pop14
	tee_local	$push12=, $1=, $pop13
	i32.le_u	$push6=, $pop12, $0
	br_if   	0, $pop6        # 0: up to label2
.LBB0_4:                                # %for.end
	end_loop
	end_block                       # label1:
	return
.LBB0_5:                                # %if.then
	end_block                       # label0:
	i32.const	$push7=, 0
	call    	exit@FUNCTION, $pop7
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push1=, a+4
	i32.const	$push0=, 1
	call    	foo@FUNCTION, $pop1, $pop0
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.p2align	2
a:
	.int32	2                       # 0x2
	.int32	0                       # 0x0
	.size	a, 8


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
	.functype	abort, void
