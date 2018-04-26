	.text
	.file	"950426-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.then
	i32.const	$push1=, 0
	i32.const	$push0=, s1
	i32.store	p1($pop1), $pop0
	i32.const	$push8=, 0
	i32.const	$push2=, -1
	i32.store	s1($pop8), $pop2
	i32.const	$push7=, 0
	i32.const	$push3=, 3
	i32.store	i($pop7), $pop3
	i32.const	$push6=, 0
	i32.const	$push4=, .L.str.1+1
	i32.store	s1+16($pop6), $pop4
	i32.const	$push5=, 0
	call    	exit@FUNCTION, $pop5
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.section	.text.func1,"ax",@progbits
	.hidden	func1                   # -- Begin function func1
	.globl	func1
	.type	func1,@function
func1:                                  # @func1
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.load	$push0=, 0($0)
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	func1, .Lfunc_end1-func1
                                        # -- End function
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	copy_local	$push0=, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	foo, .Lfunc_end2-foo
                                        # -- End function
	.hidden	s1                      # @s1
	.type	s1,@object
	.section	.bss.s1,"aw",@nobits
	.globl	s1
	.p2align	2
s1:
	.skip	24
	.size	s1, 24

	.hidden	p1                      # @p1
	.type	p1,@object
	.section	.bss.p1,"aw",@nobits
	.globl	p1
	.p2align	2
p1:
	.int32	0
	.size	p1, 4

	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.p2align	2
i:
	.int32	0                       # 0x0
	.size	i, 4

	.type	.L.str.1,@object        # @.str.1
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str.1:
	.asciz	"123"
	.size	.L.str.1, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
