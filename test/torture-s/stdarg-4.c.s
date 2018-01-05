	.text
	.file	"stdarg-4.c"
	.section	.text.f1i,"ax",@progbits
	.hidden	f1i                     # -- Begin function f1i
	.globl	f1i
	.type	f1i,@function
f1i:                                    # @f1i
	.param  	i32
	.local  	i32, f64, i32
# %bb.0:                                # %entry
	i32.const	$push0=, 7
	i32.add 	$push1=, $0, $pop0
	i32.const	$push15=, -8
	i32.and 	$0=, $pop1, $pop15
	i32.load	$1=, 8($0)
	f64.load	$2=, 0($0)
	block   	
	block   	
	f64.abs 	$push9=, $2
	f64.const	$push10=, 0x1p31
	f64.lt  	$push11=, $pop9, $pop10
	br_if   	0, $pop11       # 0: down to label1
# %bb.1:                                # %entry
	i32.const	$3=, -2147483648
	br      	1               # 1: down to label0
.LBB0_2:                                # %entry
	end_block                       # label1:
	i32.trunc_s/f64	$3=, $2
.LBB0_3:                                # %entry
	end_block                       # label0:
	i32.const	$push4=, 19
	i32.add 	$push5=, $0, $pop4
	i32.const	$push16=, -8
	i32.and 	$push6=, $pop5, $pop16
	f64.load	$push7=, 0($pop6)
	i32.add 	$push2=, $1, $3
	f64.convert_s/i32	$push3=, $pop2
	f64.add 	$2=, $pop7, $pop3
	block   	
	block   	
	f64.abs 	$push12=, $2
	f64.const	$push13=, 0x1p31
	f64.lt  	$push14=, $pop12, $pop13
	br_if   	0, $pop14       # 0: down to label3
# %bb.4:                                # %entry
	i32.const	$0=, -2147483648
	br      	1               # 1: down to label2
.LBB0_5:                                # %entry
	end_block                       # label3:
	i32.trunc_s/f64	$0=, $2
.LBB0_6:                                # %entry
	end_block                       # label2:
	i32.const	$push8=, 0
	i32.store	x($pop8), $0
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	f1i, .Lfunc_end0-f1i
                                        # -- End function
	.section	.text.f1,"ax",@progbits
	.hidden	f1                      # -- Begin function f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32, i32
	.local  	i32, f64, i32
# %bb.0:                                # %entry
	i32.const	$push16=, 0
	i32.load	$push15=, __stack_pointer($pop16)
	i32.const	$push17=, 16
	i32.sub 	$push18=, $pop15, $pop17
	i32.store	12($pop18), $1
	i32.const	$push0=, 7
	i32.add 	$push1=, $1, $pop0
	i32.const	$push19=, -8
	i32.and 	$1=, $pop1, $pop19
	i32.load	$2=, 8($1)
	f64.load	$3=, 0($1)
	block   	
	block   	
	f64.abs 	$push9=, $3
	f64.const	$push10=, 0x1p31
	f64.lt  	$push11=, $pop9, $pop10
	br_if   	0, $pop11       # 0: down to label5
# %bb.1:                                # %entry
	i32.const	$4=, -2147483648
	br      	1               # 1: down to label4
.LBB1_2:                                # %entry
	end_block                       # label5:
	i32.trunc_s/f64	$4=, $3
.LBB1_3:                                # %entry
	end_block                       # label4:
	i32.const	$push4=, 19
	i32.add 	$push5=, $1, $pop4
	i32.const	$push20=, -8
	i32.and 	$push6=, $pop5, $pop20
	f64.load	$push7=, 0($pop6)
	i32.add 	$push2=, $2, $4
	f64.convert_s/i32	$push3=, $pop2
	f64.add 	$3=, $pop7, $pop3
	block   	
	block   	
	f64.abs 	$push12=, $3
	f64.const	$push13=, 0x1p31
	f64.lt  	$push14=, $pop12, $pop13
	br_if   	0, $pop14       # 0: down to label7
# %bb.4:                                # %entry
	i32.const	$1=, -2147483648
	br      	1               # 1: down to label6
.LBB1_5:                                # %entry
	end_block                       # label7:
	i32.trunc_s/f64	$1=, $3
.LBB1_6:                                # %entry
	end_block                       # label6:
	i32.const	$push8=, 0
	i32.store	x($pop8), $1
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	f1, .Lfunc_end1-f1
                                        # -- End function
	.section	.text.f2i,"ax",@progbits
	.hidden	f2i                     # -- Begin function f2i
	.globl	f2i
	.type	f2i,@function
f2i:                                    # @f2i
	.param  	i32
	.local  	i32, f64, i32
# %bb.0:                                # %entry
	i32.const	$push4=, 15
	i32.add 	$push5=, $0, $pop4
	i32.const	$push24=, -8
	i32.and 	$1=, $pop5, $pop24
	f64.load	$push6=, 0($1)
	i32.load	$push1=, 4($0)
	i32.load	$push0=, 0($0)
	i32.add 	$push2=, $pop1, $pop0
	f64.convert_s/i32	$push3=, $pop2
	f64.add 	$2=, $pop6, $pop3
	block   	
	block   	
	f64.abs 	$push13=, $2
	f64.const	$push14=, 0x1p31
	f64.lt  	$push15=, $pop13, $pop14
	br_if   	0, $pop15       # 0: down to label9
# %bb.1:                                # %entry
	i32.const	$0=, -2147483648
	br      	1               # 1: down to label8
.LBB2_2:                                # %entry
	end_block                       # label9:
	i32.trunc_s/f64	$0=, $2
.LBB2_3:                                # %entry
	end_block                       # label8:
	i32.const	$push25=, 0
	i32.store	y($pop25), $0
	i32.load	$0=, 16($1)
	f64.load	$2=, 8($1)
	block   	
	block   	
	f64.abs 	$push16=, $2
	f64.const	$push17=, 0x1p31
	f64.lt  	$push18=, $pop16, $pop17
	br_if   	0, $pop18       # 0: down to label11
# %bb.4:                                # %entry
	i32.const	$3=, -2147483648
	br      	1               # 1: down to label10
.LBB2_5:                                # %entry
	end_block                       # label11:
	i32.trunc_s/f64	$3=, $2
.LBB2_6:                                # %entry
	end_block                       # label10:
	i32.const	$push9=, 27
	i32.add 	$push10=, $1, $pop9
	i32.const	$push26=, -8
	i32.and 	$push11=, $pop10, $pop26
	f64.load	$push12=, 0($pop11)
	i32.add 	$push7=, $0, $3
	f64.convert_s/i32	$push8=, $pop7
	f64.add 	$2=, $pop12, $pop8
	block   	
	f64.abs 	$push19=, $2
	f64.const	$push20=, 0x1p31
	f64.lt  	$push21=, $pop19, $pop20
	br_if   	0, $pop21       # 0: down to label12
# %bb.7:                                # %entry
	i32.const	$push27=, 0
	i32.const	$push22=, -2147483648
	i32.store	x($pop27), $pop22
	return
.LBB2_8:                                # %entry
	end_block                       # label12:
	i32.const	$push28=, 0
	i32.trunc_s/f64	$push23=, $2
	i32.store	x($pop28), $pop23
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	f2i, .Lfunc_end2-f2i
                                        # -- End function
	.section	.text.f2,"ax",@progbits
	.hidden	f2                      # -- Begin function f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.param  	i32, i32
	.local  	i32, f64, i32
# %bb.0:                                # %entry
	i32.const	$push25=, 0
	i32.load	$push24=, __stack_pointer($pop25)
	i32.const	$push26=, 16
	i32.sub 	$push27=, $pop24, $pop26
	i32.store	12($pop27), $1
	i32.const	$push4=, 15
	i32.add 	$push5=, $1, $pop4
	i32.const	$push28=, -8
	i32.and 	$2=, $pop5, $pop28
	f64.load	$push6=, 0($2)
	i32.load	$push1=, 4($1)
	i32.load	$push0=, 0($1)
	i32.add 	$push2=, $pop1, $pop0
	f64.convert_s/i32	$push3=, $pop2
	f64.add 	$3=, $pop6, $pop3
	block   	
	block   	
	f64.abs 	$push13=, $3
	f64.const	$push14=, 0x1p31
	f64.lt  	$push15=, $pop13, $pop14
	br_if   	0, $pop15       # 0: down to label14
# %bb.1:                                # %entry
	i32.const	$1=, -2147483648
	br      	1               # 1: down to label13
.LBB3_2:                                # %entry
	end_block                       # label14:
	i32.trunc_s/f64	$1=, $3
.LBB3_3:                                # %entry
	end_block                       # label13:
	i32.const	$push29=, 0
	i32.store	y($pop29), $1
	i32.load	$1=, 16($2)
	f64.load	$3=, 8($2)
	block   	
	block   	
	f64.abs 	$push16=, $3
	f64.const	$push17=, 0x1p31
	f64.lt  	$push18=, $pop16, $pop17
	br_if   	0, $pop18       # 0: down to label16
# %bb.4:                                # %entry
	i32.const	$4=, -2147483648
	br      	1               # 1: down to label15
.LBB3_5:                                # %entry
	end_block                       # label16:
	i32.trunc_s/f64	$4=, $3
.LBB3_6:                                # %entry
	end_block                       # label15:
	i32.const	$push9=, 27
	i32.add 	$push10=, $2, $pop9
	i32.const	$push30=, -8
	i32.and 	$push11=, $pop10, $pop30
	f64.load	$push12=, 0($pop11)
	i32.add 	$push7=, $1, $4
	f64.convert_s/i32	$push8=, $pop7
	f64.add 	$3=, $pop12, $pop8
	block   	
	f64.abs 	$push19=, $3
	f64.const	$push20=, 0x1p31
	f64.lt  	$push21=, $pop19, $pop20
	br_if   	0, $pop21       # 0: down to label17
# %bb.7:                                # %entry
	i32.const	$push31=, 0
	i32.const	$push22=, -2147483648
	i32.store	x($pop31), $pop22
	return
.LBB3_8:                                # %entry
	end_block                       # label17:
	i32.const	$push32=, 0
	i32.trunc_s/f64	$push23=, $3
	i32.store	x($pop32), $pop23
                                        # fallthrough-return
	.endfunc
.Lfunc_end3:
	.size	f2, .Lfunc_end3-f2
                                        # -- End function
	.section	.text.f3h,"ax",@progbits
	.hidden	f3h                     # -- Begin function f3h
	.globl	f3h
	.type	f3h,@function
f3h:                                    # @f3h
	.param  	i32, i32, i32, i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.add 	$push0=, $1, $0
	i32.add 	$push1=, $pop0, $2
	i32.add 	$push2=, $pop1, $3
	i32.add 	$push3=, $pop2, $4
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end4:
	.size	f3h, .Lfunc_end4-f3h
                                        # -- End function
	.section	.text.f3,"ax",@progbits
	.hidden	f3                      # -- Begin function f3
	.globl	f3
	.type	f3,@function
f3:                                     # @f3
	.param  	i32, i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push33=, 0
	i32.load	$push32=, __stack_pointer($pop33)
	i32.const	$push34=, 16
	i32.sub 	$2=, $pop32, $pop34
	i32.const	$push35=, 0
	i32.store	__stack_pointer($pop35), $2
	i32.store	12($2), $1
	block   	
	i32.const	$push0=, 4
	i32.gt_u	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label18
# %bb.1:                                # %entry
	block   	
	block   	
	block   	
	block   	
	block   	
	br_table 	$0, 4, 0, 2, 3, 1, 4 # 4: down to label19
                                        # 0: down to label23
                                        # 2: down to label21
                                        # 3: down to label20
                                        # 1: down to label22
.LBB5_2:                                # %sw.bb2
	end_block                       # label23:
	i32.load	$0=, 12($2)
	i32.const	$push28=, 4
	i32.add 	$push29=, $0, $pop28
	i32.store	12($2), $pop29
	i32.load	$push30=, 0($0)
	i32.const	$push31=, 1
	i32.add 	$0=, $pop30, $pop31
	br      	3               # 3: down to label19
.LBB5_3:                                # %sw.bb18
	end_block                       # label22:
	i32.load	$0=, 12($2)
	i32.const	$push2=, 4
	i32.add 	$push3=, $0, $pop2
	i32.store	12($2), $pop3
	i32.load	$1=, 0($0)
	i32.const	$push4=, 16
	i32.add 	$push5=, $0, $pop4
	i32.store	12($2), $pop5
	i32.load	$push6=, 4($0)
	i32.add 	$push7=, $1, $pop6
	i32.load	$push8=, 8($0)
	i32.add 	$push9=, $pop7, $pop8
	i32.load	$push10=, 12($0)
	i32.add 	$push11=, $pop9, $pop10
	i32.const	$push39=, 4
	i32.add 	$0=, $pop11, $pop39
	br      	2               # 2: down to label19
.LBB5_4:                                # %sw.bb4
	end_block                       # label21:
	i32.load	$0=, 12($2)
	i32.const	$push21=, 4
	i32.add 	$push22=, $0, $pop21
	i32.store	12($2), $pop22
	i32.load	$1=, 0($0)
	i32.const	$push23=, 8
	i32.add 	$push24=, $0, $pop23
	i32.store	12($2), $pop24
	i32.load	$push25=, 4($0)
	i32.add 	$push26=, $1, $pop25
	i32.const	$push27=, 2
	i32.add 	$0=, $pop26, $pop27
	br      	1               # 1: down to label19
.LBB5_5:                                # %sw.bb10
	end_block                       # label20:
	i32.load	$0=, 12($2)
	i32.const	$push12=, 4
	i32.add 	$push13=, $0, $pop12
	i32.store	12($2), $pop13
	i32.load	$1=, 0($0)
	i32.const	$push14=, 12
	i32.add 	$push15=, $0, $pop14
	i32.store	12($2), $pop15
	i32.load	$push16=, 4($0)
	i32.add 	$push17=, $1, $pop16
	i32.load	$push18=, 8($0)
	i32.add 	$push19=, $pop17, $pop18
	i32.const	$push20=, 3
	i32.add 	$0=, $pop19, $pop20
.LBB5_6:                                # %sw.epilog
	end_block                       # label19:
	i32.const	$push38=, 0
	i32.const	$push36=, 16
	i32.add 	$push37=, $2, $pop36
	i32.store	__stack_pointer($pop38), $pop37
	return  	$0
.LBB5_7:                                # %sw.default
	end_block                       # label18:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end5:
	.size	f3, .Lfunc_end5-f3
                                        # -- End function
	.section	.text.f4,"ax",@progbits
	.hidden	f4                      # -- Begin function f4
	.globl	f4
	.type	f4,@function
f4:                                     # @f4
	.param  	i32, i32
	.local  	f64, i32, i32
# %bb.0:                                # %entry
	i32.const	$push38=, 0
	i32.load	$push37=, __stack_pointer($pop38)
	i32.const	$push39=, 16
	i32.sub 	$4=, $pop37, $pop39
	i32.const	$push40=, 0
	i32.store	__stack_pointer($pop40), $4
	i32.store	12($4), $1
	block   	
	block   	
	block   	
	i32.const	$push0=, 5
	i32.eq  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label26
# %bb.1:                                # %entry
	i32.const	$push2=, 4
	i32.ne  	$push3=, $0, $pop2
	br_if   	2, $pop3        # 2: down to label24
# %bb.2:                                # %sw.bb
	i32.load	$push13=, 12($4)
	i32.const	$push12=, 7
	i32.add 	$push14=, $pop13, $pop12
	i32.const	$push15=, -8
	i32.and 	$1=, $pop14, $pop15
	i32.const	$push16=, 8
	i32.add 	$0=, $1, $pop16
	i32.store	12($4), $0
	f64.load	$2=, 0($1)
	br      	1               # 1: down to label25
.LBB6_3:                                # %sw.bb2
	end_block                       # label26:
	i32.load	$push5=, 12($4)
	i32.const	$push4=, 7
	i32.add 	$push6=, $pop5, $pop4
	i32.const	$push7=, -8
	i32.and 	$1=, $pop6, $pop7
	f64.load	$2=, 0($1)
	block   	
	block   	
	f64.abs 	$push25=, $2
	f64.const	$push26=, 0x1p31
	f64.lt  	$push27=, $pop25, $pop26
	br_if   	0, $pop27       # 0: down to label28
# %bb.4:                                # %sw.bb2
	i32.const	$3=, -2147483648
	br      	1               # 1: down to label27
.LBB6_5:                                # %sw.bb2
	end_block                       # label28:
	i32.trunc_s/f64	$3=, $2
.LBB6_6:                                # %sw.bb2
	end_block                       # label27:
	i32.const	$push8=, 0
	i32.store	y($pop8), $3
	i32.const	$push9=, 16
	i32.add 	$0=, $1, $pop9
	i32.store	12($4), $0
	f64.load	$push10=, 8($1)
	f64.convert_s/i32	$push11=, $3
	f64.add 	$2=, $pop10, $pop11
.LBB6_7:                                # %sw.epilog
	end_block                       # label25:
	block   	
	block   	
	f64.abs 	$push28=, $2
	f64.const	$push29=, 0x1p31
	f64.lt  	$push30=, $pop28, $pop29
	br_if   	0, $pop30       # 0: down to label30
# %bb.8:                                # %sw.epilog
	i32.const	$1=, -2147483648
	br      	1               # 1: down to label29
.LBB6_9:                                # %sw.epilog
	end_block                       # label30:
	i32.trunc_s/f64	$1=, $2
.LBB6_10:                               # %sw.epilog
	end_block                       # label29:
	i32.const	$push45=, 0
	i32.store	y($pop45), $1
	i32.const	$push17=, 7
	i32.add 	$push18=, $0, $pop17
	i32.const	$push44=, -8
	i32.and 	$0=, $pop18, $pop44
	i32.load	$1=, 8($0)
	f64.load	$2=, 0($0)
	block   	
	block   	
	f64.abs 	$push31=, $2
	f64.const	$push32=, 0x1p31
	f64.lt  	$push33=, $pop31, $pop32
	br_if   	0, $pop33       # 0: down to label32
# %bb.11:                               # %sw.epilog
	i32.const	$3=, -2147483648
	br      	1               # 1: down to label31
.LBB6_12:                               # %sw.epilog
	end_block                       # label32:
	i32.trunc_s/f64	$3=, $2
.LBB6_13:                               # %sw.epilog
	end_block                       # label31:
	i32.const	$push21=, 19
	i32.add 	$push22=, $0, $pop21
	i32.const	$push46=, -8
	i32.and 	$push23=, $pop22, $pop46
	f64.load	$push24=, 0($pop23)
	i32.add 	$push19=, $1, $3
	f64.convert_s/i32	$push20=, $pop19
	f64.add 	$2=, $pop24, $pop20
	block   	
	block   	
	f64.abs 	$push34=, $2
	f64.const	$push35=, 0x1p31
	f64.lt  	$push36=, $pop34, $pop35
	br_if   	0, $pop36       # 0: down to label34
# %bb.14:                               # %sw.epilog
	i32.const	$0=, -2147483648
	br      	1               # 1: down to label33
.LBB6_15:                               # %sw.epilog
	end_block                       # label34:
	i32.trunc_s/f64	$0=, $2
.LBB6_16:                               # %sw.epilog
	end_block                       # label33:
	i32.const	$push47=, 0
	i32.store	x($pop47), $0
	i32.const	$push43=, 0
	i32.const	$push41=, 16
	i32.add 	$push42=, $4, $pop41
	i32.store	__stack_pointer($pop43), $pop42
	return
.LBB6_17:                               # %sw.default
	end_block                       # label24:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end6:
	.size	f4, .Lfunc_end6-f4
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push77=, 0
	i32.load	$push76=, __stack_pointer($pop77)
	i32.const	$push78=, 224
	i32.sub 	$0=, $pop76, $pop78
	i32.const	$push79=, 0
	i32.store	__stack_pointer($pop79), $0
	i32.const	$push83=, 192
	i32.add 	$push84=, $0, $pop83
	i32.const	$push104=, 16
	i32.add 	$push0=, $pop84, $pop104
	i64.const	$push1=, 4629700416936869888
	i64.store	0($pop0), $pop1
	i32.const	$push2=, 128
	i32.store	200($0), $pop2
	i64.const	$push3=, 4625196817309499392
	i64.store	192($0), $pop3
	i32.const	$push85=, 192
	i32.add 	$push86=, $0, $pop85
	call    	f1@FUNCTION, $0, $pop86
	block   	
	i32.const	$push103=, 0
	i32.load	$push4=, x($pop103)
	i32.const	$push5=, 176
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label35
# %bb.1:                                # %if.end
	i32.const	$push8=, 176
	i32.add 	$push9=, $0, $pop8
	i64.const	$push10=, 4634204016564240384
	i64.store	0($pop9), $pop10
	i32.const	$push11=, 168
	i32.add 	$push12=, $0, $pop11
	i32.const	$push13=, 17
	i32.store	0($pop12), $pop13
	i32.const	$push87=, 144
	i32.add 	$push88=, $0, $pop87
	i32.const	$push106=, 16
	i32.add 	$push14=, $pop88, $pop106
	i64.const	$push15=, 4626041242239631360
	i64.store	0($pop14), $pop15
	i64.const	$push16=, 4625759767262920704
	i64.store	152($0), $pop16
	i64.const	$push17=, 30064771077
	i64.store	144($0), $pop17
	i32.const	$push89=, 144
	i32.add 	$push90=, $0, $pop89
	call    	f2@FUNCTION, $0, $pop90
	i32.const	$push105=, 0
	i32.load	$push18=, x($pop105)
	i32.const	$push19=, 100
	i32.ne  	$push20=, $pop18, $pop19
	br_if   	0, $pop20       # 0: down to label35
# %bb.2:                                # %if.end
	i32.const	$push107=, 0
	i32.load	$push7=, y($pop107)
	i32.const	$push21=, 30
	i32.ne  	$push22=, $pop7, $pop21
	br_if   	0, $pop22       # 0: down to label35
# %bb.3:                                # %if.end4
	i32.const	$push23=, 0
	i32.const	$push108=, 0
	i32.call	$push24=, f3@FUNCTION, $pop23, $pop108
	br_if   	0, $pop24       # 0: down to label35
# %bb.4:                                # %if.end7
	i32.const	$push25=, 18
	i32.store	128($0), $pop25
	i32.const	$push26=, 1
	i32.const	$push91=, 128
	i32.add 	$push92=, $0, $pop91
	i32.call	$push27=, f3@FUNCTION, $pop26, $pop92
	i32.const	$push28=, 19
	i32.ne  	$push29=, $pop27, $pop28
	br_if   	0, $pop29       # 0: down to label35
# %bb.5:                                # %if.end11
	i64.const	$push109=, 429496729618
	i64.store	112($0), $pop109
	i32.const	$push30=, 2
	i32.const	$push93=, 112
	i32.add 	$push94=, $0, $pop93
	i32.call	$push31=, f3@FUNCTION, $pop30, $pop94
	i32.const	$push32=, 120
	i32.ne  	$push33=, $pop31, $pop32
	br_if   	0, $pop33       # 0: down to label35
# %bb.6:                                # %if.end15
	i32.const	$push34=, 300
	i32.store	104($0), $pop34
	i64.const	$push110=, 429496729618
	i64.store	96($0), $pop110
	i32.const	$push35=, 3
	i32.const	$push95=, 96
	i32.add 	$push96=, $0, $pop95
	i32.call	$push36=, f3@FUNCTION, $pop35, $pop96
	i32.const	$push37=, 421
	i32.ne  	$push38=, $pop36, $pop37
	br_if   	0, $pop38       # 0: down to label35
# %bb.7:                                # %if.end19
	i64.const	$push39=, 369367187520
	i64.store	88($0), $pop39
	i64.const	$push40=, 304942678034
	i64.store	80($0), $pop40
	i32.const	$push111=, 4
	i32.const	$push97=, 80
	i32.add 	$push98=, $0, $pop97
	i32.call	$push41=, f3@FUNCTION, $pop111, $pop98
	i32.const	$push42=, 243
	i32.ne  	$push43=, $pop41, $pop42
	br_if   	0, $pop43       # 0: down to label35
# %bb.8:                                # %if.end23
	i32.const	$push45=, 72
	i32.add 	$push46=, $0, $pop45
	i64.const	$push47=, 4625759767262920704
	i64.store	0($pop46), $pop47
	i32.const	$push99=, 48
	i32.add 	$push100=, $0, $pop99
	i32.const	$push48=, 16
	i32.add 	$push49=, $pop100, $pop48
	i32.const	$push114=, 16
	i32.store	0($pop49), $pop114
	i64.const	$push50=, 4621256167635550208
	i64.store	56($0), $pop50
	i64.const	$push51=, 4618441417868443648
	i64.store	48($0), $pop51
	i32.const	$push113=, 4
	i32.const	$push101=, 48
	i32.add 	$push102=, $0, $pop101
	call    	f4@FUNCTION, $pop113, $pop102
	i32.const	$push112=, 0
	i32.load	$push52=, x($pop112)
	i32.const	$push53=, 43
	i32.ne  	$push54=, $pop52, $pop53
	br_if   	0, $pop54       # 0: down to label35
# %bb.9:                                # %if.end23
	i32.const	$push115=, 0
	i32.load	$push44=, y($pop115)
	i32.const	$push55=, 6
	i32.ne  	$push56=, $pop44, $pop55
	br_if   	0, $pop56       # 0: down to label35
# %bb.10:                               # %if.end28
	i32.const	$push58=, 32
	i32.add 	$push59=, $0, $pop58
	i64.const	$push60=, 4638566878703255552
	i64.store	0($pop59), $pop60
	i32.const	$push61=, 24
	i32.add 	$push62=, $0, $pop61
	i32.const	$push63=, 17
	i32.store	0($pop62), $pop63
	i32.const	$push64=, 16
	i32.add 	$push65=, $0, $pop64
	i64.const	$push66=, 4607182418800017408
	i64.store	0($pop65), $pop66
	i64.const	$push67=, 4626604192193052672
	i64.store	8($0), $pop67
	i64.const	$push68=, 4619567317775286272
	i64.store	0($0), $pop68
	i32.const	$push69=, 5
	call    	f4@FUNCTION, $pop69, $0
	i32.const	$push116=, 0
	i32.load	$push70=, x($pop116)
	i32.const	$push71=, 144
	i32.ne  	$push72=, $pop70, $pop71
	br_if   	0, $pop72       # 0: down to label35
# %bb.11:                               # %if.end28
	i32.const	$push117=, 0
	i32.load	$push57=, y($pop117)
	i32.const	$push73=, 28
	i32.ne  	$push74=, $pop57, $pop73
	br_if   	0, $pop74       # 0: down to label35
# %bb.12:                               # %if.end33
	i32.const	$push82=, 0
	i32.const	$push80=, 224
	i32.add 	$push81=, $0, $pop80
	i32.store	__stack_pointer($pop82), $pop81
	i32.const	$push75=, 0
	return  	$pop75
.LBB7_13:                               # %if.then
	end_block                       # label35:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end7:
	.size	main, .Lfunc_end7-main
                                        # -- End function
	.hidden	x                       # @x
	.type	x,@object
	.section	.bss.x,"aw",@nobits
	.globl	x
	.p2align	2
x:
	.int32	0                       # 0x0
	.size	x, 4

	.hidden	y                       # @y
	.type	y,@object
	.section	.bss.y,"aw",@nobits
	.globl	y
	.p2align	2
y:
	.int32	0                       # 0x0
	.size	y, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
