	.text
	.file	"pr40057.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i64
	.result 	i32
# BB#0:                                 # %entry
	i32.wrap/i64	$push0=, $0
	i32.const	$push1=, 31
	i32.shr_s	$push2=, $pop0, $pop1
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i64
	.result 	i32
# BB#0:                                 # %entry
	i32.wrap/i64	$push0=, $0
	i32.const	$push1=, 31
	i32.shr_s	$push2=, $pop0, $pop1
                                        # fallthrough-return: $pop2
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
# BB#0:                                 # %entry
	block   	
	i64.const	$push0=, 6042589866
	i32.call	$push1=, foo@FUNCTION, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.end
	i64.const	$push2=, 6579460778
	i32.call	$push3=, foo@FUNCTION, $pop2
	i32.eqz 	$push9=, $pop3
	br_if   	0, $pop9        # 0: down to label0
# BB#2:                                 # %if.end4
	i64.const	$push4=, 6042589866
	i32.call	$push5=, bar@FUNCTION, $pop4
	br_if   	0, $pop5        # 0: down to label0
# BB#3:                                 # %if.end8
	i64.const	$push6=, 6579460778
	i32.call	$push7=, bar@FUNCTION, $pop6
	i32.eqz 	$push10=, $pop7
	br_if   	0, $pop10       # 0: down to label0
# BB#4:                                 # %if.end12
	i32.const	$push8=, 0
	return  	$pop8
.LBB2_5:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
