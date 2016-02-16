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
	i32.const	$push25=, 7
	i32.add 	$push1=, $pop0, $pop25
	i32.const	$push24=, -8
	i32.and 	$push23=, $pop1, $pop24
	tee_local	$push22=, $9=, $pop23
	i32.const	$push21=, 8
	i32.add 	$push2=, $pop22, $pop21
	i32.store	$discard=, 12($13), $pop2
	block
	block
	block
	f64.load	$push3=, 0($9)
	f64.const	$push4=, 0x1.4p3
	f64.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label2
# BB#1:                                 # %if.end
	i32.load	$push6=, 12($13)
	i32.const	$push30=, 7
	i32.add 	$push7=, $pop6, $pop30
	i32.const	$push29=, -8
	i32.and 	$push28=, $pop7, $pop29
	tee_local	$push27=, $9=, $pop28
	i32.const	$push26=, 8
	i32.add 	$push8=, $pop27, $pop26
	i32.store	$discard=, 12($13), $pop8
	f64.load	$push9=, 0($9)
	f64.const	$push10=, 0x1.6p3
	f64.ne  	$push11=, $pop9, $pop10
	br_if   	1, $pop11       # 1: down to label1
# BB#2:                                 # %if.end4
	i32.load	$push12=, 12($13)
	i32.const	$push13=, 7
	i32.add 	$push14=, $pop12, $pop13
	i32.const	$push15=, -8
	i32.and 	$push32=, $pop14, $pop15
	tee_local	$push31=, $9=, $pop32
	i32.const	$push16=, 8
	i32.add 	$push17=, $pop31, $pop16
	i32.store	$discard=, 12($13), $pop17
	f64.load	$push18=, 0($9)
	f64.const	$push19=, 0x0p0
	f64.ne  	$push20=, $pop18, $pop19
	br_if   	2, $pop20       # 2: down to label0
# BB#3:                                 # %if.end7
	i32.const	$12=, 16
	i32.add 	$13=, $13, $12
	i32.const	$12=, __stack_pointer
	i32.store	$13=, 0($12), $13
	return
.LBB0_4:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_5:                                # %if.then3
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_6:                                # %if.then6
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
