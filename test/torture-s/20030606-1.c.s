	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030606-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 55
	i32.store	$discard=, 0($0), $pop0
	block
	i32.const	$push7=, 0
	i32.eq  	$push8=, $1, $pop7
	br_if   	0, $pop8        # 0: down to label0
# BB#1:                                 # %if.then
	i32.const	$push5=, 4
	i32.add 	$push2=, $0, $pop5
	i32.store	$discard=, 0($pop2), $1
	i32.const	$push1=, 8
	i32.add 	$push3=, $0, $pop1
	return  	$pop3
.LBB0_2:
	end_block                       # label0:
	i32.const	$push6=, 4
	i32.add 	$push4=, $0, $pop6
	return  	$pop4
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
