	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020307-1.c"
	.globl	f3
	.type	f3,@function
f3:                                     # @f3
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 6
	block   	.LBB0_2
	i32.and 	$push0=, $0, $1
	i32.ge_u	$push1=, $pop0, $1
	br_if   	$pop1, .LBB0_2
# BB#1:                                 # %if.end
	return
.LBB0_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	f3, .Lfunc_end0-f3

	.globl	f4
	.type	f4,@function
f4:                                     # @f4
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB1_2
	i32.const	$push0=, 14
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 10
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB1_2
# BB#1:                                 # %if.end
	return
.LBB1_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end1:
	.size	f4, .Lfunc_end1-f4

	.globl	f5
	.type	f5,@function
f5:                                     # @f5
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB2_2
	i32.const	$push0=, 30
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 18
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB2_2
# BB#1:                                 # %if.end
	return
.LBB2_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end2:
	.size	f5, .Lfunc_end2-f5

	.globl	f6
	.type	f6,@function
f6:                                     # @f6
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB3_2
	i32.const	$push0=, 62
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 34
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB3_2
# BB#1:                                 # %if.end
	return
.LBB3_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end3:
	.size	f6, .Lfunc_end3-f6

	.globl	f7
	.type	f7,@function
f7:                                     # @f7
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB4_2
	i32.const	$push0=, 126
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 66
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB4_2
# BB#1:                                 # %if.end
	return
.LBB4_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end4:
	.size	f7, .Lfunc_end4-f7

	.globl	f8
	.type	f8,@function
f8:                                     # @f8
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB5_2
	i32.const	$push0=, 254
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 130
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB5_2
# BB#1:                                 # %if.end
	return
.LBB5_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end5:
	.size	f8, .Lfunc_end5-f8

	.globl	f9
	.type	f9,@function
f9:                                     # @f9
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB6_2
	i32.const	$push0=, 510
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 258
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB6_2
# BB#1:                                 # %if.end
	return
.LBB6_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end6:
	.size	f9, .Lfunc_end6-f9

	.globl	f10
	.type	f10,@function
f10:                                    # @f10
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB7_2
	i32.const	$push0=, 1022
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 514
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB7_2
# BB#1:                                 # %if.end
	return
.LBB7_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end7:
	.size	f10, .Lfunc_end7-f10

	.globl	f11
	.type	f11,@function
f11:                                    # @f11
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB8_2
	i32.const	$push0=, 2046
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 1026
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB8_2
# BB#1:                                 # %if.end
	return
.LBB8_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end8:
	.size	f11, .Lfunc_end8-f11

	.globl	f12
	.type	f12,@function
f12:                                    # @f12
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB9_2
	i32.const	$push0=, 4094
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 2050
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB9_2
# BB#1:                                 # %if.end
	return
.LBB9_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end9:
	.size	f12, .Lfunc_end9-f12

	.globl	f13
	.type	f13,@function
f13:                                    # @f13
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB10_2
	i32.const	$push0=, 8190
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 4098
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB10_2
# BB#1:                                 # %if.end
	return
.LBB10_2:                                 # %if.then
	call    	abort
	unreachable
.Lfunc_end10:
	.size	f13, .Lfunc_end10-f13

	.globl	f14
	.type	f14,@function
f14:                                    # @f14
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB11_2
	i32.const	$push0=, 16382
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 8194
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB11_2
# BB#1:                                 # %if.end
	return
.LBB11_2:                                 # %if.then
	call    	abort
	unreachable
.Lfunc_end11:
	.size	f14, .Lfunc_end11-f14

	.globl	f15
	.type	f15,@function
f15:                                    # @f15
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB12_2
	i32.const	$push0=, 32766
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 16386
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB12_2
# BB#1:                                 # %if.end
	return
.LBB12_2:                                 # %if.then
	call    	abort
	unreachable
.Lfunc_end12:
	.size	f15, .Lfunc_end12-f15

	.globl	f16
	.type	f16,@function
f16:                                    # @f16
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB13_2
	i32.const	$push0=, 65534
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 32770
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB13_2
# BB#1:                                 # %if.end
	return
.LBB13_2:                                 # %if.then
	call    	abort
	unreachable
.Lfunc_end13:
	.size	f16, .Lfunc_end13-f16

	.globl	f17
	.type	f17,@function
f17:                                    # @f17
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB14_2
	i32.const	$push0=, 131070
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 65538
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB14_2
# BB#1:                                 # %if.end
	return
.LBB14_2:                                 # %if.then
	call    	abort
	unreachable
.Lfunc_end14:
	.size	f17, .Lfunc_end14-f17

	.globl	f18
	.type	f18,@function
f18:                                    # @f18
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB15_2
	i32.const	$push0=, 262142
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 131074
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB15_2
# BB#1:                                 # %if.end
	return
.LBB15_2:                                 # %if.then
	call    	abort
	unreachable
.Lfunc_end15:
	.size	f18, .Lfunc_end15-f18

	.globl	f19
	.type	f19,@function
f19:                                    # @f19
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB16_2
	i32.const	$push0=, 524286
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 262146
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB16_2
# BB#1:                                 # %if.end
	return
.LBB16_2:                                 # %if.then
	call    	abort
	unreachable
.Lfunc_end16:
	.size	f19, .Lfunc_end16-f19

	.globl	f20
	.type	f20,@function
f20:                                    # @f20
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB17_2
	i32.const	$push0=, 1048574
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 524290
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB17_2
# BB#1:                                 # %if.end
	return
.LBB17_2:                                 # %if.then
	call    	abort
	unreachable
.Lfunc_end17:
	.size	f20, .Lfunc_end17-f20

	.globl	f21
	.type	f21,@function
f21:                                    # @f21
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB18_2
	i32.const	$push0=, 2097150
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 1048578
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB18_2
# BB#1:                                 # %if.end
	return
.LBB18_2:                                 # %if.then
	call    	abort
	unreachable
.Lfunc_end18:
	.size	f21, .Lfunc_end18-f21

	.globl	f22
	.type	f22,@function
f22:                                    # @f22
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB19_2
	i32.const	$push0=, 4194302
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 2097154
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB19_2
# BB#1:                                 # %if.end
	return
.LBB19_2:                                 # %if.then
	call    	abort
	unreachable
.Lfunc_end19:
	.size	f22, .Lfunc_end19-f22

	.globl	f23
	.type	f23,@function
f23:                                    # @f23
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB20_2
	i32.const	$push0=, 8388606
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 4194306
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB20_2
# BB#1:                                 # %if.end
	return
.LBB20_2:                                 # %if.then
	call    	abort
	unreachable
.Lfunc_end20:
	.size	f23, .Lfunc_end20-f23

	.globl	f24
	.type	f24,@function
f24:                                    # @f24
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB21_2
	i32.const	$push0=, 16777214
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 8388610
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB21_2
# BB#1:                                 # %if.end
	return
.LBB21_2:                                 # %if.then
	call    	abort
	unreachable
.Lfunc_end21:
	.size	f24, .Lfunc_end21-f24

	.globl	f25
	.type	f25,@function
f25:                                    # @f25
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB22_2
	i32.const	$push0=, 33554430
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 16777218
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB22_2
# BB#1:                                 # %if.end
	return
.LBB22_2:                                 # %if.then
	call    	abort
	unreachable
.Lfunc_end22:
	.size	f25, .Lfunc_end22-f25

	.globl	f26
	.type	f26,@function
f26:                                    # @f26
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB23_2
	i32.const	$push0=, 67108862
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 33554434
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB23_2
# BB#1:                                 # %if.end
	return
.LBB23_2:                                 # %if.then
	call    	abort
	unreachable
.Lfunc_end23:
	.size	f26, .Lfunc_end23-f26

	.globl	f27
	.type	f27,@function
f27:                                    # @f27
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB24_2
	i32.const	$push0=, 134217726
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 67108866
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB24_2
# BB#1:                                 # %if.end
	return
.LBB24_2:                                 # %if.then
	call    	abort
	unreachable
.Lfunc_end24:
	.size	f27, .Lfunc_end24-f27

	.globl	f28
	.type	f28,@function
f28:                                    # @f28
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB25_2
	i32.const	$push0=, 268435454
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 134217730
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB25_2
# BB#1:                                 # %if.end
	return
.LBB25_2:                                 # %if.then
	call    	abort
	unreachable
.Lfunc_end25:
	.size	f28, .Lfunc_end25-f28

	.globl	f29
	.type	f29,@function
f29:                                    # @f29
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB26_2
	i32.const	$push0=, 536870910
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 268435458
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB26_2
# BB#1:                                 # %if.end
	return
.LBB26_2:                                 # %if.then
	call    	abort
	unreachable
.Lfunc_end26:
	.size	f29, .Lfunc_end26-f29

	.globl	f30
	.type	f30,@function
f30:                                    # @f30
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB27_2
	i32.const	$push0=, 1073741822
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 536870914
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB27_2
# BB#1:                                 # %if.end
	return
.LBB27_2:                                 # %if.then
	call    	abort
	unreachable
.Lfunc_end27:
	.size	f30, .Lfunc_end27-f30

	.globl	f31
	.type	f31,@function
f31:                                    # @f31
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB28_2
	i32.const	$push0=, 2147483646
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 1073741826
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB28_2
# BB#1:                                 # %if.end
	return
.LBB28_2:                                 # %if.then
	call    	abort
	unreachable
.Lfunc_end28:
	.size	f31, .Lfunc_end28-f31

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
.Lfunc_end29:
	.size	main, .Lfunc_end29-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
