	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr60960.c"
	.section	.text.f1,"ax",@progbits
	.hidden	f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 255
	i32.and 	$push3=, $2, $pop0
	i32.const	$push8=, 0
	i32.div_u	$2=, $pop3, $pop8
	i32.const	$push19=, 255
	i32.and 	$push2=, $3, $pop19
	i32.const	$push18=, 0
	i32.div_u	$3=, $pop2, $pop18
	i32.const	$push10=, 3
	i32.add 	$push11=, $0, $pop10
	i32.const	$push17=, 255
	i32.and 	$push1=, $4, $pop17
	i32.const	$push16=, 0
	i32.div_u	$push9=, $pop1, $pop16
	i32.store8	$discard=, 0($pop11):p2align=2, $pop9
	i32.const	$push12=, 2
	i32.add 	$push13=, $0, $pop12
	i32.store8	$discard=, 0($pop13):p2align=2, $3
	i32.const	$push6=, 1
	i32.add 	$push14=, $0, $pop6
	i32.store8	$discard=, 0($pop14):p2align=2, $2
	i32.const	$push4=, 254
	i32.and 	$push5=, $1, $pop4
	i32.const	$push15=, 1
	i32.shr_u	$push7=, $pop5, $pop15
	i32.store8	$discard=, 0($0):p2align=2, $pop7
	return
	.endfunc
.Lfunc_end0:
	.size	f1, .Lfunc_end0-f1

	.section	.text.f2,"ax",@progbits
	.hidden	f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.param  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push10=, 3
	i32.add 	$push11=, $0, $pop10
	i32.const	$push0=, 254
	i32.and 	$push1=, $4, $pop0
	i32.const	$push5=, 1
	i32.shr_u	$push9=, $pop1, $pop5
	i32.store8	$discard=, 0($pop11):p2align=2, $pop9
	i32.const	$push12=, 2
	i32.add 	$push13=, $0, $pop12
	i32.const	$push21=, 254
	i32.and 	$push2=, $3, $pop21
	i32.const	$push20=, 1
	i32.shr_u	$push8=, $pop2, $pop20
	i32.store8	$discard=, 0($pop13):p2align=2, $pop8
	i32.const	$push19=, 1
	i32.add 	$push14=, $0, $pop19
	i32.const	$push18=, 254
	i32.and 	$push3=, $2, $pop18
	i32.const	$push17=, 1
	i32.shr_u	$push7=, $pop3, $pop17
	i32.store8	$discard=, 0($pop14):p2align=2, $pop7
	i32.const	$push16=, 254
	i32.and 	$push4=, $1, $pop16
	i32.const	$push15=, 1
	i32.shr_u	$push6=, $pop4, $pop15
	i32.store8	$discard=, 0($0):p2align=2, $pop6
	return
	.endfunc
.Lfunc_end1:
	.size	f2, .Lfunc_end1-f2

	.section	.text.f3,"ax",@progbits
	.hidden	f3
	.globl	f3
	.type	f3,@function
f3:                                     # @f3
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 255
	i32.and 	$push8=, $1, $pop0
	i32.const	$push22=, 255
	i32.and 	$push7=, $5, $pop22
	i32.div_u	$5=, $pop8, $pop7
	i32.const	$push21=, 255
	i32.and 	$push6=, $2, $pop21
	i32.const	$push20=, 255
	i32.and 	$push5=, $6, $pop20
	i32.div_u	$6=, $pop6, $pop5
	i32.const	$push19=, 255
	i32.and 	$push4=, $3, $pop19
	i32.const	$push18=, 255
	i32.and 	$push3=, $7, $pop18
	i32.div_u	$7=, $pop4, $pop3
	i32.const	$push10=, 3
	i32.add 	$push11=, $0, $pop10
	i32.const	$push17=, 255
	i32.and 	$push2=, $4, $pop17
	i32.const	$push16=, 255
	i32.and 	$push1=, $8, $pop16
	i32.div_u	$push9=, $pop2, $pop1
	i32.store8	$discard=, 0($pop11):p2align=2, $pop9
	i32.const	$push12=, 2
	i32.add 	$push13=, $0, $pop12
	i32.store8	$discard=, 0($pop13):p2align=2, $7
	i32.const	$push14=, 1
	i32.add 	$push15=, $0, $pop14
	i32.store8	$discard=, 0($pop15):p2align=2, $6
	i32.store8	$discard=, 0($0):p2align=2, $5
	return
	.endfunc
.Lfunc_end2:
	.size	f3, .Lfunc_end2-f3

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push68=, __stack_pointer
	i32.load	$push69=, 0($pop68)
	i32.const	$push70=, 16
	i32.sub 	$0=, $pop69, $pop70
	i32.const	$push71=, __stack_pointer
	i32.store	$discard=, 0($pop71), $0
	i32.const	$push75=, 12
	i32.add 	$push76=, $0, $pop75
	i32.const	$push51=, 5
	i32.const	$push50=, 5
	i32.const	$push49=, 5
	i32.const	$push48=, 5
	call    	f1@FUNCTION, $pop76, $pop51, $pop50, $pop49, $pop48
	block
	i32.load8_u	$push7=, 12($0):p2align=2
	i32.load8_u	$push5=, 13($0)
	i32.const	$push47=, 8
	i32.shl 	$push6=, $pop5, $pop47
	i32.or  	$push8=, $pop7, $pop6
	i32.const	$push46=, 65535
	i32.and 	$push9=, $pop8, $pop46
	i32.load8_u	$push2=, 14($0):p2align=1
	i32.load8_u	$push0=, 15($0)
	i32.const	$push45=, 8
	i32.shl 	$push1=, $pop0, $pop45
	i32.or  	$push3=, $pop2, $pop1
	i32.const	$push44=, 16
	i32.shl 	$push4=, $pop3, $pop44
	i32.or  	$push10=, $pop9, $pop4
	i32.const	$push43=, 33686018
	i32.ne  	$push11=, $pop10, $pop43
	br_if   	0, $pop11       # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push77=, 8
	i32.add 	$push78=, $0, $pop77
	i32.const	$push60=, 5
	i32.const	$push59=, 5
	i32.const	$push58=, 5
	i32.const	$push57=, 5
	call    	f2@FUNCTION, $pop78, $pop60, $pop59, $pop58, $pop57
	i32.load8_u	$push19=, 8($0):p2align=2
	i32.load8_u	$push17=, 9($0)
	i32.const	$push56=, 8
	i32.shl 	$push18=, $pop17, $pop56
	i32.or  	$push20=, $pop19, $pop18
	i32.const	$push55=, 65535
	i32.and 	$push21=, $pop20, $pop55
	i32.load8_u	$push14=, 10($0):p2align=1
	i32.load8_u	$push12=, 11($0)
	i32.const	$push54=, 8
	i32.shl 	$push13=, $pop12, $pop54
	i32.or  	$push15=, $pop14, $pop13
	i32.const	$push53=, 16
	i32.shl 	$push16=, $pop15, $pop53
	i32.or  	$push22=, $pop21, $pop16
	i32.const	$push52=, 33686018
	i32.ne  	$push23=, $pop22, $pop52
	br_if   	0, $pop23       # 0: down to label0
# BB#2:                                 # %if.end6
	i32.const	$push79=, 4
	i32.add 	$push80=, $0, $pop79
	i32.const	$push25=, 5
	i32.const	$push67=, 5
	i32.const	$push66=, 5
	i32.const	$push65=, 5
	i32.const	$push24=, 2
	i32.const	$push64=, 2
	i32.const	$push63=, 2
	i32.const	$push62=, 2
	call    	f3@FUNCTION, $pop80, $pop25, $pop67, $pop66, $pop65, $pop24, $pop64, $pop63, $pop62
	i32.load8_u	$push35=, 4($0):p2align=2
	i32.load8_u	$push33=, 5($0)
	i32.const	$push27=, 8
	i32.shl 	$push34=, $pop33, $pop27
	i32.or  	$push36=, $pop35, $pop34
	i32.const	$push37=, 65535
	i32.and 	$push38=, $pop36, $pop37
	i32.load8_u	$push29=, 6($0):p2align=1
	i32.load8_u	$push26=, 7($0)
	i32.const	$push61=, 8
	i32.shl 	$push28=, $pop26, $pop61
	i32.or  	$push30=, $pop29, $pop28
	i32.const	$push31=, 16
	i32.shl 	$push32=, $pop30, $pop31
	i32.or  	$push39=, $pop38, $pop32
	i32.const	$push40=, 33686018
	i32.ne  	$push41=, $pop39, $pop40
	br_if   	0, $pop41       # 0: down to label0
# BB#3:                                 # %if.end11
	i32.const	$push42=, 0
	i32.const	$push74=, __stack_pointer
	i32.const	$push72=, 16
	i32.add 	$push73=, $0, $pop72
	i32.store	$discard=, 0($pop74), $pop73
	return  	$pop42
.LBB3_4:                                # %if.then10
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main


	.ident	"clang version 3.9.0 "
