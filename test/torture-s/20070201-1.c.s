	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20070201-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, __stack_pointer
	i32.load	$6=, 0($6)
	i32.const	$7=, 16
	i32.sub 	$7=, $6, $7
	i32.const	$7=, __stack_pointer
	i32.store	$7=, 0($7), $7
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 4
	i32.sub 	$7=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$7=, 0($3), $7
	i32.store	$discard=, 0($7), $1
	i32.const	$push2=, .L.str
	i32.call	$discard=, siprintf@FUNCTION, $0, $pop2
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 4
	i32.add 	$7=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$7=, 0($5), $7
	i32.const	$push0=, 1
	i32.add 	$push1=, $1, $pop0
	i32.const	$8=, 16
	i32.add 	$7=, $7, $8
	i32.const	$8=, __stack_pointer
	i32.store	$7=, 0($8), $7
	return  	$pop1
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %if.end
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 16
	i32.sub 	$9=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$9=, 0($5), $9
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 4
	i32.sub 	$9=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$9=, 0($1), $9
	i32.const	$push0=, 2
	i32.const	$7=, 10
	i32.add 	$7=, $9, $7
	i32.add 	$push1=, $7, $pop0
	i32.store	$discard=, 0($9), $pop1
	i32.const	$push2=, .L.str
	i32.const	$8=, 10
	i32.add 	$8=, $9, $8
	i32.call	$discard=, siprintf@FUNCTION, $8, $pop2
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 4
	i32.add 	$9=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$9=, 0($3), $9
	i32.const	$push3=, 0
	i32.const	$6=, 16
	i32.add 	$9=, $9, $6
	i32.const	$6=, __stack_pointer
	i32.store	$9=, 0($6), $9
	return  	$pop3
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"abcde"
	.size	.L.str, 6


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
