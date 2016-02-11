	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/stdarg-2.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i64, i64, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 48
	i32.sub 	$11=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$11=, 0($5), $11
	i32.store	$discard=, 44($11), $1
	block
	block
	i32.const	$push0=, 11
	i32.eq  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %entry
	block
	i32.const	$push67=, 8
	i32.eq  	$push2=, $0, $pop67
	br_if   	0, $pop2        # 0: down to label2
# BB#2:                                 # %entry
	block
	i32.const	$push3=, 5
	i32.ne  	$push4=, $0, $pop3
	br_if   	0, $pop4        # 0: down to label3
# BB#3:                                 # %sw.bb
	i32.load	$push43=, 44($11)
	i32.const	$push44=, 3
	i32.add 	$push45=, $pop43, $pop44
	i32.const	$push46=, -4
	i32.and 	$push47=, $pop45, $pop46
	tee_local	$push72=, $0=, $pop47
	i32.const	$push48=, 4
	i32.add 	$push49=, $pop72, $pop48
	i32.store	$discard=, 44($11), $pop49
	i32.load	$1=, 0($0)
	i32.const	$push50=, 11
	i32.add 	$push51=, $0, $pop50
	i32.const	$push52=, -8
	i32.and 	$push53=, $pop51, $pop52
	tee_local	$push71=, $0=, $pop53
	i32.const	$push54=, 8
	i32.add 	$push55=, $pop71, $pop54
	i32.store	$discard=, 44($11), $pop55
	f64.convert_s/i32	$push57=, $1
	f64.load	$push56=, 0($0)
	f64.add 	$push58=, $pop57, $pop56
	i32.trunc_s/f64	$1=, $pop58
	i32.const	$push59=, 15
	i32.add 	$push60=, $0, $pop59
	i32.const	$push70=, -8
	i32.and 	$push61=, $pop60, $pop70
	tee_local	$push69=, $0=, $pop61
	i32.const	$push68=, 8
	i32.add 	$push62=, $pop69, $pop68
	i32.store	$discard=, 44($11), $pop62
	i32.const	$push66=, 0
	i64.extend_u/i32	$push64=, $1
	i64.load	$push63=, 0($0)
	i64.add 	$push65=, $pop64, $pop63
	i64.store32	$discard=, foo_arg($pop66), $pop65
	br      	3               # 3: down to label0
.LBB0_4:                                # %sw.default
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_5:                                # %sw.bb5
	end_block                       # label2:
	i32.load	$push28=, 44($11)
	i32.const	$push29=, 7
	i32.add 	$push30=, $pop28, $pop29
	i32.const	$push31=, -8
	i32.and 	$push32=, $pop30, $pop31
	tee_local	$push77=, $0=, $pop32
	i32.const	$push76=, 8
	i32.add 	$push33=, $pop77, $pop76
	i32.store	$discard=, 44($11), $pop33
	i32.load	$1=, 0($0):p2align=3
	i32.const	$push34=, 15
	i32.add 	$push35=, $0, $pop34
	i32.const	$push75=, -8
	i32.and 	$push36=, $pop35, $pop75
	tee_local	$push74=, $0=, $pop36
	i32.const	$push73=, 8
	i32.add 	$push37=, $pop74, $pop73
	i32.store	$discard=, 44($11), $pop37
	i32.const	$push42=, 0
	f64.convert_s/i32	$push39=, $1
	f64.load	$push38=, 0($0)
	f64.add 	$push40=, $pop39, $pop38
	i32.trunc_s/f64	$push41=, $pop40
	i32.store	$discard=, foo_arg($pop42), $pop41
	br      	1               # 1: down to label0
.LBB0_6:                                # %sw.bb10
	end_block                       # label1:
	i32.load	$push5=, 44($11)
	i32.const	$push6=, 3
	i32.add 	$push7=, $pop5, $pop6
	i32.const	$push8=, -4
	i32.and 	$push9=, $pop7, $pop8
	tee_local	$push83=, $0=, $pop9
	i32.const	$push10=, 4
	i32.add 	$push11=, $pop83, $pop10
	i32.store	$discard=, 44($11), $pop11
	i32.load	$1=, 0($0)
	i32.const	$push12=, 19
	i32.add 	$push13=, $0, $pop12
	i32.const	$push14=, -16
	i32.and 	$push15=, $pop13, $pop14
	tee_local	$push82=, $0=, $pop15
	i64.load	$2=, 0($pop82)
	i32.const	$push16=, 8
	i32.or  	$push17=, $0, $pop16
	i32.store	$push18=, 44($11), $pop17
	tee_local	$push81=, $0=, $pop18
	i32.const	$push80=, 8
	i32.add 	$push19=, $pop81, $pop80
	i32.store	$discard=, 44($11), $pop19
	i64.load	$3=, 0($0)
	i32.const	$7=, 24
	i32.add 	$7=, $11, $7
	call    	__floatsitf@FUNCTION, $7, $1
	i64.load	$push22=, 24($11)
	i32.const	$push79=, 8
	i32.const	$8=, 24
	i32.add 	$8=, $11, $8
	i32.add 	$push20=, $8, $pop79
	i64.load	$push21=, 0($pop20)
	i32.const	$9=, 8
	i32.add 	$9=, $11, $9
	call    	__addtf3@FUNCTION, $9, $pop22, $pop21, $2, $3
	i32.const	$push27=, 0
	i64.load	$push25=, 8($11)
	i32.const	$push78=, 8
	i32.const	$10=, 8
	i32.add 	$10=, $11, $10
	i32.add 	$push23=, $10, $pop78
	i64.load	$push24=, 0($pop23)
	i32.call	$push26=, __fixtfsi@FUNCTION, $pop25, $pop24
	i32.store	$discard=, foo_arg($pop27), $pop26
.LBB0_7:                                # %sw.epilog
	end_block                       # label0:
	i32.const	$6=, 48
	i32.add 	$11=, $11, $6
	i32.const	$6=, __stack_pointer
	i32.store	$11=, 0($6), $11
	return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 16386
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label4
# BB#1:                                 # %if.then
	i32.const	$push25=, 0
	i32.const	$push24=, 0
	i32.load	$push2=, gap($pop24)
	i32.const	$push3=, 3
	i32.add 	$push4=, $pop2, $pop3
	i32.const	$push5=, -4
	i32.and 	$push6=, $pop4, $pop5
	tee_local	$push23=, $1=, $pop6
	i32.const	$push7=, 4
	i32.add 	$push8=, $pop23, $pop7
	i32.store	$discard=, gap($pop25), $pop8
	block
	i32.load	$push9=, 0($1)
	i32.const	$push10=, 13
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	0, $pop11       # 0: down to label5
# BB#2:                                 # %lor.lhs.false
	i32.const	$push28=, 0
	i32.const	$push27=, 0
	i32.load	$push12=, gap($pop27)
	i32.const	$push13=, 7
	i32.add 	$push14=, $pop12, $pop13
	i32.const	$push15=, -8
	i32.and 	$push16=, $pop14, $pop15
	tee_local	$push26=, $1=, $pop16
	i32.const	$push17=, 8
	i32.add 	$push18=, $pop26, $pop17
	i32.store	$discard=, gap($pop28), $pop18
	f64.load	$push19=, 0($1)
	f64.const	$push20=, -0x1.cp3
	f64.eq  	$push21=, $pop19, $pop20
	br_if   	1, $pop21       # 1: down to label4
.LBB1_3:                                # %if.then3
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB1_4:                                # %if.end4
	end_block                       # label4:
	i32.const	$push22=, 0
	i32.store	$discard=, bar_arg($pop22), $0
	return
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.f1,"ax",@progbits
	.hidden	f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push11=, 0
	i32.store	$push1=, gap($pop11), $1
	i32.const	$push2=, 3
	i32.add 	$push3=, $pop1, $pop2
	i32.const	$push4=, -4
	i32.and 	$push5=, $pop3, $pop4
	tee_local	$push10=, $1=, $pop5
	i32.const	$push6=, 4
	i32.add 	$push7=, $pop10, $pop6
	i32.store	$discard=, gap($pop0), $pop7
	i32.const	$push9=, 0
	i32.load	$push8=, 0($1)
	i32.store	$discard=, x($pop9), $pop8
	return
	.endfunc
.Lfunc_end2:
	.size	f1, .Lfunc_end2-f1

	.section	.text.f2,"ax",@progbits
	.hidden	f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push23=, 0
	i32.store	$discard=, gap($pop23), $1
	block
	i32.const	$push0=, 16386
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label6
# BB#1:                                 # %if.then.i
	i32.const	$push26=, 0
	i32.const	$push25=, 0
	i32.load	$push2=, gap($pop25)
	i32.const	$push3=, 3
	i32.add 	$push4=, $pop2, $pop3
	i32.const	$push5=, -4
	i32.and 	$push6=, $pop4, $pop5
	tee_local	$push24=, $1=, $pop6
	i32.const	$push7=, 4
	i32.add 	$push8=, $pop24, $pop7
	i32.store	$discard=, gap($pop26), $pop8
	block
	i32.load	$push9=, 0($1)
	i32.const	$push10=, 13
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	0, $pop11       # 0: down to label7
# BB#2:                                 # %lor.lhs.false.i
	i32.const	$push12=, 0
	i32.const	$push28=, 0
	i32.load	$push13=, gap($pop28)
	i32.const	$push14=, 7
	i32.add 	$push15=, $pop13, $pop14
	i32.const	$push16=, -8
	i32.and 	$push17=, $pop15, $pop16
	tee_local	$push27=, $1=, $pop17
	i32.const	$push18=, 8
	i32.add 	$push19=, $pop27, $pop18
	i32.store	$discard=, gap($pop12), $pop19
	f64.load	$push20=, 0($1)
	f64.const	$push21=, -0x1.cp3
	f64.eq  	$push22=, $pop20, $pop21
	br_if   	1, $pop22       # 1: down to label6
.LBB3_3:                                # %if.then3.i
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB3_4:                                # %bar.exit
	end_block                       # label6:
	i32.const	$push29=, 0
	i32.store	$discard=, bar_arg($pop29), $0
	return
	.endfunc
.Lfunc_end3:
	.size	f2, .Lfunc_end3-f2

	.section	.text.f3,"ax",@progbits
	.hidden	f3
	.globl	f3
	.type	f3,@function
f3:                                     # @f3
	.param  	i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 48
	i32.sub 	$5=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	i32.store	$push0=, 16($5):p2align=4, $1
	i32.const	$push1=, 3
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -4
	i32.and 	$push4=, $pop2, $pop3
	tee_local	$push9=, $1=, $pop4
	i32.const	$push5=, 4
	i32.add 	$push6=, $pop9, $pop5
	i32.store	$discard=, 16($5):p2align=4, $pop6
	i32.const	$push8=, 0
	i32.load	$push7=, 0($1)
	i32.store	$discard=, x($pop8), $pop7
	i32.const	$4=, 48
	i32.add 	$5=, $5, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
	return
	.endfunc
.Lfunc_end4:
	.size	f3, .Lfunc_end4-f3

	.section	.text.f4,"ax",@progbits
	.hidden	f4
	.globl	f4
	.type	f4,@function
f4:                                     # @f4
	.param  	i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 48
	i32.sub 	$5=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	i32.store	$discard=, 16($5):p2align=4, $1
	block
	i32.const	$push0=, 16386
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label8
# BB#1:                                 # %if.then.i
	i32.const	$push25=, 0
	i32.const	$push24=, 0
	i32.load	$push2=, gap($pop24)
	i32.const	$push3=, 3
	i32.add 	$push4=, $pop2, $pop3
	i32.const	$push5=, -4
	i32.and 	$push6=, $pop4, $pop5
	tee_local	$push23=, $1=, $pop6
	i32.const	$push7=, 4
	i32.add 	$push8=, $pop23, $pop7
	i32.store	$discard=, gap($pop25), $pop8
	block
	i32.load	$push9=, 0($1)
	i32.const	$push10=, 13
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	0, $pop11       # 0: down to label9
# BB#2:                                 # %lor.lhs.false.i
	i32.const	$push28=, 0
	i32.const	$push27=, 0
	i32.load	$push12=, gap($pop27)
	i32.const	$push13=, 7
	i32.add 	$push14=, $pop12, $pop13
	i32.const	$push15=, -8
	i32.and 	$push16=, $pop14, $pop15
	tee_local	$push26=, $1=, $pop16
	i32.const	$push17=, 8
	i32.add 	$push18=, $pop26, $pop17
	i32.store	$discard=, gap($pop28), $pop18
	f64.load	$push19=, 0($1)
	f64.const	$push20=, -0x1.cp3
	f64.eq  	$push21=, $pop19, $pop20
	br_if   	1, $pop21       # 1: down to label8
.LBB5_3:                                # %if.then3.i
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB5_4:                                # %bar.exit
	end_block                       # label8:
	i32.const	$push22=, 0
	i32.store	$discard=, bar_arg($pop22), $0
	i32.const	$4=, 48
	i32.add 	$5=, $5, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
	return
	.endfunc
.Lfunc_end5:
	.size	f4, .Lfunc_end5-f4

	.section	.text.f5,"ax",@progbits
	.hidden	f5
	.globl	f5
	.type	f5,@function
f5:                                     # @f5
	.param  	i32, i32
	.local  	i64, i64, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 80
	i32.sub 	$9=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$9=, 0($5), $9
	i32.store	$push0=, 48($9):p2align=4, $1
	i32.store	$discard=, 76($9), $pop0
	block
	block
	i32.const	$push1=, 11
	i32.eq  	$push2=, $0, $pop1
	br_if   	0, $pop2        # 0: down to label11
# BB#1:                                 # %entry
	block
	i32.const	$push68=, 8
	i32.eq  	$push3=, $0, $pop68
	br_if   	0, $pop3        # 0: down to label12
# BB#2:                                 # %entry
	block
	i32.const	$push4=, 5
	i32.ne  	$push5=, $0, $pop4
	br_if   	0, $pop5        # 0: down to label13
# BB#3:                                 # %sw.bb.i
	i32.load	$push44=, 76($9)
	i32.const	$push45=, 3
	i32.add 	$push46=, $pop44, $pop45
	i32.const	$push47=, -4
	i32.and 	$push48=, $pop46, $pop47
	tee_local	$push73=, $0=, $pop48
	i32.const	$push49=, 4
	i32.add 	$push50=, $pop73, $pop49
	i32.store	$discard=, 76($9), $pop50
	i32.load	$1=, 0($0)
	i32.const	$push51=, 11
	i32.add 	$push52=, $0, $pop51
	i32.const	$push53=, -8
	i32.and 	$push54=, $pop52, $pop53
	tee_local	$push72=, $0=, $pop54
	i32.const	$push55=, 8
	i32.add 	$push56=, $pop72, $pop55
	i32.store	$discard=, 76($9), $pop56
	f64.convert_s/i32	$push58=, $1
	f64.load	$push57=, 0($0)
	f64.add 	$push59=, $pop58, $pop57
	i32.trunc_s/f64	$1=, $pop59
	i32.const	$push60=, 15
	i32.add 	$push61=, $0, $pop60
	i32.const	$push71=, -8
	i32.and 	$push62=, $pop61, $pop71
	tee_local	$push70=, $0=, $pop62
	i32.const	$push69=, 8
	i32.add 	$push63=, $pop70, $pop69
	i32.store	$discard=, 76($9), $pop63
	i32.const	$push67=, 0
	i64.extend_u/i32	$push65=, $1
	i64.load	$push64=, 0($0)
	i64.add 	$push66=, $pop65, $pop64
	i64.store32	$discard=, foo_arg($pop67), $pop66
	br      	3               # 3: down to label10
.LBB6_4:                                # %sw.default.i
	end_block                       # label13:
	call    	abort@FUNCTION
	unreachable
.LBB6_5:                                # %sw.bb5.i
	end_block                       # label12:
	i32.load	$push29=, 76($9)
	i32.const	$push30=, 7
	i32.add 	$push31=, $pop29, $pop30
	i32.const	$push32=, -8
	i32.and 	$push33=, $pop31, $pop32
	tee_local	$push78=, $0=, $pop33
	i32.const	$push77=, 8
	i32.add 	$push34=, $pop78, $pop77
	i32.store	$discard=, 76($9), $pop34
	i32.load	$1=, 0($0):p2align=3
	i32.const	$push35=, 15
	i32.add 	$push36=, $0, $pop35
	i32.const	$push76=, -8
	i32.and 	$push37=, $pop36, $pop76
	tee_local	$push75=, $0=, $pop37
	i32.const	$push74=, 8
	i32.add 	$push38=, $pop75, $pop74
	i32.store	$discard=, 76($9), $pop38
	i32.const	$push43=, 0
	f64.load	$push39=, 0($0)
	f64.convert_s/i32	$push40=, $1
	f64.add 	$push41=, $pop39, $pop40
	i32.trunc_s/f64	$push42=, $pop41
	i32.store	$discard=, foo_arg($pop43), $pop42
	br      	1               # 1: down to label10
.LBB6_6:                                # %sw.bb10.i
	end_block                       # label11:
	i32.load	$push6=, 76($9)
	i32.const	$push7=, 3
	i32.add 	$push8=, $pop6, $pop7
	i32.const	$push9=, -4
	i32.and 	$push10=, $pop8, $pop9
	tee_local	$push84=, $0=, $pop10
	i32.const	$push11=, 4
	i32.add 	$push12=, $pop84, $pop11
	i32.store	$discard=, 76($9), $pop12
	i32.load	$1=, 0($0)
	i32.const	$push13=, 19
	i32.add 	$push14=, $0, $pop13
	i32.const	$push15=, -16
	i32.and 	$push16=, $pop14, $pop15
	tee_local	$push83=, $0=, $pop16
	i64.load	$2=, 0($pop83)
	i32.const	$push17=, 8
	i32.or  	$push18=, $0, $pop17
	i32.store	$push19=, 76($9), $pop18
	tee_local	$push82=, $0=, $pop19
	i32.const	$push81=, 8
	i32.add 	$push20=, $pop82, $pop81
	i32.store	$discard=, 76($9), $pop20
	i64.load	$3=, 0($0)
	i32.const	$7=, 16
	i32.add 	$7=, $9, $7
	call    	__floatsitf@FUNCTION, $7, $1
	i64.load	$push23=, 16($9)
	i32.const	$push80=, 8
	i32.const	$8=, 16
	i32.add 	$8=, $9, $8
	i32.add 	$push21=, $8, $pop80
	i64.load	$push22=, 0($pop21)
	call    	__addtf3@FUNCTION, $9, $pop23, $pop22, $2, $3
	i32.const	$push28=, 0
	i64.load	$push26=, 0($9)
	i32.const	$push79=, 8
	i32.add 	$push24=, $9, $pop79
	i64.load	$push25=, 0($pop24)
	i32.call	$push27=, __fixtfsi@FUNCTION, $pop26, $pop25
	i32.store	$discard=, foo_arg($pop28), $pop27
.LBB6_7:                                # %foo.exit
	end_block                       # label10:
	i32.const	$6=, 80
	i32.add 	$9=, $9, $6
	i32.const	$6=, __stack_pointer
	i32.store	$9=, 0($6), $9
	return
	.endfunc
.Lfunc_end6:
	.size	f5, .Lfunc_end6-f5

	.section	.text.f6,"ax",@progbits
	.hidden	f6
	.globl	f6
	.type	f6,@function
f6:                                     # @f6
	.param  	i32, i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 16
	i32.sub 	$6=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$6=, 0($4), $6
	i32.const	$push0=, 4
	i32.or  	$2=, $6, $pop0
	i32.store	$push1=, 0($2), $1
	i32.const	$push2=, 3
	i32.add 	$push3=, $pop1, $pop2
	i32.const	$push4=, -4
	i32.and 	$push5=, $pop3, $pop4
	tee_local	$push10=, $1=, $pop5
	i32.const	$push9=, 4
	i32.add 	$push6=, $pop10, $pop9
	i32.store	$discard=, 0($2), $pop6
	i32.const	$push8=, 0
	i32.load	$push7=, 0($1)
	i32.store	$discard=, x($pop8), $pop7
	i32.const	$5=, 16
	i32.add 	$6=, $6, $5
	i32.const	$5=, __stack_pointer
	i32.store	$6=, 0($5), $6
	return
	.endfunc
.Lfunc_end7:
	.size	f6, .Lfunc_end7-f6

	.section	.text.f7,"ax",@progbits
	.hidden	f7
	.globl	f7
	.type	f7,@function
f7:                                     # @f7
	.param  	i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$5=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	i32.const	$push23=, 4
	i32.or  	$push0=, $5, $pop23
	i32.store	$discard=, 0($pop0), $1
	block
	i32.const	$push1=, 16386
	i32.ne  	$push2=, $0, $pop1
	br_if   	0, $pop2        # 0: down to label14
# BB#1:                                 # %if.then.i
	i32.const	$push27=, 0
	i32.const	$push26=, 0
	i32.load	$push3=, gap($pop26)
	i32.const	$push4=, 3
	i32.add 	$push5=, $pop3, $pop4
	i32.const	$push6=, -4
	i32.and 	$push7=, $pop5, $pop6
	tee_local	$push25=, $1=, $pop7
	i32.const	$push24=, 4
	i32.add 	$push8=, $pop25, $pop24
	i32.store	$discard=, gap($pop27), $pop8
	block
	i32.load	$push9=, 0($1)
	i32.const	$push10=, 13
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	0, $pop11       # 0: down to label15
# BB#2:                                 # %lor.lhs.false.i
	i32.const	$push30=, 0
	i32.const	$push29=, 0
	i32.load	$push12=, gap($pop29)
	i32.const	$push13=, 7
	i32.add 	$push14=, $pop12, $pop13
	i32.const	$push15=, -8
	i32.and 	$push16=, $pop14, $pop15
	tee_local	$push28=, $1=, $pop16
	i32.const	$push17=, 8
	i32.add 	$push18=, $pop28, $pop17
	i32.store	$discard=, gap($pop30), $pop18
	f64.load	$push19=, 0($1)
	f64.const	$push20=, -0x1.cp3
	f64.eq  	$push21=, $pop19, $pop20
	br_if   	1, $pop21       # 1: down to label14
.LBB8_3:                                # %if.then3.i
	end_block                       # label15:
	call    	abort@FUNCTION
	unreachable
.LBB8_4:                                # %bar.exit
	end_block                       # label14:
	i32.const	$push22=, 0
	i32.store	$discard=, bar_arg($pop22), $0
	i32.const	$4=, 16
	i32.add 	$5=, $5, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
	return
	.endfunc
.Lfunc_end8:
	.size	f7, .Lfunc_end8-f7

	.section	.text.f8,"ax",@progbits
	.hidden	f8
	.globl	f8
	.type	f8,@function
f8:                                     # @f8
	.param  	i32, i32
	.local  	i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 64
	i32.sub 	$12=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$12=, 0($5), $12
	i32.const	$push68=, 4
	i32.const	$7=, 40
	i32.add 	$7=, $12, $7
	i32.or  	$push0=, $7, $pop68
	i32.store	$push1=, 0($pop0), $1
	i32.store	$discard=, 60($12), $pop1
	block
	block
	i32.const	$push2=, 11
	i32.eq  	$push3=, $0, $pop2
	br_if   	0, $pop3        # 0: down to label17
# BB#1:                                 # %entry
	block
	i32.const	$push69=, 8
	i32.eq  	$push4=, $0, $pop69
	br_if   	0, $pop4        # 0: down to label18
# BB#2:                                 # %entry
	block
	i32.const	$push5=, 5
	i32.ne  	$push6=, $0, $pop5
	br_if   	0, $pop6        # 0: down to label19
# BB#3:                                 # %sw.bb.i
	i32.load	$push44=, 60($12)
	i32.const	$push45=, 3
	i32.add 	$push46=, $pop44, $pop45
	i32.const	$push47=, -4
	i32.and 	$push48=, $pop46, $pop47
	tee_local	$push74=, $0=, $pop48
	i32.const	$push49=, 4
	i32.add 	$push50=, $pop74, $pop49
	i32.store	$discard=, 60($12), $pop50
	i32.load	$1=, 0($0)
	i32.const	$push51=, 11
	i32.add 	$push52=, $0, $pop51
	i32.const	$push53=, -8
	i32.and 	$push54=, $pop52, $pop53
	tee_local	$push73=, $0=, $pop54
	i32.const	$push55=, 8
	i32.add 	$push56=, $pop73, $pop55
	i32.store	$discard=, 60($12), $pop56
	f64.convert_s/i32	$push58=, $1
	f64.load	$push57=, 0($0)
	f64.add 	$push59=, $pop58, $pop57
	i32.trunc_s/f64	$1=, $pop59
	i32.const	$push60=, 15
	i32.add 	$push61=, $0, $pop60
	i32.const	$push72=, -8
	i32.and 	$push62=, $pop61, $pop72
	tee_local	$push71=, $0=, $pop62
	i32.const	$push70=, 8
	i32.add 	$push63=, $pop71, $pop70
	i32.store	$discard=, 60($12), $pop63
	i32.const	$push67=, 0
	i64.extend_u/i32	$push65=, $1
	i64.load	$push64=, 0($0)
	i64.add 	$push66=, $pop65, $pop64
	i64.store32	$discard=, foo_arg($pop67), $pop66
	br      	3               # 3: down to label16
.LBB9_4:                                # %sw.default.i
	end_block                       # label19:
	call    	abort@FUNCTION
	unreachable
.LBB9_5:                                # %sw.bb5.i
	end_block                       # label18:
	i32.load	$push29=, 60($12)
	i32.const	$push30=, 7
	i32.add 	$push31=, $pop29, $pop30
	i32.const	$push32=, -8
	i32.and 	$push33=, $pop31, $pop32
	tee_local	$push79=, $0=, $pop33
	i32.const	$push78=, 8
	i32.add 	$push34=, $pop79, $pop78
	i32.store	$discard=, 60($12), $pop34
	i32.load	$1=, 0($0):p2align=3
	i32.const	$push35=, 15
	i32.add 	$push36=, $0, $pop35
	i32.const	$push77=, -8
	i32.and 	$push37=, $pop36, $pop77
	tee_local	$push76=, $0=, $pop37
	i32.const	$push75=, 8
	i32.add 	$push38=, $pop76, $pop75
	i32.store	$discard=, 60($12), $pop38
	i32.const	$push43=, 0
	f64.load	$push39=, 0($0)
	f64.convert_s/i32	$push40=, $1
	f64.add 	$push41=, $pop39, $pop40
	i32.trunc_s/f64	$push42=, $pop41
	i32.store	$discard=, foo_arg($pop43), $pop42
	br      	1               # 1: down to label16
.LBB9_6:                                # %sw.bb10.i
	end_block                       # label17:
	i32.load	$push7=, 60($12)
	i32.const	$push8=, 3
	i32.add 	$push9=, $pop7, $pop8
	i32.const	$push10=, -4
	i32.and 	$push11=, $pop9, $pop10
	tee_local	$push86=, $0=, $pop11
	i32.const	$push85=, 4
	i32.add 	$push12=, $pop86, $pop85
	i32.store	$discard=, 60($12), $pop12
	i32.load	$1=, 0($0)
	i32.const	$push13=, 19
	i32.add 	$push14=, $0, $pop13
	i32.const	$push15=, -16
	i32.and 	$push16=, $pop14, $pop15
	tee_local	$push84=, $0=, $pop16
	i64.load	$2=, 0($pop84)
	i32.const	$push17=, 8
	i32.or  	$push18=, $0, $pop17
	i32.store	$push19=, 60($12), $pop18
	tee_local	$push83=, $0=, $pop19
	i32.const	$push82=, 8
	i32.add 	$push20=, $pop83, $pop82
	i32.store	$discard=, 60($12), $pop20
	i64.load	$3=, 0($0)
	i32.const	$8=, 24
	i32.add 	$8=, $12, $8
	call    	__floatsitf@FUNCTION, $8, $1
	i64.load	$push23=, 24($12)
	i32.const	$push81=, 8
	i32.const	$9=, 24
	i32.add 	$9=, $12, $9
	i32.add 	$push21=, $9, $pop81
	i64.load	$push22=, 0($pop21)
	i32.const	$10=, 8
	i32.add 	$10=, $12, $10
	call    	__addtf3@FUNCTION, $10, $pop23, $pop22, $2, $3
	i32.const	$push28=, 0
	i64.load	$push26=, 8($12)
	i32.const	$push80=, 8
	i32.const	$11=, 8
	i32.add 	$11=, $12, $11
	i32.add 	$push24=, $11, $pop80
	i64.load	$push25=, 0($pop24)
	i32.call	$push27=, __fixtfsi@FUNCTION, $pop26, $pop25
	i32.store	$discard=, foo_arg($pop28), $pop27
.LBB9_7:                                # %foo.exit
	end_block                       # label16:
	i32.const	$6=, 64
	i32.add 	$12=, $12, $6
	i32.const	$6=, __stack_pointer
	i32.store	$12=, 0($6), $12
	return
	.endfunc
.Lfunc_end9:
	.size	f8, .Lfunc_end9-f8

	.section	.text.f10,"ax",@progbits
	.hidden	f10
	.globl	f10
	.type	f10,@function
f10:                                    # @f10
	.param  	i32, i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 16
	i32.sub 	$6=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$6=, 0($4), $6
	i32.const	$push0=, 12
	i32.add 	$2=, $6, $pop0
	i32.store	$push1=, 0($2), $1
	i32.const	$push2=, 3
	i32.add 	$push3=, $pop1, $pop2
	i32.const	$push4=, -4
	i32.and 	$push5=, $pop3, $pop4
	tee_local	$push10=, $1=, $pop5
	i32.const	$push6=, 4
	i32.add 	$push7=, $pop10, $pop6
	i32.store	$discard=, 0($2), $pop7
	i32.const	$push9=, 0
	i32.load	$push8=, 0($1)
	i32.store	$discard=, x($pop9), $pop8
	i32.const	$5=, 16
	i32.add 	$6=, $6, $5
	i32.const	$5=, __stack_pointer
	i32.store	$6=, 0($5), $6
	return
	.endfunc
.Lfunc_end10:
	.size	f10, .Lfunc_end10-f10

	.section	.text.f11,"ax",@progbits
	.hidden	f11
	.globl	f11
	.type	f11,@function
f11:                                    # @f11
	.param  	i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$5=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	i32.const	$push1=, 12
	i32.add 	$push0=, $5, $pop1
	i32.store	$discard=, 0($pop0), $1
	block
	i32.const	$push2=, 16386
	i32.ne  	$push3=, $0, $pop2
	br_if   	0, $pop3        # 0: down to label20
# BB#1:                                 # %if.then.i
	i32.const	$push27=, 0
	i32.const	$push26=, 0
	i32.load	$push4=, gap($pop26)
	i32.const	$push5=, 3
	i32.add 	$push6=, $pop4, $pop5
	i32.const	$push7=, -4
	i32.and 	$push8=, $pop6, $pop7
	tee_local	$push25=, $1=, $pop8
	i32.const	$push9=, 4
	i32.add 	$push10=, $pop25, $pop9
	i32.store	$discard=, gap($pop27), $pop10
	block
	i32.load	$push11=, 0($1)
	i32.const	$push12=, 13
	i32.ne  	$push13=, $pop11, $pop12
	br_if   	0, $pop13       # 0: down to label21
# BB#2:                                 # %lor.lhs.false.i
	i32.const	$push30=, 0
	i32.const	$push29=, 0
	i32.load	$push14=, gap($pop29)
	i32.const	$push15=, 7
	i32.add 	$push16=, $pop14, $pop15
	i32.const	$push17=, -8
	i32.and 	$push18=, $pop16, $pop17
	tee_local	$push28=, $1=, $pop18
	i32.const	$push19=, 8
	i32.add 	$push20=, $pop28, $pop19
	i32.store	$discard=, gap($pop30), $pop20
	f64.load	$push21=, 0($1)
	f64.const	$push22=, -0x1.cp3
	f64.eq  	$push23=, $pop21, $pop22
	br_if   	1, $pop23       # 1: down to label20
.LBB11_3:                               # %if.then3.i
	end_block                       # label21:
	call    	abort@FUNCTION
	unreachable
.LBB11_4:                               # %bar.exit
	end_block                       # label20:
	i32.const	$push24=, 0
	i32.store	$discard=, bar_arg($pop24), $0
	i32.const	$4=, 16
	i32.add 	$5=, $5, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
	return
	.endfunc
.Lfunc_end11:
	.size	f11, .Lfunc_end11-f11

	.section	.text.f12,"ax",@progbits
	.hidden	f12
	.globl	f12
	.type	f12,@function
f12:                                    # @f12
	.param  	i32, i32
	.local  	i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 64
	i32.sub 	$12=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$12=, 0($5), $12
	i32.const	$push1=, 12
	i32.const	$7=, 40
	i32.add 	$7=, $12, $7
	i32.add 	$push0=, $7, $pop1
	i32.store	$push2=, 0($pop0), $1
	i32.store	$discard=, 60($12), $pop2
	block
	block
	i32.const	$push3=, 11
	i32.eq  	$push4=, $0, $pop3
	br_if   	0, $pop4        # 0: down to label23
# BB#1:                                 # %entry
	block
	i32.const	$push70=, 8
	i32.eq  	$push5=, $0, $pop70
	br_if   	0, $pop5        # 0: down to label24
# BB#2:                                 # %entry
	block
	i32.const	$push6=, 5
	i32.ne  	$push7=, $0, $pop6
	br_if   	0, $pop7        # 0: down to label25
# BB#3:                                 # %sw.bb.i
	i32.load	$push46=, 60($12)
	i32.const	$push47=, 3
	i32.add 	$push48=, $pop46, $pop47
	i32.const	$push49=, -4
	i32.and 	$push50=, $pop48, $pop49
	tee_local	$push75=, $0=, $pop50
	i32.const	$push51=, 4
	i32.add 	$push52=, $pop75, $pop51
	i32.store	$discard=, 60($12), $pop52
	i32.load	$1=, 0($0)
	i32.const	$push53=, 11
	i32.add 	$push54=, $0, $pop53
	i32.const	$push55=, -8
	i32.and 	$push56=, $pop54, $pop55
	tee_local	$push74=, $0=, $pop56
	i32.const	$push57=, 8
	i32.add 	$push58=, $pop74, $pop57
	i32.store	$discard=, 60($12), $pop58
	f64.convert_s/i32	$push60=, $1
	f64.load	$push59=, 0($0)
	f64.add 	$push61=, $pop60, $pop59
	i32.trunc_s/f64	$1=, $pop61
	i32.const	$push62=, 15
	i32.add 	$push63=, $0, $pop62
	i32.const	$push73=, -8
	i32.and 	$push64=, $pop63, $pop73
	tee_local	$push72=, $0=, $pop64
	i32.const	$push71=, 8
	i32.add 	$push65=, $pop72, $pop71
	i32.store	$discard=, 60($12), $pop65
	i32.const	$push69=, 0
	i64.extend_u/i32	$push67=, $1
	i64.load	$push66=, 0($0)
	i64.add 	$push68=, $pop67, $pop66
	i64.store32	$discard=, foo_arg($pop69), $pop68
	br      	3               # 3: down to label22
.LBB12_4:                               # %sw.default.i
	end_block                       # label25:
	call    	abort@FUNCTION
	unreachable
.LBB12_5:                               # %sw.bb5.i
	end_block                       # label24:
	i32.load	$push31=, 60($12)
	i32.const	$push32=, 7
	i32.add 	$push33=, $pop31, $pop32
	i32.const	$push34=, -8
	i32.and 	$push35=, $pop33, $pop34
	tee_local	$push80=, $0=, $pop35
	i32.const	$push79=, 8
	i32.add 	$push36=, $pop80, $pop79
	i32.store	$discard=, 60($12), $pop36
	i32.load	$1=, 0($0):p2align=3
	i32.const	$push37=, 15
	i32.add 	$push38=, $0, $pop37
	i32.const	$push78=, -8
	i32.and 	$push39=, $pop38, $pop78
	tee_local	$push77=, $0=, $pop39
	i32.const	$push76=, 8
	i32.add 	$push40=, $pop77, $pop76
	i32.store	$discard=, 60($12), $pop40
	i32.const	$push45=, 0
	f64.load	$push41=, 0($0)
	f64.convert_s/i32	$push42=, $1
	f64.add 	$push43=, $pop41, $pop42
	i32.trunc_s/f64	$push44=, $pop43
	i32.store	$discard=, foo_arg($pop45), $pop44
	br      	1               # 1: down to label22
.LBB12_6:                               # %sw.bb10.i
	end_block                       # label23:
	i32.load	$push8=, 60($12)
	i32.const	$push9=, 3
	i32.add 	$push10=, $pop8, $pop9
	i32.const	$push11=, -4
	i32.and 	$push12=, $pop10, $pop11
	tee_local	$push86=, $0=, $pop12
	i32.const	$push13=, 4
	i32.add 	$push14=, $pop86, $pop13
	i32.store	$discard=, 60($12), $pop14
	i32.load	$1=, 0($0)
	i32.const	$push15=, 19
	i32.add 	$push16=, $0, $pop15
	i32.const	$push17=, -16
	i32.and 	$push18=, $pop16, $pop17
	tee_local	$push85=, $0=, $pop18
	i64.load	$2=, 0($pop85)
	i32.const	$push19=, 8
	i32.or  	$push20=, $0, $pop19
	i32.store	$push21=, 60($12), $pop20
	tee_local	$push84=, $0=, $pop21
	i32.const	$push83=, 8
	i32.add 	$push22=, $pop84, $pop83
	i32.store	$discard=, 60($12), $pop22
	i64.load	$3=, 0($0)
	i32.const	$8=, 24
	i32.add 	$8=, $12, $8
	call    	__floatsitf@FUNCTION, $8, $1
	i64.load	$push25=, 24($12)
	i32.const	$push82=, 8
	i32.const	$9=, 24
	i32.add 	$9=, $12, $9
	i32.add 	$push23=, $9, $pop82
	i64.load	$push24=, 0($pop23)
	i32.const	$10=, 8
	i32.add 	$10=, $12, $10
	call    	__addtf3@FUNCTION, $10, $pop25, $pop24, $2, $3
	i32.const	$push30=, 0
	i64.load	$push28=, 8($12)
	i32.const	$push81=, 8
	i32.const	$11=, 8
	i32.add 	$11=, $12, $11
	i32.add 	$push26=, $11, $pop81
	i64.load	$push27=, 0($pop26)
	i32.call	$push29=, __fixtfsi@FUNCTION, $pop28, $pop27
	i32.store	$discard=, foo_arg($pop30), $pop29
.LBB12_7:                               # %foo.exit
	end_block                       # label22:
	i32.const	$6=, 64
	i32.add 	$12=, $12, $6
	i32.const	$6=, __stack_pointer
	i32.store	$12=, 0($6), $12
	return
	.endfunc
.Lfunc_end12:
	.size	f12, .Lfunc_end12-f12

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 176
	i32.sub 	$16=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$16=, 0($2), $16
	i32.const	$push0=, 79
	i32.store	$0=, 160($16):p2align=4, $pop0
	i32.const	$4=, 160
	i32.add 	$4=, $16, $4
	call    	f1@FUNCTION, $0, $4
	block
	i32.const	$push58=, 0
	i32.load	$push1=, x($pop58)
	i32.ne  	$push2=, $0, $pop1
	br_if   	0, $pop2        # 0: down to label26
# BB#1:                                 # %if.end
	i32.const	$push3=, 8
	i32.const	$5=, 144
	i32.add 	$5=, $16, $5
	i32.or  	$push4=, $5, $pop3
	i64.const	$push5=, -4599301119452119040
	i64.store	$discard=, 0($pop4), $pop5
	i32.const	$push6=, 13
	i32.store	$discard=, 144($16):p2align=4, $pop6
	i32.const	$push7=, 16386
	i32.const	$6=, 144
	i32.add 	$6=, $16, $6
	call    	f2@FUNCTION, $pop7, $6
	block
	i32.const	$push60=, 0
	i32.load	$push8=, bar_arg($pop60)
	i32.const	$push59=, 16386
	i32.ne  	$push9=, $pop8, $pop59
	br_if   	0, $pop9        # 0: down to label27
# BB#2:                                 # %if.end3
	i32.const	$push10=, 2031
	i32.store	$0=, 128($16):p2align=4, $pop10
	i32.const	$7=, 128
	i32.add 	$7=, $16, $7
	call    	f3@FUNCTION, $0, $7
	block
	i32.const	$push61=, 0
	i32.load	$push11=, x($pop61)
	i32.ne  	$push12=, $0, $pop11
	br_if   	0, $pop12       # 0: down to label28
# BB#3:                                 # %if.end6
	i32.const	$push13=, 18
	i32.store	$discard=, 112($16):p2align=4, $pop13
	i32.const	$push14=, 4
	i32.const	$8=, 112
	i32.add 	$8=, $16, $8
	call    	f4@FUNCTION, $pop14, $8
	block
	i32.const	$push63=, 0
	i32.load	$push15=, bar_arg($pop63)
	i32.const	$push62=, 4
	i32.ne  	$push16=, $pop15, $pop62
	br_if   	0, $pop16       # 0: down to label29
# BB#4:                                 # %if.end9
	i32.const	$push17=, 16
	i32.const	$9=, 80
	i32.add 	$9=, $16, $9
	i32.add 	$push18=, $9, $pop17
	i64.const	$push19=, 18
	i64.store	$discard=, 0($pop18):p2align=4, $pop19
	i32.const	$push20=, 8
	i32.const	$10=, 80
	i32.add 	$10=, $16, $10
	i32.or  	$push21=, $10, $pop20
	i64.const	$push22=, 4626041242239631360
	i64.store	$discard=, 0($pop21), $pop22
	i32.const	$push23=, 1
	i32.store	$discard=, 80($16):p2align=4, $pop23
	i32.const	$push24=, 5
	i32.const	$11=, 80
	i32.add 	$11=, $16, $11
	call    	f5@FUNCTION, $pop24, $11
	block
	i32.const	$push64=, 0
	i32.load	$push25=, foo_arg($pop64)
	i32.const	$push26=, 38
	i32.ne  	$push27=, $pop25, $pop26
	br_if   	0, $pop27       # 0: down to label30
# BB#5:                                 # %if.end12
	i32.const	$push28=, 18
	i32.store	$0=, 64($16):p2align=4, $pop28
	i32.const	$12=, 64
	i32.add 	$12=, $16, $12
	call    	f6@FUNCTION, $0, $12
	block
	i32.const	$push65=, 0
	i32.load	$push29=, x($pop65)
	i32.ne  	$push30=, $0, $pop29
	br_if   	0, $pop30       # 0: down to label31
# BB#6:                                 # %if.end15
	i32.const	$push31=, 7
	i32.const	$push68=, 0
	call    	f7@FUNCTION, $pop31, $pop68
	block
	i32.const	$push67=, 0
	i32.load	$push32=, bar_arg($pop67)
	i32.const	$push66=, 7
	i32.ne  	$push33=, $pop32, $pop66
	br_if   	0, $pop33       # 0: down to label32
# BB#7:                                 # %if.end18
	i32.const	$push34=, 8
	i32.const	$13=, 48
	i32.add 	$13=, $16, $13
	i32.or  	$push35=, $13, $pop34
	i64.const	$push36=, 4623507967449235456
	i64.store	$discard=, 0($pop35), $pop36
	i64.const	$push37=, 2031
	i64.store	$discard=, 48($16):p2align=4, $pop37
	i32.const	$push70=, 8
	i32.const	$14=, 48
	i32.add 	$14=, $16, $14
	call    	f8@FUNCTION, $pop70, $14
	block
	i32.const	$push69=, 0
	i32.load	$push38=, foo_arg($pop69)
	i32.const	$push39=, 2044
	i32.ne  	$push40=, $pop38, $pop39
	br_if   	0, $pop40       # 0: down to label33
# BB#8:                                 # %if.end21
	i32.const	$push41=, 180
	i32.store	$0=, 32($16):p2align=4, $pop41
	i32.const	$15=, 32
	i32.add 	$15=, $16, $15
	call    	f10@FUNCTION, $0, $15
	block
	i32.const	$push71=, 0
	i32.load	$push42=, x($pop71)
	i32.ne  	$push43=, $0, $pop42
	br_if   	0, $pop43       # 0: down to label34
# BB#9:                                 # %if.end24
	i32.const	$push44=, 10
	i32.const	$push74=, 0
	call    	f11@FUNCTION, $pop44, $pop74
	block
	i32.const	$push73=, 0
	i32.load	$push45=, bar_arg($pop73)
	i32.const	$push72=, 10
	i32.ne  	$push46=, $pop45, $pop72
	br_if   	0, $pop46       # 0: down to label35
# BB#10:                                # %if.end27
	i32.const	$push47=, 16
	i32.add 	$push48=, $16, $pop47
	i64.const	$push49=, 4612389705869164544
	i64.store	$discard=, 0($pop48):p2align=4, $pop49
	i32.const	$push50=, 8
	i32.or  	$push51=, $16, $pop50
	i64.const	$push52=, 0
	i64.store	$discard=, 0($pop51), $pop52
	i32.const	$push53=, 2030
	i32.store	$discard=, 0($16):p2align=4, $pop53
	i32.const	$push54=, 11
	call    	f12@FUNCTION, $pop54, $16
	block
	i32.const	$push75=, 0
	i32.load	$push55=, foo_arg($pop75)
	i32.const	$push56=, 2042
	i32.ne  	$push57=, $pop55, $pop56
	br_if   	0, $pop57       # 0: down to label36
# BB#11:                                # %if.end30
	i32.const	$push76=, 0
	i32.const	$3=, 176
	i32.add 	$16=, $16, $3
	i32.const	$3=, __stack_pointer
	i32.store	$16=, 0($3), $16
	return  	$pop76
.LBB13_12:                              # %if.then29
	end_block                       # label36:
	call    	abort@FUNCTION
	unreachable
.LBB13_13:                              # %if.then26
	end_block                       # label35:
	call    	abort@FUNCTION
	unreachable
.LBB13_14:                              # %if.then23
	end_block                       # label34:
	call    	abort@FUNCTION
	unreachable
.LBB13_15:                              # %if.then20
	end_block                       # label33:
	call    	abort@FUNCTION
	unreachable
.LBB13_16:                              # %if.then17
	end_block                       # label32:
	call    	abort@FUNCTION
	unreachable
.LBB13_17:                              # %if.then14
	end_block                       # label31:
	call    	abort@FUNCTION
	unreachable
.LBB13_18:                              # %if.then11
	end_block                       # label30:
	call    	abort@FUNCTION
	unreachable
.LBB13_19:                              # %if.then8
	end_block                       # label29:
	call    	abort@FUNCTION
	unreachable
.LBB13_20:                              # %if.then5
	end_block                       # label28:
	call    	abort@FUNCTION
	unreachable
.LBB13_21:                              # %if.then2
	end_block                       # label27:
	call    	abort@FUNCTION
	unreachable
.LBB13_22:                              # %if.then
	end_block                       # label26:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end13:
	.size	main, .Lfunc_end13-main

	.hidden	foo_arg                 # @foo_arg
	.type	foo_arg,@object
	.section	.bss.foo_arg,"aw",@nobits
	.globl	foo_arg
	.p2align	2
foo_arg:
	.int32	0                       # 0x0
	.size	foo_arg, 4

	.hidden	gap                     # @gap
	.type	gap,@object
	.section	.bss.gap,"aw",@nobits
	.globl	gap
	.p2align	2
gap:
	.int32	0
	.size	gap, 4

	.hidden	bar_arg                 # @bar_arg
	.type	bar_arg,@object
	.section	.bss.bar_arg,"aw",@nobits
	.globl	bar_arg
	.p2align	2
bar_arg:
	.int32	0                       # 0x0
	.size	bar_arg, 4

	.hidden	x                       # @x
	.type	x,@object
	.section	.bss.x,"aw",@nobits
	.globl	x
	.p2align	2
x:
	.int32	0                       # 0x0
	.size	x, 4

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
	.p2align	3
d:
	.int64	0                       # double 0
	.size	d, 8


	.ident	"clang version 3.9.0 "
