	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/cbrt.c"
	.section	.text.cbrtl,"ax",@progbits
	.hidden	cbrtl
	.globl	cbrtl
	.type	cbrtl,@function
cbrtl:                                  # @cbrtl
	.param  	f64
	.result 	f64
	.local  	i64, i32, i64, i32, i32, f64, f64, f64, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$9=, __stack_pointer
	i32.load	$9=, 0($9)
	i32.const	$10=, 16
	i32.sub 	$15=, $9, $10
	i32.const	$10=, __stack_pointer
	i32.store	$15=, 0($10), $15
	i64.const	$push0=, 0
	i64.store	$discard=, 8($15), $pop0
	f64.store	$discard=, 0($15), $0
	i64.reinterpret/f64	$1=, $0
	i64.const	$3=, 32
	i64.shr_u	$push1=, $1, $3
	i32.wrap/i64	$4=, $pop1
	i32.const	$push2=, -2147483648
	i32.and 	$2=, $4, $pop2
	i32.xor 	$4=, $2, $4
	block   	.LBB0_7
	block   	.LBB0_2
	i32.const	$push3=, 2146435072
	i32.lt_s	$push4=, $4, $pop3
	br_if   	$pop4, .LBB0_2
# BB#1:                                 # %if.then
	f64.add 	$0=, $0, $0
	br      	.LBB0_7
.LBB0_2:                                # %if.end
	i32.wrap/i64	$push5=, $1
	i32.or  	$push6=, $pop5, $4
	i32.const	$push62=, 0
	i32.eq  	$push63=, $pop6, $pop62
	br_if   	$pop63, .LBB0_7
# BB#3:                                 # %if.end13
	i32.const	$5=, 4
	i32.const	$12=, 0
	i32.add 	$12=, $15, $12
	block   	.LBB0_6
	block   	.LBB0_5
	i32.or  	$push7=, $12, $5
	i32.store	$discard=, 0($pop7), $4
	i32.const	$push8=, 1048575
	i32.gt_s	$push9=, $4, $pop8
	br_if   	$pop9, .LBB0_5
# BB#4:                                 # %if.then18
	i32.const	$13=, 8
	i32.add 	$13=, $15, $13
	i32.or  	$4=, $13, $5
	i32.const	$push14=, 1129316352
	i32.store	$discard=, 0($4), $pop14
	f64.load	$push15=, 8($15)
	f64.mul 	$push16=, $pop15, $0
	f64.store	$push17=, 8($15), $pop16
	i64.reinterpret/f64	$push18=, $pop17
	i64.shr_u	$push19=, $pop18, $3
	i32.wrap/i64	$push20=, $pop19
	i32.const	$push21=, 3
	i32.div_u	$push22=, $pop20, $pop21
	i32.const	$push23=, 696219795
	i32.add 	$push24=, $pop22, $pop23
	i32.store	$discard=, 0($4), $pop24
	br      	.LBB0_6
.LBB0_5:                                # %if.else
	i32.const	$push10=, 3
	i32.div_s	$4=, $4, $pop10
	i32.const	$15=, 8
	i32.add 	$15=, $15, $15
	i32.or  	$push13=, $15, $5
	i32.const	$push11=, 715094163
	i32.add 	$push12=, $4, $pop11
	i32.store	$discard=, 0($pop13), $pop12
.LBB0_6:                                # %if.end31
	f64.load	$8=, 8($15)
	f64.load	$6=, 0($15)
	f64.mul 	$push25=, $8, $8
	f64.div 	$push26=, $pop25, $6
	f64.mul 	$push27=, $8, $pop26
	f64.const	$push28=, 0x1.15f15f15f15f1p-1
	f64.add 	$7=, $pop27, $pop28
	f64.const	$push34=, 0x1.9b6db6db6db6ep0
	f64.const	$push29=, 0x1.6a0ea0ea0ea0fp0
	f64.add 	$push30=, $7, $pop29
	f64.const	$push31=, -0x1.691de2532c834p-1
	f64.div 	$push32=, $pop31, $7
	f64.add 	$push33=, $pop30, $pop32
	f64.div 	$push35=, $pop34, $pop33
	f64.const	$push36=, 0x1.6db6db6db6db7p-2
	f64.add 	$push37=, $pop35, $pop36
	f64.mul 	$push38=, $8, $pop37
	f64.store	$8=, 8($15), $pop38
	i32.const	$push39=, 0
	i32.store	$discard=, 8($15), $pop39
	i32.const	$14=, 8
	i32.add 	$14=, $15, $14
	i32.or  	$4=, $14, $5
	i64.reinterpret/f64	$push40=, $8
	i64.shr_u	$push41=, $pop40, $3
	i32.wrap/i64	$push42=, $pop41
	i32.const	$push43=, 1
	i32.add 	$push44=, $pop42, $pop43
	i32.store	$discard=, 0($4), $pop44
	f64.load	$8=, 8($15)
	f64.mul 	$push45=, $8, $8
	f64.div 	$6=, $6, $pop45
	f64.sub 	$push47=, $6, $8
	f64.add 	$push46=, $8, $8
	f64.add 	$push48=, $pop46, $6
	f64.div 	$push49=, $pop47, $pop48
	f64.mul 	$push50=, $8, $pop49
	f64.add 	$push51=, $8, $pop50
	f64.store	$push52=, 8($15), $pop51
	i64.reinterpret/f64	$push53=, $pop52
	i64.shr_u	$push54=, $pop53, $3
	i32.wrap/i64	$push55=, $pop54
	i32.or  	$push56=, $pop55, $2
	i32.store	$discard=, 0($4), $pop56
	f64.load	$8=, 8($15)
	f64.mul 	$push57=, $8, $8
	f64.div 	$push58=, $0, $pop57
	f64.sub 	$push59=, $8, $pop58
	f64.const	$push60=, -0x1.5555555555555p-2
	f64.mul 	$push61=, $pop59, $pop60
	f64.add 	$0=, $8, $pop61
.LBB0_7:                                # %cleanup
	i32.const	$11=, 16
	i32.add 	$15=, $15, $11
	i32.const	$11=, __stack_pointer
	i32.store	$15=, 0($11), $15
	return  	$0
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
	call    	exit, $pop0
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
