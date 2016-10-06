	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/920721-3.c"
	.section	.text.ru,"ax",@progbits
	.hidden	ru
	.globl	ru
	.type	ru,@function
ru:                                     # @ru
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push8=, 65535
	i32.and 	$push0=, $0, $pop8
	i32.const	$push1=, 5
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push3=, 2
	i32.add 	$push4=, $0, $pop3
	i32.const	$push9=, 65535
	i32.and 	$push5=, $pop4, $pop9
	i32.const	$push6=, 7
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#2:                                 # %if.end8
	return  	$0
.LBB0_3:                                # %if.then7
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	ru, .Lfunc_end0-ru

	.section	.text.rs,"ax",@progbits
	.hidden	rs
	.globl	rs
	.type	rs,@function
rs:                                     # @rs
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, 65535
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 5
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label1
# BB#1:                                 # %if.end8
	return  	$0
.LBB1_2:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	rs, .Lfunc_end1-rs

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
