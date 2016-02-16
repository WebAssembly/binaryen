	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/cbrt.c"
	.section	.text.cbrtl,"ax",@progbits
	.hidden	cbrtl
	.globl	cbrtl
	.type	cbrtl,@function
cbrtl:                                  # @cbrtl
	.param  	f64
	.result 	f64
	.local  	f64, i32, i32, i64, f64, f64, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$7=, __stack_pointer
	i32.load	$7=, 0($7)
	i32.const	$8=, 16
	i32.sub 	$13=, $7, $8
	i32.const	$8=, __stack_pointer
	i32.store	$13=, 0($8), $13
	i64.const	$push0=, 0
	i64.store	$discard=, 8($13), $pop0
	block
	block
	f64.store	$push76=, 0($13), $0
	tee_local	$push75=, $0=, $pop76
	i64.reinterpret/f64	$push74=, $pop75
	tee_local	$push73=, $4=, $pop74
	i64.const	$push1=, 32
	i64.shr_u	$push2=, $pop73, $pop1
	i32.wrap/i64	$push72=, $pop2
	tee_local	$push71=, $3=, $pop72
	i32.const	$push3=, -2147483648
	i32.and 	$push70=, $pop71, $pop3
	tee_local	$push69=, $2=, $pop70
	i32.xor 	$push68=, $pop69, $3
	tee_local	$push67=, $3=, $pop68
	i32.const	$push4=, 2146435072
	i32.lt_s	$push5=, $pop67, $pop4
	br_if   	0, $pop5        # 0: down to label1
# BB#1:                                 # %if.then
	f64.add 	$0=, $0, $0
	br      	1               # 1: down to label0
.LBB0_2:                                # %if.end
	end_block                       # label1:
	i32.wrap/i64	$push6=, $4
	i32.or  	$push7=, $pop6, $3
	i32.const	$push93=, 0
	i32.eq  	$push94=, $pop7, $pop93
	br_if   	0, $pop94       # 0: down to label0
# BB#3:                                 # %if.end13
	block
	block
	i32.const	$push79=, 4
	i32.or  	$push8=, $13, $pop79
	i32.store	$push78=, 0($pop8), $3
	tee_local	$push77=, $3=, $pop78
	i32.const	$push9=, 1048575
	i32.gt_s	$push10=, $pop77, $pop9
	br_if   	0, $pop10       # 0: down to label3
# BB#4:                                 # %if.then18
	i32.const	$push82=, 4
	i32.const	$10=, 8
	i32.add 	$10=, $13, $10
	i32.or  	$push81=, $10, $pop82
	tee_local	$push80=, $3=, $pop81
	i32.const	$push16=, 1129316352
	i32.store	$discard=, 0($pop80), $pop16
	f64.load	$push17=, 8($13)
	f64.mul 	$push18=, $pop17, $0
	f64.store	$push19=, 8($13), $pop18
	i64.reinterpret/f64	$push20=, $pop19
	i64.const	$push21=, 32
	i64.shr_u	$push22=, $pop20, $pop21
	i32.wrap/i64	$push23=, $pop22
	i32.const	$push24=, 3
	i32.div_u	$push25=, $pop23, $pop24
	i32.const	$push26=, 696219795
	i32.add 	$push27=, $pop25, $pop26
	i32.store	$discard=, 0($3), $pop27
	br      	1               # 1: down to label2
.LBB0_5:                                # %if.else
	end_block                       # label3:
	i32.const	$push83=, 4
	i32.const	$12=, 8
	i32.add 	$12=, $13, $12
	i32.or  	$push15=, $12, $pop83
	i32.const	$push11=, 3
	i32.div_s	$push12=, $3, $pop11
	i32.const	$push13=, 715094163
	i32.add 	$push14=, $pop12, $pop13
	i32.store	$discard=, 0($pop15), $pop14
.LBB0_6:                                # %if.end31
	end_block                       # label2:
	f64.load	$1=, 8($13)
	f64.const	$push37=, 0x1.9b6db6db6db6ep0
	f64.mul 	$push28=, $1, $1
	f64.load	$push92=, 0($13)
	tee_local	$push91=, $6=, $pop92
	f64.div 	$push29=, $pop28, $pop91
	f64.mul 	$push30=, $1, $pop29
	f64.const	$push31=, 0x1.15f15f15f15f1p-1
	f64.add 	$push90=, $pop30, $pop31
	tee_local	$push89=, $5=, $pop90
	f64.const	$push32=, 0x1.6a0ea0ea0ea0fp0
	f64.add 	$push33=, $pop89, $pop32
	f64.const	$push34=, -0x1.691de2532c834p-1
	f64.div 	$push35=, $pop34, $5
	f64.add 	$push36=, $pop33, $pop35
	f64.div 	$push38=, $pop37, $pop36
	f64.const	$push39=, 0x1.6db6db6db6db7p-2
	f64.add 	$push40=, $pop38, $pop39
	f64.mul 	$push41=, $1, $pop40
	f64.store	$1=, 8($13), $pop41
	i32.const	$push42=, 0
	i32.store	$discard=, 8($13):p2align=3, $pop42
	i32.const	$push49=, 4
	i32.const	$11=, 8
	i32.add 	$11=, $13, $11
	i32.or  	$push88=, $11, $pop49
	tee_local	$push87=, $3=, $pop88
	i64.reinterpret/f64	$push43=, $1
	i64.const	$push44=, 32
	i64.shr_u	$push45=, $pop43, $pop44
	i32.wrap/i64	$push46=, $pop45
	i32.const	$push47=, 1
	i32.add 	$push48=, $pop46, $pop47
	i32.store	$discard=, 0($pop87), $pop48
	f64.load	$1=, 8($13)
	f64.mul 	$push50=, $1, $1
	f64.div 	$push86=, $6, $pop50
	tee_local	$push85=, $6=, $pop86
	f64.sub 	$push52=, $pop85, $1
	f64.add 	$push51=, $1, $1
	f64.add 	$push53=, $pop51, $6
	f64.div 	$push54=, $pop52, $pop53
	f64.mul 	$push55=, $1, $pop54
	f64.add 	$push56=, $1, $pop55
	f64.store	$push57=, 8($13), $pop56
	i64.reinterpret/f64	$push58=, $pop57
	i64.const	$push84=, 32
	i64.shr_u	$push59=, $pop58, $pop84
	i32.wrap/i64	$push60=, $pop59
	i32.or  	$push61=, $pop60, $2
	i32.store	$discard=, 0($3), $pop61
	f64.load	$1=, 8($13)
	f64.mul 	$push62=, $1, $1
	f64.div 	$push63=, $0, $pop62
	f64.sub 	$push64=, $1, $pop63
	f64.const	$push65=, -0x1.5555555555555p-2
	f64.mul 	$push66=, $pop64, $pop65
	f64.add 	$0=, $1, $pop66
.LBB0_7:                                # %cleanup
	end_block                       # label0:
	i32.const	$9=, 16
	i32.add 	$13=, $13, $9
	i32.const	$9=, __stack_pointer
	i32.store	$13=, 0($9), $13
	return  	$0
	.endfunc
.Lfunc_end0:
	.size	cbrtl, .Lfunc_end0-cbrtl

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
