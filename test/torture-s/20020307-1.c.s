	.text
	.file	"20020307-1.c"
	.section	.text.f3,"ax",@progbits
	.hidden	f3                      # -- Begin function f3
	.globl	f3
	.type	f3,@function
f3:                                     # @f3
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 6
	i32.and 	$push1=, $0, $pop0
	i32.const	$push3=, 6
	i32.eq  	$push2=, $pop1, $pop3
	br_if   	0, $pop2        # 0: down to label0
# %bb.1:                                # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	f3, .Lfunc_end0-f3
                                        # -- End function
	.section	.text.f4,"ax",@progbits
	.hidden	f4                      # -- Begin function f4
	.globl	f4
	.type	f4,@function
f4:                                     # @f4
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 14
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 10
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label1
# %bb.1:                                # %if.end
	return
.LBB1_2:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	f4, .Lfunc_end1-f4
                                        # -- End function
	.section	.text.f5,"ax",@progbits
	.hidden	f5                      # -- Begin function f5
	.globl	f5
	.type	f5,@function
f5:                                     # @f5
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 30
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 18
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label2
# %bb.1:                                # %if.end
	return
.LBB2_2:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	f5, .Lfunc_end2-f5
                                        # -- End function
	.section	.text.f6,"ax",@progbits
	.hidden	f6                      # -- Begin function f6
	.globl	f6
	.type	f6,@function
f6:                                     # @f6
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 62
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 34
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label3
# %bb.1:                                # %if.end
	return
.LBB3_2:                                # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	f6, .Lfunc_end3-f6
                                        # -- End function
	.section	.text.f7,"ax",@progbits
	.hidden	f7                      # -- Begin function f7
	.globl	f7
	.type	f7,@function
f7:                                     # @f7
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 126
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 66
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label4
# %bb.1:                                # %if.end
	return
.LBB4_2:                                # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end4:
	.size	f7, .Lfunc_end4-f7
                                        # -- End function
	.section	.text.f8,"ax",@progbits
	.hidden	f8                      # -- Begin function f8
	.globl	f8
	.type	f8,@function
f8:                                     # @f8
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 254
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 130
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label5
# %bb.1:                                # %if.end
	return
.LBB5_2:                                # %if.then
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end5:
	.size	f8, .Lfunc_end5-f8
                                        # -- End function
	.section	.text.f9,"ax",@progbits
	.hidden	f9                      # -- Begin function f9
	.globl	f9
	.type	f9,@function
f9:                                     # @f9
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 510
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 258
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label6
# %bb.1:                                # %if.end
	return
.LBB6_2:                                # %if.then
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end6:
	.size	f9, .Lfunc_end6-f9
                                        # -- End function
	.section	.text.f10,"ax",@progbits
	.hidden	f10                     # -- Begin function f10
	.globl	f10
	.type	f10,@function
f10:                                    # @f10
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 1022
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 514
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label7
# %bb.1:                                # %if.end
	return
.LBB7_2:                                # %if.then
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end7:
	.size	f10, .Lfunc_end7-f10
                                        # -- End function
	.section	.text.f11,"ax",@progbits
	.hidden	f11                     # -- Begin function f11
	.globl	f11
	.type	f11,@function
f11:                                    # @f11
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 2046
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 1026
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label8
# %bb.1:                                # %if.end
	return
.LBB8_2:                                # %if.then
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end8:
	.size	f11, .Lfunc_end8-f11
                                        # -- End function
	.section	.text.f12,"ax",@progbits
	.hidden	f12                     # -- Begin function f12
	.globl	f12
	.type	f12,@function
f12:                                    # @f12
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 4094
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 2050
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label9
# %bb.1:                                # %if.end
	return
.LBB9_2:                                # %if.then
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end9:
	.size	f12, .Lfunc_end9-f12
                                        # -- End function
	.section	.text.f13,"ax",@progbits
	.hidden	f13                     # -- Begin function f13
	.globl	f13
	.type	f13,@function
f13:                                    # @f13
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 8190
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 4098
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label10
# %bb.1:                                # %if.end
	return
.LBB10_2:                               # %if.then
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end10:
	.size	f13, .Lfunc_end10-f13
                                        # -- End function
	.section	.text.f14,"ax",@progbits
	.hidden	f14                     # -- Begin function f14
	.globl	f14
	.type	f14,@function
f14:                                    # @f14
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 16382
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 8194
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label11
# %bb.1:                                # %if.end
	return
.LBB11_2:                               # %if.then
	end_block                       # label11:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end11:
	.size	f14, .Lfunc_end11-f14
                                        # -- End function
	.section	.text.f15,"ax",@progbits
	.hidden	f15                     # -- Begin function f15
	.globl	f15
	.type	f15,@function
f15:                                    # @f15
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 32766
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 16386
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label12
# %bb.1:                                # %if.end
	return
.LBB12_2:                               # %if.then
	end_block                       # label12:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end12:
	.size	f15, .Lfunc_end12-f15
                                        # -- End function
	.section	.text.f16,"ax",@progbits
	.hidden	f16                     # -- Begin function f16
	.globl	f16
	.type	f16,@function
f16:                                    # @f16
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 65534
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 32770
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label13
# %bb.1:                                # %if.end
	return
.LBB13_2:                               # %if.then
	end_block                       # label13:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end13:
	.size	f16, .Lfunc_end13-f16
                                        # -- End function
	.section	.text.f17,"ax",@progbits
	.hidden	f17                     # -- Begin function f17
	.globl	f17
	.type	f17,@function
f17:                                    # @f17
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 131070
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 65538
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label14
# %bb.1:                                # %if.end
	return
.LBB14_2:                               # %if.then
	end_block                       # label14:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end14:
	.size	f17, .Lfunc_end14-f17
                                        # -- End function
	.section	.text.f18,"ax",@progbits
	.hidden	f18                     # -- Begin function f18
	.globl	f18
	.type	f18,@function
f18:                                    # @f18
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 262142
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 131074
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label15
# %bb.1:                                # %if.end
	return
.LBB15_2:                               # %if.then
	end_block                       # label15:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end15:
	.size	f18, .Lfunc_end15-f18
                                        # -- End function
	.section	.text.f19,"ax",@progbits
	.hidden	f19                     # -- Begin function f19
	.globl	f19
	.type	f19,@function
f19:                                    # @f19
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 524286
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 262146
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label16
# %bb.1:                                # %if.end
	return
.LBB16_2:                               # %if.then
	end_block                       # label16:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end16:
	.size	f19, .Lfunc_end16-f19
                                        # -- End function
	.section	.text.f20,"ax",@progbits
	.hidden	f20                     # -- Begin function f20
	.globl	f20
	.type	f20,@function
f20:                                    # @f20
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 1048574
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 524290
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label17
# %bb.1:                                # %if.end
	return
.LBB17_2:                               # %if.then
	end_block                       # label17:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end17:
	.size	f20, .Lfunc_end17-f20
                                        # -- End function
	.section	.text.f21,"ax",@progbits
	.hidden	f21                     # -- Begin function f21
	.globl	f21
	.type	f21,@function
f21:                                    # @f21
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 2097150
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 1048578
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label18
# %bb.1:                                # %if.end
	return
.LBB18_2:                               # %if.then
	end_block                       # label18:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end18:
	.size	f21, .Lfunc_end18-f21
                                        # -- End function
	.section	.text.f22,"ax",@progbits
	.hidden	f22                     # -- Begin function f22
	.globl	f22
	.type	f22,@function
f22:                                    # @f22
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 4194302
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 2097154
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label19
# %bb.1:                                # %if.end
	return
.LBB19_2:                               # %if.then
	end_block                       # label19:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end19:
	.size	f22, .Lfunc_end19-f22
                                        # -- End function
	.section	.text.f23,"ax",@progbits
	.hidden	f23                     # -- Begin function f23
	.globl	f23
	.type	f23,@function
f23:                                    # @f23
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 8388606
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 4194306
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label20
# %bb.1:                                # %if.end
	return
.LBB20_2:                               # %if.then
	end_block                       # label20:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end20:
	.size	f23, .Lfunc_end20-f23
                                        # -- End function
	.section	.text.f24,"ax",@progbits
	.hidden	f24                     # -- Begin function f24
	.globl	f24
	.type	f24,@function
f24:                                    # @f24
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 16777214
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 8388610
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label21
# %bb.1:                                # %if.end
	return
.LBB21_2:                               # %if.then
	end_block                       # label21:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end21:
	.size	f24, .Lfunc_end21-f24
                                        # -- End function
	.section	.text.f25,"ax",@progbits
	.hidden	f25                     # -- Begin function f25
	.globl	f25
	.type	f25,@function
f25:                                    # @f25
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 33554430
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 16777218
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label22
# %bb.1:                                # %if.end
	return
.LBB22_2:                               # %if.then
	end_block                       # label22:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end22:
	.size	f25, .Lfunc_end22-f25
                                        # -- End function
	.section	.text.f26,"ax",@progbits
	.hidden	f26                     # -- Begin function f26
	.globl	f26
	.type	f26,@function
f26:                                    # @f26
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 67108862
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 33554434
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label23
# %bb.1:                                # %if.end
	return
.LBB23_2:                               # %if.then
	end_block                       # label23:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end23:
	.size	f26, .Lfunc_end23-f26
                                        # -- End function
	.section	.text.f27,"ax",@progbits
	.hidden	f27                     # -- Begin function f27
	.globl	f27
	.type	f27,@function
f27:                                    # @f27
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 134217726
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 67108866
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label24
# %bb.1:                                # %if.end
	return
.LBB24_2:                               # %if.then
	end_block                       # label24:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end24:
	.size	f27, .Lfunc_end24-f27
                                        # -- End function
	.section	.text.f28,"ax",@progbits
	.hidden	f28                     # -- Begin function f28
	.globl	f28
	.type	f28,@function
f28:                                    # @f28
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 268435454
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 134217730
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label25
# %bb.1:                                # %if.end
	return
.LBB25_2:                               # %if.then
	end_block                       # label25:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end25:
	.size	f28, .Lfunc_end25-f28
                                        # -- End function
	.section	.text.f29,"ax",@progbits
	.hidden	f29                     # -- Begin function f29
	.globl	f29
	.type	f29,@function
f29:                                    # @f29
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 536870910
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 268435458
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label26
# %bb.1:                                # %if.end
	return
.LBB26_2:                               # %if.then
	end_block                       # label26:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end26:
	.size	f29, .Lfunc_end26-f29
                                        # -- End function
	.section	.text.f30,"ax",@progbits
	.hidden	f30                     # -- Begin function f30
	.globl	f30
	.type	f30,@function
f30:                                    # @f30
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 1073741822
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 536870914
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label27
# %bb.1:                                # %if.end
	return
.LBB27_2:                               # %if.then
	end_block                       # label27:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end27:
	.size	f30, .Lfunc_end27-f30
                                        # -- End function
	.section	.text.f31,"ax",@progbits
	.hidden	f31                     # -- Begin function f31
	.globl	f31
	.type	f31,@function
f31:                                    # @f31
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 2147483646
	i32.and 	$push1=, $0, $pop0
	i32.const	$push2=, 1073741826
	i32.ge_u	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label28
# %bb.1:                                # %if.end
	return
.LBB28_2:                               # %if.then
	end_block                       # label28:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end28:
	.size	f31, .Lfunc_end28-f31
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end29:
	.size	main, .Lfunc_end29-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
