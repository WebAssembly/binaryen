	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20001228-1.c"
	.section	.text.foo1,"ax",@progbits
	.hidden	foo1
	.globl	foo1
	.type	foo1,@function
foo1:                                   # @foo1
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	return  	$pop0
	.endfunc
.Lfunc_end0:
	.size	foo1, .Lfunc_end0-foo1

	.section	.text.foo2,"ax",@progbits
	.hidden	foo2
	.globl	foo2
	.type	foo2,@function
foo2:                                   # @foo2
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 16
	i32.sub 	$3=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$3=, 0($1), $3
	i32.const	$push0=, 1
	i32.store	$discard=, 12($3), $pop0
	i32.load8_s	$push1=, 12($3):p2align=2
	i32.const	$2=, 16
	i32.add 	$3=, $3, $2
	i32.const	$2=, __stack_pointer
	i32.store	$3=, 0($2), $3
	return  	$pop1
	.endfunc
.Lfunc_end1:
	.size	foo2, .Lfunc_end1-foo2

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 16
	i32.sub 	$2=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$2=, 0($1), $2
	block
	i32.const	$push0=, 1
	i32.store	$push1=, 12($2), $pop0
	i32.load8_u	$push2=, 12($2):p2align=2
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push4=, 0
	call    	exit@FUNCTION, $pop4
	unreachable
.LBB2_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
