	.text
	.file	"restrict-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.store	4($0), $pop0
	i32.load	$push2=, 0($2)
	i32.load	$push1=, 0($1)
	i32.add 	$push3=, $pop2, $pop1
	i32.store	0($0), $pop3
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
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.load	$push6=, 0($0)
	tee_local	$push5=, $1=, $pop6
	i32.const	$push0=, 1
	i32.shl 	$push1=, $pop5, $pop0
	i64.extend_u/i32	$push2=, $pop1
	i64.store	0($0):p2align=2, $pop2
	block   	
	i32.const	$push4=, 1
	i32.ne  	$push3=, $1, $pop4
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %bar.exit
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
