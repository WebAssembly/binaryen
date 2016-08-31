	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-6.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32, i64, i32, i32
# BB#0:                                 # %entry
	i32.const	$push53=, 0
	i32.const	$push50=, 0
	i32.load	$push51=, __stack_pointer($pop50)
	i32.const	$push52=, 16
	i32.sub 	$push60=, $pop51, $pop52
	tee_local	$push59=, $5=, $pop60
	i32.store	$drop=, __stack_pointer($pop53), $pop59
	i32.store	$drop=, 12($5), $1
	i32.const	$push0=, 4
	i32.add 	$push58=, $1, $pop0
	tee_local	$push57=, $2=, $pop58
	i32.store	$drop=, 12($5), $pop57
	block
	i32.load	$push1=, 0($1)
	i32.const	$push2=, 10
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push4=, 7
	i32.add 	$push5=, $2, $pop4
	i32.const	$push6=, -8
	i32.and 	$push64=, $pop5, $pop6
	tee_local	$push63=, $1=, $pop64
	i32.const	$push7=, 8
	i32.add 	$push62=, $pop63, $pop7
	tee_local	$push61=, $2=, $pop62
	i32.store	$drop=, 12($5), $pop61
	i64.load	$push8=, 0($1)
	i64.const	$push9=, 10000000000
	i64.ne  	$push10=, $pop8, $pop9
	br_if   	0, $pop10       # 0: down to label0
# BB#2:                                 # %if.end6
	i32.const	$push11=, 12
	i32.add 	$push66=, $1, $pop11
	tee_local	$push65=, $1=, $pop66
	i32.store	$drop=, 12($5), $pop65
	i32.load	$push12=, 0($2)
	i32.const	$push13=, 11
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	0, $pop14       # 0: down to label0
# BB#3:                                 # %if.end11
	i32.const	$push15=, 15
	i32.add 	$push16=, $1, $pop15
	i32.const	$push17=, -16
	i32.and 	$push70=, $pop16, $pop17
	tee_local	$push69=, $1=, $pop70
	i32.const	$push18=, 16
	i32.add 	$push68=, $pop69, $pop18
	tee_local	$push67=, $2=, $pop68
	i32.store	$drop=, 12($5), $pop67
	i64.load	$push20=, 0($1)
	i64.load	$push19=, 8($1)
	i64.const	$push22=, -1475739525896764129
	i64.const	$push21=, 4611846459164112977
	i32.call	$push23=, __eqtf2@FUNCTION, $pop20, $pop19, $pop22, $pop21
	br_if   	0, $pop23       # 0: down to label0
# BB#4:                                 # %if.end16
	i32.const	$push24=, 20
	i32.add 	$push25=, $1, $pop24
	i32.store	$drop=, 12($5), $pop25
	i64.load	$push72=, 0($2)
	tee_local	$push71=, $3=, $pop72
	i32.wrap/i64	$push26=, $pop71
	i32.const	$push27=, 12
	i32.ne  	$push28=, $pop26, $pop27
	br_if   	0, $pop28       # 0: down to label0
# BB#5:                                 # %if.end21
	i32.const	$push29=, 24
	i32.add 	$push74=, $1, $pop29
	tee_local	$push73=, $2=, $pop74
	i32.store	$drop=, 12($5), $pop73
	i64.const	$push30=, -4294967296
	i64.and 	$push31=, $3, $pop30
	i64.const	$push32=, 55834574848
	i64.ne  	$push33=, $pop31, $pop32
	br_if   	0, $pop33       # 0: down to label0
# BB#6:                                 # %if.end26
	i32.const	$push34=, 32
	i32.add 	$push76=, $1, $pop34
	tee_local	$push75=, $4=, $pop76
	i32.store	$drop=, 12($5), $pop75
	i64.load	$push35=, 0($2)
	i64.const	$push36=, 20000000000
	i64.ne  	$push37=, $pop35, $pop36
	br_if   	0, $pop37       # 0: down to label0
# BB#7:                                 # %if.end31
	i32.const	$push38=, 36
	i32.add 	$push78=, $1, $pop38
	tee_local	$push77=, $1=, $pop78
	i32.store	$drop=, 12($5), $pop77
	i32.load	$push39=, 0($4)
	i32.const	$push40=, 14
	i32.ne  	$push41=, $pop39, $pop40
	br_if   	0, $pop41       # 0: down to label0
# BB#8:                                 # %if.end36
	i32.const	$push42=, 7
	i32.add 	$push43=, $1, $pop42
	i32.const	$push44=, -8
	i32.and 	$push80=, $pop43, $pop44
	tee_local	$push79=, $1=, $pop80
	i32.const	$push45=, 8
	i32.add 	$push46=, $pop79, $pop45
	i32.store	$drop=, 12($5), $pop46
	f64.load	$push47=, 0($1)
	f64.const	$push48=, 0x1.5c28f5c28f5c3p1
	f64.ne  	$push49=, $pop47, $pop48
	br_if   	0, $pop49       # 0: down to label0
# BB#9:                                 # %if.end41
	i32.const	$push56=, 0
	i32.const	$push54=, 16
	i32.add 	$push55=, $5, $pop54
	i32.store	$drop=, __stack_pointer($pop56), $pop55
	return  	$5
.LBB0_10:                               # %if.then40
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push30=, 0
	i32.const	$push27=, 0
	i32.load	$push28=, __stack_pointer($pop27)
	i32.const	$push29=, 80
	i32.sub 	$push32=, $pop28, $pop29
	tee_local	$push31=, $0=, $pop32
	i32.store	$drop=, __stack_pointer($pop30), $pop31
	i32.const	$push0=, 64
	i32.add 	$push1=, $0, $pop0
	i64.const	$push2=, 4613307314293241283
	i64.store	$drop=, 0($pop1), $pop2
	i32.const	$push3=, 56
	i32.add 	$push4=, $0, $pop3
	i32.const	$push5=, 14
	i32.store	$drop=, 0($pop4), $pop5
	i32.const	$push6=, 48
	i32.add 	$push7=, $0, $pop6
	i64.const	$push8=, 20000000000
	i64.store	$drop=, 0($pop7), $pop8
	i32.const	$push9=, 44
	i32.add 	$push10=, $0, $pop9
	i32.const	$push11=, 13
	i32.store	$drop=, 0($pop10), $pop11
	i32.const	$push12=, 40
	i32.add 	$push13=, $0, $pop12
	i32.const	$push14=, 12
	i32.store	$drop=, 0($pop13), $pop14
	i32.const	$push15=, 32
	i32.add 	$push16=, $0, $pop15
	i64.const	$push17=, 4611846459164112977
	i64.store	$drop=, 0($pop16), $pop17
	i32.const	$push18=, 24
	i32.add 	$push19=, $0, $pop18
	i64.const	$push20=, -1475739525896764129
	i64.store	$drop=, 0($pop19), $pop20
	i32.const	$push21=, 16
	i32.add 	$push22=, $0, $pop21
	i32.const	$push23=, 11
	i32.store	$drop=, 0($pop22), $pop23
	i64.const	$push24=, 10000000000
	i64.store	$drop=, 8($0), $pop24
	i32.const	$push25=, 10
	i32.store	$drop=, 0($0), $pop25
	i32.call	$drop=, f@FUNCTION, $0, $0
	i32.const	$push26=, 0
	call    	exit@FUNCTION, $pop26
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 "
	.functype	abort, void
	.functype	exit, void, i32
