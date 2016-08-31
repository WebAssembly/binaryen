	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/960317-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block
	block
	i32.const	$push0=, 0
	i32.const	$push7=, -1
	i32.shl 	$push6=, $pop7, $0
	tee_local	$push5=, $2=, $pop6
	i32.sub 	$push1=, $pop0, $pop5
	i32.and 	$push2=, $1, $pop1
	i32.eqz 	$push9=, $pop2
	br_if   	0, $pop9        # 0: down to label1
# BB#1:                                 # %if.end
	i32.const	$0=, 1
	i32.const	$push8=, -1
	i32.xor 	$push3=, $2, $pop8
	i32.and 	$push4=, $1, $pop3
	br_if   	1, $pop4        # 1: down to label0
.LBB0_2:                                # %ab
	end_block                       # label1:
	i32.const	$0=, 0
.LBB0_3:                                # %cleanup
	end_block                       # label0:
	copy_local	$push10=, $0
                                        # fallthrough-return: $pop10
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 "
	.functype	exit, void, i32
