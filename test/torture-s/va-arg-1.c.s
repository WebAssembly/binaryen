	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$10=, __stack_pointer
	i32.load	$10=, 0($10)
	i32.const	$11=, 16
	i32.sub 	$13=, $10, $11
	i32.const	$11=, __stack_pointer
	i32.store	$13=, 0($11), $13
	i32.store	$push0=, 12($13), $9
	i32.const	$push23=, 3
	i32.add 	$push1=, $pop0, $pop23
	i32.const	$push22=, -4
	i32.and 	$push21=, $pop1, $pop22
	tee_local	$push20=, $9=, $pop21
	i32.const	$push19=, 4
	i32.add 	$push2=, $pop20, $pop19
	i32.store	$discard=, 12($13), $pop2
	block
	block
	block
	i32.load	$push3=, 0($9)
	i32.const	$push4=, 10
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label2
# BB#1:                                 # %if.end
	i32.load	$push6=, 12($13)
	i32.const	$push28=, 3
	i32.add 	$push7=, $pop6, $pop28
	i32.const	$push27=, -4
	i32.and 	$push26=, $pop7, $pop27
	tee_local	$push25=, $9=, $pop26
	i32.const	$push24=, 4
	i32.add 	$push8=, $pop25, $pop24
	i32.store	$discard=, 12($13), $pop8
	i32.load	$push9=, 0($9)
	i32.const	$push10=, 11
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	1, $pop11       # 1: down to label1
# BB#2:                                 # %if.end4
	i32.load	$push12=, 12($13)
	i32.const	$push13=, 3
	i32.add 	$push14=, $pop12, $pop13
	i32.const	$push15=, -4
	i32.and 	$push30=, $pop14, $pop15
	tee_local	$push29=, $9=, $pop30
	i32.const	$push16=, 4
	i32.add 	$push17=, $pop29, $pop16
	i32.store	$discard=, 12($13), $pop17
	i32.load	$push18=, 0($9)
	br_if   	2, $pop18       # 2: down to label0
# BB#3:                                 # %if.end7
	i32.const	$12=, 16
	i32.add 	$13=, $13, $12
	i32.const	$12=, __stack_pointer
	i32.store	$13=, 0($12), $13
	return  	$9
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
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 16
	i32.sub 	$3=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$3=, 0($2), $3
	i32.const	$push0=, 8
	i32.or  	$push1=, $3, $pop0
	i32.const	$push2=, 0
	i32.store	$0=, 0($pop1):p2align=3, $pop2
	i64.const	$push3=, 47244640266
	i64.store	$discard=, 0($3):p2align=4, $pop3
	i32.call	$discard=, f@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $0, $0, $3
	call    	exit@FUNCTION, $0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
