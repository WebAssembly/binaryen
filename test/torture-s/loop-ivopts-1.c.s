	.text
	.file	"loop-ivopts-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, 1126498304
	i32.store	foo.tmp+8($pop1), $pop0
	i32.const	$push4=, 0
	i64.const	$push2=, 4803089003686395904
	i64.store	foo.tmp($pop4), $pop2
	i32.const	$push3=, 0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %for.inc9.3
	i32.const	$push1=, 0
	i64.const	$push0=, 4838273375797772288
	i64.store	foo.tmp+4($pop1):p2align=2, $pop0
	i32.const	$push9=, 0
	i32.const	$push2=, 1095761920
	i32.store	foo.tmp($pop9), $pop2
	i32.const	$push3=, 1118306304
	i32.store	4($0), $pop3
	i32.const	$push8=, 1095761920
	i32.store	0($0), $pop8
	i32.const	$push7=, 0
	i32.load	$push4=, foo.tmp+8($pop7)
	i32.store	8($0), $pop4
	i32.const	$push6=, 0
	i32.load	$push5=, foo.tmp+12($pop6)
	i32.store	12($0), $pop5
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo
                                        # -- End function
	.type	foo.tmp,@object         # @foo.tmp
	.section	.bss.foo.tmp,"aw",@nobits
	.p2align	4
foo.tmp:
	.skip	16
	.size	foo.tmp, 16


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
