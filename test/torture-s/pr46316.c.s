	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr46316.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i64
	.result 	i64
# BB#0:                                 # %entry
	i64.const	$push0=, -4
	i64.const	$push11=, -4
	i64.lt_s	$push1=, $0, $pop11
	i64.select	$push2=, $0, $pop0, $pop1
	i64.const	$push3=, -1
	i64.xor 	$push4=, $pop2, $pop3
	i64.add 	$push5=, $0, $pop4
	i64.const	$push6=, 2
	i64.add 	$push7=, $pop5, $pop6
	i64.const	$push8=, -2
	i64.and 	$push9=, $pop7, $pop8
	i64.sub 	$push10=, $0, $pop9
                                        # fallthrough-return: $pop10
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
	i64.const	$push0=, 0
	i64.call	$push1=, foo@FUNCTION, $pop0
	i64.const	$push2=, -4
	i64.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push4=, 0
	return  	$pop4
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
