	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000113-1.c"
	.section	.text.foobar,"ax",@progbits
	.hidden	foobar
	.globl	foobar
	.type	foobar,@function
foobar:                                 # @foobar
	.param  	i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push2=, 1
	i32.and 	$push0=, $0, $pop2
	tee_local	$push12=, $0=, $pop0
	i32.const	$push14=, 0
	i32.eq  	$push15=, $pop12, $pop14
	br_if   	0, $pop15       # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.const	$push3=, 3
	i32.and 	$push1=, $1, $pop3
	tee_local	$push13=, $1=, $pop1
	i32.sub 	$push4=, $pop13, $0
	i32.mul 	$push5=, $pop4, $1
	i32.add 	$push6=, $pop5, $2
	i32.const	$push7=, 7
	i32.and 	$push8=, $pop6, $pop7
	i32.const	$push9=, 5
	i32.ne  	$push10=, $pop8, $pop9
	br_if   	0, $pop10       # 0: down to label0
# BB#2:                                 # %if.end
	i32.const	$push11=, 0
	call    	exit@FUNCTION, $pop11
	unreachable
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foobar, .Lfunc_end0-foobar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 1
	i32.const	$push1=, 2
	i32.const	$push0=, 3
	i32.call	$discard=, foobar@FUNCTION, $pop2, $pop1, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
