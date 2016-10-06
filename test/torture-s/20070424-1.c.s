	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20070424-1.c"
	.section	.text.do_exit,"ax",@progbits
	.hidden	do_exit
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

	.section	.text.do_abort,"ax",@progbits
	.hidden	do_abort
	.globl	do_abort
	.type	do_abort,@function
do_abort:                               # @do_abort
# BB#0:                                 # %entry
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	do_abort, .Lfunc_end1-do_abort

	.section	.text.foo,"ax",@progbits
	.hidden	foo
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

	.section	.text.main,"ax",@progbits
	.hidden	main
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
	.functype	abort, void
