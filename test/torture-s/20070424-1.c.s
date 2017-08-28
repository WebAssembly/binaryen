	.text
	.file	"20070424-1.c"
	.section	.text.do_exit,"ax",@progbits
	.hidden	do_exit                 # -- Begin function do_exit
	.globl	do_exit
	.type	do_exit,@function
do_exit:                                # @do_exit
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end0:
	.size	do_exit, .Lfunc_end0-do_exit
                                        # -- End function
	.section	.text.do_abort,"ax",@progbits
	.hidden	do_abort                # -- Begin function do_abort
	.globl	do_abort
	.type	do_abort,@function
do_abort:                               # @do_abort
# BB#0:                                 # %entry
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	do_abort, .Lfunc_end1-do_abort
                                        # -- End function
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	
	i32.ge_s	$push0=, $0, $1
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %doit
	call    	do_abort@FUNCTION
	unreachable
.LBB2_2:                                # %if.end
	end_block                       # label0:
	call    	do_exit@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	foo, .Lfunc_end2-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	call    	do_exit@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	exit, void, i32
	.functype	abort, void
