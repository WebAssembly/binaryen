	.text
	.file	"pr41395-2.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	i32.shl 	$push1=, $1, $pop0
	i32.add 	$push2=, $0, $pop1
	i32.const	$push3=, 8
	i32.add 	$push10=, $pop2, $pop3
	tee_local	$push9=, $1=, $pop10
	i32.const	$push4=, 0
	i32.store16	0($pop9), $pop4
	i32.const	$push5=, 40
	i32.add 	$push6=, $0, $pop5
	i32.const	$push8=, 1
	i32.store16	0($pop6), $pop8
	i32.load16_s	$push7=, 0($1)
                                        # fallthrough-return: $pop7
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
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, 276
	i32.call	$push1=, malloc@FUNCTION, $pop0
	i32.const	$push2=, 16
	i32.call	$push3=, foo@FUNCTION, $pop1, $pop2
	i32.const	$push4=, 1
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push6=, 0
	return  	$pop6
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	malloc, i32, i32
	.functype	abort, void
