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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 16
	i32.sub 	$15=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$15=, 0($1), $15
	i32.const	$push65=, 5
	i32.const	$push64=, 5
	i32.const	$push63=, 5
	i32.const	$push62=, 5
	i32.const	$3=, 12
	i32.add 	$3=, $15, $3
	call    	f1@FUNCTION, $3, $pop65, $pop64, $pop63, $pop62
	i32.load8_u	$push10=, 12($15):p2align=2
	i32.const	$push61=, 1
	i32.const	$4=, 12
	i32.add 	$4=, $15, $4
	i32.or  	$push7=, $4, $pop61
	i32.load8_u	$push8=, 0($pop7)
	i32.const	$push60=, 8
	i32.shl 	$push9=, $pop8, $pop60
	i32.or  	$push11=, $pop10, $pop9
	i32.const	$push59=, 65535
	i32.and 	$push12=, $pop11, $pop59
	i32.const	$push58=, 2
	i32.const	$5=, 12
	i32.add 	$5=, $15, $5
	i32.or  	$push3=, $5, $pop58
	i32.load8_u	$push4=, 0($pop3):p2align=1
	i32.const	$push57=, 3
	i32.const	$6=, 12
	i32.add 	$6=, $15, $6
	block
	block
	block
	i32.or  	$push0=, $6, $pop57
	i32.load8_u	$push1=, 0($pop0)
	i32.const	$push56=, 8
	i32.shl 	$push2=, $pop1, $pop56
	i32.or  	$push5=, $pop4, $pop2
	i32.const	$push55=, 16
	i32.shl 	$push6=, $pop5, $pop55
	i32.or  	$push13=, $pop12, $pop6
	i32.const	$push54=, 33686018
	i32.ne  	$push14=, $pop13, $pop54
	br_if   	0, $pop14       # 0: down to label2
# BB#1:                                 # %if.end
	i32.const	$push77=, 5
	i32.const	$push76=, 5
	i32.const	$push75=, 5
	i32.const	$push74=, 5
	i32.const	$7=, 8
	i32.add 	$7=, $15, $7
	call    	f2@FUNCTION, $7, $pop77, $pop76, $pop75, $pop74
	i32.load8_u	$push25=, 8($15):p2align=2
	i32.const	$push73=, 1
	i32.const	$8=, 8
	i32.add 	$8=, $15, $8
	i32.or  	$push22=, $8, $pop73
	i32.load8_u	$push23=, 0($pop22)
	i32.const	$push72=, 8
	i32.shl 	$push24=, $pop23, $pop72
	i32.or  	$push26=, $pop25, $pop24
	i32.const	$push71=, 65535
	i32.and 	$push27=, $pop26, $pop71
	i32.const	$push70=, 2
	i32.const	$9=, 8
	i32.add 	$9=, $15, $9
	i32.or  	$push18=, $9, $pop70
	i32.load8_u	$push19=, 0($pop18):p2align=1
	i32.const	$push69=, 3
	i32.const	$10=, 8
	i32.add 	$10=, $15, $10
	i32.or  	$push15=, $10, $pop69
	i32.load8_u	$push16=, 0($pop15)
	i32.const	$push68=, 8
	i32.shl 	$push17=, $pop16, $pop68
	i32.or  	$push20=, $pop19, $pop17
	i32.const	$push67=, 16
	i32.shl 	$push21=, $pop20, $pop67
	i32.or  	$push28=, $pop27, $pop21
	i32.const	$push66=, 33686018
	i32.ne  	$push29=, $pop28, $pop66
	br_if   	1, $pop29       # 1: down to label1
# BB#2:                                 # %if.end6
	i32.const	$push31=, 5
	i32.const	$push85=, 5
	i32.const	$push84=, 5
	i32.const	$push83=, 5
	i32.const	$push30=, 2
	i32.const	$push82=, 2
	i32.const	$push81=, 2
	i32.const	$push80=, 2
	i32.const	$11=, 4
	i32.add 	$11=, $15, $11
	call    	f3@FUNCTION, $11, $pop31, $pop85, $pop84, $pop83, $pop30, $pop82, $pop81, $pop80
	i32.load8_u	$push46=, 4($15):p2align=2
	i32.const	$push42=, 1
	i32.const	$12=, 4
	i32.add 	$12=, $15, $12
	i32.or  	$push43=, $12, $pop42
	i32.load8_u	$push44=, 0($pop43)
	i32.const	$push35=, 8
	i32.shl 	$push45=, $pop44, $pop35
	i32.or  	$push47=, $pop46, $pop45
	i32.const	$push48=, 65535
	i32.and 	$push49=, $pop47, $pop48
	i32.const	$push79=, 2
	i32.const	$13=, 4
	i32.add 	$13=, $15, $13
	i32.or  	$push37=, $13, $pop79
	i32.load8_u	$push38=, 0($pop37):p2align=1
	i32.const	$push32=, 3
	i32.const	$14=, 4
	i32.add 	$14=, $15, $14
	i32.or  	$push33=, $14, $pop32
	i32.load8_u	$push34=, 0($pop33)
	i32.const	$push78=, 8
	i32.shl 	$push36=, $pop34, $pop78
	i32.or  	$push39=, $pop38, $pop36
	i32.const	$push40=, 16
	i32.shl 	$push41=, $pop39, $pop40
	i32.or  	$push50=, $pop49, $pop41
	i32.const	$push51=, 33686018
	i32.ne  	$push52=, $pop50, $pop51
	br_if   	2, $pop52       # 2: down to label0
# BB#3:                                 # %if.end11
	i32.const	$push53=, 0
	i32.const	$2=, 16
	i32.add 	$15=, $15, $2
	i32.const	$2=, __stack_pointer
	i32.store	$15=, 0($2), $15
	return  	$pop53
.LBB3_4:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB3_5:                                # %if.then5
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB3_6:                                # %if.then10
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main


	.ident	"clang version 3.9.0 "
