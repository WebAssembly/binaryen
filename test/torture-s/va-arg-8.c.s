	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-8.c"
	.section	.text.debug,"ax",@progbits
	.hidden	debug
	.globl	debug
	.type	debug,@function
debug:                                  # @debug
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i64, i32
# BB#0:                                 # %entry
	i32.const	$push16=, __stack_pointer
	i32.load	$push17=, 0($pop16)
	i32.const	$push18=, 16
	i32.sub 	$12=, $pop17, $pop18
	i32.const	$push19=, __stack_pointer
	i32.store	$discard=, 0($pop19), $12
	i32.store	$push13=, 12($12), $9
	tee_local	$push12=, $9=, $pop13
	i32.const	$push1=, 4
	i32.add 	$push0=, $pop12, $pop1
	i32.store	$10=, 12($12), $pop0
	block
	i32.load	$push2=, 0($9)
	i32.const	$push3=, 10
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push5=, 7
	i32.add 	$push6=, $10, $pop5
	i32.const	$push7=, -8
	i32.and 	$push15=, $pop6, $pop7
	tee_local	$push14=, $9=, $pop15
	i64.load	$11=, 0($pop14)
	i32.const	$push8=, 8
	i32.add 	$push9=, $9, $pop8
	i32.store	$discard=, 12($12), $pop9
	i64.const	$push10=, 20014547621496
	i64.ne  	$push11=, $11, $pop10
	br_if   	0, $pop11       # 0: down to label0
# BB#2:                                 # %if.end6
	i32.const	$push20=, 16
	i32.add 	$12=, $12, $pop20
	i32.const	$push21=, __stack_pointer
	i32.store	$discard=, 0($pop21), $12
	return
.LBB0_3:                                # %if.then5
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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push3=, __stack_pointer
	i32.load	$push4=, 0($pop3)
	i32.const	$push5=, 16
	i32.sub 	$1=, $pop4, $pop5
	i32.const	$push6=, __stack_pointer
	i32.store	$discard=, 0($pop6), $1
	i64.const	$push0=, 20014547621496
	i64.store	$discard=, 8($1), $pop0
	i32.const	$push1=, 10
	i32.store	$discard=, 0($1):p2align=4, $pop1
	call    	debug@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $0, $0, $1
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
