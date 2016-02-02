	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20021120-3.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$7=, __stack_pointer
	i32.load	$7=, 0($7)
	i32.const	$8=, 16
	i32.sub 	$10=, $7, $8
	i32.const	$8=, __stack_pointer
	i32.store	$10=, 0($8), $10
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 4
	i32.sub 	$10=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$10=, 0($4), $10
	i32.div_u	$push0=, $1, $2
	i32.store	$discard=, 0($10), $pop0
	i32.const	$push1=, .L.str
	i32.call	$discard=, sprintf@FUNCTION, $0, $pop1
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 4
	i32.add 	$10=, $5, $6
	i32.const	$6=, __stack_pointer
	i32.store	$10=, 0($6), $10
	i32.const	$push2=, 1
	i32.add 	$push3=, $1, $pop2
	i32.const	$push6=, 1
	i32.add 	$push4=, $2, $pop6
	i32.div_u	$push5=, $pop3, $pop4
	i32.const	$9=, 16
	i32.add 	$10=, $10, $9
	i32.const	$9=, __stack_pointer
	i32.store	$10=, 0($9), $10
	return  	$pop5
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %if.end
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 32
	i32.sub 	$7=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$7=, 0($5), $7
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 4
	i32.sub 	$7=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$7=, 0($1), $7
	i32.const	$push0=, 1073741823
	i32.store	$discard=, 0($7), $pop0
	i32.const	$push1=, .L.str
	i32.const	$6=, 16
	i32.add 	$6=, $7, $6
	i32.call	$discard=, sprintf@FUNCTION, $6, $pop1
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 4
	i32.add 	$7=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$7=, 0($3), $7
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"%d"
	.size	.L.str, 3


	.ident	"clang version 3.9.0 "
