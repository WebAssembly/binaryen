	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-17.c"
	.section	.text.vafunction,"ax",@progbits
	.hidden	vafunction
	.globl	vafunction
	.type	vafunction,@function
vafunction:                             # @vafunction
	.param  	i32, i32
	.local  	i32, f64, i32
# BB#0:                                 # %entry
	i32.const	$push42=, __stack_pointer
	i32.load	$push43=, 0($pop42)
	i32.const	$push44=, 16
	i32.sub 	$4=, $pop43, $pop44
	i32.const	$push45=, __stack_pointer
	i32.store	$discard=, 0($pop45), $4
	i32.store	$push0=, 12($4), $1
	i32.const	$push1=, 7
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -8
	i32.and 	$push41=, $pop2, $pop3
	tee_local	$push40=, $1=, $pop41
	f64.load	$3=, 0($pop40)
	i32.const	$push4=, 8
	i32.add 	$push5=, $1, $pop4
	i32.store	$2=, 12($4), $pop5
	block
	f64.const	$push6=, 0x1p0
	f64.ne  	$push7=, $3, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#1:                                 # %if.end
	f64.load	$3=, 0($2)
	i32.const	$push8=, 16
	i32.add 	$push9=, $1, $pop8
	i32.store	$2=, 12($4), $pop9
	f64.const	$push10=, 0x1p1
	f64.ne  	$push11=, $3, $pop10
	br_if   	0, $pop11       # 0: down to label0
# BB#2:                                 # %if.end6
	f64.load	$3=, 0($2)
	i32.const	$push12=, 24
	i32.add 	$push13=, $1, $pop12
	i32.store	$2=, 12($4), $pop13
	f64.const	$push14=, 0x1.8p1
	f64.ne  	$push15=, $3, $pop14
	br_if   	0, $pop15       # 0: down to label0
# BB#3:                                 # %if.end11
	f64.load	$3=, 0($2)
	i32.const	$push16=, 32
	i32.add 	$push17=, $1, $pop16
	i32.store	$2=, 12($4), $pop17
	f64.const	$push18=, 0x1p2
	f64.ne  	$push19=, $3, $pop18
	br_if   	0, $pop19       # 0: down to label0
# BB#4:                                 # %if.end16
	f64.load	$3=, 0($2)
	i32.const	$push20=, 40
	i32.add 	$push21=, $1, $pop20
	i32.store	$2=, 12($4), $pop21
	f64.const	$push22=, 0x1.4p2
	f64.ne  	$push23=, $3, $pop22
	br_if   	0, $pop23       # 0: down to label0
# BB#5:                                 # %if.end21
	f64.load	$3=, 0($2)
	i32.const	$push24=, 48
	i32.add 	$push25=, $1, $pop24
	i32.store	$2=, 12($4), $pop25
	f64.const	$push26=, 0x1.8p2
	f64.ne  	$push27=, $3, $pop26
	br_if   	0, $pop27       # 0: down to label0
# BB#6:                                 # %if.end26
	f64.load	$3=, 0($2)
	i32.const	$push28=, 56
	i32.add 	$push29=, $1, $pop28
	i32.store	$2=, 12($4), $pop29
	f64.const	$push30=, 0x1.cp2
	f64.ne  	$push31=, $3, $pop30
	br_if   	0, $pop31       # 0: down to label0
# BB#7:                                 # %if.end31
	f64.load	$3=, 0($2)
	i32.const	$push32=, 64
	i32.add 	$push33=, $1, $pop32
	i32.store	$2=, 12($4), $pop33
	f64.const	$push34=, 0x1p3
	f64.ne  	$push35=, $3, $pop34
	br_if   	0, $pop35       # 0: down to label0
# BB#8:                                 # %if.end36
	f64.load	$3=, 0($2)
	i32.const	$push36=, 72
	i32.add 	$push37=, $1, $pop36
	i32.store	$discard=, 12($4), $pop37
	f64.const	$push38=, 0x1.2p3
	f64.ne  	$push39=, $3, $pop38
	br_if   	0, $pop39       # 0: down to label0
# BB#9:                                 # %if.end41
	i32.const	$push46=, 16
	i32.add 	$4=, $4, $pop46
	i32.const	$push47=, __stack_pointer
	i32.store	$discard=, 0($pop47), $4
	return
.LBB0_10:                               # %if.then40
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	vafunction, .Lfunc_end0-vafunction

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push24=, __stack_pointer
	i32.load	$push25=, 0($pop24)
	i32.const	$push26=, 80
	i32.sub 	$1=, $pop25, $pop26
	i32.const	$push27=, __stack_pointer
	i32.store	$discard=, 0($pop27), $1
	i32.const	$push0=, 64
	i32.add 	$push1=, $1, $pop0
	i64.const	$push2=, 4621256167635550208
	i64.store	$discard=, 0($pop1):p2align=4, $pop2
	i32.const	$push3=, 56
	i32.add 	$push4=, $1, $pop3
	i64.const	$push5=, 4620693217682128896
	i64.store	$discard=, 0($pop4), $pop5
	i32.const	$push6=, 48
	i32.add 	$push7=, $1, $pop6
	i64.const	$push8=, 4619567317775286272
	i64.store	$discard=, 0($pop7):p2align=4, $pop8
	i32.const	$push9=, 40
	i32.add 	$push10=, $1, $pop9
	i64.const	$push11=, 4618441417868443648
	i64.store	$discard=, 0($pop10), $pop11
	i32.const	$push12=, 32
	i32.add 	$push13=, $1, $pop12
	i64.const	$push14=, 4617315517961601024
	i64.store	$discard=, 0($pop13):p2align=4, $pop14
	i32.const	$push15=, 24
	i32.add 	$push16=, $1, $pop15
	i64.const	$push17=, 4616189618054758400
	i64.store	$discard=, 0($pop16), $pop17
	i32.const	$push18=, 16
	i32.add 	$push19=, $1, $pop18
	i64.const	$push20=, 4613937818241073152
	i64.store	$discard=, 0($pop19):p2align=4, $pop20
	i64.const	$push21=, 4611686018427387904
	i64.store	$discard=, 8($1), $pop21
	i64.const	$push22=, 4607182418800017408
	i64.store	$discard=, 0($1):p2align=4, $pop22
	call    	vafunction@FUNCTION, $0, $1
	i32.const	$push23=, 0
	call    	exit@FUNCTION, $pop23
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
