	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/cbrt.c"
	.section	.text.cbrtl,"ax",@progbits
	.hidden	cbrtl
	.globl	cbrtl
	.type	cbrtl,@function
cbrtl:                                  # @cbrtl
	.param  	f64
	.result 	f64
	.local  	f64, i64, i32, i32, f64, i32
# BB#0:                                 # %entry
	i32.const	$push64=, 0
	i32.load	$push65=, __stack_pointer($pop64)
	i32.const	$push66=, 16
	i32.sub 	$push78=, $pop65, $pop66
	tee_local	$push77=, $6=, $pop78
	i64.const	$push2=, 0
	i64.store	$drop=, 8($pop77), $pop2
	block
	f64.store	$push76=, 0($6), $0
	tee_local	$push75=, $1=, $pop76
	i64.reinterpret/f64	$push74=, $pop75
	tee_local	$push73=, $2=, $pop74
	i64.const	$push3=, 32
	i64.shr_u	$push4=, $pop73, $pop3
	i32.wrap/i64	$push72=, $pop4
	tee_local	$push71=, $4=, $pop72
	i32.const	$push5=, -2147483648
	i32.and 	$push70=, $pop71, $pop5
	tee_local	$push69=, $3=, $pop70
	i32.xor 	$push68=, $pop69, $4
	tee_local	$push67=, $4=, $pop68
	i32.const	$push6=, 2146435072
	i32.lt_s	$push7=, $pop67, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#1:                                 # %if.then
	f64.add 	$push79=, $1, $1
	return  	$pop79
.LBB0_2:                                # %if.end
	end_block                       # label0:
	block
	i32.wrap/i64	$push8=, $2
	i32.or  	$push9=, $pop8, $4
	i32.eqz 	$push95=, $pop9
	br_if   	0, $pop95       # 0: down to label1
# BB#3:                                 # %if.end13
	block
	block
	i32.store	$push81=, 4($6), $4
	tee_local	$push80=, $4=, $pop81
	i32.const	$push10=, 1048575
	i32.gt_s	$push11=, $pop80, $pop10
	br_if   	0, $pop11       # 0: down to label3
# BB#4:                                 # %if.then18
	i32.const	$push16=, 1129316352
	i32.store	$drop=, 12($6), $pop16
	f64.load	$push17=, 8($6)
	f64.mul 	$push18=, $pop17, $1
	f64.store	$push0=, 8($6), $pop18
	i64.reinterpret/f64	$push19=, $pop0
	i64.const	$push20=, 32
	i64.shr_u	$push21=, $pop19, $pop20
	i32.wrap/i64	$push22=, $pop21
	i32.const	$push23=, 3
	i32.div_u	$push24=, $pop22, $pop23
	i32.const	$push25=, 696219795
	i32.add 	$push26=, $pop24, $pop25
	i32.store	$drop=, 12($6), $pop26
	br      	1               # 1: down to label2
.LBB0_5:                                # %if.else
	end_block                       # label3:
	i32.const	$push12=, 3
	i32.div_u	$push13=, $4, $pop12
	i32.const	$push14=, 715094163
	i32.add 	$push15=, $pop13, $pop14
	i32.store	$drop=, 12($6), $pop15
.LBB0_6:                                # %if.end31
	end_block                       # label2:
	f64.load	$push94=, 8($6)
	tee_local	$push93=, $0=, $pop94
	f64.const	$push36=, 0x1.9b6db6db6db6ep0
	f64.mul 	$push27=, $0, $0
	f64.load	$push92=, 0($6)
	tee_local	$push91=, $5=, $pop92
	f64.div 	$push28=, $pop27, $pop91
	f64.mul 	$push29=, $0, $pop28
	f64.const	$push30=, 0x1.15f15f15f15f1p-1
	f64.add 	$push90=, $pop29, $pop30
	tee_local	$push89=, $0=, $pop90
	f64.const	$push33=, 0x1.6a0ea0ea0ea0fp0
	f64.add 	$push34=, $pop89, $pop33
	f64.const	$push31=, -0x1.691de2532c834p-1
	f64.div 	$push32=, $pop31, $0
	f64.add 	$push35=, $pop34, $pop32
	f64.div 	$push37=, $pop36, $pop35
	f64.const	$push38=, 0x1.6db6db6db6db7p-2
	f64.add 	$push39=, $pop37, $pop38
	f64.mul 	$push40=, $pop93, $pop39
	f64.store	$0=, 8($6), $pop40
	i32.const	$push41=, 0
	i32.store	$drop=, 8($6), $pop41
	i64.reinterpret/f64	$push42=, $0
	i64.const	$push43=, 32
	i64.shr_u	$push44=, $pop42, $pop43
	i32.wrap/i64	$push45=, $pop44
	i32.const	$push46=, 1
	i32.add 	$push47=, $pop45, $pop46
	i32.store	$drop=, 12($6), $pop47
	f64.load	$push88=, 8($6)
	tee_local	$push87=, $0=, $pop88
	f64.mul 	$push48=, $0, $0
	f64.div 	$push86=, $5, $pop48
	tee_local	$push85=, $5=, $pop86
	f64.sub 	$push51=, $pop85, $0
	f64.add 	$push49=, $0, $0
	f64.add 	$push50=, $pop49, $5
	f64.div 	$push52=, $pop51, $pop50
	f64.mul 	$push53=, $0, $pop52
	f64.add 	$push54=, $pop87, $pop53
	f64.store	$push1=, 8($6), $pop54
	i64.reinterpret/f64	$push55=, $pop1
	i64.const	$push84=, 32
	i64.shr_u	$push56=, $pop55, $pop84
	i32.wrap/i64	$push57=, $pop56
	i32.or  	$push58=, $pop57, $3
	i32.store	$drop=, 12($6), $pop58
	f64.load	$push83=, 8($6)
	tee_local	$push82=, $0=, $pop83
	f64.mul 	$push59=, $0, $0
	f64.div 	$push60=, $1, $pop59
	f64.sub 	$push61=, $0, $pop60
	f64.const	$push62=, -0x1.5555555555555p-2
	f64.mul 	$push63=, $pop61, $pop62
	f64.add 	$0=, $pop82, $pop63
.LBB0_7:                                # %cleanup
	end_block                       # label1:
	copy_local	$push96=, $0
                                        # fallthrough-return: $pop96
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
	.functype	exit, void, i32
