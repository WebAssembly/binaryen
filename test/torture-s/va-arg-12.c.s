	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-12.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	f64, f64, f64, f64, f64, f64, f64, f64, f64, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$10=, __stack_pointer
	i32.load	$10=, 0($10)
	i32.const	$11=, 16
	i32.sub 	$13=, $10, $11
	i32.const	$11=, __stack_pointer
	i32.store	$13=, 0($11), $13
	i32.store	$push0=, 12($13), $9
	i32.const	$push27=, 7
	i32.add 	$push1=, $pop0, $pop27
	i32.const	$push26=, -8
	i32.and 	$push2=, $pop1, $pop26
	tee_local	$push25=, $9=, $pop2
	i32.const	$push24=, 8
	i32.add 	$push3=, $pop25, $pop24
	i32.store	$discard=, 12($13), $pop3
	block
	f64.load	$push4=, 0($9)
	f64.const	$push5=, 0x1.4p3
	f64.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label0
# BB#1:                                 # %if.end
	i32.load	$push7=, 12($13)
	i32.const	$push31=, 7
	i32.add 	$push8=, $pop7, $pop31
	i32.const	$push30=, -8
	i32.and 	$push9=, $pop8, $pop30
	tee_local	$push29=, $9=, $pop9
	i32.const	$push28=, 8
	i32.add 	$push10=, $pop29, $pop28
	i32.store	$discard=, 12($13), $pop10
	block
	f64.load	$push11=, 0($9)
	f64.const	$push12=, 0x1.6p3
	f64.ne  	$push13=, $pop11, $pop12
	br_if   	0, $pop13       # 0: down to label1
# BB#2:                                 # %if.end4
	i32.load	$push14=, 12($13)
	i32.const	$push15=, 7
	i32.add 	$push16=, $pop14, $pop15
	i32.const	$push17=, -8
	i32.and 	$push18=, $pop16, $pop17
	tee_local	$push32=, $9=, $pop18
	i32.const	$push19=, 8
	i32.add 	$push20=, $pop32, $pop19
	i32.store	$discard=, 12($13), $pop20
	block
	f64.load	$push21=, 0($9)
	f64.const	$push22=, 0x0p0
	f64.ne  	$push23=, $pop21, $pop22
	br_if   	0, $pop23       # 0: down to label2
# BB#3:                                 # %if.end7
	i32.const	$12=, 16
	i32.add 	$13=, $13, $12
	i32.const	$12=, __stack_pointer
	i32.store	$13=, 0($12), $13
	return
.LBB0_4:                                # %if.then6
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_5:                                # %if.then3
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_6:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	f64, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 32
	i32.sub 	$3=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$3=, 0($2), $3
	i32.const	$push0=, 16
	i32.add 	$push1=, $3, $pop0
	i64.const	$push2=, 0
	i64.store	$discard=, 0($pop1):p2align=4, $pop2
	i32.const	$push3=, 8
	i32.or  	$push4=, $3, $pop3
	i64.const	$push5=, 4622382067542392832
	i64.store	$discard=, 0($pop4), $pop5
	i64.const	$push6=, 4621819117588971520
	i64.store	$discard=, 0($3):p2align=4, $pop6
	call    	f@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $0, $0, $3
	i32.const	$push7=, 0
	call    	exit@FUNCTION, $pop7
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
