	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/stdarg-4.c"
	.section	.text.f1i,"ax",@progbits
	.hidden	f1i
	.globl	f1i
	.type	f1i,@function
f1i:                                    # @f1i
	.param  	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 16
	i32.sub 	$6=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$6=, 0($4), $6
	i32.store	$push0=, 12($6), $0
	i32.const	$push1=, 7
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -8
	i32.and 	$push4=, $pop2, $pop3
	tee_local	$push28=, $0=, $pop4
	i32.const	$push5=, 8
	i32.add 	$push6=, $pop28, $pop5
	i32.store	$discard=, 12($6), $pop6
	f64.load	$push7=, 0($0)
	i32.trunc_s/f64	$1=, $pop7
	i32.const	$push8=, 11
	i32.add 	$push9=, $0, $pop8
	i32.const	$push10=, -4
	i32.and 	$push11=, $pop9, $pop10
	tee_local	$push27=, $0=, $pop11
	i32.const	$push12=, 4
	i32.add 	$push13=, $pop27, $pop12
	i32.store	$discard=, 12($6), $pop13
	i32.load	$2=, 0($0)
	i32.const	$push26=, 11
	i32.add 	$push15=, $0, $pop26
	i32.const	$push25=, -8
	i32.and 	$push16=, $pop15, $pop25
	tee_local	$push24=, $0=, $pop16
	i32.const	$push23=, 8
	i32.add 	$push17=, $pop24, $pop23
	i32.store	$discard=, 12($6), $pop17
	i32.const	$push22=, 0
	i32.add 	$push14=, $2, $1
	f64.convert_s/i32	$push19=, $pop14
	f64.load	$push18=, 0($0)
	f64.add 	$push20=, $pop19, $pop18
	i32.trunc_s/f64	$push21=, $pop20
	i32.store	$discard=, x($pop22), $pop21
	i32.const	$5=, 16
	i32.add 	$6=, $6, $5
	i32.const	$5=, __stack_pointer
	i32.store	$6=, 0($5), $6
	return
	.endfunc
.Lfunc_end0:
	.size	f1i, .Lfunc_end0-f1i

	.section	.text.f1,"ax",@progbits
	.hidden	f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32, i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 16
	i32.sub 	$7=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$7=, 0($5), $7
	i32.store	$push0=, 8($7), $1
	i32.store	$push1=, 12($7), $pop0
	i32.const	$push2=, 7
	i32.add 	$push3=, $pop1, $pop2
	i32.const	$push4=, -8
	i32.and 	$push5=, $pop3, $pop4
	tee_local	$push29=, $1=, $pop5
	i32.const	$push6=, 8
	i32.add 	$push7=, $pop29, $pop6
	i32.store	$discard=, 12($7), $pop7
	f64.load	$push8=, 0($1)
	i32.trunc_s/f64	$2=, $pop8
	i32.const	$push9=, 11
	i32.add 	$push10=, $1, $pop9
	i32.const	$push11=, -4
	i32.and 	$push12=, $pop10, $pop11
	tee_local	$push28=, $1=, $pop12
	i32.const	$push13=, 4
	i32.add 	$push14=, $pop28, $pop13
	i32.store	$discard=, 12($7), $pop14
	i32.load	$3=, 0($1)
	i32.const	$push27=, 11
	i32.add 	$push16=, $1, $pop27
	i32.const	$push26=, -8
	i32.and 	$push17=, $pop16, $pop26
	tee_local	$push25=, $1=, $pop17
	i32.const	$push24=, 8
	i32.add 	$push18=, $pop25, $pop24
	i32.store	$discard=, 12($7), $pop18
	i32.const	$push23=, 0
	f64.load	$push19=, 0($1)
	i32.add 	$push15=, $3, $2
	f64.convert_s/i32	$push20=, $pop15
	f64.add 	$push21=, $pop19, $pop20
	i32.trunc_s/f64	$push22=, $pop21
	i32.store	$discard=, x($pop23), $pop22
	i32.const	$6=, 16
	i32.add 	$7=, $7, $6
	i32.const	$6=, __stack_pointer
	i32.store	$7=, 0($6), $7
	return
	.endfunc
.Lfunc_end1:
	.size	f1, .Lfunc_end1-f1

	.section	.text.f2i,"ax",@progbits
	.hidden	f2i
	.globl	f2i
	.type	f2i,@function
f2i:                                    # @f2i
	.param  	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 16
	i32.sub 	$7=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$7=, 0($5), $7
	i32.store	$push0=, 8($7), $0
	i32.const	$push1=, 3
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -4
	i32.and 	$push4=, $pop2, $pop3
	tee_local	$push55=, $0=, $pop4
	i32.const	$push5=, 4
	i32.add 	$push6=, $pop55, $pop5
	i32.store	$discard=, 8($7), $pop6
	i32.load	$1=, 0($0)
	i32.const	$push7=, 7
	i32.add 	$push8=, $0, $pop7
	i32.const	$push54=, -4
	i32.and 	$push9=, $pop8, $pop54
	tee_local	$push53=, $0=, $pop9
	i32.const	$push52=, 4
	i32.add 	$push10=, $pop53, $pop52
	i32.store	$discard=, 8($7), $pop10
	i32.load	$2=, 0($0)
	i32.const	$push12=, 11
	i32.add 	$push13=, $0, $pop12
	i32.const	$push14=, -8
	i32.and 	$push15=, $pop13, $pop14
	tee_local	$push51=, $0=, $pop15
	i32.const	$push16=, 8
	i32.add 	$push17=, $pop51, $pop16
	i32.store	$3=, 8($7), $pop17
	i32.const	$push22=, 0
	i32.add 	$push11=, $2, $1
	f64.convert_s/i32	$push19=, $pop11
	f64.load	$push18=, 0($0)
	f64.add 	$push20=, $pop19, $pop18
	i32.trunc_s/f64	$push21=, $pop20
	i32.store	$discard=, y($pop22), $pop21
	i32.store	$discard=, 12($7), $3
	i32.const	$push23=, 15
	i32.add 	$push24=, $0, $pop23
	i32.const	$push50=, -8
	i32.and 	$push25=, $pop24, $pop50
	tee_local	$push49=, $0=, $pop25
	i32.const	$push48=, 8
	i32.add 	$push26=, $pop49, $pop48
	i32.store	$discard=, 12($7), $pop26
	f64.load	$push27=, 0($0)
	i32.trunc_s/f64	$1=, $pop27
	i32.const	$push47=, 11
	i32.add 	$push28=, $0, $pop47
	i32.const	$push46=, -4
	i32.and 	$push29=, $pop28, $pop46
	tee_local	$push45=, $0=, $pop29
	i32.const	$push44=, 4
	i32.add 	$push30=, $pop45, $pop44
	i32.store	$discard=, 12($7), $pop30
	i32.load	$2=, 0($0)
	i32.const	$push43=, 11
	i32.add 	$push32=, $0, $pop43
	i32.const	$push42=, -8
	i32.and 	$push33=, $pop32, $pop42
	tee_local	$push41=, $0=, $pop33
	i32.const	$push40=, 8
	i32.add 	$push34=, $pop41, $pop40
	i32.store	$discard=, 12($7), $pop34
	i32.const	$push39=, 0
	f64.load	$push35=, 0($0)
	i32.add 	$push31=, $2, $1
	f64.convert_s/i32	$push36=, $pop31
	f64.add 	$push37=, $pop35, $pop36
	i32.trunc_s/f64	$push38=, $pop37
	i32.store	$discard=, x($pop39), $pop38
	i32.const	$6=, 16
	i32.add 	$7=, $7, $6
	i32.const	$6=, __stack_pointer
	i32.store	$7=, 0($6), $7
	return
	.endfunc
.Lfunc_end2:
	.size	f2i, .Lfunc_end2-f2i

	.section	.text.f2,"ax",@progbits
	.hidden	f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.param  	i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 16
	i32.sub 	$8=, $5, $6
	i32.const	$6=, __stack_pointer
	i32.store	$8=, 0($6), $8
	i32.store	$push0=, 4($8), $1
	i32.store	$push1=, 8($8), $pop0
	i32.const	$push2=, 3
	i32.add 	$push3=, $pop1, $pop2
	i32.const	$push4=, -4
	i32.and 	$push5=, $pop3, $pop4
	tee_local	$push56=, $1=, $pop5
	i32.const	$push6=, 4
	i32.add 	$push7=, $pop56, $pop6
	i32.store	$discard=, 8($8), $pop7
	i32.load	$2=, 0($1)
	i32.const	$push8=, 7
	i32.add 	$push9=, $1, $pop8
	i32.const	$push55=, -4
	i32.and 	$push10=, $pop9, $pop55
	tee_local	$push54=, $1=, $pop10
	i32.const	$push53=, 4
	i32.add 	$push11=, $pop54, $pop53
	i32.store	$discard=, 8($8), $pop11
	i32.load	$3=, 0($1)
	i32.const	$push13=, 11
	i32.add 	$push14=, $1, $pop13
	i32.const	$push15=, -8
	i32.and 	$push16=, $pop14, $pop15
	tee_local	$push52=, $1=, $pop16
	i32.const	$push17=, 8
	i32.add 	$push18=, $pop52, $pop17
	i32.store	$4=, 8($8), $pop18
	i32.const	$push23=, 0
	f64.load	$push19=, 0($1)
	i32.add 	$push12=, $3, $2
	f64.convert_s/i32	$push20=, $pop12
	f64.add 	$push21=, $pop19, $pop20
	i32.trunc_s/f64	$push22=, $pop21
	i32.store	$discard=, y($pop23), $pop22
	i32.store	$discard=, 12($8), $4
	i32.const	$push24=, 15
	i32.add 	$push25=, $1, $pop24
	i32.const	$push51=, -8
	i32.and 	$push26=, $pop25, $pop51
	tee_local	$push50=, $1=, $pop26
	i32.const	$push49=, 8
	i32.add 	$push27=, $pop50, $pop49
	i32.store	$discard=, 12($8), $pop27
	f64.load	$push28=, 0($1)
	i32.trunc_s/f64	$2=, $pop28
	i32.const	$push48=, 11
	i32.add 	$push29=, $1, $pop48
	i32.const	$push47=, -4
	i32.and 	$push30=, $pop29, $pop47
	tee_local	$push46=, $1=, $pop30
	i32.const	$push45=, 4
	i32.add 	$push31=, $pop46, $pop45
	i32.store	$discard=, 12($8), $pop31
	i32.load	$3=, 0($1)
	i32.const	$push44=, 11
	i32.add 	$push33=, $1, $pop44
	i32.const	$push43=, -8
	i32.and 	$push34=, $pop33, $pop43
	tee_local	$push42=, $1=, $pop34
	i32.const	$push41=, 8
	i32.add 	$push35=, $pop42, $pop41
	i32.store	$discard=, 12($8), $pop35
	i32.const	$push40=, 0
	f64.load	$push36=, 0($1)
	i32.add 	$push32=, $3, $2
	f64.convert_s/i32	$push37=, $pop32
	f64.add 	$push38=, $pop36, $pop37
	i32.trunc_s/f64	$push39=, $pop38
	i32.store	$discard=, x($pop40), $pop39
	i32.const	$7=, 16
	i32.add 	$8=, $8, $7
	i32.const	$7=, __stack_pointer
	i32.store	$8=, 0($7), $8
	return
	.endfunc
.Lfunc_end3:
	.size	f2, .Lfunc_end3-f2

	.section	.text.f3h,"ax",@progbits
	.hidden	f3h
	.globl	f3h
	.type	f3h,@function
f3h:                                    # @f3h
	.param  	i32, i32, i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.add 	$push0=, $1, $0
	i32.add 	$push1=, $pop0, $2
	i32.add 	$push2=, $pop1, $3
	i32.add 	$push3=, $pop2, $4
	return  	$pop3
	.endfunc
.Lfunc_end4:
	.size	f3h, .Lfunc_end4-f3h

	.section	.text.f3,"ax",@progbits
	.hidden	f3
	.globl	f3
	.type	f3,@function
f3:                                     # @f3
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 16
	i32.sub 	$7=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$7=, 0($5), $7
	i32.store	$discard=, 12($7), $1
	block
	i32.const	$push0=, 4
	i32.gt_u	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$1=, 0
	block
	block
	block
	block
	block
	tableswitch	$0, 4, 4, 0, 1, 2, 3 # 4: down to label1
                                        # 0: down to label5
                                        # 1: down to label4
                                        # 2: down to label3
                                        # 3: down to label2
.LBB5_2:                                # %sw.bb2
	end_block                       # label5:
	i32.load	$push54=, 12($7)
	i32.const	$push55=, 3
	i32.add 	$push56=, $pop54, $pop55
	i32.const	$push57=, -4
	i32.and 	$push58=, $pop56, $pop57
	tee_local	$push63=, $0=, $pop58
	i32.const	$push59=, 4
	i32.add 	$push60=, $pop63, $pop59
	i32.store	$discard=, 12($7), $pop60
	i32.load	$push61=, 0($0)
	i32.const	$push62=, 1
	i32.add 	$1=, $pop61, $pop62
	br      	3               # 3: down to label1
.LBB5_3:                                # %sw.bb4
	end_block                       # label4:
	i32.load	$push40=, 12($7)
	i32.const	$push41=, 3
	i32.add 	$push42=, $pop40, $pop41
	i32.const	$push43=, -4
	i32.and 	$push44=, $pop42, $pop43
	tee_local	$push67=, $0=, $pop44
	i32.const	$push45=, 4
	i32.add 	$push46=, $pop67, $pop45
	i32.store	$discard=, 12($7), $pop46
	i32.load	$1=, 0($0)
	i32.const	$push47=, 7
	i32.add 	$push48=, $0, $pop47
	i32.const	$push66=, -4
	i32.and 	$push49=, $pop48, $pop66
	tee_local	$push65=, $0=, $pop49
	i32.const	$push64=, 4
	i32.add 	$push50=, $pop65, $pop64
	i32.store	$discard=, 12($7), $pop50
	i32.load	$push51=, 0($0)
	i32.add 	$push52=, $1, $pop51
	i32.const	$push53=, 2
	i32.add 	$1=, $pop52, $pop53
	br      	2               # 2: down to label1
.LBB5_4:                                # %sw.bb6
	end_block                       # label3:
	i32.load	$push23=, 12($7)
	i32.const	$push24=, 3
	i32.add 	$push25=, $pop23, $pop24
	i32.const	$push26=, -4
	i32.and 	$push27=, $pop25, $pop26
	tee_local	$push76=, $0=, $pop27
	i32.const	$push28=, 4
	i32.add 	$push29=, $pop76, $pop28
	i32.store	$discard=, 12($7), $pop29
	i32.load	$1=, 0($0)
	i32.const	$push30=, 7
	i32.add 	$push31=, $0, $pop30
	i32.const	$push75=, -4
	i32.and 	$push32=, $pop31, $pop75
	tee_local	$push74=, $0=, $pop32
	i32.const	$push73=, 4
	i32.add 	$push33=, $pop74, $pop73
	i32.store	$discard=, 12($7), $pop33
	i32.load	$2=, 0($0)
	i32.const	$push72=, 7
	i32.add 	$push34=, $0, $pop72
	i32.const	$push71=, -4
	i32.and 	$push35=, $pop34, $pop71
	tee_local	$push70=, $0=, $pop35
	i32.const	$push69=, 4
	i32.add 	$push36=, $pop70, $pop69
	i32.store	$discard=, 12($7), $pop36
	i32.add 	$push38=, $1, $2
	i32.load	$push37=, 0($0)
	i32.add 	$push39=, $pop38, $pop37
	i32.const	$push68=, 3
	i32.add 	$1=, $pop39, $pop68
	br      	1               # 1: down to label1
.LBB5_5:                                # %sw.bb8
	end_block                       # label2:
	i32.load	$push2=, 12($7)
	i32.const	$push3=, 3
	i32.add 	$push4=, $pop2, $pop3
	i32.const	$push5=, -4
	i32.and 	$push6=, $pop4, $pop5
	tee_local	$push89=, $0=, $pop6
	i32.const	$push7=, 4
	i32.add 	$push8=, $pop89, $pop7
	i32.store	$discard=, 12($7), $pop8
	i32.load	$1=, 0($0)
	i32.const	$push9=, 7
	i32.add 	$push10=, $0, $pop9
	i32.const	$push88=, -4
	i32.and 	$push11=, $pop10, $pop88
	tee_local	$push87=, $0=, $pop11
	i32.const	$push86=, 4
	i32.add 	$push12=, $pop87, $pop86
	i32.store	$discard=, 12($7), $pop12
	i32.load	$2=, 0($0)
	i32.const	$push85=, 7
	i32.add 	$push13=, $0, $pop85
	i32.const	$push84=, -4
	i32.and 	$push14=, $pop13, $pop84
	tee_local	$push83=, $0=, $pop14
	i32.const	$push82=, 4
	i32.add 	$push15=, $pop83, $pop82
	i32.store	$discard=, 12($7), $pop15
	i32.load	$3=, 0($0)
	i32.const	$push81=, 7
	i32.add 	$push16=, $0, $pop81
	i32.const	$push80=, -4
	i32.and 	$push17=, $pop16, $pop80
	tee_local	$push79=, $0=, $pop17
	i32.const	$push78=, 4
	i32.add 	$push18=, $pop79, $pop78
	i32.store	$discard=, 12($7), $pop18
	i32.add 	$push20=, $1, $2
	i32.add 	$push21=, $3, $pop20
	i32.load	$push19=, 0($0)
	i32.add 	$push22=, $pop21, $pop19
	i32.const	$push77=, 4
	i32.add 	$1=, $pop22, $pop77
.LBB5_6:                                # %sw.epilog
	end_block                       # label1:
	i32.const	$6=, 16
	i32.add 	$7=, $7, $6
	i32.const	$6=, __stack_pointer
	i32.store	$7=, 0($6), $7
	return  	$1
.LBB5_7:                                # %sw.default
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end5:
	.size	f3, .Lfunc_end5-f3

	.section	.text.f4,"ax",@progbits
	.hidden	f4
	.globl	f4
	.type	f4,@function
f4:                                     # @f4
	.param  	i32, i32
	.local  	i32, f64, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 16
	i32.sub 	$7=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$7=, 0($5), $7
	i32.store	$discard=, 8($7), $1
	block
	block
	i32.const	$push0=, 5
	i32.eq  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label7
# BB#1:                                 # %entry
	block
	i32.const	$push2=, 4
	i32.ne  	$push3=, $0, $pop2
	br_if   	0, $pop3        # 0: down to label8
# BB#2:                                 # %sw.bb
	i32.load	$push20=, 8($7)
	i32.const	$push21=, 7
	i32.add 	$push22=, $pop20, $pop21
	i32.const	$push23=, -8
	i32.and 	$push24=, $pop22, $pop23
	tee_local	$push51=, $0=, $pop24
	i32.const	$push25=, 8
	i32.add 	$push26=, $pop51, $pop25
	i32.store	$discard=, 8($7), $pop26
	f64.load	$3=, 0($0)
	br      	2               # 2: down to label6
.LBB6_3:                                # %sw.default
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB6_4:                                # %sw.bb2
	end_block                       # label7:
	i32.load	$push4=, 8($7)
	i32.const	$push5=, 7
	i32.add 	$push6=, $pop4, $pop5
	i32.const	$push7=, -8
	i32.and 	$push8=, $pop6, $pop7
	tee_local	$push55=, $0=, $pop8
	i32.const	$push9=, 8
	i32.add 	$push10=, $pop55, $pop9
	i32.store	$discard=, 8($7), $pop10
	i32.const	$push13=, 0
	f64.load	$push11=, 0($0)
	i32.trunc_s/f64	$push12=, $pop11
	i32.store	$1=, y($pop13), $pop12
	i32.const	$push14=, 15
	i32.add 	$push15=, $0, $pop14
	i32.const	$push54=, -8
	i32.and 	$push16=, $pop15, $pop54
	tee_local	$push53=, $0=, $pop16
	i32.const	$push52=, 8
	i32.add 	$push17=, $pop53, $pop52
	i32.store	$discard=, 8($7), $pop17
	f64.convert_s/i32	$push19=, $1
	f64.load	$push18=, 0($0)
	f64.add 	$3=, $pop19, $pop18
.LBB6_5:                                # %sw.epilog
	end_block                       # label6:
	i32.load	$0=, 8($7)
	i32.const	$push28=, 0
	i32.trunc_s/f64	$push27=, $3
	i32.store	$discard=, y($pop28), $pop27
	i32.store	$push29=, 12($7), $0
	i32.const	$push30=, 7
	i32.add 	$push31=, $pop29, $pop30
	i32.const	$push32=, -8
	i32.and 	$push33=, $pop31, $pop32
	tee_local	$push62=, $0=, $pop33
	i32.const	$push34=, 8
	i32.add 	$push35=, $pop62, $pop34
	i32.store	$discard=, 12($7), $pop35
	f64.load	$push36=, 0($0)
	i32.trunc_s/f64	$1=, $pop36
	i32.const	$push37=, 11
	i32.add 	$push38=, $0, $pop37
	i32.const	$push39=, -4
	i32.and 	$push40=, $pop38, $pop39
	tee_local	$push61=, $0=, $pop40
	i32.const	$push41=, 4
	i32.add 	$push42=, $pop61, $pop41
	i32.store	$discard=, 12($7), $pop42
	i32.load	$2=, 0($0)
	i32.const	$push60=, 11
	i32.add 	$push44=, $0, $pop60
	i32.const	$push59=, -8
	i32.and 	$push45=, $pop44, $pop59
	tee_local	$push58=, $0=, $pop45
	i32.const	$push57=, 8
	i32.add 	$push46=, $pop58, $pop57
	i32.store	$discard=, 12($7), $pop46
	i32.const	$push56=, 0
	f64.load	$push47=, 0($0)
	i32.add 	$push43=, $2, $1
	f64.convert_s/i32	$push48=, $pop43
	f64.add 	$push49=, $pop47, $pop48
	i32.trunc_s/f64	$push50=, $pop49
	i32.store	$discard=, x($pop56), $pop50
	i32.const	$6=, 16
	i32.add 	$7=, $7, $6
	i32.const	$6=, __stack_pointer
	i32.store	$7=, 0($6), $7
	return
	.endfunc
.Lfunc_end6:
	.size	f4, .Lfunc_end6-f4

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 224
	i32.sub 	$23=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$23=, 0($3), $23
	i32.const	$push87=, 16
	i32.const	$5=, 192
	i32.add 	$5=, $23, $5
	i32.add 	$push0=, $5, $pop87
	i64.const	$push1=, 4629700416936869888
	i64.store	$discard=, 0($pop0):p2align=4, $pop1
	i32.const	$push86=, 8
	i32.const	$6=, 192
	i32.add 	$6=, $23, $6
	i32.or  	$push2=, $6, $pop86
	i32.const	$push3=, 128
	i32.store	$discard=, 0($pop2):p2align=3, $pop3
	i64.const	$push4=, 4625196817309499392
	i64.store	$discard=, 192($23):p2align=4, $pop4
	i32.const	$7=, 192
	i32.add 	$7=, $23, $7
	call    	f1@FUNCTION, $0, $7
	block
	i32.const	$push85=, 0
	i32.load	$push5=, x($pop85)
	i32.const	$push6=, 176
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label9
# BB#1:                                 # %if.end
	i32.const	$push9=, 32
	i32.const	$8=, 144
	i32.add 	$8=, $23, $8
	i32.add 	$push10=, $8, $pop9
	i64.const	$push11=, 4634204016564240384
	i64.store	$discard=, 0($pop10):p2align=4, $pop11
	i32.const	$push12=, 24
	i32.const	$9=, 144
	i32.add 	$9=, $23, $9
	i32.add 	$push13=, $9, $pop12
	i32.const	$push14=, 17
	i32.store	$discard=, 0($pop13):p2align=3, $pop14
	i32.const	$push90=, 16
	i32.const	$10=, 144
	i32.add 	$10=, $23, $10
	i32.add 	$push15=, $10, $pop90
	i64.const	$push16=, 4626041242239631360
	i64.store	$discard=, 0($pop15):p2align=4, $pop16
	i32.const	$push89=, 8
	i32.const	$11=, 144
	i32.add 	$11=, $23, $11
	i32.or  	$push17=, $11, $pop89
	i64.const	$push18=, 4625759767262920704
	i64.store	$discard=, 0($pop17), $pop18
	i64.const	$push19=, 30064771077
	i64.store	$discard=, 144($23):p2align=4, $pop19
	i32.const	$12=, 144
	i32.add 	$12=, $23, $12
	call    	f2@FUNCTION, $0, $12
	block
	i32.const	$push88=, 0
	i32.load	$push20=, x($pop88)
	i32.const	$push21=, 100
	i32.ne  	$push22=, $pop20, $pop21
	br_if   	0, $pop22       # 0: down to label10
# BB#2:                                 # %if.end
	i32.const	$push91=, 0
	i32.load	$push8=, y($pop91)
	i32.const	$push23=, 30
	i32.ne  	$push24=, $pop8, $pop23
	br_if   	0, $pop24       # 0: down to label10
# BB#3:                                 # %if.end4
	block
	i32.const	$push25=, 0
	i32.const	$push92=, 0
	i32.call	$push26=, f3@FUNCTION, $pop25, $pop92
	br_if   	0, $pop26       # 0: down to label11
# BB#4:                                 # %if.end7
	i32.const	$push27=, 18
	i32.store	$discard=, 128($23):p2align=4, $pop27
	i32.const	$push28=, 1
	i32.const	$13=, 128
	i32.add 	$13=, $23, $13
	block
	i32.call	$push29=, f3@FUNCTION, $pop28, $13
	i32.const	$push30=, 19
	i32.ne  	$push31=, $pop29, $pop30
	br_if   	0, $pop31       # 0: down to label12
# BB#5:                                 # %if.end11
	i64.const	$push32=, 429496729618
	i64.store	$1=, 112($23):p2align=4, $pop32
	i32.const	$push33=, 2
	i32.const	$14=, 112
	i32.add 	$14=, $23, $14
	block
	i32.call	$push34=, f3@FUNCTION, $pop33, $14
	i32.const	$push35=, 120
	i32.ne  	$push36=, $pop34, $pop35
	br_if   	0, $pop36       # 0: down to label13
# BB#6:                                 # %if.end15
	i32.const	$push93=, 8
	i32.const	$15=, 96
	i32.add 	$15=, $23, $15
	i32.or  	$push37=, $15, $pop93
	i32.const	$push38=, 300
	i32.store	$discard=, 0($pop37):p2align=3, $pop38
	i64.store	$discard=, 96($23):p2align=4, $1
	i32.const	$push39=, 3
	i32.const	$16=, 96
	i32.add 	$16=, $23, $16
	block
	i32.call	$push40=, f3@FUNCTION, $pop39, $16
	i32.const	$push41=, 421
	i32.ne  	$push42=, $pop40, $pop41
	br_if   	0, $pop42       # 0: down to label14
# BB#7:                                 # %if.end19
	i32.const	$push95=, 8
	i32.const	$17=, 80
	i32.add 	$17=, $23, $17
	i32.or  	$push43=, $17, $pop95
	i64.const	$push44=, 369367187520
	i64.store	$discard=, 0($pop43), $pop44
	i64.const	$push45=, 304942678034
	i64.store	$discard=, 80($23):p2align=4, $pop45
	i32.const	$push94=, 4
	i32.const	$18=, 80
	i32.add 	$18=, $23, $18
	block
	i32.call	$push46=, f3@FUNCTION, $pop94, $18
	i32.const	$push47=, 243
	i32.ne  	$push48=, $pop46, $pop47
	br_if   	0, $pop48       # 0: down to label15
# BB#8:                                 # %if.end23
	i32.const	$push50=, 24
	i32.const	$19=, 48
	i32.add 	$19=, $23, $19
	i32.add 	$push51=, $19, $pop50
	i64.const	$push52=, 4625759767262920704
	i64.store	$discard=, 0($pop51), $pop52
	i32.const	$push53=, 16
	i32.const	$20=, 48
	i32.add 	$20=, $23, $20
	i32.add 	$push54=, $20, $pop53
	i32.const	$push98=, 16
	i32.store	$discard=, 0($pop54):p2align=4, $pop98
	i32.const	$push55=, 8
	i32.const	$21=, 48
	i32.add 	$21=, $23, $21
	i32.or  	$push56=, $21, $pop55
	i64.const	$push57=, 4621256167635550208
	i64.store	$discard=, 0($pop56), $pop57
	i64.const	$push58=, 4618441417868443648
	i64.store	$discard=, 48($23):p2align=4, $pop58
	i32.const	$push97=, 4
	i32.const	$22=, 48
	i32.add 	$22=, $23, $22
	call    	f4@FUNCTION, $pop97, $22
	block
	i32.const	$push96=, 0
	i32.load	$push59=, x($pop96)
	i32.const	$push60=, 43
	i32.ne  	$push61=, $pop59, $pop60
	br_if   	0, $pop61       # 0: down to label16
# BB#9:                                 # %if.end23
	i32.const	$push99=, 0
	i32.load	$push49=, y($pop99)
	i32.const	$push62=, 6
	i32.ne  	$push63=, $pop49, $pop62
	br_if   	0, $pop63       # 0: down to label16
# BB#10:                                # %if.end28
	i32.const	$push65=, 32
	i32.add 	$push66=, $23, $pop65
	i64.const	$push67=, 4638566878703255552
	i64.store	$discard=, 0($pop66):p2align=4, $pop67
	i32.const	$push68=, 24
	i32.add 	$push69=, $23, $pop68
	i32.const	$push70=, 17
	i32.store	$discard=, 0($pop69):p2align=3, $pop70
	i32.const	$push71=, 16
	i32.add 	$push72=, $23, $pop71
	i64.const	$push73=, 4607182418800017408
	i64.store	$discard=, 0($pop72):p2align=4, $pop73
	i32.const	$push74=, 8
	i32.or  	$push75=, $23, $pop74
	i64.const	$push76=, 4626604192193052672
	i64.store	$discard=, 0($pop75), $pop76
	i64.const	$push77=, 4619567317775286272
	i64.store	$discard=, 0($23):p2align=4, $pop77
	i32.const	$push78=, 5
	call    	f4@FUNCTION, $pop78, $23
	block
	i32.const	$push100=, 0
	i32.load	$push79=, x($pop100)
	i32.const	$push80=, 144
	i32.ne  	$push81=, $pop79, $pop80
	br_if   	0, $pop81       # 0: down to label17
# BB#11:                                # %if.end28
	i32.const	$push101=, 0
	i32.load	$push64=, y($pop101)
	i32.const	$push82=, 28
	i32.ne  	$push83=, $pop64, $pop82
	br_if   	0, $pop83       # 0: down to label17
# BB#12:                                # %if.end33
	i32.const	$push84=, 0
	i32.const	$4=, 224
	i32.add 	$23=, $23, $4
	i32.const	$4=, __stack_pointer
	i32.store	$23=, 0($4), $23
	return  	$pop84
.LBB7_13:                               # %if.then32
	end_block                       # label17:
	call    	abort@FUNCTION
	unreachable
.LBB7_14:                               # %if.then27
	end_block                       # label16:
	call    	abort@FUNCTION
	unreachable
.LBB7_15:                               # %if.then22
	end_block                       # label15:
	call    	abort@FUNCTION
	unreachable
.LBB7_16:                               # %if.then18
	end_block                       # label14:
	call    	abort@FUNCTION
	unreachable
.LBB7_17:                               # %if.then14
	end_block                       # label13:
	call    	abort@FUNCTION
	unreachable
.LBB7_18:                               # %if.then10
	end_block                       # label12:
	call    	abort@FUNCTION
	unreachable
.LBB7_19:                               # %if.then6
	end_block                       # label11:
	call    	abort@FUNCTION
	unreachable
.LBB7_20:                               # %if.then3
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
.LBB7_21:                               # %if.then
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end7:
	.size	main, .Lfunc_end7-main

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


	.ident	"clang version 3.9.0 "
