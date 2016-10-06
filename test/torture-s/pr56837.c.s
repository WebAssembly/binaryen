	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr56837.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, -8192
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.const	$push5=, a+8192
	i32.add 	$push0=, $0, $pop5
	i64.const	$push4=, 4294967295
	i64.store	0($pop0), $pop4
	i32.const	$push3=, 8
	i32.add 	$push2=, $0, $pop3
	tee_local	$push1=, $0=, $pop2
	br_if   	0, $pop1        # 0: up to label0
# BB#2:                                 # %for.end
	end_loop
                                        # fallthrough-return
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
	call    	foo@FUNCTION
	i32.const	$1=, 0
	i32.const	$0=, a
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label2:
	i32.load	$push1=, 0($0)
	i32.const	$push6=, -1
	i32.ne  	$push2=, $pop1, $pop6
	br_if   	1, $pop2        # 1: down to label1
# BB#2:                                 # %for.body
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push7=, 4
	i32.add 	$push3=, $0, $pop7
	i32.load	$push0=, 0($pop3)
	br_if   	1, $pop0        # 1: down to label1
# BB#3:                                 # %for.cond
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push12=, 8
	i32.add 	$0=, $0, $pop12
	i32.const	$push11=, 1
	i32.add 	$push10=, $1, $pop11
	tee_local	$push9=, $1=, $pop10
	i32.const	$push8=, 1023
	i32.le_s	$push4=, $pop9, $pop8
	br_if   	0, $pop4        # 0: up to label2
# BB#4:                                 # %for.end
	end_loop
	i32.const	$push5=, 0
	return  	$pop5
.LBB1_5:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	4
a:
	.skip	8192
	.size	a, 8192


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
