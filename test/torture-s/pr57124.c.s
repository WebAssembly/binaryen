	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr57124.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.load16_u	$push0=, 0($0)
	i32.const	$push1=, 4095
	i32.gt_u	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB0_2:                                # %if.end
	end_block                       # label0:
	i32.const	$push3=, 0
	call    	exit@FUNCTION, $pop3
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push5=, 0
	i32.const	$push2=, 0
	i32.load	$push3=, __stack_pointer($pop2)
	i32.const	$push4=, 16
	i32.sub 	$push10=, $pop3, $pop4
	i32.store	$push12=, __stack_pointer($pop5), $pop10
	tee_local	$push11=, $0=, $pop12
	i32.const	$push0=, 65531
	i32.store16	$drop=, 14($pop11), $pop0
	i32.const	$push1=, 65526
	i32.store16	$drop=, 12($0), $pop1
	i32.const	$push6=, 14
	i32.add 	$push7=, $0, $pop6
	i32.const	$push8=, 12
	i32.add 	$push9=, $0, $pop8
	i32.call	$drop=, foo@FUNCTION, $pop7, $pop9
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
