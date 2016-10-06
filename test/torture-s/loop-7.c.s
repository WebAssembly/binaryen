	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-7.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, -1
	i32.const	$2=, 0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label1:
	i32.const	$push10=, 1
	i32.shl 	$push0=, $pop10, $2
	i32.eq  	$push1=, $pop0, $0
	i32.select	$1=, $2, $1, $pop1
	i32.const	$push9=, 1
	i32.add 	$push8=, $2, $pop9
	tee_local	$push7=, $2=, $pop8
	i32.const	$push6=, 9
	i32.gt_s	$push2=, $pop7, $pop6
	br_if   	1, $pop2        # 1: down to label0
# BB#2:                                 # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push11=, 0
	i32.lt_s	$push3=, $1, $pop11
	br_if   	0, $pop3        # 0: up to label1
.LBB0_3:                                # %for.end
	end_loop
	end_block                       # label0:
	block   	
	i32.const	$push4=, -1
	i32.le_s	$push5=, $1, $pop4
	br_if   	0, $pop5        # 0: down to label2
# BB#4:                                 # %if.end5
	return
.LBB0_5:                                # %if.then4
	end_block                       # label2:
	call    	abort@FUNCTION
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
	i32.const	$push0=, 64
	call    	foo@FUNCTION, $pop0
	i32.const	$push1=, 0
	call    	exit@FUNCTION, $pop1
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
