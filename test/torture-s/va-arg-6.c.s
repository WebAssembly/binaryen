	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-6.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i64, i64, f64
# BB#0:                                 # %entry
	i32.const	$push54=, __stack_pointer
	i32.const	$push51=, __stack_pointer
	i32.load	$push52=, 0($pop51)
	i32.const	$push53=, 16
	i32.sub 	$push58=, $pop52, $pop53
	i32.store	$4=, 0($pop54), $pop58
	i32.store	$push60=, 12($4), $1
	tee_local	$push59=, $1=, $pop60
	i32.const	$push3=, 4
	i32.add 	$push0=, $pop59, $pop3
	i32.store	$2=, 12($4), $pop0
	block
	i32.load	$push4=, 0($1)
	i32.const	$push5=, 10
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push7=, 7
	i32.add 	$push8=, $2, $pop7
	i32.const	$push9=, -8
	i32.and 	$push62=, $pop8, $pop9
	tee_local	$push61=, $1=, $pop62
	i64.load	$5=, 0($pop61)
	i32.const	$push10=, 8
	i32.add 	$push11=, $1, $pop10
	i32.store	$2=, 12($4), $pop11
	i64.const	$push12=, 10000000000
	i64.ne  	$push13=, $5, $pop12
	br_if   	0, $pop13       # 0: down to label0
# BB#2:                                 # %if.end6
	i32.const	$push14=, 12
	i32.add 	$push1=, $1, $pop14
	i32.store	$1=, 12($4), $pop1
	i32.load	$push15=, 0($2)
	i32.const	$push16=, 11
	i32.ne  	$push17=, $pop15, $pop16
	br_if   	0, $pop17       # 0: down to label0
# BB#3:                                 # %if.end11
	i32.const	$push18=, 15
	i32.add 	$push19=, $1, $pop18
	i32.const	$push20=, -16
	i32.and 	$push64=, $pop19, $pop20
	tee_local	$push63=, $1=, $pop64
	i64.load	$5=, 8($pop63)
	i64.load	$6=, 0($1)
	i32.const	$push21=, 16
	i32.add 	$push22=, $1, $pop21
	i32.store	$2=, 12($4), $pop22
	i64.const	$push24=, -1475739525896764129
	i64.const	$push23=, 4611846459164112977
	i32.call	$push25=, __eqtf2@FUNCTION, $6, $5, $pop24, $pop23
	br_if   	0, $pop25       # 0: down to label0
# BB#4:                                 # %if.end16
	i32.const	$push26=, 20
	i32.add 	$push27=, $1, $pop26
	i32.store	$3=, 12($4), $pop27
	i32.load	$push28=, 0($2)
	i32.const	$push29=, 12
	i32.ne  	$push30=, $pop28, $pop29
	br_if   	0, $pop30       # 0: down to label0
# BB#5:                                 # %if.end21
	i32.const	$push31=, 24
	i32.add 	$push32=, $1, $pop31
	i32.store	$2=, 12($4), $pop32
	i32.load	$push33=, 0($3)
	i32.const	$push34=, 13
	i32.ne  	$push35=, $pop33, $pop34
	br_if   	0, $pop35       # 0: down to label0
# BB#6:                                 # %if.end26
	i64.load	$5=, 0($2)
	i32.const	$push36=, 32
	i32.add 	$push37=, $1, $pop36
	i32.store	$2=, 12($4), $pop37
	i64.const	$push38=, 20000000000
	i64.ne  	$push39=, $5, $pop38
	br_if   	0, $pop39       # 0: down to label0
# BB#7:                                 # %if.end31
	i32.const	$push40=, 36
	i32.add 	$push2=, $1, $pop40
	i32.store	$1=, 12($4), $pop2
	i32.load	$push41=, 0($2)
	i32.const	$push42=, 14
	i32.ne  	$push43=, $pop41, $pop42
	br_if   	0, $pop43       # 0: down to label0
# BB#8:                                 # %if.end36
	i32.const	$push44=, 7
	i32.add 	$push45=, $1, $pop44
	i32.const	$push46=, -8
	i32.and 	$push66=, $pop45, $pop46
	tee_local	$push65=, $1=, $pop66
	f64.load	$7=, 0($pop65)
	i32.const	$push47=, 8
	i32.add 	$push48=, $1, $pop47
	i32.store	$discard=, 12($4), $pop48
	f64.const	$push49=, 0x1.5c28f5c28f5c3p1
	f64.ne  	$push50=, $7, $pop49
	br_if   	0, $pop50       # 0: down to label0
# BB#9:                                 # %if.end41
	i32.const	$push57=, __stack_pointer
	i32.const	$push55=, 16
	i32.add 	$push56=, $4, $pop55
	i32.store	$discard=, 0($pop57), $pop56
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
	i32.const	$push30=, __stack_pointer
	i32.const	$push27=, __stack_pointer
	i32.load	$push28=, 0($pop27)
	i32.const	$push29=, 80
	i32.sub 	$push31=, $pop28, $pop29
	i32.store	$push33=, 0($pop30), $pop31
	tee_local	$push32=, $0=, $pop33
	i32.const	$push0=, 64
	i32.add 	$push1=, $pop32, $pop0
	i64.const	$push2=, 4613307314293241283
	i64.store	$discard=, 0($pop1), $pop2
	i32.const	$push3=, 56
	i32.add 	$push4=, $0, $pop3
	i32.const	$push5=, 14
	i32.store	$discard=, 0($pop4), $pop5
	i32.const	$push6=, 48
	i32.add 	$push7=, $0, $pop6
	i64.const	$push8=, 20000000000
	i64.store	$discard=, 0($pop7), $pop8
	i32.const	$push9=, 44
	i32.add 	$push10=, $0, $pop9
	i32.const	$push11=, 13
	i32.store	$discard=, 0($pop10), $pop11
	i32.const	$push12=, 40
	i32.add 	$push13=, $0, $pop12
	i32.const	$push14=, 12
	i32.store	$discard=, 0($pop13), $pop14
	i32.const	$push15=, 32
	i32.add 	$push16=, $0, $pop15
	i64.const	$push17=, 4611846459164112977
	i64.store	$discard=, 0($pop16), $pop17
	i32.const	$push18=, 24
	i32.add 	$push19=, $0, $pop18
	i64.const	$push20=, -1475739525896764129
	i64.store	$discard=, 0($pop19), $pop20
	i32.const	$push21=, 16
	i32.add 	$push22=, $0, $pop21
	i32.const	$push23=, 11
	i32.store	$discard=, 0($pop22), $pop23
	i64.const	$push24=, 10000000000
	i64.store	$discard=, 8($0), $pop24
	i32.const	$push25=, 10
	i32.store	$discard=, 0($0), $pop25
	i32.call	$discard=, f@FUNCTION, $0, $0
	i32.const	$push26=, 0
	call    	exit@FUNCTION, $pop26
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
