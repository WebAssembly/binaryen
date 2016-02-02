	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr29006.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %entry
	i64.const	$push0=, 0
	i64.store	$discard=, 1($0):p2align=0, $pop0
	return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 16
	i32.sub 	$3=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$3=, 0($1), $3
	i32.const	$push2=, 8
	i32.add 	$push3=, $3, $pop2
	i32.const	$push0=, 0
	i32.load8_u	$push1=, .Lmain.s+8($pop0)
	i32.store8	$discard=, 0($pop3):p2align=3, $pop1
	i32.const	$push10=, 0
	i64.load	$push4=, .Lmain.s($pop10):p2align=0
	i64.store	$discard=, 0($3), $pop4
	call    	foo@FUNCTION, $3
	i32.const	$push5=, 1
	i32.or  	$push6=, $3, $pop5
	i64.load	$push7=, 0($pop6):p2align=0
	i64.const	$push8=, 0
	i64.ne  	$push9=, $pop7, $pop8
	i32.const	$2=, 16
	i32.add 	$3=, $3, $2
	i32.const	$2=, __stack_pointer
	i32.store	$3=, 0($2), $3
	return  	$pop9
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.Lmain.s,@object        # @main.s
	.section	.rodata..Lmain.s,"a",@progbits
.Lmain.s:
	.int8	1                       # 0x1
	.int64	-1                      # 0xffffffffffffffff
	.size	.Lmain.s, 9


	.ident	"clang version 3.9.0 "
