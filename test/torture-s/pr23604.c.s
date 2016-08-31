	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr23604.c"
	.section	.text.g,"ax",@progbits
	.hidden	g
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 1
	block
	i32.const	$push3=, 1
	i32.gt_u	$push0=, $0, $pop3
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %if.then2
	i32.eqz 	$push2=, $1
	i32.eq  	$push1=, $0, $1
	i32.or  	$2=, $pop2, $pop1
.LBB0_2:                                # %return
	end_block                       # label0:
	copy_local	$push4=, $2
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end0:
	.size	g, .Lfunc_end0-g

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 "
