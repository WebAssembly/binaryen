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
	.local  	i64, i32
# BB#0:                                 # %entry
	i32.const	$push10=, __stack_pointer
	i32.const	$push7=, __stack_pointer
	i32.load	$push8=, 0($pop7)
	i32.const	$push9=, 16
	i32.sub 	$push14=, $pop8, $pop9
	i32.store	$push17=, 0($pop10), $pop14
	tee_local	$push16=, $1=, $pop17
	i32.const	$push2=, 8
	i32.add 	$push3=, $pop16, $pop2
	i32.const	$push0=, 0
	i32.load8_u	$push1=, .Lmain.s+8($pop0)
	i32.store8	$discard=, 0($pop3), $pop1
	i32.const	$push15=, 0
	i64.load	$push4=, .Lmain.s($pop15):p2align=0
	i64.store	$discard=, 0($1), $pop4
	call    	foo@FUNCTION, $1
	i64.load	$0=, 1($1):p2align=0
	i32.const	$push13=, __stack_pointer
	i32.const	$push11=, 16
	i32.add 	$push12=, $1, $pop11
	i32.store	$discard=, 0($pop13), $pop12
	i64.const	$push5=, 0
	i64.ne  	$push6=, $0, $pop5
	return  	$pop6
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
