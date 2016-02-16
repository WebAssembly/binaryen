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
	block
	i32.const	$push21=, 0
	i32.eq  	$push22=, $0, $pop21
	br_if   	0, $pop22       # 0: down to label1
# BB#1:                                 # %for.inc
	i32.const	$1=, 1
	i32.const	$push12=, 1
	i32.eq  	$push0=, $0, $pop12
	br_if   	0, $pop0        # 0: down to label1
# BB#2:                                 # %for.inc.1
	i32.const	$1=, 2
	i32.const	$push13=, 2
	i32.eq  	$push1=, $0, $pop13
	br_if   	0, $pop1        # 0: down to label1
# BB#3:                                 # %for.inc.2
	i32.const	$1=, 3
	i32.const	$push14=, 3
	i32.eq  	$push2=, $0, $pop14
	br_if   	0, $pop2        # 0: down to label1
# BB#4:                                 # %for.inc.3
	i32.const	$1=, 4
	i32.const	$push15=, 4
	i32.eq  	$push3=, $0, $pop15
	br_if   	0, $pop3        # 0: down to label1
# BB#5:                                 # %for.inc.4
	i32.const	$1=, 5
	i32.const	$push16=, 5
	i32.eq  	$push4=, $0, $pop16
	br_if   	0, $pop4        # 0: down to label1
# BB#6:                                 # %for.inc.5
	i32.const	$1=, 6
	i32.const	$push17=, 6
	i32.eq  	$push5=, $0, $pop17
	br_if   	0, $pop5        # 0: down to label1
# BB#7:                                 # %for.inc.6
	i32.const	$1=, 7
	i32.const	$push18=, 7
	i32.eq  	$push6=, $0, $pop18
	br_if   	0, $pop6        # 0: down to label1
# BB#8:                                 # %for.inc.7
	i32.const	$1=, 8
	i32.const	$push19=, 8
	i32.ne  	$push7=, $0, $pop19
	br_if   	1, $pop7        # 1: down to label0
.LBB0_9:                                # %cleanup
	end_block                       # label1:
	return  	$1
.LBB0_10:                               # %for.inc.8
	end_block                       # label0:
	i32.const	$push8=, 9
	i32.const	$push10=, -1
	i32.const	$push20=, 9
	i32.eq  	$push9=, $0, $pop20
	i32.select	$push11=, $pop8, $pop10, $pop9
	return  	$pop11
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	block
	block
	i32.const	$push0=, 1
	i32.eq  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label3
# BB#1:                                 # %for.inc
	i32.const	$1=, 1
	i32.const	$push2=, 2
	i32.eq  	$push3=, $0, $pop2
	br_if   	0, $pop3        # 0: down to label3
# BB#2:                                 # %for.inc.1
	i32.const	$1=, 2
	i32.const	$push4=, 3
	i32.eq  	$push5=, $0, $pop4
	br_if   	0, $pop5        # 0: down to label3
# BB#3:                                 # %for.inc.2
	i32.const	$1=, 3
	i32.const	$push6=, 4
	i32.eq  	$push7=, $0, $pop6
	br_if   	0, $pop7        # 0: down to label3
# BB#4:                                 # %for.inc.3
	i32.const	$1=, 4
	i32.const	$push8=, 5
	i32.eq  	$push9=, $0, $pop8
	br_if   	0, $pop9        # 0: down to label3
# BB#5:                                 # %for.inc.4
	i32.const	$1=, 5
	i32.const	$push10=, 6
	i32.eq  	$push11=, $0, $pop10
	br_if   	0, $pop11       # 0: down to label3
# BB#6:                                 # %for.inc.5
	i32.const	$1=, 6
	i32.const	$push12=, 7
	i32.eq  	$push13=, $0, $pop12
	br_if   	0, $pop13       # 0: down to label3
# BB#7:                                 # %for.inc.6
	i32.const	$1=, 7
	i32.const	$push14=, 8
	i32.eq  	$push15=, $0, $pop14
	br_if   	0, $pop15       # 0: down to label3
# BB#8:                                 # %for.inc.7
	i32.const	$1=, 8
	i32.const	$push21=, 9
	i32.ne  	$push16=, $0, $pop21
	br_if   	1, $pop16       # 1: down to label2
.LBB2_9:                                # %cleanup
	end_block                       # label3:
	return  	$1
.LBB2_10:                               # %for.inc.8
	end_block                       # label2:
	i32.const	$push22=, 9
	i32.const	$push19=, -1
	i32.const	$push17=, 10
	i32.eq  	$push18=, $0, $pop17
	i32.select	$push20=, $pop22, $pop19, $pop18
	return  	$pop20
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	block
	block
	i32.const	$push0=, -1
	i32.eq  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label5
# BB#1:                                 # %for.inc
	i32.const	$1=, 1
	i32.const	$push2=, -2
	i32.eq  	$push3=, $0, $pop2
	br_if   	0, $pop3        # 0: down to label5
# BB#2:                                 # %for.inc.1
	i32.const	$1=, 2
	i32.const	$push4=, -3
	i32.eq  	$push5=, $0, $pop4
	br_if   	0, $pop5        # 0: down to label5
# BB#3:                                 # %for.inc.2
	i32.const	$1=, 3
	i32.const	$push6=, -4
	i32.eq  	$push7=, $0, $pop6
	br_if   	0, $pop7        # 0: down to label5
# BB#4:                                 # %for.inc.3
	i32.const	$1=, 4
	i32.const	$push8=, -5
	i32.eq  	$push9=, $0, $pop8
	br_if   	0, $pop9        # 0: down to label5
# BB#5:                                 # %for.inc.4
	i32.const	$1=, 5
	i32.const	$push10=, -6
	i32.eq  	$push11=, $0, $pop10
	br_if   	0, $pop11       # 0: down to label5
# BB#6:                                 # %for.inc.5
	i32.const	$1=, 6
	i32.const	$push12=, -7
	i32.eq  	$push13=, $0, $pop12
	br_if   	0, $pop13       # 0: down to label5
# BB#7:                                 # %for.inc.6
	i32.const	$1=, 7
	i32.const	$push14=, -8
	i32.eq  	$push15=, $0, $pop14
	br_if   	0, $pop15       # 0: down to label5
# BB#8:                                 # %for.inc.7
	i32.const	$1=, 8
	i32.const	$push16=, -9
	i32.ne  	$push17=, $0, $pop16
	br_if   	1, $pop17       # 1: down to label4
.LBB4_9:                                # %cleanup
	end_block                       # label5:
	return  	$1
.LBB4_10:                               # %for.inc.8
	end_block                       # label4:
	i32.const	$push21=, 9
	i32.const	$push20=, -1
	i32.const	$push18=, -10
	i32.eq  	$push19=, $0, $pop18
	i32.select	$push22=, $pop21, $pop20, $pop19
	return  	$pop22
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
