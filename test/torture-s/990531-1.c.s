	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/990531-1.c"
	.section	.text.bad,"ax",@progbits
	.hidden	bad
	.globl	bad
	.type	bad,@function
bad:                                    # @bad
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$4=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$4=, 0($3), $4
	i32.store	$discard=, 8($4), $1
	i32.const	$5=, 8
	i32.add 	$5=, $4, $5
	i32.add 	$push0=, $5, $0
	i32.const	$push1=, 0
	i32.store8	$discard=, 0($pop0), $pop1
	i32.load	$push2=, 8($4)
	i32.const	$4=, 16
	i32.add 	$4=, $4, $4
	i32.const	$4=, __stack_pointer
	i32.store	$4=, 0($4), $4
	return  	$pop2
.Lfunc_end0:
	.size	bad, .Lfunc_end0-bad

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
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
