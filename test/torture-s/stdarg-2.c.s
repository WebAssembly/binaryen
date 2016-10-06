	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/stdarg-2.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push41=, 0
	i32.const	$push38=, 0
	i32.load	$push39=, __stack_pointer($pop38)
	i32.const	$push40=, 32
	i32.sub 	$push50=, $pop39, $pop40
	tee_local	$push49=, $2=, $pop50
	i32.store	__stack_pointer($pop41), $pop49
	block   	
	block   	
	block   	
	block   	
	i32.const	$push0=, 11
	i32.eq  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label3
# BB#1:                                 # %entry
	i32.const	$push2=, 8
	i32.eq  	$push3=, $0, $pop2
	br_if   	1, $pop3        # 1: down to label2
# BB#2:                                 # %entry
	i32.const	$push4=, 5
	i32.ne  	$push5=, $0, $pop4
	br_if   	3, $pop5        # 3: down to label0
# BB#3:                                 # %sw.bb
	i32.const	$push33=, 0
	i32.load	$push30=, 0($1)
	f64.convert_s/i32	$push31=, $pop30
	i32.const	$push26=, 11
	i32.add 	$push27=, $1, $pop26
	i32.const	$push28=, -8
	i32.and 	$push54=, $pop27, $pop28
	tee_local	$push53=, $0=, $pop54
	f64.load	$push29=, 0($pop53)
	f64.add 	$push32=, $pop31, $pop29
	i32.trunc_s/f64	$push52=, $pop32
	tee_local	$push51=, $1=, $pop52
	i32.store	foo_arg($pop33), $pop51
	i64.extend_u/i32	$push35=, $1
	i64.load	$push34=, 8($0)
	i64.add 	$push36=, $pop35, $pop34
	i32.wrap/i64	$0=, $pop36
	br      	2               # 2: down to label1
.LBB0_4:                                # %sw.bb18
	end_block                       # label3:
	i32.const	$push45=, 16
	i32.add 	$push46=, $2, $pop45
	i32.load	$push59=, 0($1)
	tee_local	$push58=, $0=, $pop59
	call    	__floatsitf@FUNCTION, $pop46, $pop58
	i64.load	$push14=, 16($2)
	i32.const	$push47=, 16
	i32.add 	$push48=, $2, $pop47
	i32.const	$push11=, 8
	i32.add 	$push12=, $pop48, $pop11
	i64.load	$push13=, 0($pop12)
	i32.const	$push6=, 19
	i32.add 	$push7=, $1, $pop6
	i32.const	$push8=, -16
	i32.and 	$push57=, $pop7, $pop8
	tee_local	$push56=, $1=, $pop57
	i64.load	$push10=, 0($pop56)
	i64.load	$push9=, 8($1)
	call    	__addtf3@FUNCTION, $2, $pop14, $pop13, $pop10, $pop9
	i32.const	$push15=, 0
	i32.store	foo_arg($pop15), $0
	i64.load	$push18=, 0($2)
	i32.const	$push55=, 8
	i32.add 	$push16=, $2, $pop55
	i64.load	$push17=, 0($pop16)
	i32.call	$0=, __fixtfsi@FUNCTION, $pop18, $pop17
	br      	1               # 1: down to label1
.LBB0_5:                                # %sw.bb9
	end_block                       # label2:
	i32.const	$push22=, 0
	i32.const	$push19=, 7
	i32.add 	$push20=, $1, $pop19
	i32.const	$push21=, -8
	i32.and 	$push63=, $pop20, $pop21
	tee_local	$push62=, $0=, $pop63
	i32.load	$push61=, 0($pop62)
	tee_local	$push60=, $1=, $pop61
	i32.store	foo_arg($pop22), $pop60
	f64.convert_s/i32	$push24=, $1
	f64.load	$push23=, 8($0)
	f64.add 	$push25=, $pop24, $pop23
	i32.trunc_s/f64	$0=, $pop25
.LBB0_6:                                # %sw.epilog
	end_block                       # label1:
	i32.const	$push37=, 0
	i32.store	foo_arg($pop37), $0
	i32.const	$push44=, 0
	i32.const	$push42=, 32
	i32.add 	$push43=, $2, $pop42
	i32.store	__stack_pointer($pop44), $pop43
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
	.local  	i32, i32
# BB#0:                                 # %entry
	block   	
	block   	
	i32.const	$push0=, 16386
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label5
# BB#1:                                 # %if.then
	i32.const	$push20=, 0
	i32.const	$push19=, 0
	i32.load	$push18=, gap($pop19)
	tee_local	$push17=, $2=, $pop18
	i32.const	$push2=, 4
	i32.add 	$push16=, $pop17, $pop2
	tee_local	$push15=, $1=, $pop16
	i32.store	gap($pop20), $pop15
	i32.load	$push3=, 0($2)
	i32.const	$push4=, 13
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	1, $pop5        # 1: down to label4
# BB#2:                                 # %lor.lhs.false
	i32.const	$push23=, 0
	i32.const	$push6=, 7
	i32.add 	$push7=, $1, $pop6
	i32.const	$push8=, -8
	i32.and 	$push22=, $pop7, $pop8
	tee_local	$push21=, $2=, $pop22
	i32.const	$push9=, 8
	i32.add 	$push10=, $pop21, $pop9
	i32.store	gap($pop23), $pop10
	f64.load	$push11=, 0($2)
	f64.const	$push12=, -0x1.cp3
	f64.ne  	$push13=, $pop11, $pop12
	br_if   	1, $pop13       # 1: down to label4
.LBB1_3:                                # %if.end6
	end_block                       # label5:
	i32.const	$push14=, 0
	i32.store	bar_arg($pop14), $0
	return
.LBB1_4:                                # %if.then5
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
	i32.store	gap($pop0), $1
	i32.const	$push5=, 0
	i32.const	$push1=, 4
	i32.add 	$push2=, $1, $pop1
	i32.store	gap($pop5), $pop2
	i32.const	$push4=, 0
	i32.load	$push3=, 0($1)
	i32.store	x($pop4), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	f1, .Lfunc_end2-f1

	.section	.text.f2,"ax",@progbits
	.hidden	f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push15=, 0
	i32.store	gap($pop15), $1
	block   	
	block   	
	i32.const	$push0=, 16386
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label7
# BB#1:                                 # %if.then.i
	i32.const	$push21=, 0
	i32.const	$push20=, 0
	i32.load	$push19=, gap($pop20)
	tee_local	$push18=, $1=, $pop19
	i32.const	$push2=, 4
	i32.add 	$push17=, $pop18, $pop2
	tee_local	$push16=, $2=, $pop17
	i32.store	gap($pop21), $pop16
	i32.load	$push3=, 0($1)
	i32.const	$push4=, 13
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	1, $pop5        # 1: down to label6
# BB#2:                                 # %lor.lhs.false.i
	i32.const	$push11=, 0
	i32.const	$push6=, 7
	i32.add 	$push7=, $2, $pop6
	i32.const	$push8=, -8
	i32.and 	$push23=, $pop7, $pop8
	tee_local	$push22=, $1=, $pop23
	i32.const	$push9=, 8
	i32.add 	$push10=, $pop22, $pop9
	i32.store	gap($pop11), $pop10
	f64.load	$push12=, 0($1)
	f64.const	$push13=, -0x1.cp3
	f64.ne  	$push14=, $pop12, $pop13
	br_if   	1, $pop14       # 1: down to label6
.LBB3_3:                                # %bar.exit
	end_block                       # label7:
	i32.const	$push24=, 0
	i32.store	bar_arg($pop24), $0
	return
.LBB3_4:                                # %if.then5.i
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push4=, 0
	i32.load	$push5=, __stack_pointer($pop4)
	i32.const	$push6=, 48
	i32.sub 	$push8=, $pop5, $pop6
	tee_local	$push7=, $2=, $pop8
	i32.store	16($pop7), $1
	i32.const	$push0=, 4
	i32.add 	$push1=, $1, $pop0
	i32.store	16($2), $pop1
	i32.const	$push3=, 0
	i32.load	$push2=, 0($1)
	i32.store	x($pop3), $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end4:
	.size	f3, .Lfunc_end4-f3

	.section	.text.f4,"ax",@progbits
	.hidden	f4
	.globl	f4
	.type	f4,@function
f4:                                     # @f4
	.param  	i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push18=, 0
	i32.const	$push15=, 0
	i32.load	$push16=, __stack_pointer($pop15)
	i32.const	$push17=, 48
	i32.sub 	$push23=, $pop16, $pop17
	tee_local	$push22=, $3=, $pop23
	i32.store	__stack_pointer($pop18), $pop22
	i32.store	16($3), $1
	block   	
	block   	
	i32.const	$push0=, 16386
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label9
# BB#1:                                 # %if.then.i
	i32.const	$push29=, 0
	i32.const	$push28=, 0
	i32.load	$push27=, gap($pop28)
	tee_local	$push26=, $1=, $pop27
	i32.const	$push2=, 4
	i32.add 	$push25=, $pop26, $pop2
	tee_local	$push24=, $2=, $pop25
	i32.store	gap($pop29), $pop24
	i32.load	$push3=, 0($1)
	i32.const	$push4=, 13
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	1, $pop5        # 1: down to label8
# BB#2:                                 # %lor.lhs.false.i
	i32.const	$push32=, 0
	i32.const	$push6=, 7
	i32.add 	$push7=, $2, $pop6
	i32.const	$push8=, -8
	i32.and 	$push31=, $pop7, $pop8
	tee_local	$push30=, $1=, $pop31
	i32.const	$push9=, 8
	i32.add 	$push10=, $pop30, $pop9
	i32.store	gap($pop32), $pop10
	f64.load	$push11=, 0($1)
	f64.const	$push12=, -0x1.cp3
	f64.ne  	$push13=, $pop11, $pop12
	br_if   	1, $pop13       # 1: down to label8
.LBB5_3:                                # %bar.exit
	end_block                       # label9:
	i32.const	$push14=, 0
	i32.store	bar_arg($pop14), $0
	i32.const	$push21=, 0
	i32.const	$push19=, 48
	i32.add 	$push20=, $3, $pop19
	i32.store	__stack_pointer($pop21), $pop20
	return
.LBB5_4:                                # %if.then5.i
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push41=, 0
	i32.const	$push38=, 0
	i32.load	$push39=, __stack_pointer($pop38)
	i32.const	$push40=, 80
	i32.sub 	$push50=, $pop39, $pop40
	tee_local	$push49=, $2=, $pop50
	i32.store	__stack_pointer($pop41), $pop49
	i32.store	48($2), $1
	block   	
	block   	
	block   	
	block   	
	i32.const	$push0=, 11
	i32.eq  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label13
# BB#1:                                 # %entry
	i32.const	$push2=, 8
	i32.eq  	$push3=, $0, $pop2
	br_if   	1, $pop3        # 1: down to label12
# BB#2:                                 # %entry
	i32.const	$push4=, 5
	i32.ne  	$push5=, $0, $pop4
	br_if   	3, $pop5        # 3: down to label10
# BB#3:                                 # %sw.bb.i
	i32.const	$push33=, 0
	i32.load	$push30=, 0($1)
	f64.convert_s/i32	$push31=, $pop30
	i32.const	$push26=, 11
	i32.add 	$push27=, $1, $pop26
	i32.const	$push28=, -8
	i32.and 	$push54=, $pop27, $pop28
	tee_local	$push53=, $1=, $pop54
	f64.load	$push29=, 0($pop53)
	f64.add 	$push32=, $pop31, $pop29
	i32.trunc_s/f64	$push52=, $pop32
	tee_local	$push51=, $0=, $pop52
	i32.store	foo_arg($pop33), $pop51
	i64.extend_u/i32	$push35=, $0
	i64.load	$push34=, 8($1)
	i64.add 	$push36=, $pop35, $pop34
	i32.wrap/i64	$1=, $pop36
	br      	2               # 2: down to label11
.LBB6_4:                                # %sw.bb18.i
	end_block                       # label13:
	i32.const	$push45=, 16
	i32.add 	$push46=, $2, $pop45
	i32.load	$push59=, 0($1)
	tee_local	$push58=, $0=, $pop59
	call    	__floatsitf@FUNCTION, $pop46, $pop58
	i64.load	$push14=, 16($2)
	i32.const	$push47=, 16
	i32.add 	$push48=, $2, $pop47
	i32.const	$push11=, 8
	i32.add 	$push12=, $pop48, $pop11
	i64.load	$push13=, 0($pop12)
	i32.const	$push6=, 19
	i32.add 	$push7=, $1, $pop6
	i32.const	$push8=, -16
	i32.and 	$push57=, $pop7, $pop8
	tee_local	$push56=, $1=, $pop57
	i64.load	$push10=, 0($pop56)
	i64.load	$push9=, 8($1)
	call    	__addtf3@FUNCTION, $2, $pop14, $pop13, $pop10, $pop9
	i32.const	$push15=, 0
	i32.store	foo_arg($pop15), $0
	i64.load	$push18=, 0($2)
	i32.const	$push55=, 8
	i32.add 	$push16=, $2, $pop55
	i64.load	$push17=, 0($pop16)
	i32.call	$1=, __fixtfsi@FUNCTION, $pop18, $pop17
	br      	1               # 1: down to label11
.LBB6_5:                                # %sw.bb9.i
	end_block                       # label12:
	i32.const	$push22=, 0
	i32.const	$push19=, 7
	i32.add 	$push20=, $1, $pop19
	i32.const	$push21=, -8
	i32.and 	$push63=, $pop20, $pop21
	tee_local	$push62=, $1=, $pop63
	i32.load	$push61=, 0($pop62)
	tee_local	$push60=, $0=, $pop61
	i32.store	foo_arg($pop22), $pop60
	f64.convert_s/i32	$push24=, $0
	f64.load	$push23=, 8($1)
	f64.add 	$push25=, $pop24, $pop23
	i32.trunc_s/f64	$1=, $pop25
.LBB6_6:                                # %foo.exit
	end_block                       # label11:
	i32.const	$push37=, 0
	i32.store	foo_arg($pop37), $1
	i32.const	$push44=, 0
	i32.const	$push42=, 80
	i32.add 	$push43=, $2, $pop42
	i32.store	__stack_pointer($pop44), $pop43
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push4=, 0
	i32.load	$push5=, __stack_pointer($pop4)
	i32.const	$push6=, 16
	i32.sub 	$push8=, $pop5, $pop6
	tee_local	$push7=, $2=, $pop8
	i32.store	4($pop7), $1
	i32.const	$push0=, 4
	i32.add 	$push1=, $1, $pop0
	i32.store	4($2), $pop1
	i32.const	$push3=, 0
	i32.load	$push2=, 0($1)
	i32.store	x($pop3), $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end7:
	.size	f6, .Lfunc_end7-f6

	.section	.text.f7,"ax",@progbits
	.hidden	f7
	.globl	f7
	.type	f7,@function
f7:                                     # @f7
	.param  	i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push18=, 0
	i32.const	$push15=, 0
	i32.load	$push16=, __stack_pointer($pop15)
	i32.const	$push17=, 16
	i32.sub 	$push23=, $pop16, $pop17
	tee_local	$push22=, $3=, $pop23
	i32.store	__stack_pointer($pop18), $pop22
	i32.store	4($3), $1
	block   	
	block   	
	i32.const	$push0=, 16386
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label15
# BB#1:                                 # %if.then.i
	i32.const	$push29=, 0
	i32.const	$push28=, 0
	i32.load	$push27=, gap($pop28)
	tee_local	$push26=, $1=, $pop27
	i32.const	$push2=, 4
	i32.add 	$push25=, $pop26, $pop2
	tee_local	$push24=, $2=, $pop25
	i32.store	gap($pop29), $pop24
	i32.load	$push3=, 0($1)
	i32.const	$push4=, 13
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	1, $pop5        # 1: down to label14
# BB#2:                                 # %lor.lhs.false.i
	i32.const	$push32=, 0
	i32.const	$push6=, 7
	i32.add 	$push7=, $2, $pop6
	i32.const	$push8=, -8
	i32.and 	$push31=, $pop7, $pop8
	tee_local	$push30=, $1=, $pop31
	i32.const	$push9=, 8
	i32.add 	$push10=, $pop30, $pop9
	i32.store	gap($pop32), $pop10
	f64.load	$push11=, 0($1)
	f64.const	$push12=, -0x1.cp3
	f64.ne  	$push13=, $pop11, $pop12
	br_if   	1, $pop13       # 1: down to label14
.LBB8_3:                                # %bar.exit
	end_block                       # label15:
	i32.const	$push14=, 0
	i32.store	bar_arg($pop14), $0
	i32.const	$push21=, 0
	i32.const	$push19=, 16
	i32.add 	$push20=, $3, $pop19
	i32.store	__stack_pointer($pop21), $pop20
	return
.LBB8_4:                                # %if.then5.i
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push41=, 0
	i32.const	$push38=, 0
	i32.load	$push39=, __stack_pointer($pop38)
	i32.const	$push40=, 48
	i32.sub 	$push50=, $pop39, $pop40
	tee_local	$push49=, $2=, $pop50
	i32.store	__stack_pointer($pop41), $pop49
	i32.store	36($2), $1
	block   	
	block   	
	block   	
	block   	
	i32.const	$push0=, 11
	i32.eq  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label19
# BB#1:                                 # %entry
	i32.const	$push2=, 8
	i32.eq  	$push3=, $0, $pop2
	br_if   	1, $pop3        # 1: down to label18
# BB#2:                                 # %entry
	i32.const	$push4=, 5
	i32.ne  	$push5=, $0, $pop4
	br_if   	3, $pop5        # 3: down to label16
# BB#3:                                 # %sw.bb.i
	i32.const	$push33=, 0
	i32.load	$push30=, 0($1)
	f64.convert_s/i32	$push31=, $pop30
	i32.const	$push26=, 11
	i32.add 	$push27=, $1, $pop26
	i32.const	$push28=, -8
	i32.and 	$push54=, $pop27, $pop28
	tee_local	$push53=, $1=, $pop54
	f64.load	$push29=, 0($pop53)
	f64.add 	$push32=, $pop31, $pop29
	i32.trunc_s/f64	$push52=, $pop32
	tee_local	$push51=, $0=, $pop52
	i32.store	foo_arg($pop33), $pop51
	i64.extend_u/i32	$push35=, $0
	i64.load	$push34=, 8($1)
	i64.add 	$push36=, $pop35, $pop34
	i32.wrap/i64	$1=, $pop36
	br      	2               # 2: down to label17
.LBB9_4:                                # %sw.bb18.i
	end_block                       # label19:
	i32.const	$push45=, 16
	i32.add 	$push46=, $2, $pop45
	i32.load	$push59=, 0($1)
	tee_local	$push58=, $0=, $pop59
	call    	__floatsitf@FUNCTION, $pop46, $pop58
	i64.load	$push14=, 16($2)
	i32.const	$push47=, 16
	i32.add 	$push48=, $2, $pop47
	i32.const	$push11=, 8
	i32.add 	$push12=, $pop48, $pop11
	i64.load	$push13=, 0($pop12)
	i32.const	$push6=, 19
	i32.add 	$push7=, $1, $pop6
	i32.const	$push8=, -16
	i32.and 	$push57=, $pop7, $pop8
	tee_local	$push56=, $1=, $pop57
	i64.load	$push10=, 0($pop56)
	i64.load	$push9=, 8($1)
	call    	__addtf3@FUNCTION, $2, $pop14, $pop13, $pop10, $pop9
	i32.const	$push15=, 0
	i32.store	foo_arg($pop15), $0
	i64.load	$push18=, 0($2)
	i32.const	$push55=, 8
	i32.add 	$push16=, $2, $pop55
	i64.load	$push17=, 0($pop16)
	i32.call	$1=, __fixtfsi@FUNCTION, $pop18, $pop17
	br      	1               # 1: down to label17
.LBB9_5:                                # %sw.bb9.i
	end_block                       # label18:
	i32.const	$push22=, 0
	i32.const	$push19=, 7
	i32.add 	$push20=, $1, $pop19
	i32.const	$push21=, -8
	i32.and 	$push63=, $pop20, $pop21
	tee_local	$push62=, $1=, $pop63
	i32.load	$push61=, 0($pop62)
	tee_local	$push60=, $0=, $pop61
	i32.store	foo_arg($pop22), $pop60
	f64.convert_s/i32	$push24=, $0
	f64.load	$push23=, 8($1)
	f64.add 	$push25=, $pop24, $pop23
	i32.trunc_s/f64	$1=, $pop25
.LBB9_6:                                # %foo.exit
	end_block                       # label17:
	i32.const	$push37=, 0
	i32.store	foo_arg($pop37), $1
	i32.const	$push44=, 0
	i32.const	$push42=, 48
	i32.add 	$push43=, $2, $pop42
	i32.store	__stack_pointer($pop44), $pop43
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push5=, 0
	i32.load	$push6=, __stack_pointer($pop5)
	i32.const	$push7=, 16
	i32.sub 	$push8=, $pop6, $pop7
	i32.const	$push0=, 12
	i32.add 	$push10=, $pop8, $pop0
	tee_local	$push9=, $2=, $pop10
	i32.store	0($pop9), $1
	i32.const	$push1=, 4
	i32.add 	$push2=, $1, $pop1
	i32.store	0($2), $pop2
	i32.const	$push4=, 0
	i32.load	$push3=, 0($1)
	i32.store	x($pop4), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end10:
	.size	f10, .Lfunc_end10-f10

	.section	.text.f11,"ax",@progbits
	.hidden	f11
	.globl	f11
	.type	f11,@function
f11:                                    # @f11
	.param  	i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push20=, 0
	i32.const	$push17=, 0
	i32.load	$push18=, __stack_pointer($pop17)
	i32.const	$push19=, 16
	i32.sub 	$push25=, $pop18, $pop19
	tee_local	$push24=, $3=, $pop25
	i32.store	__stack_pointer($pop20), $pop24
	i32.const	$push1=, 12
	i32.add 	$push0=, $3, $pop1
	i32.store	0($pop0), $1
	block   	
	block   	
	i32.const	$push2=, 16386
	i32.ne  	$push3=, $0, $pop2
	br_if   	0, $pop3        # 0: down to label21
# BB#1:                                 # %if.then.i
	i32.const	$push31=, 0
	i32.const	$push30=, 0
	i32.load	$push29=, gap($pop30)
	tee_local	$push28=, $1=, $pop29
	i32.const	$push4=, 4
	i32.add 	$push27=, $pop28, $pop4
	tee_local	$push26=, $2=, $pop27
	i32.store	gap($pop31), $pop26
	i32.load	$push5=, 0($1)
	i32.const	$push6=, 13
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	1, $pop7        # 1: down to label20
# BB#2:                                 # %lor.lhs.false.i
	i32.const	$push34=, 0
	i32.const	$push8=, 7
	i32.add 	$push9=, $2, $pop8
	i32.const	$push10=, -8
	i32.and 	$push33=, $pop9, $pop10
	tee_local	$push32=, $1=, $pop33
	i32.const	$push11=, 8
	i32.add 	$push12=, $pop32, $pop11
	i32.store	gap($pop34), $pop12
	f64.load	$push13=, 0($1)
	f64.const	$push14=, -0x1.cp3
	f64.ne  	$push15=, $pop13, $pop14
	br_if   	1, $pop15       # 1: down to label20
.LBB11_3:                               # %bar.exit
	end_block                       # label21:
	i32.const	$push16=, 0
	i32.store	bar_arg($pop16), $0
	i32.const	$push23=, 0
	i32.const	$push21=, 16
	i32.add 	$push22=, $3, $pop21
	i32.store	__stack_pointer($pop23), $pop22
	return
.LBB11_4:                               # %if.then5.i
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push43=, 0
	i32.const	$push40=, 0
	i32.load	$push41=, __stack_pointer($pop40)
	i32.const	$push42=, 48
	i32.sub 	$push52=, $pop41, $pop42
	tee_local	$push51=, $2=, $pop52
	i32.store	__stack_pointer($pop43), $pop51
	i32.const	$push1=, 44
	i32.add 	$push0=, $2, $pop1
	i32.store	0($pop0), $1
	block   	
	block   	
	block   	
	block   	
	i32.const	$push2=, 11
	i32.eq  	$push3=, $0, $pop2
	br_if   	0, $pop3        # 0: down to label25
# BB#1:                                 # %entry
	i32.const	$push4=, 8
	i32.eq  	$push5=, $0, $pop4
	br_if   	1, $pop5        # 1: down to label24
# BB#2:                                 # %entry
	i32.const	$push6=, 5
	i32.ne  	$push7=, $0, $pop6
	br_if   	3, $pop7        # 3: down to label22
# BB#3:                                 # %sw.bb.i
	i32.const	$push35=, 0
	i32.load	$push32=, 0($1)
	f64.convert_s/i32	$push33=, $pop32
	i32.const	$push28=, 11
	i32.add 	$push29=, $1, $pop28
	i32.const	$push30=, -8
	i32.and 	$push56=, $pop29, $pop30
	tee_local	$push55=, $1=, $pop56
	f64.load	$push31=, 0($pop55)
	f64.add 	$push34=, $pop33, $pop31
	i32.trunc_s/f64	$push54=, $pop34
	tee_local	$push53=, $0=, $pop54
	i32.store	foo_arg($pop35), $pop53
	i64.extend_u/i32	$push37=, $0
	i64.load	$push36=, 8($1)
	i64.add 	$push38=, $pop37, $pop36
	i32.wrap/i64	$1=, $pop38
	br      	2               # 2: down to label23
.LBB12_4:                               # %sw.bb18.i
	end_block                       # label25:
	i32.const	$push47=, 16
	i32.add 	$push48=, $2, $pop47
	i32.load	$push61=, 0($1)
	tee_local	$push60=, $0=, $pop61
	call    	__floatsitf@FUNCTION, $pop48, $pop60
	i64.load	$push16=, 16($2)
	i32.const	$push49=, 16
	i32.add 	$push50=, $2, $pop49
	i32.const	$push13=, 8
	i32.add 	$push14=, $pop50, $pop13
	i64.load	$push15=, 0($pop14)
	i32.const	$push8=, 19
	i32.add 	$push9=, $1, $pop8
	i32.const	$push10=, -16
	i32.and 	$push59=, $pop9, $pop10
	tee_local	$push58=, $1=, $pop59
	i64.load	$push12=, 0($pop58)
	i64.load	$push11=, 8($1)
	call    	__addtf3@FUNCTION, $2, $pop16, $pop15, $pop12, $pop11
	i32.const	$push17=, 0
	i32.store	foo_arg($pop17), $0
	i64.load	$push20=, 0($2)
	i32.const	$push57=, 8
	i32.add 	$push18=, $2, $pop57
	i64.load	$push19=, 0($pop18)
	i32.call	$1=, __fixtfsi@FUNCTION, $pop20, $pop19
	br      	1               # 1: down to label23
.LBB12_5:                               # %sw.bb9.i
	end_block                       # label24:
	i32.const	$push24=, 0
	i32.const	$push21=, 7
	i32.add 	$push22=, $1, $pop21
	i32.const	$push23=, -8
	i32.and 	$push65=, $pop22, $pop23
	tee_local	$push64=, $1=, $pop65
	i32.load	$push63=, 0($pop64)
	tee_local	$push62=, $0=, $pop63
	i32.store	foo_arg($pop24), $pop62
	f64.convert_s/i32	$push26=, $0
	f64.load	$push25=, 8($1)
	f64.add 	$push27=, $pop26, $pop25
	i32.trunc_s/f64	$1=, $pop27
.LBB12_6:                               # %foo.exit
	end_block                       # label23:
	i32.const	$push39=, 0
	i32.store	foo_arg($pop39), $1
	i32.const	$push46=, 0
	i32.const	$push44=, 48
	i32.add 	$push45=, $2, $pop44
	i32.store	__stack_pointer($pop46), $pop45
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push54=, 0
	i32.const	$push51=, 0
	i32.load	$push52=, __stack_pointer($pop51)
	i32.const	$push53=, 176
	i32.sub 	$push77=, $pop52, $pop53
	tee_local	$push76=, $0=, $pop77
	i32.store	__stack_pointer($pop54), $pop76
	i32.const	$push0=, 79
	i32.store	160($0), $pop0
	i32.const	$push58=, 160
	i32.add 	$push59=, $0, $pop58
	call    	f1@FUNCTION, $0, $pop59
	block   	
	i32.const	$push75=, 0
	i32.load	$push1=, x($pop75)
	i32.const	$push74=, 79
	i32.ne  	$push2=, $pop1, $pop74
	br_if   	0, $pop2        # 0: down to label26
# BB#1:                                 # %if.end
	i64.const	$push3=, -4599301119452119040
	i64.store	152($0), $pop3
	i32.const	$push4=, 13
	i32.store	144($0), $pop4
	i32.const	$push5=, 16386
	i32.const	$push60=, 144
	i32.add 	$push61=, $0, $pop60
	call    	f2@FUNCTION, $pop5, $pop61
	i32.const	$push79=, 0
	i32.load	$push6=, bar_arg($pop79)
	i32.const	$push78=, 16386
	i32.ne  	$push7=, $pop6, $pop78
	br_if   	0, $pop7        # 0: down to label26
# BB#2:                                 # %if.end3
	i32.const	$push8=, 2031
	i32.store	128($0), $pop8
	i32.const	$push62=, 128
	i32.add 	$push63=, $0, $pop62
	call    	f3@FUNCTION, $0, $pop63
	i32.const	$push81=, 0
	i32.load	$push9=, x($pop81)
	i32.const	$push80=, 2031
	i32.ne  	$push10=, $pop9, $pop80
	br_if   	0, $pop10       # 0: down to label26
# BB#3:                                 # %if.end6
	i32.const	$push11=, 18
	i32.store	112($0), $pop11
	i32.const	$push12=, 4
	i32.const	$push64=, 112
	i32.add 	$push65=, $0, $pop64
	call    	f4@FUNCTION, $pop12, $pop65
	i32.const	$push83=, 0
	i32.load	$push13=, bar_arg($pop83)
	i32.const	$push82=, 4
	i32.ne  	$push14=, $pop13, $pop82
	br_if   	0, $pop14       # 0: down to label26
# BB#4:                                 # %if.end9
	i32.const	$push15=, 96
	i32.add 	$push16=, $0, $pop15
	i64.const	$push17=, 18
	i64.store	0($pop16), $pop17
	i64.const	$push18=, 4626041242239631360
	i64.store	88($0), $pop18
	i32.const	$push19=, 1
	i32.store	80($0), $pop19
	i32.const	$push20=, 5
	i32.const	$push66=, 80
	i32.add 	$push67=, $0, $pop66
	call    	f5@FUNCTION, $pop20, $pop67
	i32.const	$push84=, 0
	i32.load	$push21=, foo_arg($pop84)
	i32.const	$push22=, 38
	i32.ne  	$push23=, $pop21, $pop22
	br_if   	0, $pop23       # 0: down to label26
# BB#5:                                 # %if.end12
	i32.const	$push24=, 18
	i32.store	64($0), $pop24
	i32.const	$push68=, 64
	i32.add 	$push69=, $0, $pop68
	call    	f6@FUNCTION, $0, $pop69
	i32.const	$push86=, 0
	i32.load	$push25=, x($pop86)
	i32.const	$push85=, 18
	i32.ne  	$push26=, $pop25, $pop85
	br_if   	0, $pop26       # 0: down to label26
# BB#6:                                 # %if.end15
	i32.const	$push27=, 7
	i32.const	$push89=, 0
	call    	f7@FUNCTION, $pop27, $pop89
	i32.const	$push88=, 0
	i32.load	$push28=, bar_arg($pop88)
	i32.const	$push87=, 7
	i32.ne  	$push29=, $pop28, $pop87
	br_if   	0, $pop29       # 0: down to label26
# BB#7:                                 # %if.end18
	i64.const	$push30=, 4623507967449235456
	i64.store	56($0), $pop30
	i64.const	$push31=, 2031
	i64.store	48($0), $pop31
	i32.const	$push32=, 8
	i32.const	$push70=, 48
	i32.add 	$push71=, $0, $pop70
	call    	f8@FUNCTION, $pop32, $pop71
	i32.const	$push90=, 0
	i32.load	$push33=, foo_arg($pop90)
	i32.const	$push34=, 2044
	i32.ne  	$push35=, $pop33, $pop34
	br_if   	0, $pop35       # 0: down to label26
# BB#8:                                 # %if.end21
	i32.const	$push36=, 180
	i32.store	32($0), $pop36
	i32.const	$push72=, 32
	i32.add 	$push73=, $0, $pop72
	call    	f10@FUNCTION, $0, $pop73
	i32.const	$push92=, 0
	i32.load	$push37=, x($pop92)
	i32.const	$push91=, 180
	i32.ne  	$push38=, $pop37, $pop91
	br_if   	0, $pop38       # 0: down to label26
# BB#9:                                 # %if.end24
	i32.const	$push39=, 10
	i32.const	$push95=, 0
	call    	f11@FUNCTION, $pop39, $pop95
	i32.const	$push94=, 0
	i32.load	$push40=, bar_arg($pop94)
	i32.const	$push93=, 10
	i32.ne  	$push41=, $pop40, $pop93
	br_if   	0, $pop41       # 0: down to label26
# BB#10:                                # %if.end27
	i32.const	$push42=, 16
	i32.add 	$push43=, $0, $pop42
	i64.const	$push44=, 4612389705869164544
	i64.store	0($pop43), $pop44
	i64.const	$push45=, 0
	i64.store	8($0), $pop45
	i32.const	$push46=, 2030
	i32.store	0($0), $pop46
	i32.const	$push47=, 11
	call    	f12@FUNCTION, $pop47, $0
	i32.const	$push96=, 0
	i32.load	$push48=, foo_arg($pop96)
	i32.const	$push49=, 2042
	i32.ne  	$push50=, $pop48, $pop49
	br_if   	0, $pop50       # 0: down to label26
# BB#11:                                # %if.end30
	i32.const	$push57=, 0
	i32.const	$push55=, 176
	i32.add 	$push56=, $0, $pop55
	i32.store	__stack_pointer($pop57), $pop56
	i32.const	$push97=, 0
	return  	$pop97
.LBB13_12:                              # %if.then29
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
