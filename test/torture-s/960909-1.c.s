	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/960909-1.c"
	.section	.text.ffs,"ax",@progbits
	.hidden	ffs
	.globl	ffs
	.type	ffs,@function
ffs:                                    # @ffs
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 0
	block
	i32.const	$push2=, 0
	i32.eq  	$push3=, $0, $pop2
	br_if   	$pop3, 0        # 0: down to label0
# BB#1:                                 # %for.cond.preheader
	i32.const	$1=, 1
	copy_local	$2=, $1
	copy_local	$3=, $1
	i32.and 	$push0=, $0, $1
	br_if   	$pop0, 0        # 0: down to label0
.LBB0_2:                                # %for.inc
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.add 	$3=, $3, $1
	i32.shl 	$2=, $2, $1
	i32.and 	$push1=, $2, $0
	i32.const	$push4=, 0
	i32.eq  	$push5=, $pop1, $pop4
	br_if   	$pop5, 0        # 0: up to label1
.LBB0_3:                                # %cleanup
	end_loop                        # label2:
	end_block                       # label0:
	return  	$3
.Lfunc_end0:
	.size	ffs, .Lfunc_end0-ffs

	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 0
	i32.eq  	$push1=, $0, $pop0
	br_if   	$pop1, 0        # 0: down to label3
# BB#1:                                 # %if.end
	return  	$0
.LBB1_2:                                # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.Lfunc_end1:
	.size	f, .Lfunc_end1-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
