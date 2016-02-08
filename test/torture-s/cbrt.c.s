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
	i64.const	$push3=, 0
	i64.store	$discard=, 8($13), $pop3
	block
	block
	f64.store	$push77=, 0($13), $0
	tee_local	$push82=, $0=, $pop77
	i64.reinterpret/f64	$push0=, $pop82
	tee_local	$push81=, $4=, $pop0
	i64.const	$push4=, 32
	i64.shr_u	$push5=, $pop81, $pop4
	i32.wrap/i64	$push6=, $pop5
	tee_local	$push80=, $3=, $pop6
	i32.const	$push7=, -2147483648
	i32.and 	$push1=, $pop80, $pop7
	tee_local	$push79=, $2=, $pop1
	i32.xor 	$push2=, $pop79, $3
	tee_local	$push78=, $3=, $pop2
	i32.const	$push8=, 2146435072
	i32.lt_s	$push9=, $pop78, $pop8
	br_if   	0, $pop9        # 0: down to label1
# BB#1:                                 # %if.then
	f64.add 	$0=, $0, $0
	br      	1               # 1: down to label0
.LBB0_2:                                # %if.end
	end_block                       # label1:
	i32.wrap/i64	$push10=, $4
	i32.or  	$push11=, $pop10, $3
	i32.const	$push93=, 0
	i32.eq  	$push94=, $pop11, $pop93
	br_if   	0, $pop94       # 0: down to label0
# BB#3:                                 # %if.end13
	block
	block
	i32.const	$push84=, 4
	i32.or  	$push12=, $13, $pop84
	i32.store	$push13=, 0($pop12), $3
	tee_local	$push83=, $3=, $pop13
	i32.const	$push14=, 1048575
	i32.gt_s	$push15=, $pop83, $pop14
	br_if   	0, $pop15       # 0: down to label3
# BB#4:                                 # %if.then18
	i32.const	$push86=, 4
	i32.const	$10=, 8
	i32.add 	$10=, $13, $10
	i32.or  	$push21=, $10, $pop86
	tee_local	$push85=, $3=, $pop21
	i32.const	$push22=, 1129316352
	i32.store	$discard=, 0($pop85), $pop22
	f64.load	$push23=, 8($13)
	f64.mul 	$push24=, $pop23, $0
	f64.store	$push25=, 8($13), $pop24
	i64.reinterpret/f64	$push26=, $pop25
	i64.const	$push27=, 32
	i64.shr_u	$push28=, $pop26, $pop27
	i32.wrap/i64	$push29=, $pop28
	i32.const	$push30=, 3
	i32.div_u	$push31=, $pop29, $pop30
	i32.const	$push32=, 696219795
	i32.add 	$push33=, $pop31, $pop32
	i32.store	$discard=, 0($3), $pop33
	br      	1               # 1: down to label2
.LBB0_5:                                # %if.else
	end_block                       # label3:
	i32.const	$push87=, 4
	i32.const	$12=, 8
	i32.add 	$12=, $13, $12
	i32.or  	$push20=, $12, $pop87
	i32.const	$push16=, 3
	i32.div_s	$push17=, $3, $pop16
	i32.const	$push18=, 715094163
	i32.add 	$push19=, $pop17, $pop18
	i32.store	$discard=, 0($pop20), $pop19
.LBB0_6:                                # %if.end31
	end_block                       # label2:
	f64.load	$1=, 8($13)
	f64.const	$push45=, 0x1.9b6db6db6db6ep0
	f64.mul 	$push34=, $1, $1
	f64.load	$push35=, 0($13)
	tee_local	$push92=, $6=, $pop35
	f64.div 	$push36=, $pop34, $pop92
	f64.mul 	$push37=, $1, $pop36
	f64.const	$push38=, 0x1.15f15f15f15f1p-1
	f64.add 	$push39=, $pop37, $pop38
	tee_local	$push91=, $5=, $pop39
	f64.const	$push40=, 0x1.6a0ea0ea0ea0fp0
	f64.add 	$push41=, $pop91, $pop40
	f64.const	$push42=, -0x1.691de2532c834p-1
	f64.div 	$push43=, $pop42, $5
	f64.add 	$push44=, $pop41, $pop43
	f64.div 	$push46=, $pop45, $pop44
	f64.const	$push47=, 0x1.6db6db6db6db7p-2
	f64.add 	$push48=, $pop46, $pop47
	f64.mul 	$push49=, $1, $pop48
	f64.store	$1=, 8($13), $pop49
	i32.const	$push50=, 0
	i32.store	$discard=, 8($13):p2align=3, $pop50
	i32.const	$push57=, 4
	i32.const	$11=, 8
	i32.add 	$11=, $13, $11
	i32.or  	$push58=, $11, $pop57
	tee_local	$push90=, $3=, $pop58
	i64.reinterpret/f64	$push51=, $1
	i64.const	$push52=, 32
	i64.shr_u	$push53=, $pop51, $pop52
	i32.wrap/i64	$push54=, $pop53
	i32.const	$push55=, 1
	i32.add 	$push56=, $pop54, $pop55
	i32.store	$discard=, 0($pop90), $pop56
	f64.load	$1=, 8($13)
	f64.mul 	$push59=, $1, $1
	f64.div 	$push60=, $6, $pop59
	tee_local	$push89=, $6=, $pop60
	f64.sub 	$push62=, $pop89, $1
	f64.add 	$push61=, $1, $1
	f64.add 	$push63=, $pop61, $6
	f64.div 	$push64=, $pop62, $pop63
	f64.mul 	$push65=, $1, $pop64
	f64.add 	$push66=, $1, $pop65
	f64.store	$push67=, 8($13), $pop66
	i64.reinterpret/f64	$push68=, $pop67
	i64.const	$push88=, 32
	i64.shr_u	$push69=, $pop68, $pop88
	i32.wrap/i64	$push70=, $pop69
	i32.or  	$push71=, $pop70, $2
	i32.store	$discard=, 0($3), $pop71
	f64.load	$1=, 8($13)
	f64.mul 	$push72=, $1, $1
	f64.div 	$push73=, $0, $pop72
	f64.sub 	$push74=, $1, $pop73
	f64.const	$push75=, -0x1.5555555555555p-2
	f64.mul 	$push76=, $pop74, $pop75
	f64.add 	$0=, $1, $pop76
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
