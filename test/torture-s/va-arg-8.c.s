	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-8.c"
	.section	.text.debug,"ax",@progbits
	.hidden	debug
	.globl	debug
	.type	debug,@function
debug:                                  # @debug
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$10=, __stack_pointer
	i32.load	$10=, 0($10)
	i32.const	$11=, 16
	i32.sub 	$13=, $10, $11
	i32.const	$11=, __stack_pointer
	i32.store	$13=, 0($11), $13
	i32.store	$push0=, 12($13), $9
	i32.const	$push1=, 3
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -4
	i32.and 	$push19=, $pop2, $pop3
	tee_local	$push18=, $9=, $pop19
	i32.const	$push4=, 4
	i32.add 	$push5=, $pop18, $pop4
	i32.store	$discard=, 12($13), $pop5
	block
	block
	i32.load	$push6=, 0($9)
	i32.const	$push7=, 10
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label1
# BB#1:                                 # %if.end
	i32.load	$push9=, 12($13)
	i32.const	$push10=, 7
	i32.add 	$push11=, $pop9, $pop10
	i32.const	$push12=, -8
	i32.and 	$push21=, $pop11, $pop12
	tee_local	$push20=, $9=, $pop21
	i32.const	$push13=, 8
	i32.add 	$push14=, $pop20, $pop13
	i32.store	$discard=, 12($13), $pop14
	i64.load	$push15=, 0($9)
	i64.const	$push16=, 20014547621496
	i64.ne  	$push17=, $pop15, $pop16
	br_if   	1, $pop17       # 1: down to label0
# BB#2:                                 # %if.end4
	i32.const	$12=, 16
	i32.add 	$13=, $13, $12
	i32.const	$12=, __stack_pointer
	i32.store	$13=, 0($12), $13
	return
.LBB0_3:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_4:                                # %if.then3
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	debug, .Lfunc_end0-debug

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
	i64.const	$push2=, 20014547621496
	i64.store	$discard=, 0($pop1), $pop2
	i32.const	$push3=, 10
	i32.store	$discard=, 0($3):p2align=4, $pop3
	call    	debug@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $0, $0, $3
	i32.const	$push4=, 0
	call    	exit@FUNCTION, $pop4
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
