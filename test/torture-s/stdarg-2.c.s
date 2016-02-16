	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/stdarg-2.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 48
	i32.sub 	$12=, $5, $6
	i32.const	$6=, __stack_pointer
	i32.store	$12=, 0($6), $12
	i32.store	$discard=, 44($12), $1
	block
	block
	block
	block
	i32.const	$push0=, 11
	i32.eq  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label3
# BB#1:                                 # %entry
	i32.const	$push59=, 8
	i32.eq  	$push2=, $0, $pop59
	br_if   	1, $pop2        # 1: down to label2
# BB#2:                                 # %entry
	i32.const	$push3=, 5
	i32.ne  	$push4=, $0, $pop3
	br_if   	3, $pop4        # 3: down to label0
# BB#3:                                 # %sw.bb
	i32.load	$push38=, 44($12)
	i32.const	$push39=, 3
	i32.add 	$push40=, $pop38, $pop39
	i32.const	$push41=, -4
	i32.and 	$push67=, $pop40, $pop41
	tee_local	$push66=, $0=, $pop67
	i32.const	$push42=, 4
	i32.add 	$push43=, $pop66, $pop42
	i32.store	$discard=, 44($12), $pop43
	i32.load	$1=, 0($0)
	i32.const	$push44=, 11
	i32.add 	$push45=, $0, $pop44
	i32.const	$push46=, -8
	i32.and 	$push65=, $pop45, $pop46
	tee_local	$push64=, $0=, $pop65
	i32.const	$push47=, 8
	i32.add 	$push48=, $pop64, $pop47
	i32.store	$discard=, 44($12), $pop48
	f64.convert_s/i32	$push50=, $1
	f64.load	$push49=, 0($0)
	f64.add 	$push51=, $pop50, $pop49
	i32.trunc_s/f64	$1=, $pop51
	i32.const	$push52=, 15
	i32.add 	$push53=, $0, $pop52
	i32.const	$push63=, -8
	i32.and 	$push62=, $pop53, $pop63
	tee_local	$push61=, $0=, $pop62
	i32.const	$push60=, 8
	i32.add 	$push54=, $pop61, $pop60
	i32.store	$discard=, 44($12), $pop54
	i32.const	$push58=, 0
	i64.extend_u/i32	$push56=, $1
	i64.load	$push55=, 0($0)
	i64.add 	$push57=, $pop56, $pop55
	i64.store32	$discard=, foo_arg($pop58), $pop57
	br      	2               # 2: down to label1
.LBB0_4:                                # %sw.bb10
	end_block                       # label3:
	i32.load	$push5=, 44($12)
	i32.const	$push6=, 3
	i32.add 	$push7=, $pop5, $pop6
	i32.const	$push8=, -4
	i32.and 	$push81=, $pop7, $pop8
	tee_local	$push80=, $0=, $pop81
	i32.const	$push9=, 4
	i32.add 	$push10=, $pop80, $pop9
	i32.store	$discard=, 44($12), $pop10
	i32.load	$1=, 0($0)
	i32.const	$push11=, 19
	i32.add 	$push12=, $0, $pop11
	i32.const	$push13=, -16
	i32.and 	$push79=, $pop12, $pop13
	tee_local	$push78=, $4=, $pop79
	i32.const	$push14=, 8
	i32.or  	$push15=, $pop78, $pop14
	i32.store	$0=, 44($12), $pop15
	i64.load	$2=, 0($4)
	i32.const	$push77=, 8
	i32.add 	$push16=, $0, $pop77
	i32.store	$discard=, 44($12), $pop16
	i64.load	$3=, 0($0)
	i32.const	$8=, 24
	i32.add 	$8=, $12, $8
	call    	__floatsitf@FUNCTION, $8, $1
	i64.load	$push19=, 24($12)
	i32.const	$push76=, 8
	i32.const	$9=, 24
	i32.add 	$9=, $12, $9
	i32.add 	$push17=, $9, $pop76
	i64.load	$push18=, 0($pop17)
	i32.const	$10=, 8
	i32.add 	$10=, $12, $10
	call    	__addtf3@FUNCTION, $10, $pop19, $pop18, $2, $3
	i32.const	$push24=, 0
	i64.load	$push22=, 8($12)
	i32.const	$push75=, 8
	i32.const	$11=, 8
	i32.add 	$11=, $12, $11
	i32.add 	$push20=, $11, $pop75
	i64.load	$push21=, 0($pop20)
	i32.call	$push23=, __fixtfsi@FUNCTION, $pop22, $pop21
	i32.store	$discard=, foo_arg($pop24), $pop23
	br      	1               # 1: down to label1
.LBB0_5:                                # %sw.bb5
	end_block                       # label2:
	i32.load	$push25=, 44($12)
	i32.const	$push26=, 7
	i32.add 	$push27=, $pop25, $pop26
	i32.const	$push28=, -8
	i32.and 	$push74=, $pop27, $pop28
	tee_local	$push73=, $0=, $pop74
	i32.const	$push72=, 8
	i32.add 	$push29=, $pop73, $pop72
	i32.store	$discard=, 44($12), $pop29
	i32.load	$1=, 0($0):p2align=3
	i32.const	$push30=, 15
	i32.add 	$push31=, $0, $pop30
	i32.const	$push71=, -8
	i32.and 	$push70=, $pop31, $pop71
	tee_local	$push69=, $0=, $pop70
	i32.const	$push68=, 8
	i32.add 	$push32=, $pop69, $pop68
	i32.store	$discard=, 44($12), $pop32
	i32.const	$push37=, 0
	f64.convert_s/i32	$push34=, $1
	f64.load	$push33=, 0($0)
	f64.add 	$push35=, $pop34, $pop33
	i32.trunc_s/f64	$push36=, $pop35
	i32.store	$discard=, foo_arg($pop37), $pop36
.LBB0_6:                                # %sw.epilog
	end_block                       # label1:
	i32.const	$7=, 48
	i32.add 	$12=, $12, $7
	i32.const	$7=, __stack_pointer
	i32.store	$12=, 0($7), $12
	return
.LBB0_7:                                # %sw.default
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
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
	block
	i32.const	$push0=, 16386
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label5
# BB#1:                                 # %if.then
	i32.const	$push24=, 0
	i32.const	$push23=, 0
	i32.load	$push2=, gap($pop23)
	i32.const	$push3=, 3
	i32.add 	$push4=, $pop2, $pop3
	i32.const	$push5=, -4
	i32.and 	$push22=, $pop4, $pop5
	tee_local	$push21=, $1=, $pop22
	i32.const	$push6=, 4
	i32.add 	$push7=, $pop21, $pop6
	i32.store	$discard=, gap($pop24), $pop7
	i32.load	$push8=, 0($1)
	i32.const	$push9=, 13
	i32.ne  	$push10=, $pop8, $pop9
	br_if   	1, $pop10       # 1: down to label4
# BB#2:                                 # %lor.lhs.false
	i32.const	$push28=, 0
	i32.const	$push27=, 0
	i32.load	$push11=, gap($pop27)
	i32.const	$push12=, 7
	i32.add 	$push13=, $pop11, $pop12
	i32.const	$push14=, -8
	i32.and 	$push26=, $pop13, $pop14
	tee_local	$push25=, $1=, $pop26
	i32.const	$push15=, 8
	i32.add 	$push16=, $pop25, $pop15
	i32.store	$discard=, gap($pop28), $pop16
	f64.load	$push17=, 0($1)
	f64.const	$push18=, -0x1.cp3
	f64.ne  	$push19=, $pop17, $pop18
	br_if   	1, $pop19       # 1: down to label4
.LBB1_3:                                # %if.end4
	end_block                       # label5:
	i32.const	$push20=, 0
	i32.store	$discard=, bar_arg($pop20), $0
	return
.LBB1_4:                                # %if.then3
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
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
	i32.and 	$push10=, $pop3, $pop4
	tee_local	$push9=, $1=, $pop10
	i32.const	$push5=, 4
	i32.add 	$push6=, $pop9, $pop5
	i32.store	$discard=, gap($pop0), $pop6
	i32.const	$push8=, 0
	i32.load	$push7=, 0($1)
	i32.store	$discard=, x($pop8), $pop7
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
	i32.const	$push21=, 0
	i32.store	$discard=, gap($pop21), $1
	block
	block
	i32.const	$push0=, 16386
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label7
# BB#1:                                 # %if.then.i
	i32.const	$push25=, 0
	i32.const	$push24=, 0
	i32.load	$push2=, gap($pop24)
	i32.const	$push3=, 3
	i32.add 	$push4=, $pop2, $pop3
	i32.const	$push5=, -4
	i32.and 	$push23=, $pop4, $pop5
	tee_local	$push22=, $1=, $pop23
	i32.const	$push6=, 4
	i32.add 	$push7=, $pop22, $pop6
	i32.store	$discard=, gap($pop25), $pop7
	i32.load	$push8=, 0($1)
	i32.const	$push9=, 13
	i32.ne  	$push10=, $pop8, $pop9
	br_if   	1, $pop10       # 1: down to label6
# BB#2:                                 # %lor.lhs.false.i
	i32.const	$push11=, 0
	i32.const	$push28=, 0
	i32.load	$push12=, gap($pop28)
	i32.const	$push13=, 7
	i32.add 	$push14=, $pop12, $pop13
	i32.const	$push15=, -8
	i32.and 	$push27=, $pop14, $pop15
	tee_local	$push26=, $1=, $pop27
	i32.const	$push16=, 8
	i32.add 	$push17=, $pop26, $pop16
	i32.store	$discard=, gap($pop11), $pop17
	f64.load	$push18=, 0($1)
	f64.const	$push19=, -0x1.cp3
	f64.ne  	$push20=, $pop18, $pop19
	br_if   	1, $pop20       # 1: down to label6
.LBB3_3:                                # %bar.exit
	end_block                       # label7:
	i32.const	$push29=, 0
	i32.store	$discard=, bar_arg($pop29), $0
	return
.LBB3_4:                                # %if.then3.i
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
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
	i32.and 	$push9=, $pop2, $pop3
	tee_local	$push8=, $1=, $pop9
	i32.const	$push4=, 4
	i32.add 	$push5=, $pop8, $pop4
	i32.store	$discard=, 16($5):p2align=4, $pop5
	i32.const	$push7=, 0
	i32.load	$push6=, 0($1)
	i32.store	$discard=, x($pop7), $pop6
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
	block
	i32.const	$push0=, 16386
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label9
# BB#1:                                 # %if.then.i
	i32.const	$push24=, 0
	i32.const	$push23=, 0
	i32.load	$push2=, gap($pop23)
	i32.const	$push3=, 3
	i32.add 	$push4=, $pop2, $pop3
	i32.const	$push5=, -4
	i32.and 	$push22=, $pop4, $pop5
	tee_local	$push21=, $1=, $pop22
	i32.const	$push6=, 4
	i32.add 	$push7=, $pop21, $pop6
	i32.store	$discard=, gap($pop24), $pop7
	i32.load	$push8=, 0($1)
	i32.const	$push9=, 13
	i32.ne  	$push10=, $pop8, $pop9
	br_if   	1, $pop10       # 1: down to label8
# BB#2:                                 # %lor.lhs.false.i
	i32.const	$push28=, 0
	i32.const	$push27=, 0
	i32.load	$push11=, gap($pop27)
	i32.const	$push12=, 7
	i32.add 	$push13=, $pop11, $pop12
	i32.const	$push14=, -8
	i32.and 	$push26=, $pop13, $pop14
	tee_local	$push25=, $1=, $pop26
	i32.const	$push15=, 8
	i32.add 	$push16=, $pop25, $pop15
	i32.store	$discard=, gap($pop28), $pop16
	f64.load	$push17=, 0($1)
	f64.const	$push18=, -0x1.cp3
	f64.ne  	$push19=, $pop17, $pop18
	br_if   	1, $pop19       # 1: down to label8
.LBB5_3:                                # %bar.exit
	end_block                       # label9:
	i32.const	$push20=, 0
	i32.store	$discard=, bar_arg($pop20), $0
	i32.const	$4=, 48
	i32.add 	$5=, $5, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
	return
.LBB5_4:                                # %if.then3.i
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end5:
	.size	f4, .Lfunc_end5-f4

	.section	.text.f5,"ax",@progbits
	.hidden	f5
	.globl	f5
	.type	f5,@function
f5:                                     # @f5
	.param  	i32, i32
	.local  	i64, i64, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 80
	i32.sub 	$10=, $5, $6
	i32.const	$6=, __stack_pointer
	i32.store	$10=, 0($6), $10
	i32.store	$push0=, 48($10):p2align=4, $1
	i32.store	$discard=, 76($10), $pop0
	block
	block
	block
	block
	i32.const	$push1=, 11
	i32.eq  	$push2=, $0, $pop1
	br_if   	0, $pop2        # 0: down to label13
# BB#1:                                 # %entry
	i32.const	$push60=, 8
	i32.eq  	$push3=, $0, $pop60
	br_if   	1, $pop3        # 1: down to label12
# BB#2:                                 # %entry
	i32.const	$push4=, 5
	i32.ne  	$push5=, $0, $pop4
	br_if   	3, $pop5        # 3: down to label10
# BB#3:                                 # %sw.bb.i
	i32.load	$push39=, 76($10)
	i32.const	$push40=, 3
	i32.add 	$push41=, $pop39, $pop40
	i32.const	$push42=, -4
	i32.and 	$push68=, $pop41, $pop42
	tee_local	$push67=, $0=, $pop68
	i32.const	$push43=, 4
	i32.add 	$push44=, $pop67, $pop43
	i32.store	$discard=, 76($10), $pop44
	i32.load	$1=, 0($0)
	i32.const	$push45=, 11
	i32.add 	$push46=, $0, $pop45
	i32.const	$push47=, -8
	i32.and 	$push66=, $pop46, $pop47
	tee_local	$push65=, $0=, $pop66
	i32.const	$push48=, 8
	i32.add 	$push49=, $pop65, $pop48
	i32.store	$discard=, 76($10), $pop49
	f64.convert_s/i32	$push51=, $1
	f64.load	$push50=, 0($0)
	f64.add 	$push52=, $pop51, $pop50
	i32.trunc_s/f64	$1=, $pop52
	i32.const	$push53=, 15
	i32.add 	$push54=, $0, $pop53
	i32.const	$push64=, -8
	i32.and 	$push63=, $pop54, $pop64
	tee_local	$push62=, $0=, $pop63
	i32.const	$push61=, 8
	i32.add 	$push55=, $pop62, $pop61
	i32.store	$discard=, 76($10), $pop55
	i32.const	$push59=, 0
	i64.extend_u/i32	$push57=, $1
	i64.load	$push56=, 0($0)
	i64.add 	$push58=, $pop57, $pop56
	i64.store32	$discard=, foo_arg($pop59), $pop58
	br      	2               # 2: down to label11
.LBB6_4:                                # %sw.bb10.i
	end_block                       # label13:
	i32.load	$push6=, 76($10)
	i32.const	$push7=, 3
	i32.add 	$push8=, $pop6, $pop7
	i32.const	$push9=, -4
	i32.and 	$push82=, $pop8, $pop9
	tee_local	$push81=, $0=, $pop82
	i32.const	$push10=, 4
	i32.add 	$push11=, $pop81, $pop10
	i32.store	$discard=, 76($10), $pop11
	i32.load	$1=, 0($0)
	i32.const	$push12=, 19
	i32.add 	$push13=, $0, $pop12
	i32.const	$push14=, -16
	i32.and 	$push80=, $pop13, $pop14
	tee_local	$push79=, $4=, $pop80
	i32.const	$push15=, 8
	i32.or  	$push16=, $pop79, $pop15
	i32.store	$0=, 76($10), $pop16
	i64.load	$2=, 0($4)
	i32.const	$push78=, 8
	i32.add 	$push17=, $0, $pop78
	i32.store	$discard=, 76($10), $pop17
	i64.load	$3=, 0($0)
	i32.const	$8=, 16
	i32.add 	$8=, $10, $8
	call    	__floatsitf@FUNCTION, $8, $1
	i64.load	$push20=, 16($10)
	i32.const	$push77=, 8
	i32.const	$9=, 16
	i32.add 	$9=, $10, $9
	i32.add 	$push18=, $9, $pop77
	i64.load	$push19=, 0($pop18)
	call    	__addtf3@FUNCTION, $10, $pop20, $pop19, $2, $3
	i32.const	$push25=, 0
	i64.load	$push23=, 0($10)
	i32.const	$push76=, 8
	i32.add 	$push21=, $10, $pop76
	i64.load	$push22=, 0($pop21)
	i32.call	$push24=, __fixtfsi@FUNCTION, $pop23, $pop22
	i32.store	$discard=, foo_arg($pop25), $pop24
	br      	1               # 1: down to label11
.LBB6_5:                                # %sw.bb5.i
	end_block                       # label12:
	i32.load	$push26=, 76($10)
	i32.const	$push27=, 7
	i32.add 	$push28=, $pop26, $pop27
	i32.const	$push29=, -8
	i32.and 	$push75=, $pop28, $pop29
	tee_local	$push74=, $0=, $pop75
	i32.const	$push73=, 8
	i32.add 	$push30=, $pop74, $pop73
	i32.store	$discard=, 76($10), $pop30
	i32.load	$1=, 0($0):p2align=3
	i32.const	$push31=, 15
	i32.add 	$push32=, $0, $pop31
	i32.const	$push72=, -8
	i32.and 	$push71=, $pop32, $pop72
	tee_local	$push70=, $0=, $pop71
	i32.const	$push69=, 8
	i32.add 	$push33=, $pop70, $pop69
	i32.store	$discard=, 76($10), $pop33
	i32.const	$push38=, 0
	f64.load	$push34=, 0($0)
	f64.convert_s/i32	$push35=, $1
	f64.add 	$push36=, $pop34, $pop35
	i32.trunc_s/f64	$push37=, $pop36
	i32.store	$discard=, foo_arg($pop38), $pop37
.LBB6_6:                                # %foo.exit
	end_block                       # label11:
	i32.const	$7=, 80
	i32.add 	$10=, $10, $7
	i32.const	$7=, __stack_pointer
	i32.store	$10=, 0($7), $10
	return
.LBB6_7:                                # %sw.default.i
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
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
	i32.and 	$push10=, $pop3, $pop4
	tee_local	$push9=, $1=, $pop10
	i32.const	$push8=, 4
	i32.add 	$push5=, $pop9, $pop8
	i32.store	$discard=, 0($2), $pop5
	i32.const	$push7=, 0
	i32.load	$push6=, 0($1)
	i32.store	$discard=, x($pop7), $pop6
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
	i32.const	$push21=, 4
	i32.or  	$push0=, $5, $pop21
	i32.store	$discard=, 0($pop0), $1
	block
	block
	i32.const	$push1=, 16386
	i32.ne  	$push2=, $0, $pop1
	br_if   	0, $pop2        # 0: down to label15
# BB#1:                                 # %if.then.i
	i32.const	$push26=, 0
	i32.const	$push25=, 0
	i32.load	$push3=, gap($pop25)
	i32.const	$push4=, 3
	i32.add 	$push5=, $pop3, $pop4
	i32.const	$push6=, -4
	i32.and 	$push24=, $pop5, $pop6
	tee_local	$push23=, $1=, $pop24
	i32.const	$push22=, 4
	i32.add 	$push7=, $pop23, $pop22
	i32.store	$discard=, gap($pop26), $pop7
	i32.load	$push8=, 0($1)
	i32.const	$push9=, 13
	i32.ne  	$push10=, $pop8, $pop9
	br_if   	1, $pop10       # 1: down to label14
# BB#2:                                 # %lor.lhs.false.i
	i32.const	$push30=, 0
	i32.const	$push29=, 0
	i32.load	$push11=, gap($pop29)
	i32.const	$push12=, 7
	i32.add 	$push13=, $pop11, $pop12
	i32.const	$push14=, -8
	i32.and 	$push28=, $pop13, $pop14
	tee_local	$push27=, $1=, $pop28
	i32.const	$push15=, 8
	i32.add 	$push16=, $pop27, $pop15
	i32.store	$discard=, gap($pop30), $pop16
	f64.load	$push17=, 0($1)
	f64.const	$push18=, -0x1.cp3
	f64.ne  	$push19=, $pop17, $pop18
	br_if   	1, $pop19       # 1: down to label14
.LBB8_3:                                # %bar.exit
	end_block                       # label15:
	i32.const	$push20=, 0
	i32.store	$discard=, bar_arg($pop20), $0
	i32.const	$4=, 16
	i32.add 	$5=, $5, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
	return
.LBB8_4:                                # %if.then3.i
	end_block                       # label14:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end8:
	.size	f7, .Lfunc_end8-f7

	.section	.text.f8,"ax",@progbits
	.hidden	f8
	.globl	f8
	.type	f8,@function
f8:                                     # @f8
	.param  	i32, i32
	.local  	i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 64
	i32.sub 	$13=, $5, $6
	i32.const	$6=, __stack_pointer
	i32.store	$13=, 0($6), $13
	i32.const	$push60=, 4
	i32.const	$8=, 40
	i32.add 	$8=, $13, $8
	i32.or  	$push0=, $8, $pop60
	i32.store	$push1=, 0($pop0), $1
	i32.store	$discard=, 60($13), $pop1
	block
	block
	block
	block
	i32.const	$push2=, 11
	i32.eq  	$push3=, $0, $pop2
	br_if   	0, $pop3        # 0: down to label19
# BB#1:                                 # %entry
	i32.const	$push61=, 8
	i32.eq  	$push4=, $0, $pop61
	br_if   	1, $pop4        # 1: down to label18
# BB#2:                                 # %entry
	i32.const	$push5=, 5
	i32.ne  	$push6=, $0, $pop5
	br_if   	3, $pop6        # 3: down to label16
# BB#3:                                 # %sw.bb.i
	i32.load	$push39=, 60($13)
	i32.const	$push40=, 3
	i32.add 	$push41=, $pop39, $pop40
	i32.const	$push42=, -4
	i32.and 	$push69=, $pop41, $pop42
	tee_local	$push68=, $0=, $pop69
	i32.const	$push43=, 4
	i32.add 	$push44=, $pop68, $pop43
	i32.store	$discard=, 60($13), $pop44
	i32.load	$1=, 0($0)
	i32.const	$push45=, 11
	i32.add 	$push46=, $0, $pop45
	i32.const	$push47=, -8
	i32.and 	$push67=, $pop46, $pop47
	tee_local	$push66=, $0=, $pop67
	i32.const	$push48=, 8
	i32.add 	$push49=, $pop66, $pop48
	i32.store	$discard=, 60($13), $pop49
	f64.convert_s/i32	$push51=, $1
	f64.load	$push50=, 0($0)
	f64.add 	$push52=, $pop51, $pop50
	i32.trunc_s/f64	$1=, $pop52
	i32.const	$push53=, 15
	i32.add 	$push54=, $0, $pop53
	i32.const	$push65=, -8
	i32.and 	$push64=, $pop54, $pop65
	tee_local	$push63=, $0=, $pop64
	i32.const	$push62=, 8
	i32.add 	$push55=, $pop63, $pop62
	i32.store	$discard=, 60($13), $pop55
	i32.const	$push59=, 0
	i64.extend_u/i32	$push57=, $1
	i64.load	$push56=, 0($0)
	i64.add 	$push58=, $pop57, $pop56
	i64.store32	$discard=, foo_arg($pop59), $pop58
	br      	2               # 2: down to label17
.LBB9_4:                                # %sw.bb10.i
	end_block                       # label19:
	i32.load	$push7=, 60($13)
	i32.const	$push8=, 3
	i32.add 	$push9=, $pop7, $pop8
	i32.const	$push10=, -4
	i32.and 	$push84=, $pop9, $pop10
	tee_local	$push83=, $0=, $pop84
	i32.const	$push82=, 4
	i32.add 	$push11=, $pop83, $pop82
	i32.store	$discard=, 60($13), $pop11
	i32.load	$1=, 0($0)
	i32.const	$push12=, 19
	i32.add 	$push13=, $0, $pop12
	i32.const	$push14=, -16
	i32.and 	$push81=, $pop13, $pop14
	tee_local	$push80=, $4=, $pop81
	i32.const	$push15=, 8
	i32.or  	$push16=, $pop80, $pop15
	i32.store	$0=, 60($13), $pop16
	i64.load	$2=, 0($4)
	i32.const	$push79=, 8
	i32.add 	$push17=, $0, $pop79
	i32.store	$discard=, 60($13), $pop17
	i64.load	$3=, 0($0)
	i32.const	$9=, 24
	i32.add 	$9=, $13, $9
	call    	__floatsitf@FUNCTION, $9, $1
	i64.load	$push20=, 24($13)
	i32.const	$push78=, 8
	i32.const	$10=, 24
	i32.add 	$10=, $13, $10
	i32.add 	$push18=, $10, $pop78
	i64.load	$push19=, 0($pop18)
	i32.const	$11=, 8
	i32.add 	$11=, $13, $11
	call    	__addtf3@FUNCTION, $11, $pop20, $pop19, $2, $3
	i32.const	$push25=, 0
	i64.load	$push23=, 8($13)
	i32.const	$push77=, 8
	i32.const	$12=, 8
	i32.add 	$12=, $13, $12
	i32.add 	$push21=, $12, $pop77
	i64.load	$push22=, 0($pop21)
	i32.call	$push24=, __fixtfsi@FUNCTION, $pop23, $pop22
	i32.store	$discard=, foo_arg($pop25), $pop24
	br      	1               # 1: down to label17
.LBB9_5:                                # %sw.bb5.i
	end_block                       # label18:
	i32.load	$push26=, 60($13)
	i32.const	$push27=, 7
	i32.add 	$push28=, $pop26, $pop27
	i32.const	$push29=, -8
	i32.and 	$push76=, $pop28, $pop29
	tee_local	$push75=, $0=, $pop76
	i32.const	$push74=, 8
	i32.add 	$push30=, $pop75, $pop74
	i32.store	$discard=, 60($13), $pop30
	i32.load	$1=, 0($0):p2align=3
	i32.const	$push31=, 15
	i32.add 	$push32=, $0, $pop31
	i32.const	$push73=, -8
	i32.and 	$push72=, $pop32, $pop73
	tee_local	$push71=, $0=, $pop72
	i32.const	$push70=, 8
	i32.add 	$push33=, $pop71, $pop70
	i32.store	$discard=, 60($13), $pop33
	i32.const	$push38=, 0
	f64.load	$push34=, 0($0)
	f64.convert_s/i32	$push35=, $1
	f64.add 	$push36=, $pop34, $pop35
	i32.trunc_s/f64	$push37=, $pop36
	i32.store	$discard=, foo_arg($pop38), $pop37
.LBB9_6:                                # %foo.exit
	end_block                       # label17:
	i32.const	$7=, 64
	i32.add 	$13=, $13, $7
	i32.const	$7=, __stack_pointer
	i32.store	$13=, 0($7), $13
	return
.LBB9_7:                                # %sw.default.i
	end_block                       # label16:
	call    	abort@FUNCTION
	unreachable
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
	i32.and 	$push10=, $pop3, $pop4
	tee_local	$push9=, $1=, $pop10
	i32.const	$push5=, 4
	i32.add 	$push6=, $pop9, $pop5
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
	block
	i32.const	$push2=, 16386
	i32.ne  	$push3=, $0, $pop2
	br_if   	0, $pop3        # 0: down to label21
# BB#1:                                 # %if.then.i
	i32.const	$push26=, 0
	i32.const	$push25=, 0
	i32.load	$push4=, gap($pop25)
	i32.const	$push5=, 3
	i32.add 	$push6=, $pop4, $pop5
	i32.const	$push7=, -4
	i32.and 	$push24=, $pop6, $pop7
	tee_local	$push23=, $1=, $pop24
	i32.const	$push8=, 4
	i32.add 	$push9=, $pop23, $pop8
	i32.store	$discard=, gap($pop26), $pop9
	i32.load	$push10=, 0($1)
	i32.const	$push11=, 13
	i32.ne  	$push12=, $pop10, $pop11
	br_if   	1, $pop12       # 1: down to label20
# BB#2:                                 # %lor.lhs.false.i
	i32.const	$push30=, 0
	i32.const	$push29=, 0
	i32.load	$push13=, gap($pop29)
	i32.const	$push14=, 7
	i32.add 	$push15=, $pop13, $pop14
	i32.const	$push16=, -8
	i32.and 	$push28=, $pop15, $pop16
	tee_local	$push27=, $1=, $pop28
	i32.const	$push17=, 8
	i32.add 	$push18=, $pop27, $pop17
	i32.store	$discard=, gap($pop30), $pop18
	f64.load	$push19=, 0($1)
	f64.const	$push20=, -0x1.cp3
	f64.ne  	$push21=, $pop19, $pop20
	br_if   	1, $pop21       # 1: down to label20
.LBB11_3:                               # %bar.exit
	end_block                       # label21:
	i32.const	$push22=, 0
	i32.store	$discard=, bar_arg($pop22), $0
	i32.const	$4=, 16
	i32.add 	$5=, $5, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
	return
.LBB11_4:                               # %if.then3.i
	end_block                       # label20:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end11:
	.size	f11, .Lfunc_end11-f11

	.section	.text.f12,"ax",@progbits
	.hidden	f12
	.globl	f12
	.type	f12,@function
f12:                                    # @f12
	.param  	i32, i32
	.local  	i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 64
	i32.sub 	$13=, $5, $6
	i32.const	$6=, __stack_pointer
	i32.store	$13=, 0($6), $13
	i32.const	$push1=, 12
	i32.const	$8=, 40
	i32.add 	$8=, $13, $8
	i32.add 	$push0=, $8, $pop1
	i32.store	$push2=, 0($pop0), $1
	i32.store	$discard=, 60($13), $pop2
	block
	block
	block
	block
	i32.const	$push3=, 11
	i32.eq  	$push4=, $0, $pop3
	br_if   	0, $pop4        # 0: down to label25
# BB#1:                                 # %entry
	i32.const	$push62=, 8
	i32.eq  	$push5=, $0, $pop62
	br_if   	1, $pop5        # 1: down to label24
# BB#2:                                 # %entry
	i32.const	$push6=, 5
	i32.ne  	$push7=, $0, $pop6
	br_if   	3, $pop7        # 3: down to label22
# BB#3:                                 # %sw.bb.i
	i32.load	$push41=, 60($13)
	i32.const	$push42=, 3
	i32.add 	$push43=, $pop41, $pop42
	i32.const	$push44=, -4
	i32.and 	$push70=, $pop43, $pop44
	tee_local	$push69=, $0=, $pop70
	i32.const	$push45=, 4
	i32.add 	$push46=, $pop69, $pop45
	i32.store	$discard=, 60($13), $pop46
	i32.load	$1=, 0($0)
	i32.const	$push47=, 11
	i32.add 	$push48=, $0, $pop47
	i32.const	$push49=, -8
	i32.and 	$push68=, $pop48, $pop49
	tee_local	$push67=, $0=, $pop68
	i32.const	$push50=, 8
	i32.add 	$push51=, $pop67, $pop50
	i32.store	$discard=, 60($13), $pop51
	f64.convert_s/i32	$push53=, $1
	f64.load	$push52=, 0($0)
	f64.add 	$push54=, $pop53, $pop52
	i32.trunc_s/f64	$1=, $pop54
	i32.const	$push55=, 15
	i32.add 	$push56=, $0, $pop55
	i32.const	$push66=, -8
	i32.and 	$push65=, $pop56, $pop66
	tee_local	$push64=, $0=, $pop65
	i32.const	$push63=, 8
	i32.add 	$push57=, $pop64, $pop63
	i32.store	$discard=, 60($13), $pop57
	i32.const	$push61=, 0
	i64.extend_u/i32	$push59=, $1
	i64.load	$push58=, 0($0)
	i64.add 	$push60=, $pop59, $pop58
	i64.store32	$discard=, foo_arg($pop61), $pop60
	br      	2               # 2: down to label23
.LBB12_4:                               # %sw.bb10.i
	end_block                       # label25:
	i32.load	$push8=, 60($13)
	i32.const	$push9=, 3
	i32.add 	$push10=, $pop8, $pop9
	i32.const	$push11=, -4
	i32.and 	$push84=, $pop10, $pop11
	tee_local	$push83=, $0=, $pop84
	i32.const	$push12=, 4
	i32.add 	$push13=, $pop83, $pop12
	i32.store	$discard=, 60($13), $pop13
	i32.load	$1=, 0($0)
	i32.const	$push14=, 19
	i32.add 	$push15=, $0, $pop14
	i32.const	$push16=, -16
	i32.and 	$push82=, $pop15, $pop16
	tee_local	$push81=, $4=, $pop82
	i32.const	$push17=, 8
	i32.or  	$push18=, $pop81, $pop17
	i32.store	$0=, 60($13), $pop18
	i64.load	$2=, 0($4)
	i32.const	$push80=, 8
	i32.add 	$push19=, $0, $pop80
	i32.store	$discard=, 60($13), $pop19
	i64.load	$3=, 0($0)
	i32.const	$9=, 24
	i32.add 	$9=, $13, $9
	call    	__floatsitf@FUNCTION, $9, $1
	i64.load	$push22=, 24($13)
	i32.const	$push79=, 8
	i32.const	$10=, 24
	i32.add 	$10=, $13, $10
	i32.add 	$push20=, $10, $pop79
	i64.load	$push21=, 0($pop20)
	i32.const	$11=, 8
	i32.add 	$11=, $13, $11
	call    	__addtf3@FUNCTION, $11, $pop22, $pop21, $2, $3
	i32.const	$push27=, 0
	i64.load	$push25=, 8($13)
	i32.const	$push78=, 8
	i32.const	$12=, 8
	i32.add 	$12=, $13, $12
	i32.add 	$push23=, $12, $pop78
	i64.load	$push24=, 0($pop23)
	i32.call	$push26=, __fixtfsi@FUNCTION, $pop25, $pop24
	i32.store	$discard=, foo_arg($pop27), $pop26
	br      	1               # 1: down to label23
.LBB12_5:                               # %sw.bb5.i
	end_block                       # label24:
	i32.load	$push28=, 60($13)
	i32.const	$push29=, 7
	i32.add 	$push30=, $pop28, $pop29
	i32.const	$push31=, -8
	i32.and 	$push77=, $pop30, $pop31
	tee_local	$push76=, $0=, $pop77
	i32.const	$push75=, 8
	i32.add 	$push32=, $pop76, $pop75
	i32.store	$discard=, 60($13), $pop32
	i32.load	$1=, 0($0):p2align=3
	i32.const	$push33=, 15
	i32.add 	$push34=, $0, $pop33
	i32.const	$push74=, -8
	i32.and 	$push73=, $pop34, $pop74
	tee_local	$push72=, $0=, $pop73
	i32.const	$push71=, 8
	i32.add 	$push35=, $pop72, $pop71
	i32.store	$discard=, 60($13), $pop35
	i32.const	$push40=, 0
	f64.load	$push36=, 0($0)
	f64.convert_s/i32	$push37=, $1
	f64.add 	$push38=, $pop36, $pop37
	i32.trunc_s/f64	$push39=, $pop38
	i32.store	$discard=, foo_arg($pop40), $pop39
.LBB12_6:                               # %foo.exit
	end_block                       # label23:
	i32.const	$7=, 64
	i32.add 	$13=, $13, $7
	i32.const	$7=, __stack_pointer
	i32.store	$13=, 0($7), $13
	return
.LBB12_7:                               # %sw.default.i
	end_block                       # label22:
	call    	abort@FUNCTION
	unreachable
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
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	i32.const	$push58=, 0
	i32.load	$push1=, x($pop58)
	i32.ne  	$push2=, $0, $pop1
	br_if   	0, $pop2        # 0: down to label36
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
	i32.const	$push60=, 0
	i32.load	$push8=, bar_arg($pop60)
	i32.const	$push59=, 16386
	i32.ne  	$push9=, $pop8, $pop59
	br_if   	1, $pop9        # 1: down to label35
# BB#2:                                 # %if.end3
	i32.const	$push10=, 2031
	i32.store	$0=, 128($16):p2align=4, $pop10
	i32.const	$7=, 128
	i32.add 	$7=, $16, $7
	call    	f3@FUNCTION, $0, $7
	i32.const	$push61=, 0
	i32.load	$push11=, x($pop61)
	i32.ne  	$push12=, $0, $pop11
	br_if   	2, $pop12       # 2: down to label34
# BB#3:                                 # %if.end6
	i32.const	$push13=, 18
	i32.store	$discard=, 112($16):p2align=4, $pop13
	i32.const	$push14=, 4
	i32.const	$8=, 112
	i32.add 	$8=, $16, $8
	call    	f4@FUNCTION, $pop14, $8
	i32.const	$push63=, 0
	i32.load	$push15=, bar_arg($pop63)
	i32.const	$push62=, 4
	i32.ne  	$push16=, $pop15, $pop62
	br_if   	3, $pop16       # 3: down to label33
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
	i32.const	$push64=, 0
	i32.load	$push25=, foo_arg($pop64)
	i32.const	$push26=, 38
	i32.ne  	$push27=, $pop25, $pop26
	br_if   	4, $pop27       # 4: down to label32
# BB#5:                                 # %if.end12
	i32.const	$push28=, 18
	i32.store	$0=, 64($16):p2align=4, $pop28
	i32.const	$12=, 64
	i32.add 	$12=, $16, $12
	call    	f6@FUNCTION, $0, $12
	i32.const	$push65=, 0
	i32.load	$push29=, x($pop65)
	i32.ne  	$push30=, $0, $pop29
	br_if   	5, $pop30       # 5: down to label31
# BB#6:                                 # %if.end15
	i32.const	$push31=, 7
	i32.const	$push68=, 0
	call    	f7@FUNCTION, $pop31, $pop68
	i32.const	$push67=, 0
	i32.load	$push32=, bar_arg($pop67)
	i32.const	$push66=, 7
	i32.ne  	$push33=, $pop32, $pop66
	br_if   	6, $pop33       # 6: down to label30
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
	i32.const	$push69=, 0
	i32.load	$push38=, foo_arg($pop69)
	i32.const	$push39=, 2044
	i32.ne  	$push40=, $pop38, $pop39
	br_if   	7, $pop40       # 7: down to label29
# BB#8:                                 # %if.end21
	i32.const	$push41=, 180
	i32.store	$0=, 32($16):p2align=4, $pop41
	i32.const	$15=, 32
	i32.add 	$15=, $16, $15
	call    	f10@FUNCTION, $0, $15
	i32.const	$push71=, 0
	i32.load	$push42=, x($pop71)
	i32.ne  	$push43=, $0, $pop42
	br_if   	8, $pop43       # 8: down to label28
# BB#9:                                 # %if.end24
	i32.const	$push44=, 10
	i32.const	$push74=, 0
	call    	f11@FUNCTION, $pop44, $pop74
	i32.const	$push73=, 0
	i32.load	$push45=, bar_arg($pop73)
	i32.const	$push72=, 10
	i32.ne  	$push46=, $pop45, $pop72
	br_if   	9, $pop46       # 9: down to label27
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
	i32.const	$push75=, 0
	i32.load	$push55=, foo_arg($pop75)
	i32.const	$push56=, 2042
	i32.ne  	$push57=, $pop55, $pop56
	br_if   	10, $pop57      # 10: down to label26
# BB#11:                                # %if.end30
	i32.const	$push76=, 0
	i32.const	$3=, 176
	i32.add 	$16=, $16, $3
	i32.const	$3=, __stack_pointer
	i32.store	$16=, 0($3), $16
	return  	$pop76
.LBB13_12:                              # %if.then
	end_block                       # label36:
	call    	abort@FUNCTION
	unreachable
.LBB13_13:                              # %if.then2
	end_block                       # label35:
	call    	abort@FUNCTION
	unreachable
.LBB13_14:                              # %if.then5
	end_block                       # label34:
	call    	abort@FUNCTION
	unreachable
.LBB13_15:                              # %if.then8
	end_block                       # label33:
	call    	abort@FUNCTION
	unreachable
.LBB13_16:                              # %if.then11
	end_block                       # label32:
	call    	abort@FUNCTION
	unreachable
.LBB13_17:                              # %if.then14
	end_block                       # label31:
	call    	abort@FUNCTION
	unreachable
.LBB13_18:                              # %if.then17
	end_block                       # label30:
	call    	abort@FUNCTION
	unreachable
.LBB13_19:                              # %if.then20
	end_block                       # label29:
	call    	abort@FUNCTION
	unreachable
.LBB13_20:                              # %if.then23
	end_block                       # label28:
	call    	abort@FUNCTION
	unreachable
.LBB13_21:                              # %if.then26
	end_block                       # label27:
	call    	abort@FUNCTION
	unreachable
.LBB13_22:                              # %if.then29
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
