	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20051215-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push7=, 1
	i32.lt_s	$push0=, $1, $pop7
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %for.body.lr.ph
	i32.const	$3=, 0
	i32.const	$4=, 0
	i32.const	$5=, 0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	block   	
	i32.eqz 	$push13=, $2
	br_if   	0, $pop13       # 0: down to label2
# BB#3:                                 # %if.then
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.load	$push1=, 0($2)
	i32.mul 	$4=, $pop1, $3
.LBB0_4:                                # %if.end
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label2:
	i32.mul 	$push3=, $4, $0
	i32.const	$push12=, 0
	i32.const	$push11=, 0
	i32.gt_s	$push2=, $0, $pop11
	i32.select	$push4=, $pop3, $pop12, $pop2
	i32.add 	$5=, $5, $pop4
	i32.const	$push10=, 1
	i32.add 	$push9=, $3, $pop10
	tee_local	$push8=, $3=, $pop9
	i32.ne  	$push5=, $1, $pop8
	br_if   	0, $pop5        # 0: up to label1
# BB#5:                                 # %for.end6
	end_loop
	return  	$5
.LBB0_6:
	end_block                       # label0:
	i32.const	$push6=, 0
                                        # fallthrough-return: $pop6
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
	block   	
	i32.const	$push1=, 3
	i32.const	$push0=, 2
	i32.const	$push3=, 0
	i32.call	$push2=, foo@FUNCTION, $pop1, $pop0, $pop3
	br_if   	0, $pop2        # 0: down to label3
# BB#1:                                 # %if.end
	i32.const	$push4=, 0
	return  	$pop4
.LBB1_2:                                # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 "
	.functype	abort, void
