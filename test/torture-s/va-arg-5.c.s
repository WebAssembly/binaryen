	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-5.c"
	.section	.text.va_double,"ax",@progbits
	.hidden	va_double
	.globl	va_double
	.type	va_double,@function
va_double:                              # @va_double
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$5=, $2, $3
	copy_local	$6=, $5
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	i32.store	$push0=, 12($5), $6
	i32.const	$push31=, 7
	i32.add 	$push1=, $pop0, $pop31
	i32.const	$push30=, -8
	i32.and 	$push2=, $pop1, $pop30
	tee_local	$push29=, $1=, $pop2
	i32.const	$push28=, 8
	i32.add 	$push3=, $pop29, $pop28
	i32.store	$discard=, 12($5), $pop3
	block
	f64.load	$push4=, 0($1)
	f64.const	$push5=, 0x1.921fafc8b007ap1
	f64.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label0
# BB#1:                                 # %if.end
	i32.load	$push7=, 12($5)
	i32.const	$push35=, 7
	i32.add 	$push8=, $pop7, $pop35
	i32.const	$push34=, -8
	i32.and 	$push9=, $pop8, $pop34
	tee_local	$push33=, $1=, $pop9
	i32.const	$push32=, 8
	i32.add 	$push10=, $pop33, $pop32
	i32.store	$discard=, 12($5), $pop10
	block
	f64.load	$push11=, 0($1)
	f64.const	$push12=, 0x1.5bf04577d9557p1
	f64.ne  	$push13=, $pop11, $pop12
	br_if   	0, $pop13       # 0: down to label1
# BB#2:                                 # %if.end4
	i32.load	$push14=, 12($5)
	i32.const	$push39=, 7
	i32.add 	$push15=, $pop14, $pop39
	i32.const	$push38=, -8
	i32.and 	$push16=, $pop15, $pop38
	tee_local	$push37=, $1=, $pop16
	i32.const	$push36=, 8
	i32.add 	$push17=, $pop37, $pop36
	i32.store	$discard=, 12($5), $pop17
	block
	f64.load	$push18=, 0($1)
	f64.const	$push19=, 0x1.1e3779131154cp1
	f64.ne  	$push20=, $pop18, $pop19
	br_if   	0, $pop20       # 0: down to label2
# BB#3:                                 # %if.end7
	i32.load	$push21=, 12($5)
	i32.const	$push43=, 7
	i32.add 	$push22=, $pop21, $pop43
	i32.const	$push42=, -8
	i32.and 	$push23=, $pop22, $pop42
	tee_local	$push41=, $1=, $pop23
	i32.const	$push40=, 8
	i32.add 	$push24=, $pop41, $pop40
	i32.store	$discard=, 12($5), $pop24
	block
	f64.load	$push25=, 0($1)
	f64.const	$push26=, 0x1.12e0be1b5921ep1
	f64.ne  	$push27=, $pop25, $pop26
	br_if   	0, $pop27       # 0: down to label3
# BB#4:                                 # %if.end10
	i32.const	$4=, 16
	i32.add 	$5=, $6, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
	return  	$1
.LBB0_5:                                # %if.then9
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_6:                                # %if.then6
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_7:                                # %if.then3
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_8:                                # %if.then
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
	.param  	i32
	.result 	i32
	.local  	i64, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 16
	i32.sub 	$6=, $3, $4
	copy_local	$7=, $6
	i32.const	$4=, __stack_pointer
	i32.store	$6=, 0($4), $6
	i32.store	$push0=, 12($6), $7
	i32.const	$push45=, 15
	i32.add 	$push1=, $pop0, $pop45
	i32.const	$push44=, -16
	i32.and 	$push2=, $pop1, $pop44
	tee_local	$push43=, $2=, $pop2
	i64.load	$1=, 0($pop43)
	i32.const	$push42=, 8
	i32.or  	$push3=, $2, $pop42
	i32.store	$push4=, 12($6), $pop3
	tee_local	$push41=, $2=, $pop4
	i32.const	$push40=, 8
	i32.add 	$push5=, $pop41, $pop40
	i32.store	$discard=, 12($6), $pop5
	block
	i64.load	$push6=, 0($2)
	i64.const	$push8=, -7338557514379428662
	i64.const	$push7=, 4611846683218194439
	i32.call	$push9=, __eqtf2@FUNCTION, $1, $pop6, $pop8, $pop7
	br_if   	0, $pop9        # 0: down to label4
# BB#1:                                 # %if.end
	i32.load	$push10=, 12($6)
	i32.const	$push51=, 15
	i32.add 	$push11=, $pop10, $pop51
	i32.const	$push50=, -16
	i32.and 	$push12=, $pop11, $pop50
	tee_local	$push49=, $2=, $pop12
	i64.load	$1=, 0($pop49)
	i32.const	$push48=, 8
	i32.or  	$push13=, $2, $pop48
	i32.store	$push14=, 12($6), $pop13
	tee_local	$push47=, $2=, $pop14
	i32.const	$push46=, 8
	i32.add 	$push15=, $pop47, $pop46
	i32.store	$discard=, 12($6), $pop15
	block
	i64.load	$push16=, 0($2)
	i64.const	$push18=, 8163791057260899163
	i64.const	$push17=, 4611787105943148885
	i32.call	$push19=, __eqtf2@FUNCTION, $1, $pop16, $pop18, $pop17
	br_if   	0, $pop19       # 0: down to label5
# BB#2:                                 # %if.end4
	i32.load	$push20=, 12($6)
	i32.const	$push57=, 15
	i32.add 	$push21=, $pop20, $pop57
	i32.const	$push56=, -16
	i32.and 	$push22=, $pop21, $pop56
	tee_local	$push55=, $2=, $pop22
	i64.load	$1=, 0($pop55)
	i32.const	$push54=, 8
	i32.or  	$push23=, $2, $pop54
	i32.store	$push24=, 12($6), $pop23
	tee_local	$push53=, $2=, $pop24
	i32.const	$push52=, 8
	i32.add 	$push25=, $pop53, $pop52
	i32.store	$discard=, 12($6), $pop25
	block
	i64.load	$push26=, 0($2)
	i64.const	$push28=, -4892607794577095924
	i64.const	$push27=, 4611719242030715220
	i32.call	$push29=, __eqtf2@FUNCTION, $1, $pop26, $pop28, $pop27
	br_if   	0, $pop29       # 0: down to label6
# BB#3:                                 # %if.end7
	i32.load	$push30=, 12($6)
	i32.const	$push63=, 15
	i32.add 	$push31=, $pop30, $pop63
	i32.const	$push62=, -16
	i32.and 	$push32=, $pop31, $pop62
	tee_local	$push61=, $2=, $pop32
	i64.load	$1=, 0($pop61)
	i32.const	$push60=, 8
	i32.or  	$push33=, $2, $pop60
	i32.store	$push34=, 12($6), $pop33
	tee_local	$push59=, $2=, $pop34
	i32.const	$push58=, 8
	i32.add 	$push35=, $pop59, $pop58
	i32.store	$discard=, 12($6), $pop35
	block
	i64.load	$push36=, 0($2)
	i64.const	$push38=, -2718666384188054750
	i64.const	$push37=, 4611706774898825505
	i32.call	$push39=, __eqtf2@FUNCTION, $1, $pop36, $pop38, $pop37
	br_if   	0, $pop39       # 0: down to label7
# BB#4:                                 # %if.end10
	i32.const	$5=, 16
	i32.add 	$6=, $7, $5
	i32.const	$5=, __stack_pointer
	i32.store	$6=, 0($5), $6
	return  	$2
.LBB1_5:                                # %if.then9
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB1_6:                                # %if.then6
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB1_7:                                # %if.then3
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB1_8:                                # %if.then
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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$9=, __stack_pointer
	i32.load	$9=, 0($9)
	i32.const	$10=, 64
	i32.sub 	$11=, $9, $10
	i32.const	$10=, __stack_pointer
	i32.store	$11=, 0($10), $11
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 32
	i32.sub 	$11=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$11=, 0($2), $11
	i64.const	$push0=, 4614256655080292474
	i64.store	$discard=, 0($11), $pop0
	i32.const	$push1=, 24
	i32.add 	$0=, $11, $pop1
	i64.const	$push2=, 4612018121970389534
	i64.store	$discard=, 0($0), $pop2
	i32.const	$push3=, 16
	i32.add 	$0=, $11, $pop3
	i64.const	$push4=, 4612217596080624972
	i64.store	$discard=, 0($0), $pop4
	i32.const	$push5=, 8
	i32.add 	$0=, $11, $pop5
	i64.const	$push6=, 4613303418679563607
	i64.store	$discard=, 0($0), $pop6
	i32.call	$discard=, va_double@FUNCTION, $0
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 32
	i32.add 	$11=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$11=, 0($4), $11
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 64
	i32.sub 	$11=, $5, $6
	i32.const	$6=, __stack_pointer
	i32.store	$11=, 0($6), $11
	i64.const	$push7=, -7338557514379428662
	i64.store	$discard=, 0($11), $pop7
	i32.const	$push8=, 56
	i32.add 	$0=, $11, $pop8
	i64.const	$push9=, 4611706774898825505
	i64.store	$discard=, 0($0), $pop9
	i32.const	$push10=, 48
	i32.add 	$0=, $11, $pop10
	i64.const	$push11=, -2718666384188054750
	i64.store	$discard=, 0($0), $pop11
	i32.const	$push12=, 40
	i32.add 	$0=, $11, $pop12
	i64.const	$push13=, 4611719242030715220
	i64.store	$discard=, 0($0), $pop13
	i32.const	$push14=, 32
	i32.add 	$0=, $11, $pop14
	i64.const	$push15=, -4892607794577095924
	i64.store	$discard=, 0($0), $pop15
	i32.const	$push22=, 24
	i32.add 	$0=, $11, $pop22
	i64.const	$push16=, 4611787105943148885
	i64.store	$discard=, 0($0), $pop16
	i32.const	$push21=, 16
	i32.add 	$0=, $11, $pop21
	i64.const	$push17=, 8163791057260899163
	i64.store	$discard=, 0($0), $pop17
	i32.const	$push20=, 8
	i32.add 	$0=, $11, $pop20
	i64.const	$push18=, 4611846683218194439
	i64.store	$discard=, 0($0), $pop18
	i32.call	$discard=, va_long_double@FUNCTION, $0
	i32.const	$7=, __stack_pointer
	i32.load	$7=, 0($7)
	i32.const	$8=, 64
	i32.add 	$11=, $7, $8
	i32.const	$8=, __stack_pointer
	i32.store	$11=, 0($8), $11
	i32.const	$push19=, 0
	call    	exit@FUNCTION, $pop19
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
