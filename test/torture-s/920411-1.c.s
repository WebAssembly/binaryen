	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/920411-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 16
	i32.sub 	$6=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$6=, 0($2), $6
	i32.load8_u	$push0=, 0($0)
	i32.store8	$discard=, 12($6), $pop0
	i32.const	$push2=, 1
	i32.const	$4=, 12
	i32.add 	$4=, $6, $4
	i32.or  	$push3=, $4, $pop2
	i32.load8_u	$push1=, 1($0)
	i32.store8	$discard=, 0($pop3), $pop1
	i32.const	$push5=, 2
	i32.const	$5=, 12
	i32.add 	$5=, $6, $5
	i32.or  	$push6=, $5, $pop5
	i32.load8_u	$push4=, 2($0)
	i32.store8	$discard=, 0($pop6), $pop4
	i32.const	$push8=, 3
	i32.const	$6=, 12
	i32.add 	$6=, $6, $6
	i32.or  	$push9=, $6, $pop8
	i32.load8_u	$push7=, 3($0)
	i32.store8	$discard=, 0($pop9), $pop7
	i32.load	$push10=, 12($6)
	i32.const	$3=, 16
	i32.add 	$6=, $6, $3
	i32.const	$3=, __stack_pointer
	i32.store	$6=, 0($3), $6
	return  	$pop10
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

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
	.section	".note.GNU-stack","",@progbits
