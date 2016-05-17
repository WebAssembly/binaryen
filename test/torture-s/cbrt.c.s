	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/cbrt.c"
	.section	.text.cbrtl,"ax",@progbits
	.hidden	cbrtl
	.globl	cbrtl
	.type	cbrtl,@function
cbrtl:                                  # @cbrtl
	.param  	f64
	.result 	f64
	.local  	i32, i32, i64, f64, i32, f64, f64
# BB#0:                                 # %entry
	i32.const	$push62=, __stack_pointer
	i32.load	$push63=, 0($pop62)
	i32.const	$push64=, 16
	i32.sub 	$push76=, $pop63, $pop64
	tee_local	$push75=, $5=, $pop76
	i64.const	$push1=, 0
	i64.store	$drop=, 8($pop75), $pop1
	block
	f64.store	$push74=, 0($5), $0
	tee_local	$push73=, $4=, $pop74
	i64.reinterpret/f64	$push72=, $pop73
	tee_local	$push71=, $3=, $pop72
	i64.const	$push2=, 32
	i64.shr_u	$push3=, $pop71, $pop2
	i32.wrap/i64	$push70=, $pop3
	tee_local	$push69=, $2=, $pop70
	i32.const	$push4=, -2147483648
	i32.and 	$push68=, $pop69, $pop4
	tee_local	$push67=, $1=, $pop68
	i32.xor 	$push66=, $pop67, $2
	tee_local	$push65=, $2=, $pop66
	i32.const	$push5=, 2146435072
	i32.lt_s	$push6=, $pop65, $pop5
	br_if   	0, $pop6        # 0: down to label0
# BB#1:                                 # %if.then
	f64.add 	$push78=, $4, $4
	tee_local	$push77=, $0=, $pop78
	return  	$pop77
.LBB0_2:                                # %if.end
	end_block                       # label0:
	block
	i32.wrap/i64	$push7=, $3
	i32.or  	$push8=, $pop7, $2
	i32.eqz 	$push90=, $pop8
	br_if   	0, $pop90       # 0: down to label1
# BB#3:                                 # %if.end13
	block
	block
	i32.store	$push80=, 4($5), $2
	tee_local	$push79=, $2=, $pop80
	i32.const	$push9=, 1048575
	i32.gt_s	$push10=, $pop79, $pop9
	br_if   	0, $pop10       # 0: down to label3
# BB#4:                                 # %if.then18
	i32.const	$push15=, 1129316352
	i32.store	$drop=, 12($5), $pop15
	f64.load	$push16=, 8($5)
	f64.mul 	$push82=, $pop16, $4
	tee_local	$push81=, $0=, $pop82
	f64.store	$drop=, 8($5), $pop81
	i64.reinterpret/f64	$push17=, $0
	i64.const	$push18=, 32
	i64.shr_u	$push19=, $pop17, $pop18
	i32.wrap/i64	$push20=, $pop19
	i32.const	$push21=, 3
	i32.div_u	$push22=, $pop20, $pop21
	i32.const	$push23=, 696219795
	i32.add 	$push24=, $pop22, $pop23
	i32.store	$drop=, 12($5), $pop24
	br      	1               # 1: down to label2
.LBB0_5:                                # %if.else
	end_block                       # label3:
	i32.const	$push11=, 3
	i32.div_u	$push12=, $2, $pop11
	i32.const	$push13=, 715094163
	i32.add 	$push14=, $pop12, $pop13
	i32.store	$drop=, 12($5), $pop14
.LBB0_6:                                # %if.end31
	end_block                       # label2:
	f64.load	$0=, 8($5)
	f64.const	$push34=, 0x1.9b6db6db6db6ep0
	f64.mul 	$push25=, $0, $0
	f64.load	$push89=, 0($5)
	tee_local	$push88=, $7=, $pop89
	f64.div 	$push26=, $pop25, $pop88
	f64.mul 	$push27=, $0, $pop26
	f64.const	$push28=, 0x1.15f15f15f15f1p-1
	f64.add 	$push87=, $pop27, $pop28
	tee_local	$push86=, $6=, $pop87
	f64.const	$push29=, 0x1.6a0ea0ea0ea0fp0
	f64.add 	$push30=, $pop86, $pop29
	f64.const	$push31=, -0x1.691de2532c834p-1
	f64.div 	$push32=, $pop31, $6
	f64.add 	$push33=, $pop30, $pop32
	f64.div 	$push35=, $pop34, $pop33
	f64.const	$push36=, 0x1.6db6db6db6db7p-2
	f64.add 	$push37=, $pop35, $pop36
	f64.mul 	$push38=, $0, $pop37
	f64.store	$0=, 8($5), $pop38
	i32.const	$push39=, 0
	i32.store	$drop=, 8($5), $pop39
	i64.reinterpret/f64	$push40=, $0
	i64.const	$push41=, 32
	i64.shr_u	$push42=, $pop40, $pop41
	i32.wrap/i64	$push43=, $pop42
	i32.const	$push44=, 1
	i32.add 	$push45=, $pop43, $pop44
	i32.store	$drop=, 12($5), $pop45
	f64.load	$0=, 8($5)
	f64.mul 	$push46=, $0, $0
	f64.div 	$push85=, $7, $pop46
	tee_local	$push84=, $7=, $pop85
	f64.sub 	$push48=, $pop84, $0
	f64.add 	$push47=, $0, $0
	f64.add 	$push49=, $pop47, $7
	f64.div 	$push50=, $pop48, $pop49
	f64.mul 	$push51=, $0, $pop50
	f64.add 	$push52=, $0, $pop51
	f64.store	$push0=, 8($5), $pop52
	i64.reinterpret/f64	$push53=, $pop0
	i64.const	$push83=, 32
	i64.shr_u	$push54=, $pop53, $pop83
	i32.wrap/i64	$push55=, $pop54
	i32.or  	$push56=, $pop55, $1
	i32.store	$drop=, 12($5), $pop56
	f64.load	$0=, 8($5)
	f64.mul 	$push57=, $0, $0
	f64.div 	$push58=, $4, $pop57
	f64.sub 	$push59=, $0, $pop58
	f64.const	$push60=, -0x1.5555555555555p-2
	f64.mul 	$push61=, $pop59, $pop60
	f64.add 	$0=, $0, $pop61
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
