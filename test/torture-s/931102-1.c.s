	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/931102-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	block
	i32.const	$push3=, 1
	i32.and 	$push0=, $0, $pop3
	br_if   	0, $pop0        # 0: down to label0
.LBB0_1:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push7=, 1
	i32.add 	$1=, $1, $pop7
	i32.const	$push6=, 24
	i32.shl 	$push1=, $0, $pop6
	i32.const	$push5=, 25
	i32.shr_s	$0=, $pop1, $pop5
	i32.const	$push4=, 1
	i32.and 	$push2=, $0, $pop4
	i32.const	$push8=, 0
	i32.eq  	$push9=, $pop2, $pop8
	br_if   	0, $pop9        # 0: up to label1
.LBB0_2:                                # %while.end
	end_loop                        # label2:
	end_block                       # label0:
	return  	$1
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


	.ident	"clang version 3.9.0 "
