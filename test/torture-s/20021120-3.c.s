	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20021120-3.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push7=, __stack_pointer
	i32.load	$push8=, 0($pop7)
	i32.const	$push9=, 16
	i32.sub 	$3=, $pop8, $pop9
	i32.const	$push10=, __stack_pointer
	i32.store	$discard=, 0($pop10), $3
	i32.div_u	$push0=, $1, $2
	i32.store	$discard=, 0($3):p2align=4, $pop0
	i32.const	$push1=, .L.str
	i32.call	$discard=, sprintf@FUNCTION, $0, $pop1, $3
	i32.const	$push2=, 1
	i32.add 	$push3=, $1, $pop2
	i32.const	$push6=, 1
	i32.add 	$push4=, $2, $pop6
	i32.div_u	$push5=, $pop3, $pop4
	i32.const	$push11=, 16
	i32.add 	$3=, $3, $pop11
	i32.const	$push12=, __stack_pointer
	i32.store	$discard=, 0($pop12), $3
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
	.local  	i32, i32
# BB#0:                                 # %if.end
	i32.const	$push3=, __stack_pointer
	i32.load	$push4=, 0($pop3)
	i32.const	$push5=, 32
	i32.sub 	$1=, $pop4, $pop5
	i32.const	$push6=, __stack_pointer
	i32.store	$discard=, 0($pop6), $1
	i32.const	$push0=, 1073741823
	i32.store	$discard=, 0($1):p2align=4, $pop0
	i32.const	$push1=, .L.str
	i32.const	$0=, 16
	i32.add 	$0=, $1, $0
	i32.call	$discard=, sprintf@FUNCTION, $0, $pop1, $1
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
