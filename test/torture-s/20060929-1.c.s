	.text
	.file	"20060929-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.load	$push4=, 0($0)
	tee_local	$push3=, $2=, $pop4
	i32.load	$push0=, 0($1)
	i32.store	0($pop3), $pop0
	i32.const	$push1=, 4
	i32.add 	$push2=, $2, $pop1
	i32.store	0($0), $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.load	$push4=, 0($0)
	tee_local	$push3=, $2=, $pop4
	i32.load	$push0=, 0($1)
	i32.store	0($pop3), $pop0
	i32.const	$push1=, 4
	i32.add 	$push2=, $2, $pop1
	i32.store	0($0), $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar
                                        # -- End function
	.section	.text.baz,"ax",@progbits
	.hidden	baz                     # -- Begin function baz
	.globl	baz
	.type	baz,@function
baz:                                    # @baz
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.load	$push4=, 0($0)
	tee_local	$push3=, $2=, $pop4
	i32.load	$push0=, 0($1)
	i32.store	0($pop3), $pop0
	i32.const	$push1=, 4
	i32.add 	$push2=, $2, $pop1
	i32.store	0($0), $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	baz, .Lfunc_end2-baz
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end19
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
