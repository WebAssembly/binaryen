	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/dbra-1.c"
	.section	.text.f1,"ax",@progbits
	.hidden	f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	block
	i32.const	$push11=, 0
	i32.eq  	$push12=, $0, $pop11
	br_if   	$pop12, 0       # 0: down to label0
# BB#1:                                 # %for.inc
	i32.const	$1=, 1
	i32.eq  	$push0=, $0, $1
	br_if   	$pop0, 0        # 0: down to label0
# BB#2:                                 # %for.inc.1
	i32.const	$1=, 2
	i32.eq  	$push1=, $0, $1
	br_if   	$pop1, 0        # 0: down to label0
# BB#3:                                 # %for.inc.2
	i32.const	$1=, 3
	i32.eq  	$push2=, $0, $1
	br_if   	$pop2, 0        # 0: down to label0
# BB#4:                                 # %for.inc.3
	i32.const	$1=, 4
	i32.eq  	$push3=, $0, $1
	br_if   	$pop3, 0        # 0: down to label0
# BB#5:                                 # %for.inc.4
	i32.const	$1=, 5
	i32.eq  	$push4=, $0, $1
	br_if   	$pop4, 0        # 0: down to label0
# BB#6:                                 # %for.inc.5
	i32.const	$1=, 6
	i32.eq  	$push5=, $0, $1
	br_if   	$pop5, 0        # 0: down to label0
# BB#7:                                 # %for.inc.6
	i32.const	$1=, 7
	i32.eq  	$push6=, $0, $1
	br_if   	$pop6, 0        # 0: down to label0
# BB#8:                                 # %for.inc.7
	i32.const	$1=, 8
	i32.eq  	$push7=, $0, $1
	br_if   	$pop7, 0        # 0: down to label0
# BB#9:                                 # %for.inc.8
	i32.const	$1=, 9
	i32.eq  	$push8=, $0, $1
	i32.const	$push9=, -1
	i32.select	$push10=, $pop8, $1, $pop9
	return  	$pop10
.LBB0_10:                               # %cleanup
	end_block                       # label0:
	return  	$1
	.endfunc
.Lfunc_end0:
	.size	f1, .Lfunc_end0-f1

	.section	.text.f2,"ax",@progbits
	.hidden	f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.eq  	$push1=, $0, $pop0
	return  	$pop1
	.endfunc
.Lfunc_end1:
	.size	f2, .Lfunc_end1-f2

	.section	.text.f3,"ax",@progbits
	.hidden	f3
	.globl	f3
	.type	f3,@function
f3:                                     # @f3
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 1
	i32.const	$2=, 0
	block
	i32.eq  	$push0=, $0, $1
	br_if   	$pop0, 0        # 0: down to label1
# BB#1:                                 # %for.inc
	copy_local	$2=, $1
	i32.const	$1=, 2
	i32.eq  	$push1=, $0, $1
	br_if   	$pop1, 0        # 0: down to label1
# BB#2:                                 # %for.inc.1
	copy_local	$2=, $1
	i32.const	$1=, 3
	i32.eq  	$push2=, $0, $1
	br_if   	$pop2, 0        # 0: down to label1
# BB#3:                                 # %for.inc.2
	copy_local	$2=, $1
	i32.const	$1=, 4
	i32.eq  	$push3=, $0, $1
	br_if   	$pop3, 0        # 0: down to label1
# BB#4:                                 # %for.inc.3
	copy_local	$2=, $1
	i32.const	$1=, 5
	i32.eq  	$push4=, $0, $1
	br_if   	$pop4, 0        # 0: down to label1
# BB#5:                                 # %for.inc.4
	copy_local	$2=, $1
	i32.const	$1=, 6
	i32.eq  	$push5=, $0, $1
	br_if   	$pop5, 0        # 0: down to label1
# BB#6:                                 # %for.inc.5
	copy_local	$2=, $1
	i32.const	$1=, 7
	i32.eq  	$push6=, $0, $1
	br_if   	$pop6, 0        # 0: down to label1
# BB#7:                                 # %for.inc.6
	copy_local	$2=, $1
	i32.const	$1=, 8
	i32.eq  	$push7=, $0, $1
	br_if   	$pop7, 0        # 0: down to label1
# BB#8:                                 # %for.inc.7
	copy_local	$2=, $1
	i32.const	$1=, 9
	i32.eq  	$push8=, $0, $1
	br_if   	$pop8, 0        # 0: down to label1
# BB#9:                                 # %for.inc.8
	i32.const	$push9=, 10
	i32.eq  	$push10=, $0, $pop9
	i32.const	$push11=, -1
	i32.select	$push12=, $pop10, $1, $pop11
	return  	$pop12
.LBB2_10:                               # %cleanup
	end_block                       # label1:
	return  	$2
	.endfunc
.Lfunc_end2:
	.size	f3, .Lfunc_end2-f3

	.section	.text.f4,"ax",@progbits
	.hidden	f4
	.globl	f4
	.type	f4,@function
f4:                                     # @f4
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	i32.eq  	$push1=, $0, $pop0
	return  	$pop1
	.endfunc
.Lfunc_end3:
	.size	f4, .Lfunc_end3-f4

	.section	.text.f5,"ax",@progbits
	.hidden	f5
	.globl	f5
	.type	f5,@function
f5:                                     # @f5
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, -1
	i32.const	$2=, 0
	block
	i32.eq  	$push0=, $0, $1
	br_if   	$pop0, 0        # 0: down to label2
# BB#1:                                 # %for.inc
	i32.const	$2=, 1
	i32.const	$push1=, -2
	i32.eq  	$push2=, $0, $pop1
	br_if   	$pop2, 0        # 0: down to label2
# BB#2:                                 # %for.inc.1
	i32.const	$2=, 2
	i32.const	$push3=, -3
	i32.eq  	$push4=, $0, $pop3
	br_if   	$pop4, 0        # 0: down to label2
# BB#3:                                 # %for.inc.2
	i32.const	$2=, 3
	i32.const	$push5=, -4
	i32.eq  	$push6=, $0, $pop5
	br_if   	$pop6, 0        # 0: down to label2
# BB#4:                                 # %for.inc.3
	i32.const	$2=, 4
	i32.const	$push7=, -5
	i32.eq  	$push8=, $0, $pop7
	br_if   	$pop8, 0        # 0: down to label2
# BB#5:                                 # %for.inc.4
	i32.const	$2=, 5
	i32.const	$push9=, -6
	i32.eq  	$push10=, $0, $pop9
	br_if   	$pop10, 0       # 0: down to label2
# BB#6:                                 # %for.inc.5
	i32.const	$2=, 6
	i32.const	$push11=, -7
	i32.eq  	$push12=, $0, $pop11
	br_if   	$pop12, 0       # 0: down to label2
# BB#7:                                 # %for.inc.6
	i32.const	$2=, 7
	i32.const	$push13=, -8
	i32.eq  	$push14=, $0, $pop13
	br_if   	$pop14, 0       # 0: down to label2
# BB#8:                                 # %for.inc.7
	i32.const	$2=, 8
	i32.const	$push15=, -9
	i32.eq  	$push16=, $0, $pop15
	br_if   	$pop16, 0       # 0: down to label2
# BB#9:                                 # %for.inc.8
	i32.const	$push17=, -10
	i32.eq  	$push18=, $0, $pop17
	i32.const	$push19=, 9
	i32.select	$push20=, $pop18, $pop19, $1
	return  	$pop20
.LBB4_10:                               # %cleanup
	end_block                       # label2:
	return  	$2
	.endfunc
.Lfunc_end4:
	.size	f5, .Lfunc_end4-f5

	.section	.text.f6,"ax",@progbits
	.hidden	f6
	.globl	f6
	.type	f6,@function
f6:                                     # @f6
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, -1
	i32.eq  	$push1=, $0, $pop0
	return  	$pop1
	.endfunc
.Lfunc_end5:
	.size	f6, .Lfunc_end5-f6

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end32
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end6:
	.size	main, .Lfunc_end6-main


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
