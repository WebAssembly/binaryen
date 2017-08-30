	.text
	.file	"20021118-3.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push2=, -2
	i32.eq  	$push3=, $0, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$push1=, -100
	i32.sub 	$push0=, $pop1, $0
	i32.const	$push5=, 0
	i32.ge_s	$push4=, $pop0, $pop5
	br_if   	0, $pop4        # 0: down to label0
# BB#2:                                 # %if.end
	i32.const	$push6=, 0
	return  	$pop6
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
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
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
