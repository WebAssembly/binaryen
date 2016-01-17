	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/920731-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 1
	i32.const	$2=, 0
	block
	i32.and 	$push0=, $0, $1
	br_if   	$pop0, 0        # 0: down to label0
.LBB0_1:                                # %for.inc
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.add 	$2=, $2, $1
	i32.const	$push2=, 7
	i32.gt_s	$push3=, $2, $pop2
	br_if   	$pop3, 1        # 1: down to label2
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.shr_s	$0=, $0, $1
	i32.and 	$push1=, $0, $1
	i32.const	$push4=, 0
	i32.eq  	$push5=, $pop1, $pop4
	br_if   	$pop5, 0        # 0: up to label1
.LBB0_3:                                # %for.end
	end_loop                        # label2:
	end_block                       # label0:
	return  	$2
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
