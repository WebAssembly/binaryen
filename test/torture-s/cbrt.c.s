	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/cbrt.c"
	.section	.text.cbrtl,"ax",@progbits
	.hidden	cbrtl
	.globl	cbrtl
	.type	cbrtl,@function
cbrtl:                                  # @cbrtl
	.param  	f64
	.result 	f64
	.local  	f64, i32, i32, i64, f64, f64, i32
# BB#0:                                 # %entry
	i32.const	$push83=, __stack_pointer
	i32.load	$push84=, 0($pop83)
	i32.const	$push85=, 16
	i32.sub 	$7=, $pop84, $pop85
	i64.const	$push0=, 0
	i64.store	$discard=, 8($7), $pop0
	block
	f64.store	$push73=, 0($7), $0
	tee_local	$push72=, $0=, $pop73
	i64.reinterpret/f64	$push71=, $pop72
	tee_local	$push70=, $4=, $pop71
	i64.const	$push1=, 32
	i64.shr_u	$push2=, $pop70, $pop1
	i32.wrap/i64	$push69=, $pop2
	tee_local	$push68=, $3=, $pop69
	i32.const	$push3=, -2147483648
	i32.and 	$push67=, $pop68, $pop3
	tee_local	$push66=, $2=, $pop67
	i32.xor 	$push65=, $pop66, $3
	tee_local	$push64=, $3=, $pop65
	i32.const	$push4=, 2146435072
	i32.lt_s	$push5=, $pop64, $pop4
	br_if   	0, $pop5        # 0: down to label0
# BB#1:                                 # %if.then
	f64.add 	$0=, $0, $0
	return  	$0
.LBB0_2:                                # %if.end
	end_block                       # label0:
	block
	i32.wrap/i64	$push6=, $4
	i32.or  	$push7=, $pop6, $3
	i32.const	$push86=, 0
	i32.eq  	$push87=, $pop7, $pop86
	br_if   	0, $pop87       # 0: down to label1
# BB#3:                                 # %if.end13
	block
	block
	i32.store	$push75=, 4($7), $3
	tee_local	$push74=, $3=, $pop75
	i32.const	$push8=, 1048575
	i32.gt_s	$push9=, $pop74, $pop8
	br_if   	0, $pop9        # 0: down to label3
# BB#4:                                 # %if.then18
	i32.const	$push14=, 1129316352
	i32.store	$discard=, 12($7), $pop14
	f64.load	$push15=, 8($7)
	f64.mul 	$push16=, $pop15, $0
	f64.store	$push17=, 8($7), $pop16
	i64.reinterpret/f64	$push18=, $pop17
	i64.const	$push19=, 32
	i64.shr_u	$push20=, $pop18, $pop19
	i32.wrap/i64	$push21=, $pop20
	i32.const	$push22=, 3
	i32.div_u	$push23=, $pop21, $pop22
	i32.const	$push24=, 696219795
	i32.add 	$push25=, $pop23, $pop24
	i32.store	$discard=, 12($7), $pop25
	br      	1               # 1: down to label2
.LBB0_5:                                # %if.else
	end_block                       # label3:
	i32.const	$push10=, 3
	i32.div_u	$push11=, $3, $pop10
	i32.const	$push12=, 715094163
	i32.add 	$push13=, $pop11, $pop12
	i32.store	$discard=, 12($7), $pop13
.LBB0_6:                                # %if.end31
	end_block                       # label2:
	f64.load	$1=, 8($7)
	f64.const	$push35=, 0x1.9b6db6db6db6ep0
	f64.mul 	$push26=, $1, $1
	f64.load	$push82=, 0($7)
	tee_local	$push81=, $6=, $pop82
	f64.div 	$push27=, $pop26, $pop81
	f64.mul 	$push28=, $1, $pop27
	f64.const	$push29=, 0x1.15f15f15f15f1p-1
	f64.add 	$push80=, $pop28, $pop29
	tee_local	$push79=, $5=, $pop80
	f64.const	$push30=, 0x1.6a0ea0ea0ea0fp0
	f64.add 	$push31=, $pop79, $pop30
	f64.const	$push32=, -0x1.691de2532c834p-1
	f64.div 	$push33=, $pop32, $5
	f64.add 	$push34=, $pop31, $pop33
	f64.div 	$push36=, $pop35, $pop34
	f64.const	$push37=, 0x1.6db6db6db6db7p-2
	f64.add 	$push38=, $pop36, $pop37
	f64.mul 	$push39=, $1, $pop38
	f64.store	$1=, 8($7), $pop39
	i32.const	$push40=, 0
	i32.store	$discard=, 8($7):p2align=3, $pop40
	i64.reinterpret/f64	$push41=, $1
	i64.const	$push42=, 32
	i64.shr_u	$push43=, $pop41, $pop42
	i32.wrap/i64	$push44=, $pop43
	i32.const	$push45=, 1
	i32.add 	$push46=, $pop44, $pop45
	i32.store	$discard=, 12($7), $pop46
	f64.load	$1=, 8($7)
	f64.mul 	$push47=, $1, $1
	f64.div 	$push78=, $6, $pop47
	tee_local	$push77=, $6=, $pop78
	f64.sub 	$push49=, $pop77, $1
	f64.add 	$push48=, $1, $1
	f64.add 	$push50=, $pop48, $6
	f64.div 	$push51=, $pop49, $pop50
	f64.mul 	$push52=, $1, $pop51
	f64.add 	$push53=, $1, $pop52
	f64.store	$push54=, 8($7), $pop53
	i64.reinterpret/f64	$push55=, $pop54
	i64.const	$push76=, 32
	i64.shr_u	$push56=, $pop55, $pop76
	i32.wrap/i64	$push57=, $pop56
	i32.or  	$push58=, $pop57, $2
	i32.store	$discard=, 12($7), $pop58
	f64.load	$1=, 8($7)
	f64.mul 	$push59=, $1, $1
	f64.div 	$push60=, $0, $pop59
	f64.sub 	$push61=, $1, $pop60
	f64.const	$push62=, -0x1.5555555555555p-2
	f64.mul 	$push63=, $pop61, $pop62
	f64.add 	$0=, $1, $pop63
.LBB0_7:                                # %cleanup
	end_block                       # label1:
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
