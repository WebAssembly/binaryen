	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20040223-1.c"
	.section	.text.a,"ax",@progbits
	.hidden	a
	.globl	a
	.type	a,@function
a:                                      # @a
	.param  	i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 1234
	i32.ne  	$push1=, $1, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	a, .Lfunc_end0-a

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
