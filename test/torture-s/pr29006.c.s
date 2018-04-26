	.text
	.file	"pr29006.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# %bb.0:                                # %entry
	i64.const	$push0=, 0
	i64.store	1($0):p2align=0, $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i32
# %bb.0:                                # %entry
	i32.const	$push8=, 0
	i32.load	$push7=, __stack_pointer($pop8)
	i32.const	$push9=, 16
	i32.sub 	$1=, $pop7, $pop9
	i32.const	$push10=, 0
	i32.store	__stack_pointer($pop10), $1
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
                                        # -- End function
	.type	.Lmain.s,@object        # @main.s
	.section	.rodata..Lmain.s,"a",@progbits
.Lmain.s:
	.int8	1                       # 0x1
	.int64	-1                      # 0xffffffffffffffff
	.size	.Lmain.s, 9


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
