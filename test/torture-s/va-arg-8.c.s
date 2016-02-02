	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-8.c"
	.section	.text.debug,"ax",@progbits
	.hidden	debug
	.globl	debug
	.type	debug,@function
debug:                                  # @debug
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$10=, __stack_pointer
	i32.load	$10=, 0($10)
	i32.const	$11=, 16
	i32.sub 	$13=, $10, $11
	copy_local	$14=, $13
	i32.const	$11=, __stack_pointer
	i32.store	$13=, 0($11), $13
	i32.store	$push0=, 12($13), $14
	i32.const	$push1=, 3
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -4
	i32.and 	$push4=, $pop2, $pop3
	tee_local	$push20=, $9=, $pop4
	i32.const	$push5=, 4
	i32.add 	$push6=, $pop20, $pop5
	i32.store	$discard=, 12($13), $pop6
	block
	i32.load	$push7=, 0($9)
	i32.const	$push8=, 10
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	$pop9, 0        # 0: down to label0
# BB#1:                                 # %if.end
	i32.load	$push10=, 12($13)
	i32.const	$push11=, 7
	i32.add 	$push12=, $pop10, $pop11
	i32.const	$push13=, -8
	i32.and 	$push14=, $pop12, $pop13
	tee_local	$push21=, $9=, $pop14
	i32.const	$push15=, 8
	i32.add 	$push16=, $pop21, $pop15
	i32.store	$discard=, 12($13), $pop16
	block
	i64.load	$push17=, 0($9)
	i64.const	$push18=, 20014547621496
	i64.ne  	$push19=, $pop17, $pop18
	br_if   	$pop19, 0       # 0: down to label1
# BB#2:                                 # %if.end4
	i32.const	$12=, 16
	i32.add 	$13=, $14, $12
	i32.const	$12=, __stack_pointer
	i32.store	$13=, 0($12), $13
	return
.LBB0_3:                                # %if.then3
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_4:                                # %if.then
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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 16
	i32.sub 	$7=, $5, $6
	i32.const	$6=, __stack_pointer
	i32.store	$7=, 0($6), $7
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 16
	i32.sub 	$7=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$7=, 0($2), $7
	i32.const	$push0=, 10
	i32.store	$discard=, 0($7), $pop0
	i32.const	$push1=, 8
	i32.add 	$0=, $7, $pop1
	i64.const	$push2=, 20014547621496
	i64.store	$discard=, 0($0), $pop2
	call    	debug@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $0, $0
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 16
	i32.add 	$7=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$7=, 0($4), $7
	i32.const	$push3=, 0
	call    	exit@FUNCTION, $pop3
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
