	.text
	.file	"stdarg-2.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32, f64, i32
# %bb.0:                                # %entry
	i32.const	$push41=, 0
	i32.load	$push40=, __stack_pointer($pop41)
	i32.const	$push42=, 32
	i32.sub 	$4=, $pop40, $pop42
	i32.const	$push43=, 0
	i32.store	__stack_pointer($pop43), $4
	block   	
	block   	
	block   	
	block   	
	block   	
	i32.const	$push0=, 11
	i32.eq  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label4
# %bb.1:                                # %entry
	block   	
	i32.const	$push2=, 8
	i32.eq  	$push3=, $0, $pop2
	br_if   	0, $pop3        # 0: down to label5
# %bb.2:                                # %entry
	i32.const	$push4=, 5
	i32.ne  	$push5=, $0, $pop4
	br_if   	5, $pop5        # 5: down to label0
# %bb.3:                                # %sw.bb
	i32.const	$push25=, 11
	i32.add 	$push26=, $1, $pop25
	i32.const	$push27=, -8
	i32.and 	$0=, $pop26, $pop27
	i32.load	$2=, 8($0)
	f64.load	$push28=, 0($0)
	i32.load	$push29=, 0($1)
	f64.convert_s/i32	$push30=, $pop29
	f64.add 	$3=, $pop28, $pop30
	f64.abs 	$push32=, $3
	f64.const	$push33=, 0x1p31
	f64.lt  	$push34=, $pop32, $pop33
	br_if   	2, $pop34       # 2: down to label3
# %bb.4:                                # %sw.bb
	i32.const	$push36=, -2147483648
	i32.add 	$0=, $2, $pop36
	br      	4               # 4: down to label1
.LBB0_5:                                # %sw.bb9
	end_block                       # label5:
	i32.const	$push19=, 7
	i32.add 	$push20=, $1, $pop19
	i32.const	$push21=, -8
	i32.and 	$0=, $pop20, $pop21
	f64.load	$push22=, 8($0)
	i32.load	$push23=, 0($0)
	f64.convert_s/i32	$push24=, $pop23
	f64.add 	$3=, $pop22, $pop24
	f64.abs 	$push37=, $3
	f64.const	$push38=, 0x1p31
	f64.lt  	$push39=, $pop37, $pop38
	br_if   	2, $pop39       # 2: down to label2
# %bb.6:                                # %sw.bb9
	i32.const	$0=, -2147483648
	br      	3               # 3: down to label1
.LBB0_7:                                # %sw.bb18
	end_block                       # label4:
	i32.const	$push47=, 16
	i32.add 	$push48=, $4, $pop47
	i32.load	$push6=, 0($1)
	call    	__floatsitf@FUNCTION, $pop48, $pop6
	i32.const	$push7=, 19
	i32.add 	$push8=, $1, $pop7
	i32.const	$push9=, -16
	i32.and 	$0=, $pop8, $pop9
	i64.load	$push11=, 0($0)
	i64.load	$push10=, 8($0)
	i64.load	$push15=, 16($4)
	i32.const	$push49=, 16
	i32.add 	$push50=, $4, $pop49
	i32.const	$push12=, 8
	i32.add 	$push13=, $pop50, $pop12
	i64.load	$push14=, 0($pop13)
	call    	__addtf3@FUNCTION, $4, $pop11, $pop10, $pop15, $pop14
	i64.load	$push18=, 0($4)
	i32.const	$push51=, 8
	i32.add 	$push16=, $4, $pop51
	i64.load	$push17=, 0($pop16)
	i32.call	$0=, __fixtfsi@FUNCTION, $pop18, $pop17
	br      	2               # 2: down to label1
.LBB0_8:                                # %sw.bb
	end_block                       # label3:
	i32.trunc_s/f64	$push35=, $3
	i32.add 	$0=, $2, $pop35
	br      	1               # 1: down to label1
.LBB0_9:                                # %sw.bb9
	end_block                       # label2:
	i32.trunc_s/f64	$0=, $3
.LBB0_10:                               # %sw.epilog
	end_block                       # label1:
	i32.const	$push31=, 0
	i32.store	foo_arg($pop31), $0
	i32.const	$push46=, 0
	i32.const	$push44=, 32
	i32.add 	$push45=, $4, $pop44
	i32.store	__stack_pointer($pop46), $pop45
	return
.LBB0_11:                               # %sw.default
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
	.local  	i32, i32
# %bb.0:                                # %entry
	block   	
	block   	
	i32.const	$push0=, 16386
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label7
# %bb.1:                                # %if.then
	i32.const	$push16=, 0
	i32.load	$2=, gap($pop16)
	i32.const	$push2=, 4
	i32.add 	$1=, $2, $pop2
	i32.const	$push15=, 0
	i32.store	gap($pop15), $1
	i32.load	$push3=, 0($2)
	i32.const	$push4=, 13
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	1, $pop5        # 1: down to label6
# %bb.2:                                # %lor.lhs.false
	i32.const	$push6=, 7
	i32.add 	$push7=, $1, $pop6
	i32.const	$push8=, -8
	i32.and 	$2=, $pop7, $pop8
	i32.const	$push17=, 0
	i32.const	$push9=, 8
	i32.add 	$push10=, $2, $pop9
	i32.store	gap($pop17), $pop10
	f64.load	$push11=, 0($2)
	f64.const	$push12=, -0x1.cp3
	f64.ne  	$push13=, $pop11, $pop12
	br_if   	1, $pop13       # 1: down to label6
.LBB1_3:                                # %if.end6
	end_block                       # label7:
	i32.const	$push14=, 0
	i32.store	bar_arg($pop14), $0
	return
.LBB1_4:                                # %if.then5
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar
                                        # -- End function
	.section	.text.f1,"ax",@progbits
	.hidden	f1                      # -- Begin function f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push2=, 0
	i32.const	$push0=, 4
	i32.add 	$push1=, $1, $pop0
	i32.store	gap($pop2), $pop1
	i32.const	$push4=, 0
	i32.load	$push3=, 0($1)
	i32.store	x($pop4), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	f1, .Lfunc_end2-f1
                                        # -- End function
	.section	.text.f2,"ax",@progbits
	.hidden	f2                      # -- Begin function f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.param  	i32, i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push15=, 0
	i32.store	gap($pop15), $1
	block   	
	block   	
	i32.const	$push0=, 16386
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label9
# %bb.1:                                # %if.then.i
	i32.const	$push17=, 0
	i32.load	$1=, gap($pop17)
	i32.const	$push2=, 4
	i32.add 	$2=, $1, $pop2
	i32.const	$push16=, 0
	i32.store	gap($pop16), $2
	i32.load	$push3=, 0($1)
	i32.const	$push4=, 13
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	1, $pop5        # 1: down to label8
# %bb.2:                                # %lor.lhs.false.i
	i32.const	$push6=, 7
	i32.add 	$push7=, $2, $pop6
	i32.const	$push8=, -8
	i32.and 	$1=, $pop7, $pop8
	i32.const	$push11=, 0
	i32.const	$push9=, 8
	i32.add 	$push10=, $1, $pop9
	i32.store	gap($pop11), $pop10
	f64.load	$push12=, 0($1)
	f64.const	$push13=, -0x1.cp3
	f64.ne  	$push14=, $pop12, $pop13
	br_if   	1, $pop14       # 1: down to label8
.LBB3_3:                                # %bar.exit
	end_block                       # label9:
	i32.const	$push18=, 0
	i32.store	bar_arg($pop18), $0
	return
.LBB3_4:                                # %if.then5.i
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	f2, .Lfunc_end3-f2
                                        # -- End function
	.section	.text.f3,"ax",@progbits
	.hidden	f3                      # -- Begin function f3
	.globl	f3
	.type	f3,@function
f3:                                     # @f3
	.param  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push5=, 0
	i32.load	$push4=, __stack_pointer($pop5)
	i32.const	$push6=, 48
	i32.sub 	$push7=, $pop4, $pop6
	i32.const	$push0=, 4
	i32.add 	$push1=, $1, $pop0
	i32.store	16($pop7), $pop1
	i32.const	$push3=, 0
	i32.load	$push2=, 0($1)
	i32.store	x($pop3), $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end4:
	.size	f3, .Lfunc_end4-f3
                                        # -- End function
	.section	.text.f4,"ax",@progbits
	.hidden	f4                      # -- Begin function f4
	.globl	f4
	.type	f4,@function
f4:                                     # @f4
	.param  	i32, i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push16=, 0
	i32.load	$push15=, __stack_pointer($pop16)
	i32.const	$push17=, 48
	i32.sub 	$3=, $pop15, $pop17
	i32.const	$push18=, 0
	i32.store	__stack_pointer($pop18), $3
	i32.store	16($3), $1
	block   	
	block   	
	i32.const	$push0=, 16386
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label11
# %bb.1:                                # %if.then.i
	i32.const	$push23=, 0
	i32.load	$1=, gap($pop23)
	i32.const	$push2=, 4
	i32.add 	$2=, $1, $pop2
	i32.const	$push22=, 0
	i32.store	gap($pop22), $2
	i32.load	$push3=, 0($1)
	i32.const	$push4=, 13
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	1, $pop5        # 1: down to label10
# %bb.2:                                # %lor.lhs.false.i
	i32.const	$push6=, 7
	i32.add 	$push7=, $2, $pop6
	i32.const	$push8=, -8
	i32.and 	$1=, $pop7, $pop8
	i32.const	$push24=, 0
	i32.const	$push9=, 8
	i32.add 	$push10=, $1, $pop9
	i32.store	gap($pop24), $pop10
	f64.load	$push11=, 0($1)
	f64.const	$push12=, -0x1.cp3
	f64.ne  	$push13=, $pop11, $pop12
	br_if   	1, $pop13       # 1: down to label10
.LBB5_3:                                # %bar.exit
	end_block                       # label11:
	i32.const	$push14=, 0
	i32.store	bar_arg($pop14), $0
	i32.const	$push21=, 0
	i32.const	$push19=, 48
	i32.add 	$push20=, $3, $pop19
	i32.store	__stack_pointer($pop21), $pop20
	return
.LBB5_4:                                # %if.then5.i
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end5:
	.size	f4, .Lfunc_end5-f4
                                        # -- End function
	.section	.text.f5,"ax",@progbits
	.hidden	f5                      # -- Begin function f5
	.globl	f5
	.type	f5,@function
f5:                                     # @f5
	.param  	i32, i32
	.local  	i32, f64, i32
# %bb.0:                                # %entry
	i32.const	$push41=, 0
	i32.load	$push40=, __stack_pointer($pop41)
	i32.const	$push42=, 80
	i32.sub 	$4=, $pop40, $pop42
	i32.const	$push43=, 0
	i32.store	__stack_pointer($pop43), $4
	i32.store	48($4), $1
	block   	
	block   	
	block   	
	block   	
	block   	
	i32.const	$push0=, 11
	i32.eq  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label16
# %bb.1:                                # %entry
	block   	
	i32.const	$push2=, 8
	i32.eq  	$push3=, $0, $pop2
	br_if   	0, $pop3        # 0: down to label17
# %bb.2:                                # %entry
	i32.const	$push4=, 5
	i32.ne  	$push5=, $0, $pop4
	br_if   	5, $pop5        # 5: down to label12
# %bb.3:                                # %sw.bb.i
	i32.const	$push25=, 11
	i32.add 	$push26=, $1, $pop25
	i32.const	$push27=, -8
	i32.and 	$0=, $pop26, $pop27
	i32.load	$2=, 8($0)
	f64.load	$push28=, 0($0)
	i32.load	$push29=, 0($1)
	f64.convert_s/i32	$push30=, $pop29
	f64.add 	$3=, $pop28, $pop30
	f64.abs 	$push32=, $3
	f64.const	$push33=, 0x1p31
	f64.lt  	$push34=, $pop32, $pop33
	br_if   	2, $pop34       # 2: down to label15
# %bb.4:                                # %sw.bb.i
	i32.const	$push36=, -2147483648
	i32.add 	$1=, $2, $pop36
	br      	4               # 4: down to label13
.LBB6_5:                                # %sw.bb9.i
	end_block                       # label17:
	i32.const	$push19=, 7
	i32.add 	$push20=, $1, $pop19
	i32.const	$push21=, -8
	i32.and 	$1=, $pop20, $pop21
	f64.load	$push22=, 8($1)
	i32.load	$push23=, 0($1)
	f64.convert_s/i32	$push24=, $pop23
	f64.add 	$3=, $pop22, $pop24
	f64.abs 	$push37=, $3
	f64.const	$push38=, 0x1p31
	f64.lt  	$push39=, $pop37, $pop38
	br_if   	2, $pop39       # 2: down to label14
# %bb.6:                                # %sw.bb9.i
	i32.const	$1=, -2147483648
	br      	3               # 3: down to label13
.LBB6_7:                                # %sw.bb18.i
	end_block                       # label16:
	i32.const	$push47=, 16
	i32.add 	$push48=, $4, $pop47
	i32.load	$push6=, 0($1)
	call    	__floatsitf@FUNCTION, $pop48, $pop6
	i32.const	$push7=, 19
	i32.add 	$push8=, $1, $pop7
	i32.const	$push9=, -16
	i32.and 	$1=, $pop8, $pop9
	i64.load	$push11=, 0($1)
	i64.load	$push10=, 8($1)
	i64.load	$push15=, 16($4)
	i32.const	$push49=, 16
	i32.add 	$push50=, $4, $pop49
	i32.const	$push12=, 8
	i32.add 	$push13=, $pop50, $pop12
	i64.load	$push14=, 0($pop13)
	call    	__addtf3@FUNCTION, $4, $pop11, $pop10, $pop15, $pop14
	i64.load	$push18=, 0($4)
	i32.const	$push51=, 8
	i32.add 	$push16=, $4, $pop51
	i64.load	$push17=, 0($pop16)
	i32.call	$1=, __fixtfsi@FUNCTION, $pop18, $pop17
	br      	2               # 2: down to label13
.LBB6_8:                                # %sw.bb.i
	end_block                       # label15:
	i32.trunc_s/f64	$push35=, $3
	i32.add 	$1=, $2, $pop35
	br      	1               # 1: down to label13
.LBB6_9:                                # %sw.bb9.i
	end_block                       # label14:
	i32.trunc_s/f64	$1=, $3
.LBB6_10:                               # %foo.exit
	end_block                       # label13:
	i32.const	$push31=, 0
	i32.store	foo_arg($pop31), $1
	i32.const	$push46=, 0
	i32.const	$push44=, 80
	i32.add 	$push45=, $4, $pop44
	i32.store	__stack_pointer($pop46), $pop45
	return
.LBB6_11:                               # %sw.default.i
	end_block                       # label12:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end6:
	.size	f5, .Lfunc_end6-f5
                                        # -- End function
	.section	.text.f6,"ax",@progbits
	.hidden	f6                      # -- Begin function f6
	.globl	f6
	.type	f6,@function
f6:                                     # @f6
	.param  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push5=, 0
	i32.load	$push4=, __stack_pointer($pop5)
	i32.const	$push6=, 16
	i32.sub 	$push7=, $pop4, $pop6
	i32.const	$push0=, 4
	i32.add 	$push1=, $1, $pop0
	i32.store	4($pop7), $pop1
	i32.const	$push3=, 0
	i32.load	$push2=, 0($1)
	i32.store	x($pop3), $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end7:
	.size	f6, .Lfunc_end7-f6
                                        # -- End function
	.section	.text.f7,"ax",@progbits
	.hidden	f7                      # -- Begin function f7
	.globl	f7
	.type	f7,@function
f7:                                     # @f7
	.param  	i32, i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push16=, 0
	i32.load	$push15=, __stack_pointer($pop16)
	i32.const	$push17=, 16
	i32.sub 	$3=, $pop15, $pop17
	i32.const	$push18=, 0
	i32.store	__stack_pointer($pop18), $3
	i32.store	4($3), $1
	block   	
	block   	
	i32.const	$push0=, 16386
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label19
# %bb.1:                                # %if.then.i
	i32.const	$push23=, 0
	i32.load	$1=, gap($pop23)
	i32.const	$push2=, 4
	i32.add 	$2=, $1, $pop2
	i32.const	$push22=, 0
	i32.store	gap($pop22), $2
	i32.load	$push3=, 0($1)
	i32.const	$push4=, 13
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	1, $pop5        # 1: down to label18
# %bb.2:                                # %lor.lhs.false.i
	i32.const	$push6=, 7
	i32.add 	$push7=, $2, $pop6
	i32.const	$push8=, -8
	i32.and 	$1=, $pop7, $pop8
	i32.const	$push24=, 0
	i32.const	$push9=, 8
	i32.add 	$push10=, $1, $pop9
	i32.store	gap($pop24), $pop10
	f64.load	$push11=, 0($1)
	f64.const	$push12=, -0x1.cp3
	f64.ne  	$push13=, $pop11, $pop12
	br_if   	1, $pop13       # 1: down to label18
.LBB8_3:                                # %bar.exit
	end_block                       # label19:
	i32.const	$push14=, 0
	i32.store	bar_arg($pop14), $0
	i32.const	$push21=, 0
	i32.const	$push19=, 16
	i32.add 	$push20=, $3, $pop19
	i32.store	__stack_pointer($pop21), $pop20
	return
.LBB8_4:                                # %if.then5.i
	end_block                       # label18:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end8:
	.size	f7, .Lfunc_end8-f7
                                        # -- End function
	.section	.text.f8,"ax",@progbits
	.hidden	f8                      # -- Begin function f8
	.globl	f8
	.type	f8,@function
f8:                                     # @f8
	.param  	i32, i32
	.local  	i32, f64, i32
# %bb.0:                                # %entry
	i32.const	$push41=, 0
	i32.load	$push40=, __stack_pointer($pop41)
	i32.const	$push42=, 48
	i32.sub 	$4=, $pop40, $pop42
	i32.const	$push43=, 0
	i32.store	__stack_pointer($pop43), $4
	i32.store	36($4), $1
	block   	
	block   	
	block   	
	block   	
	block   	
	i32.const	$push0=, 11
	i32.eq  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label24
# %bb.1:                                # %entry
	block   	
	i32.const	$push2=, 8
	i32.eq  	$push3=, $0, $pop2
	br_if   	0, $pop3        # 0: down to label25
# %bb.2:                                # %entry
	i32.const	$push4=, 5
	i32.ne  	$push5=, $0, $pop4
	br_if   	5, $pop5        # 5: down to label20
# %bb.3:                                # %sw.bb.i
	i32.const	$push25=, 11
	i32.add 	$push26=, $1, $pop25
	i32.const	$push27=, -8
	i32.and 	$0=, $pop26, $pop27
	i32.load	$2=, 8($0)
	f64.load	$push28=, 0($0)
	i32.load	$push29=, 0($1)
	f64.convert_s/i32	$push30=, $pop29
	f64.add 	$3=, $pop28, $pop30
	f64.abs 	$push32=, $3
	f64.const	$push33=, 0x1p31
	f64.lt  	$push34=, $pop32, $pop33
	br_if   	2, $pop34       # 2: down to label23
# %bb.4:                                # %sw.bb.i
	i32.const	$push36=, -2147483648
	i32.add 	$1=, $2, $pop36
	br      	4               # 4: down to label21
.LBB9_5:                                # %sw.bb9.i
	end_block                       # label25:
	i32.const	$push19=, 7
	i32.add 	$push20=, $1, $pop19
	i32.const	$push21=, -8
	i32.and 	$1=, $pop20, $pop21
	f64.load	$push22=, 8($1)
	i32.load	$push23=, 0($1)
	f64.convert_s/i32	$push24=, $pop23
	f64.add 	$3=, $pop22, $pop24
	f64.abs 	$push37=, $3
	f64.const	$push38=, 0x1p31
	f64.lt  	$push39=, $pop37, $pop38
	br_if   	2, $pop39       # 2: down to label22
# %bb.6:                                # %sw.bb9.i
	i32.const	$1=, -2147483648
	br      	3               # 3: down to label21
.LBB9_7:                                # %sw.bb18.i
	end_block                       # label24:
	i32.const	$push47=, 16
	i32.add 	$push48=, $4, $pop47
	i32.load	$push6=, 0($1)
	call    	__floatsitf@FUNCTION, $pop48, $pop6
	i32.const	$push7=, 19
	i32.add 	$push8=, $1, $pop7
	i32.const	$push9=, -16
	i32.and 	$1=, $pop8, $pop9
	i64.load	$push11=, 0($1)
	i64.load	$push10=, 8($1)
	i64.load	$push15=, 16($4)
	i32.const	$push49=, 16
	i32.add 	$push50=, $4, $pop49
	i32.const	$push12=, 8
	i32.add 	$push13=, $pop50, $pop12
	i64.load	$push14=, 0($pop13)
	call    	__addtf3@FUNCTION, $4, $pop11, $pop10, $pop15, $pop14
	i64.load	$push18=, 0($4)
	i32.const	$push51=, 8
	i32.add 	$push16=, $4, $pop51
	i64.load	$push17=, 0($pop16)
	i32.call	$1=, __fixtfsi@FUNCTION, $pop18, $pop17
	br      	2               # 2: down to label21
.LBB9_8:                                # %sw.bb.i
	end_block                       # label23:
	i32.trunc_s/f64	$push35=, $3
	i32.add 	$1=, $2, $pop35
	br      	1               # 1: down to label21
.LBB9_9:                                # %sw.bb9.i
	end_block                       # label22:
	i32.trunc_s/f64	$1=, $3
.LBB9_10:                               # %foo.exit
	end_block                       # label21:
	i32.const	$push31=, 0
	i32.store	foo_arg($pop31), $1
	i32.const	$push46=, 0
	i32.const	$push44=, 48
	i32.add 	$push45=, $4, $pop44
	i32.store	__stack_pointer($pop46), $pop45
	return
.LBB9_11:                               # %sw.default.i
	end_block                       # label20:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end9:
	.size	f8, .Lfunc_end9-f8
                                        # -- End function
	.section	.text.f10,"ax",@progbits
	.hidden	f10                     # -- Begin function f10
	.globl	f10
	.type	f10,@function
f10:                                    # @f10
	.param  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push7=, 0
	i32.load	$push6=, __stack_pointer($pop7)
	i32.const	$push8=, 16
	i32.sub 	$push9=, $pop6, $pop8
	i32.const	$push2=, 12
	i32.add 	$push3=, $pop9, $pop2
	i32.const	$push0=, 4
	i32.add 	$push1=, $1, $pop0
	i32.store	0($pop3), $pop1
	i32.const	$push5=, 0
	i32.load	$push4=, 0($1)
	i32.store	x($pop5), $pop4
                                        # fallthrough-return
	.endfunc
.Lfunc_end10:
	.size	f10, .Lfunc_end10-f10
                                        # -- End function
	.section	.text.f11,"ax",@progbits
	.hidden	f11                     # -- Begin function f11
	.globl	f11
	.type	f11,@function
f11:                                    # @f11
	.param  	i32, i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push18=, 0
	i32.load	$push17=, __stack_pointer($pop18)
	i32.const	$push19=, 16
	i32.sub 	$3=, $pop17, $pop19
	i32.const	$push20=, 0
	i32.store	__stack_pointer($pop20), $3
	i32.const	$push1=, 12
	i32.add 	$push0=, $3, $pop1
	i32.store	0($pop0), $1
	block   	
	block   	
	i32.const	$push2=, 16386
	i32.ne  	$push3=, $0, $pop2
	br_if   	0, $pop3        # 0: down to label27
# %bb.1:                                # %if.then.i
	i32.const	$push25=, 0
	i32.load	$1=, gap($pop25)
	i32.const	$push4=, 4
	i32.add 	$2=, $1, $pop4
	i32.const	$push24=, 0
	i32.store	gap($pop24), $2
	i32.load	$push5=, 0($1)
	i32.const	$push6=, 13
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	1, $pop7        # 1: down to label26
# %bb.2:                                # %lor.lhs.false.i
	i32.const	$push8=, 7
	i32.add 	$push9=, $2, $pop8
	i32.const	$push10=, -8
	i32.and 	$1=, $pop9, $pop10
	i32.const	$push26=, 0
	i32.const	$push11=, 8
	i32.add 	$push12=, $1, $pop11
	i32.store	gap($pop26), $pop12
	f64.load	$push13=, 0($1)
	f64.const	$push14=, -0x1.cp3
	f64.ne  	$push15=, $pop13, $pop14
	br_if   	1, $pop15       # 1: down to label26
.LBB11_3:                               # %bar.exit
	end_block                       # label27:
	i32.const	$push16=, 0
	i32.store	bar_arg($pop16), $0
	i32.const	$push23=, 0
	i32.const	$push21=, 16
	i32.add 	$push22=, $3, $pop21
	i32.store	__stack_pointer($pop23), $pop22
	return
.LBB11_4:                               # %if.then5.i
	end_block                       # label26:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end11:
	.size	f11, .Lfunc_end11-f11
                                        # -- End function
	.section	.text.f12,"ax",@progbits
	.hidden	f12                     # -- Begin function f12
	.globl	f12
	.type	f12,@function
f12:                                    # @f12
	.param  	i32, i32
	.local  	i32, f64, i32
# %bb.0:                                # %entry
	i32.const	$push43=, 0
	i32.load	$push42=, __stack_pointer($pop43)
	i32.const	$push44=, 48
	i32.sub 	$4=, $pop42, $pop44
	i32.const	$push45=, 0
	i32.store	__stack_pointer($pop45), $4
	i32.const	$push1=, 44
	i32.add 	$push0=, $4, $pop1
	i32.store	0($pop0), $1
	block   	
	block   	
	block   	
	block   	
	block   	
	i32.const	$push2=, 11
	i32.eq  	$push3=, $0, $pop2
	br_if   	0, $pop3        # 0: down to label32
# %bb.1:                                # %entry
	block   	
	i32.const	$push4=, 8
	i32.eq  	$push5=, $0, $pop4
	br_if   	0, $pop5        # 0: down to label33
# %bb.2:                                # %entry
	i32.const	$push6=, 5
	i32.ne  	$push7=, $0, $pop6
	br_if   	5, $pop7        # 5: down to label28
# %bb.3:                                # %sw.bb.i
	i32.const	$push27=, 11
	i32.add 	$push28=, $1, $pop27
	i32.const	$push29=, -8
	i32.and 	$0=, $pop28, $pop29
	i32.load	$2=, 8($0)
	f64.load	$push30=, 0($0)
	i32.load	$push31=, 0($1)
	f64.convert_s/i32	$push32=, $pop31
	f64.add 	$3=, $pop30, $pop32
	f64.abs 	$push34=, $3
	f64.const	$push35=, 0x1p31
	f64.lt  	$push36=, $pop34, $pop35
	br_if   	2, $pop36       # 2: down to label31
# %bb.4:                                # %sw.bb.i
	i32.const	$push38=, -2147483648
	i32.add 	$1=, $2, $pop38
	br      	4               # 4: down to label29
.LBB12_5:                               # %sw.bb9.i
	end_block                       # label33:
	i32.const	$push21=, 7
	i32.add 	$push22=, $1, $pop21
	i32.const	$push23=, -8
	i32.and 	$1=, $pop22, $pop23
	f64.load	$push24=, 8($1)
	i32.load	$push25=, 0($1)
	f64.convert_s/i32	$push26=, $pop25
	f64.add 	$3=, $pop24, $pop26
	f64.abs 	$push39=, $3
	f64.const	$push40=, 0x1p31
	f64.lt  	$push41=, $pop39, $pop40
	br_if   	2, $pop41       # 2: down to label30
# %bb.6:                                # %sw.bb9.i
	i32.const	$1=, -2147483648
	br      	3               # 3: down to label29
.LBB12_7:                               # %sw.bb18.i
	end_block                       # label32:
	i32.const	$push49=, 16
	i32.add 	$push50=, $4, $pop49
	i32.load	$push8=, 0($1)
	call    	__floatsitf@FUNCTION, $pop50, $pop8
	i32.const	$push9=, 19
	i32.add 	$push10=, $1, $pop9
	i32.const	$push11=, -16
	i32.and 	$1=, $pop10, $pop11
	i64.load	$push13=, 0($1)
	i64.load	$push12=, 8($1)
	i64.load	$push17=, 16($4)
	i32.const	$push51=, 16
	i32.add 	$push52=, $4, $pop51
	i32.const	$push14=, 8
	i32.add 	$push15=, $pop52, $pop14
	i64.load	$push16=, 0($pop15)
	call    	__addtf3@FUNCTION, $4, $pop13, $pop12, $pop17, $pop16
	i64.load	$push20=, 0($4)
	i32.const	$push53=, 8
	i32.add 	$push18=, $4, $pop53
	i64.load	$push19=, 0($pop18)
	i32.call	$1=, __fixtfsi@FUNCTION, $pop20, $pop19
	br      	2               # 2: down to label29
.LBB12_8:                               # %sw.bb.i
	end_block                       # label31:
	i32.trunc_s/f64	$push37=, $3
	i32.add 	$1=, $2, $pop37
	br      	1               # 1: down to label29
.LBB12_9:                               # %sw.bb9.i
	end_block                       # label30:
	i32.trunc_s/f64	$1=, $3
.LBB12_10:                              # %foo.exit
	end_block                       # label29:
	i32.const	$push33=, 0
	i32.store	foo_arg($pop33), $1
	i32.const	$push48=, 0
	i32.const	$push46=, 48
	i32.add 	$push47=, $4, $pop46
	i32.store	__stack_pointer($pop48), $pop47
	return
.LBB12_11:                              # %sw.default.i
	end_block                       # label28:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end12:
	.size	f12, .Lfunc_end12-f12
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push52=, 0
	i32.load	$push51=, __stack_pointer($pop52)
	i32.const	$push53=, 176
	i32.sub 	$0=, $pop51, $pop53
	i32.const	$push54=, 0
	i32.store	__stack_pointer($pop54), $0
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
	br_if   	0, $pop2        # 0: down to label34
# %bb.1:                                # %if.end
	i64.const	$push3=, -4599301119452119040
	i64.store	152($0), $pop3
	i32.const	$push4=, 13
	i32.store	144($0), $pop4
	i32.const	$push5=, 16386
	i32.const	$push60=, 144
	i32.add 	$push61=, $0, $pop60
	call    	f2@FUNCTION, $pop5, $pop61
	i32.const	$push77=, 0
	i32.load	$push6=, bar_arg($pop77)
	i32.const	$push76=, 16386
	i32.ne  	$push7=, $pop6, $pop76
	br_if   	0, $pop7        # 0: down to label34
# %bb.2:                                # %if.end3
	i32.const	$push8=, 2031
	i32.store	128($0), $pop8
	i32.const	$push62=, 128
	i32.add 	$push63=, $0, $pop62
	call    	f3@FUNCTION, $0, $pop63
	i32.const	$push79=, 0
	i32.load	$push9=, x($pop79)
	i32.const	$push78=, 2031
	i32.ne  	$push10=, $pop9, $pop78
	br_if   	0, $pop10       # 0: down to label34
# %bb.3:                                # %if.end6
	i32.const	$push11=, 18
	i32.store	112($0), $pop11
	i32.const	$push12=, 4
	i32.const	$push64=, 112
	i32.add 	$push65=, $0, $pop64
	call    	f4@FUNCTION, $pop12, $pop65
	i32.const	$push81=, 0
	i32.load	$push13=, bar_arg($pop81)
	i32.const	$push80=, 4
	i32.ne  	$push14=, $pop13, $pop80
	br_if   	0, $pop14       # 0: down to label34
# %bb.4:                                # %if.end9
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
	i32.const	$push82=, 0
	i32.load	$push21=, foo_arg($pop82)
	i32.const	$push22=, 38
	i32.ne  	$push23=, $pop21, $pop22
	br_if   	0, $pop23       # 0: down to label34
# %bb.5:                                # %if.end12
	i32.const	$push24=, 18
	i32.store	64($0), $pop24
	i32.const	$push68=, 64
	i32.add 	$push69=, $0, $pop68
	call    	f6@FUNCTION, $0, $pop69
	i32.const	$push84=, 0
	i32.load	$push25=, x($pop84)
	i32.const	$push83=, 18
	i32.ne  	$push26=, $pop25, $pop83
	br_if   	0, $pop26       # 0: down to label34
# %bb.6:                                # %if.end15
	i32.const	$push27=, 7
	i32.const	$push87=, 0
	call    	f7@FUNCTION, $pop27, $pop87
	i32.const	$push86=, 0
	i32.load	$push28=, bar_arg($pop86)
	i32.const	$push85=, 7
	i32.ne  	$push29=, $pop28, $pop85
	br_if   	0, $pop29       # 0: down to label34
# %bb.7:                                # %if.end18
	i64.const	$push30=, 4623507967449235456
	i64.store	56($0), $pop30
	i64.const	$push31=, 2031
	i64.store	48($0), $pop31
	i32.const	$push32=, 8
	i32.const	$push70=, 48
	i32.add 	$push71=, $0, $pop70
	call    	f8@FUNCTION, $pop32, $pop71
	i32.const	$push88=, 0
	i32.load	$push33=, foo_arg($pop88)
	i32.const	$push34=, 2044
	i32.ne  	$push35=, $pop33, $pop34
	br_if   	0, $pop35       # 0: down to label34
# %bb.8:                                # %if.end21
	i32.const	$push36=, 180
	i32.store	32($0), $pop36
	i32.const	$push72=, 32
	i32.add 	$push73=, $0, $pop72
	call    	f10@FUNCTION, $0, $pop73
	i32.const	$push90=, 0
	i32.load	$push37=, x($pop90)
	i32.const	$push89=, 180
	i32.ne  	$push38=, $pop37, $pop89
	br_if   	0, $pop38       # 0: down to label34
# %bb.9:                                # %if.end24
	i32.const	$push39=, 10
	i32.const	$push93=, 0
	call    	f11@FUNCTION, $pop39, $pop93
	i32.const	$push92=, 0
	i32.load	$push40=, bar_arg($pop92)
	i32.const	$push91=, 10
	i32.ne  	$push41=, $pop40, $pop91
	br_if   	0, $pop41       # 0: down to label34
# %bb.10:                               # %if.end27
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
	i32.const	$push94=, 0
	i32.load	$push48=, foo_arg($pop94)
	i32.const	$push49=, 2042
	i32.ne  	$push50=, $pop48, $pop49
	br_if   	0, $pop50       # 0: down to label34
# %bb.11:                               # %if.end30
	i32.const	$push57=, 0
	i32.const	$push55=, 176
	i32.add 	$push56=, $0, $pop55
	i32.store	__stack_pointer($pop57), $pop56
	i32.const	$push95=, 0
	return  	$pop95
.LBB13_12:                              # %if.then
	end_block                       # label34:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end13:
	.size	main, .Lfunc_end13-main
                                        # -- End function
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
