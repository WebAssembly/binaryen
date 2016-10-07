	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/990811-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	block   	
	block   	
	i32.const	$push0=, 2
	i32.eq  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label2
# BB#1:                                 # %entry
	i32.const	$push2=, 1
	i32.eq  	$push3=, $0, $pop2
	br_if   	1, $pop3        # 1: down to label1
# BB#2:                                 # %entry
	br_if   	2, $0           # 2: down to label0
# BB#3:                                 # %sw.bb
	i32.load	$push6=, 0($1)
	return  	$pop6
.LBB0_4:                                # %sw.bb2
	end_block                       # label2:
	i32.load16_s	$push4=, 0($1)
	return  	$pop4
.LBB0_5:                                # %sw.bb1
	end_block                       # label1:
	i32.load8_s	$push5=, 0($1)
	return  	$pop5
.LBB0_6:                                # %sw.epilog
	end_block                       # label0:
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
# BB#0:                                 # %if.end16
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
