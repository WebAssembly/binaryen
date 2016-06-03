	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-6.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i64
# BB#0:                                 # %entry
	i32.const	$push60=, 0
	i32.const	$push57=, 0
	i32.load	$push58=, __stack_pointer($pop57)
	i32.const	$push59=, 16
	i32.sub 	$push64=, $pop58, $pop59
	i32.store	$push68=, __stack_pointer($pop60), $pop64
	tee_local	$push67=, $4=, $pop68
	i32.store	$push66=, 12($4), $1
	tee_local	$push65=, $1=, $pop66
	i32.const	$push3=, 4
	i32.add 	$push0=, $pop65, $pop3
	i32.store	$2=, 12($pop67), $pop0
	block
	i32.load	$push4=, 0($1)
	i32.const	$push5=, 10
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push7=, 7
	i32.add 	$push8=, $2, $pop7
	i32.const	$push9=, -8
	i32.and 	$push70=, $pop8, $pop9
	tee_local	$push69=, $1=, $pop70
	i32.const	$push10=, 8
	i32.add 	$push11=, $pop69, $pop10
	i32.store	$2=, 12($4), $pop11
	i64.load	$push12=, 0($1)
	i64.const	$push13=, 10000000000
	i64.ne  	$push14=, $pop12, $pop13
	br_if   	0, $pop14       # 0: down to label0
# BB#2:                                 # %if.end6
	i32.const	$push15=, 12
	i32.add 	$push1=, $1, $pop15
	i32.store	$1=, 12($4), $pop1
	i32.load	$push16=, 0($2)
	i32.const	$push17=, 11
	i32.ne  	$push18=, $pop16, $pop17
	br_if   	0, $pop18       # 0: down to label0
# BB#3:                                 # %if.end11
	i32.const	$push19=, 15
	i32.add 	$push20=, $1, $pop19
	i32.const	$push21=, -16
	i32.and 	$push72=, $pop20, $pop21
	tee_local	$push71=, $1=, $pop72
	i32.const	$push22=, 16
	i32.add 	$push23=, $pop71, $pop22
	i32.store	$2=, 12($4), $pop23
	i64.load	$push25=, 0($1)
	i64.load	$push24=, 8($1)
	i64.const	$push27=, -1475739525896764129
	i64.const	$push26=, 4611846459164112977
	i32.call	$push28=, __eqtf2@FUNCTION, $pop25, $pop24, $pop27, $pop26
	br_if   	0, $pop28       # 0: down to label0
# BB#4:                                 # %if.end16
	i32.const	$push29=, 20
	i32.add 	$push30=, $1, $pop29
	i32.store	$drop=, 12($4), $pop30
	i64.load	$push74=, 0($2)
	tee_local	$push73=, $5=, $pop74
	i32.wrap/i64	$push31=, $pop73
	i32.const	$push32=, 12
	i32.ne  	$push33=, $pop31, $pop32
	br_if   	0, $pop33       # 0: down to label0
# BB#5:                                 # %if.end21
	i32.const	$push34=, 24
	i32.add 	$push35=, $1, $pop34
	i32.store	$2=, 12($4), $pop35
	i64.const	$push36=, -4294967296
	i64.and 	$push37=, $5, $pop36
	i64.const	$push38=, 55834574848
	i64.ne  	$push39=, $pop37, $pop38
	br_if   	0, $pop39       # 0: down to label0
# BB#6:                                 # %if.end26
	i32.const	$push40=, 32
	i32.add 	$push41=, $1, $pop40
	i32.store	$3=, 12($4), $pop41
	i64.load	$push42=, 0($2)
	i64.const	$push43=, 20000000000
	i64.ne  	$push44=, $pop42, $pop43
	br_if   	0, $pop44       # 0: down to label0
# BB#7:                                 # %if.end31
	i32.const	$push45=, 36
	i32.add 	$push2=, $1, $pop45
	i32.store	$1=, 12($4), $pop2
	i32.load	$push46=, 0($3)
	i32.const	$push47=, 14
	i32.ne  	$push48=, $pop46, $pop47
	br_if   	0, $pop48       # 0: down to label0
# BB#8:                                 # %if.end36
	i32.const	$push49=, 7
	i32.add 	$push50=, $1, $pop49
	i32.const	$push51=, -8
	i32.and 	$push76=, $pop50, $pop51
	tee_local	$push75=, $1=, $pop76
	i32.const	$push52=, 8
	i32.add 	$push53=, $pop75, $pop52
	i32.store	$drop=, 12($4), $pop53
	f64.load	$push54=, 0($1)
	f64.const	$push55=, 0x1.5c28f5c28f5c3p1
	f64.ne  	$push56=, $pop54, $pop55
	br_if   	0, $pop56       # 0: down to label0
# BB#9:                                 # %if.end41
	i32.const	$push63=, 0
	i32.const	$push61=, 16
	i32.add 	$push62=, $4, $pop61
	i32.store	$drop=, __stack_pointer($pop63), $pop62
	return  	$4
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
	i32.sub 	$push31=, $pop28, $pop29
	i32.store	$push33=, __stack_pointer($pop30), $pop31
	tee_local	$push32=, $0=, $pop33
	i32.const	$push0=, 64
	i32.add 	$push1=, $pop32, $pop0
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


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
