	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/cbrt.c"
	.section	.text.cbrtl,"ax",@progbits
	.hidden	cbrtl
	.globl	cbrtl
	.type	cbrtl,@function
cbrtl:                                  # @cbrtl
	.param  	f64
	.result 	f64
	.local  	i64, i32, i32, f64, f64, i32
# BB#0:                                 # %entry
	i32.const	$push57=, 0
	i32.load	$push58=, __stack_pointer($pop57)
	i32.const	$push59=, 16
	i32.sub 	$push69=, $pop58, $pop59
	tee_local	$push68=, $6=, $pop69
	i64.const	$push0=, 0
	i64.store	8($pop68), $pop0
	f64.store	0($6), $0
	block   	
	i64.reinterpret/f64	$push67=, $0
	tee_local	$push66=, $1=, $pop67
	i64.const	$push1=, 32
	i64.shr_u	$push2=, $pop66, $pop1
	i32.wrap/i64	$push65=, $pop2
	tee_local	$push64=, $3=, $pop65
	i32.const	$push3=, -2147483648
	i32.and 	$push63=, $pop64, $pop3
	tee_local	$push62=, $2=, $pop63
	i32.xor 	$push61=, $pop62, $3
	tee_local	$push60=, $3=, $pop61
	i32.const	$push4=, 2146435072
	i32.lt_s	$push5=, $pop60, $pop4
	br_if   	0, $pop5        # 0: down to label0
# BB#1:                                 # %if.then
	f64.add 	$push70=, $0, $0
	return  	$pop70
.LBB0_2:                                # %if.end
	end_block                       # label0:
	block   	
	i32.wrap/i64	$push6=, $1
	i32.or  	$push7=, $pop6, $3
	i32.eqz 	$push90=, $pop7
	br_if   	0, $pop90       # 0: down to label1
# BB#3:                                 # %if.end13
	i32.store	4($6), $3
	block   	
	block   	
	i32.const	$push8=, 1048575
	i32.gt_s	$push9=, $3, $pop8
	br_if   	0, $pop9        # 0: down to label3
# BB#4:                                 # %if.then18
	i32.const	$push13=, 1129316352
	i32.store	12($6), $pop13
	f64.load	$push14=, 8($6)
	f64.mul 	$push72=, $pop14, $0
	tee_local	$push71=, $5=, $pop72
	f64.store	8($6), $pop71
	i64.reinterpret/f64	$push15=, $5
	i64.const	$push16=, 32
	i64.shr_u	$push17=, $pop15, $pop16
	i32.wrap/i64	$push18=, $pop17
	i32.const	$push19=, 3
	i32.div_u	$push20=, $pop18, $pop19
	i32.const	$push21=, 696219795
	i32.add 	$3=, $pop20, $pop21
	br      	1               # 1: down to label2
.LBB0_5:                                # %if.else
	end_block                       # label3:
	i32.const	$push10=, 3
	i32.div_u	$push11=, $3, $pop10
	i32.const	$push12=, 715094163
	i32.add 	$3=, $pop11, $pop12
.LBB0_6:                                # %if.end31
	end_block                       # label2:
	i32.store	12($6), $3
	f64.load	$push89=, 8($6)
	tee_local	$push88=, $5=, $pop89
	f64.const	$push31=, 0x1.9b6db6db6db6ep0
	f64.mul 	$push22=, $5, $5
	f64.load	$push87=, 0($6)
	tee_local	$push86=, $4=, $pop87
	f64.div 	$push23=, $pop22, $pop86
	f64.mul 	$push24=, $5, $pop23
	f64.const	$push25=, 0x1.15f15f15f15f1p-1
	f64.add 	$push85=, $pop24, $pop25
	tee_local	$push84=, $5=, $pop85
	f64.const	$push28=, 0x1.6a0ea0ea0ea0fp0
	f64.add 	$push29=, $pop84, $pop28
	f64.const	$push26=, -0x1.691de2532c834p-1
	f64.div 	$push27=, $pop26, $5
	f64.add 	$push30=, $pop29, $pop27
	f64.div 	$push32=, $pop31, $pop30
	f64.const	$push33=, 0x1.6db6db6db6db7p-2
	f64.add 	$push34=, $pop32, $pop33
	f64.mul 	$push83=, $pop88, $pop34
	tee_local	$push82=, $5=, $pop83
	f64.store	8($6), $pop82
	i32.const	$push35=, 0
	i32.store	8($6), $pop35
	i64.reinterpret/f64	$push36=, $5
	i64.const	$push37=, 32
	i64.shr_u	$push38=, $pop36, $pop37
	i32.wrap/i64	$push39=, $pop38
	i32.const	$push40=, 1
	i32.add 	$push41=, $pop39, $pop40
	i32.store	12($6), $pop41
	f64.load	$push81=, 8($6)
	tee_local	$push80=, $5=, $pop81
	f64.mul 	$push42=, $5, $5
	f64.div 	$push79=, $4, $pop42
	tee_local	$push78=, $4=, $pop79
	f64.sub 	$push45=, $pop78, $5
	f64.add 	$push43=, $5, $5
	f64.add 	$push44=, $pop43, $4
	f64.div 	$push46=, $pop45, $pop44
	f64.mul 	$push47=, $5, $pop46
	f64.add 	$push77=, $pop80, $pop47
	tee_local	$push76=, $5=, $pop77
	f64.store	8($6), $pop76
	i64.reinterpret/f64	$push48=, $5
	i64.const	$push75=, 32
	i64.shr_u	$push49=, $pop48, $pop75
	i32.wrap/i64	$push50=, $pop49
	i32.or  	$push51=, $pop50, $2
	i32.store	12($6), $pop51
	f64.load	$push74=, 8($6)
	tee_local	$push73=, $5=, $pop74
	f64.mul 	$push52=, $5, $5
	f64.div 	$push53=, $0, $pop52
	f64.sub 	$push54=, $5, $pop53
	f64.const	$push55=, -0x1.5555555555555p-2
	f64.mul 	$push56=, $pop54, $pop55
	f64.add 	$0=, $pop73, $pop56
.LBB0_7:                                # %cleanup
	end_block                       # label1:
	copy_local	$push91=, $0
                                        # fallthrough-return: $pop91
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
