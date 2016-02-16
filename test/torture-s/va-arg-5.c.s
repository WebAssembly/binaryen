	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-5.c"
	.section	.text.va_double,"ax",@progbits
	.hidden	va_double
	.globl	va_double
	.type	va_double,@function
va_double:                              # @va_double
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$5=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	i32.store	$push0=, 12($5), $1
	i32.const	$push28=, 7
	i32.add 	$push1=, $pop0, $pop28
	i32.const	$push27=, -8
	i32.and 	$push26=, $pop1, $pop27
	tee_local	$push25=, $1=, $pop26
	i32.const	$push24=, 8
	i32.add 	$push2=, $pop25, $pop24
	i32.store	$discard=, 12($5), $pop2
	block
	block
	block
	block
	f64.load	$push3=, 0($1)
	f64.const	$push4=, 0x1.921fafc8b007ap1
	f64.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label3
# BB#1:                                 # %if.end
	i32.load	$push6=, 12($5)
	i32.const	$push33=, 7
	i32.add 	$push7=, $pop6, $pop33
	i32.const	$push32=, -8
	i32.and 	$push31=, $pop7, $pop32
	tee_local	$push30=, $1=, $pop31
	i32.const	$push29=, 8
	i32.add 	$push8=, $pop30, $pop29
	i32.store	$discard=, 12($5), $pop8
	f64.load	$push9=, 0($1)
	f64.const	$push10=, 0x1.5bf04577d9557p1
	f64.ne  	$push11=, $pop9, $pop10
	br_if   	1, $pop11       # 1: down to label2
# BB#2:                                 # %if.end4
	i32.load	$push12=, 12($5)
	i32.const	$push38=, 7
	i32.add 	$push13=, $pop12, $pop38
	i32.const	$push37=, -8
	i32.and 	$push36=, $pop13, $pop37
	tee_local	$push35=, $1=, $pop36
	i32.const	$push34=, 8
	i32.add 	$push14=, $pop35, $pop34
	i32.store	$discard=, 12($5), $pop14
	f64.load	$push15=, 0($1)
	f64.const	$push16=, 0x1.1e3779131154cp1
	f64.ne  	$push17=, $pop15, $pop16
	br_if   	2, $pop17       # 2: down to label1
# BB#3:                                 # %if.end7
	i32.load	$push18=, 12($5)
	i32.const	$push43=, 7
	i32.add 	$push19=, $pop18, $pop43
	i32.const	$push42=, -8
	i32.and 	$push41=, $pop19, $pop42
	tee_local	$push40=, $1=, $pop41
	i32.const	$push39=, 8
	i32.add 	$push20=, $pop40, $pop39
	i32.store	$discard=, 12($5), $pop20
	f64.load	$push21=, 0($1)
	f64.const	$push22=, 0x1.12e0be1b5921ep1
	f64.ne  	$push23=, $pop21, $pop22
	br_if   	3, $pop23       # 3: down to label0
# BB#4:                                 # %if.end10
	i32.const	$4=, 16
	i32.add 	$5=, $5, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
	return  	$1
.LBB0_5:                                # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_6:                                # %if.then3
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_7:                                # %if.then6
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_8:                                # %if.then9
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	va_double, .Lfunc_end0-va_double

	.section	.text.va_long_double,"ax",@progbits
	.hidden	va_long_double
	.globl	va_long_double
	.type	va_long_double,@function
va_long_double:                         # @va_long_double
	.param  	i32, i32
	.result 	i32
	.local  	i64, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 16
	i32.sub 	$7=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$7=, 0($5), $7
	i32.store	$push0=, 12($7), $1
	i32.const	$push37=, 15
	i32.add 	$push1=, $pop0, $pop37
	i32.const	$push36=, -16
	i32.and 	$push35=, $pop1, $pop36
	tee_local	$push34=, $3=, $pop35
	i32.const	$push33=, 8
	i32.or  	$push2=, $pop34, $pop33
	i32.store	$1=, 12($7), $pop2
	i64.load	$2=, 0($3)
	i32.const	$push32=, 8
	i32.add 	$push3=, $1, $pop32
	i32.store	$discard=, 12($7), $pop3
	block
	block
	block
	block
	i64.load	$push4=, 0($1)
	i64.const	$push6=, -7338557514379428662
	i64.const	$push5=, 4611846683218194439
	i32.call	$push7=, __eqtf2@FUNCTION, $2, $pop4, $pop6, $pop5
	br_if   	0, $pop7        # 0: down to label7
# BB#1:                                 # %if.end
	i32.load	$push8=, 12($7)
	i32.const	$push43=, 15
	i32.add 	$push9=, $pop8, $pop43
	i32.const	$push42=, -16
	i32.and 	$push41=, $pop9, $pop42
	tee_local	$push40=, $3=, $pop41
	i32.const	$push39=, 8
	i32.or  	$push10=, $pop40, $pop39
	i32.store	$1=, 12($7), $pop10
	i64.load	$2=, 0($3)
	i32.const	$push38=, 8
	i32.add 	$push11=, $1, $pop38
	i32.store	$discard=, 12($7), $pop11
	i64.load	$push12=, 0($1)
	i64.const	$push14=, 8163791057260899163
	i64.const	$push13=, 4611787105943148885
	i32.call	$push15=, __eqtf2@FUNCTION, $2, $pop12, $pop14, $pop13
	br_if   	1, $pop15       # 1: down to label6
# BB#2:                                 # %if.end4
	i32.load	$push16=, 12($7)
	i32.const	$push49=, 15
	i32.add 	$push17=, $pop16, $pop49
	i32.const	$push48=, -16
	i32.and 	$push47=, $pop17, $pop48
	tee_local	$push46=, $3=, $pop47
	i32.const	$push45=, 8
	i32.or  	$push18=, $pop46, $pop45
	i32.store	$1=, 12($7), $pop18
	i64.load	$2=, 0($3)
	i32.const	$push44=, 8
	i32.add 	$push19=, $1, $pop44
	i32.store	$discard=, 12($7), $pop19
	i64.load	$push20=, 0($1)
	i64.const	$push22=, -4892607794577095924
	i64.const	$push21=, 4611719242030715220
	i32.call	$push23=, __eqtf2@FUNCTION, $2, $pop20, $pop22, $pop21
	br_if   	2, $pop23       # 2: down to label5
# BB#3:                                 # %if.end7
	i32.load	$push24=, 12($7)
	i32.const	$push55=, 15
	i32.add 	$push25=, $pop24, $pop55
	i32.const	$push54=, -16
	i32.and 	$push53=, $pop25, $pop54
	tee_local	$push52=, $3=, $pop53
	i32.const	$push51=, 8
	i32.or  	$push26=, $pop52, $pop51
	i32.store	$1=, 12($7), $pop26
	i64.load	$2=, 0($3)
	i32.const	$push50=, 8
	i32.add 	$push27=, $1, $pop50
	i32.store	$discard=, 12($7), $pop27
	i64.load	$push28=, 0($1)
	i64.const	$push30=, -2718666384188054750
	i64.const	$push29=, 4611706774898825505
	i32.call	$push31=, __eqtf2@FUNCTION, $2, $pop28, $pop30, $pop29
	br_if   	3, $pop31       # 3: down to label4
# BB#4:                                 # %if.end10
	i32.const	$6=, 16
	i32.add 	$7=, $7, $6
	i32.const	$6=, __stack_pointer
	i32.store	$7=, 0($6), $7
	return  	$1
.LBB1_5:                                # %if.then
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB1_6:                                # %if.then3
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB1_7:                                # %if.then6
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB1_8:                                # %if.then9
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	va_long_double, .Lfunc_end1-va_long_double

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 96
	i32.sub 	$7=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$7=, 0($2), $7
	i32.const	$push0=, 24
	i32.const	$3=, 64
	i32.add 	$3=, $7, $3
	i32.add 	$push1=, $3, $pop0
	i64.const	$push2=, 4612018121970389534
	i64.store	$discard=, 0($pop1), $pop2
	i32.const	$push3=, 16
	i32.const	$4=, 64
	i32.add 	$4=, $7, $4
	i32.add 	$push4=, $4, $pop3
	i64.const	$push5=, 4612217596080624972
	i64.store	$discard=, 0($pop4):p2align=4, $pop5
	i32.const	$push6=, 8
	i32.const	$5=, 64
	i32.add 	$5=, $7, $5
	i32.or  	$push7=, $5, $pop6
	i64.const	$push8=, 4613303418679563607
	i64.store	$discard=, 0($pop7), $pop8
	i64.const	$push9=, 4614256655080292474
	i64.store	$discard=, 64($7):p2align=4, $pop9
	i32.const	$6=, 64
	i32.add 	$6=, $7, $6
	i32.call	$discard=, va_double@FUNCTION, $0, $6
	i32.const	$push10=, 56
	i32.add 	$push11=, $7, $pop10
	i64.const	$push12=, 4611706774898825505
	i64.store	$discard=, 0($pop11), $pop12
	i32.const	$push13=, 48
	i32.add 	$push14=, $7, $pop13
	i64.const	$push15=, -2718666384188054750
	i64.store	$discard=, 0($pop14):p2align=4, $pop15
	i32.const	$push16=, 40
	i32.add 	$push17=, $7, $pop16
	i64.const	$push18=, 4611719242030715220
	i64.store	$discard=, 0($pop17), $pop18
	i32.const	$push19=, 32
	i32.add 	$push20=, $7, $pop19
	i64.const	$push21=, -4892607794577095924
	i64.store	$discard=, 0($pop20):p2align=4, $pop21
	i32.const	$push32=, 24
	i32.add 	$push22=, $7, $pop32
	i64.const	$push23=, 4611787105943148885
	i64.store	$discard=, 0($pop22), $pop23
	i32.const	$push31=, 16
	i32.add 	$push24=, $7, $pop31
	i64.const	$push25=, 8163791057260899163
	i64.store	$discard=, 0($pop24):p2align=4, $pop25
	i32.const	$push30=, 8
	i32.or  	$push26=, $7, $pop30
	i64.const	$push27=, 4611846683218194439
	i64.store	$discard=, 0($pop26), $pop27
	i64.const	$push28=, -7338557514379428662
	i64.store	$discard=, 0($7):p2align=4, $pop28
	i32.call	$discard=, va_long_double@FUNCTION, $0, $7
	i32.const	$push29=, 0
	call    	exit@FUNCTION, $pop29
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
