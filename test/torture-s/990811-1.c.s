	.text
	.file	"990811-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	block   	
	i32.const	$push0=, 2
	i32.eq  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %entry
	block   	
	i32.const	$push2=, 1
	i32.eq  	$push3=, $0, $pop2
	br_if   	0, $pop3        # 0: down to label2
# BB#2:                                 # %entry
	br_if   	2, $0           # 2: down to label0
# BB#3:                                 # %sw.bb
	i32.load	$push6=, 0($1)
	return  	$pop6
.LBB0_4:                                # %sw.bb1
	end_block                       # label2:
	i32.load8_s	$push5=, 0($1)
	return  	$pop5
.LBB0_5:                                # %sw.bb2
	end_block                       # label1:
	i32.load16_s	$push4=, 0($1)
	return  	$pop4
.LBB0_6:                                # %sw.epilog
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
# BB#0:                                 # %if.end16
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
