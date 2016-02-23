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
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push2=, __stack_pointer
	i32.load	$push3=, 0($pop2)
	i32.const	$push4=, 16
	i32.sub 	$2=, $pop3, $pop4
	i32.const	$push5=, __stack_pointer
	i32.store	$discard=, 0($pop5), $2
	i32.const	$push0=, 65531
	i32.store16	$discard=, 14($2), $pop0
	i32.const	$push1=, 65526
	i32.store16	$discard=, 12($2), $pop1
	i32.const	$0=, 14
	i32.add 	$0=, $2, $0
	i32.const	$1=, 12
	i32.add 	$1=, $2, $1
	i32.call	$discard=, foo@FUNCTION, $0, $1
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
