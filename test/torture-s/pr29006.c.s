	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr29006.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %entry
	i64.const	$push0=, 0
	i64.store	1($0):p2align=0, $pop0
                                        # fallthrough-return
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
	i32.const	$push10=, 0
	i32.const	$push7=, 0
	i32.load	$push8=, __stack_pointer($pop7)
	i32.const	$push9=, 16
	i32.sub 	$push16=, $pop8, $pop9
	tee_local	$push15=, $1=, $pop16
	i32.store	__stack_pointer($pop10), $pop15
	i32.const	$push2=, 8
	i32.add 	$push3=, $1, $pop2
	i32.const	$push0=, 0
	i32.load8_u	$push1=, .Lmain.s+8($pop0)
	i32.store8	0($pop3), $pop1
	i32.const	$push14=, 0
	i64.load	$push4=, .Lmain.s($pop14):p2align=0
	i64.store	0($1), $pop4
	call    	foo@FUNCTION, $1
	i64.load	$0=, 1($1):p2align=0
	i32.const	$push13=, 0
	i32.const	$push11=, 16
	i32.add 	$push12=, $1, $pop11
	i32.store	__stack_pointer($pop13), $pop12
	i64.const	$push5=, 0
	i64.ne  	$push6=, $0, $pop5
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.Lmain.s,@object        # @main.s
	.section	.rodata..Lmain.s,"a",@progbits
.Lmain.s:
	.int8	1                       # 0x1
	.int64	-1                      # 0xffffffffffffffff
	.size	.Lmain.s, 9


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
