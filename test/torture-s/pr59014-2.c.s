	.text
	.file	"pr59014-2.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i64, i64
	.result 	i64
# BB#0:                                 # %entry
	i64.const	$push3=, 6
	i64.add 	$push0=, $1, $0
	i64.or  	$push1=, $1, $0
	i32.wrap/i64	$push2=, $pop1
	i64.select	$push4=, $pop3, $pop0, $pop2
                                        # fallthrough-return: $pop4
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
	i64.const	$push1=, 12884901888
	i64.const	$push0=, 21474836480
	i64.call	$push2=, foo@FUNCTION, $pop1, $pop0
	i64.const	$push3=, 34359738368
	i64.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push5=, 0
	return  	$pop5
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
