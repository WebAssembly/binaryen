	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr38236.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push4=, __stack_pointer
	i32.load	$push5=, 0($pop4)
	i32.const	$push6=, 16
	i32.sub 	$7=, $pop5, $pop6
	i32.const	$4=, 12
	i32.add 	$4=, $7, $4
	i32.const	$5=, 8
	i32.add 	$5=, $7, $5
	i32.select	$push1=, $4, $5, $3
	i32.const	$push2=, 1
	i32.store	$discard=, 0($pop1), $pop2
	i32.const	$6=, 12
	i32.add 	$6=, $7, $6
	i32.select	$push0=, $6, $0, $2
	i32.load	$push3=, 0($pop0)
	return  	$pop3
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
	block
	i32.const	$push5=, 0
	i32.const	$push0=, 1
	i32.const	$push4=, 1
	i32.call	$push1=, foo@FUNCTION, $pop5, $0, $pop0, $pop4
	i32.const	$push3=, 1
	i32.ne  	$push2=, $pop1, $pop3
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push6=, 0
	return  	$pop6
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
