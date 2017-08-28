	.text
	.file	"cbrt.c"
	.section	.text.cbrtl,"ax",@progbits
	.hidden	cbrtl                   # -- Begin function cbrtl
	.globl	cbrtl
	.type	cbrtl,@function
cbrtl:                                  # @cbrtl
	.param  	f64
	.result 	f64
	.local  	i64, i32, i32, f64, f64, i32
# BB#0:                                 # %entry
	i32.const	$push59=, 0
	i32.load	$push58=, __stack_pointer($pop59)
	i32.const	$push60=, 16
	i32.sub 	$push68=, $pop58, $pop60
	tee_local	$push67=, $6=, $pop68
	f64.store	0($pop67), $0
	i64.const	$push0=, 0
	i64.store	8($6), $pop0
	block   	
	i64.reinterpret/f64	$push66=, $0
	tee_local	$push65=, $1=, $pop66
	i64.const	$push1=, 32
	i64.shr_u	$push2=, $pop65, $pop1
	i32.wrap/i64	$push64=, $pop2
	tee_local	$push63=, $3=, $pop64
	i32.const	$push4=, 2147483647
	i32.and 	$push62=, $pop63, $pop4
	tee_local	$push61=, $2=, $pop62
	i32.const	$push5=, 2146435072
	i32.lt_u	$push6=, $pop61, $pop5
	br_if   	0, $pop6        # 0: down to label0
# BB#1:                                 # %if.then
	f64.add 	$push69=, $0, $0
	return  	$pop69
.LBB0_2:                                # %if.end
	end_block                       # label0:
	block   	
	i32.wrap/i64	$push7=, $1
	i32.or  	$push8=, $2, $pop7
	i32.eqz 	$push89=, $pop8
	br_if   	0, $pop89       # 0: down to label1
# BB#3:                                 # %if.end13
	i32.const	$push3=, -2147483648
	i32.and 	$3=, $3, $pop3
	i32.store	4($6), $2
	block   	
	block   	
	i32.const	$push9=, 1048575
	i32.gt_u	$push10=, $2, $pop9
	br_if   	0, $pop10       # 0: down to label3
# BB#4:                                 # %if.then18
	i32.const	$push14=, 1129316352
	i32.store	12($6), $pop14
	f64.load	$push15=, 8($6)
	f64.mul 	$push71=, $pop15, $0
	tee_local	$push70=, $5=, $pop71
	f64.store	8($6), $pop70
	i64.reinterpret/f64	$push16=, $5
	i64.const	$push17=, 32
	i64.shr_u	$push18=, $pop16, $pop17
	i32.wrap/i64	$push19=, $pop18
	i32.const	$push20=, 3
	i32.div_u	$push21=, $pop19, $pop20
	i32.const	$push22=, 696219795
	i32.add 	$2=, $pop21, $pop22
	br      	1               # 1: down to label2
.LBB0_5:                                # %if.else
	end_block                       # label3:
	i32.const	$push11=, 3
	i32.div_u	$push12=, $2, $pop11
	i32.const	$push13=, 715094163
	i32.add 	$2=, $pop12, $pop13
.LBB0_6:                                # %if.end31
	end_block                       # label2:
	i32.store	12($6), $2
	f64.load	$push88=, 8($6)
	tee_local	$push87=, $5=, $pop88
	f64.const	$push32=, 0x1.9b6db6db6db6ep0
	f64.mul 	$push23=, $5, $5
	f64.load	$push86=, 0($6)
	tee_local	$push85=, $4=, $pop86
	f64.div 	$push24=, $pop23, $pop85
	f64.mul 	$push25=, $5, $pop24
	f64.const	$push26=, 0x1.15f15f15f15f1p-1
	f64.add 	$push84=, $pop25, $pop26
	tee_local	$push83=, $5=, $pop84
	f64.const	$push29=, 0x1.6a0ea0ea0ea0fp0
	f64.add 	$push30=, $pop83, $pop29
	f64.const	$push27=, -0x1.691de2532c834p-1
	f64.div 	$push28=, $pop27, $5
	f64.add 	$push31=, $pop30, $pop28
	f64.div 	$push33=, $pop32, $pop31
	f64.const	$push34=, 0x1.6db6db6db6db7p-2
	f64.add 	$push35=, $pop33, $pop34
	f64.mul 	$push82=, $pop87, $pop35
	tee_local	$push81=, $5=, $pop82
	f64.store	8($6), $pop81
	i32.const	$push36=, 0
	i32.store	8($6), $pop36
	i64.reinterpret/f64	$push37=, $5
	i64.const	$push38=, 32
	i64.shr_u	$push39=, $pop37, $pop38
	i32.wrap/i64	$push40=, $pop39
	i32.const	$push41=, 1
	i32.add 	$push42=, $pop40, $pop41
	i32.store	12($6), $pop42
	f64.load	$push80=, 8($6)
	tee_local	$push79=, $5=, $pop80
	f64.mul 	$push43=, $5, $5
	f64.div 	$push78=, $4, $pop43
	tee_local	$push77=, $4=, $pop78
	f64.sub 	$push46=, $pop77, $5
	f64.add 	$push44=, $5, $5
	f64.add 	$push45=, $pop44, $4
	f64.div 	$push47=, $pop46, $pop45
	f64.mul 	$push48=, $5, $pop47
	f64.add 	$push76=, $pop79, $pop48
	tee_local	$push75=, $5=, $pop76
	f64.store	8($6), $pop75
	i64.reinterpret/f64	$push49=, $5
	i64.const	$push74=, 32
	i64.shr_u	$push50=, $pop49, $pop74
	i32.wrap/i64	$push51=, $pop50
	i32.or  	$push52=, $3, $pop51
	i32.store	12($6), $pop52
	f64.load	$push73=, 8($6)
	tee_local	$push72=, $5=, $pop73
	f64.mul 	$push53=, $5, $5
	f64.div 	$push54=, $0, $pop53
	f64.sub 	$push55=, $5, $pop54
	f64.const	$push56=, -0x1.5555555555555p-2
	f64.mul 	$push57=, $pop55, $pop56
	f64.add 	$0=, $pop72, $pop57
.LBB0_7:                                # %cleanup
	end_block                       # label1:
	copy_local	$push90=, $0
                                        # fallthrough-return: $pop90
	.endfunc
.Lfunc_end0:
	.size	cbrtl, .Lfunc_end0-cbrtl
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	exit, void, i32
