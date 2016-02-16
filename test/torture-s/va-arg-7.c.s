	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-7.c"
	.section	.text.debug,"ax",@progbits
	.hidden	debug
	.globl	debug
	.type	debug,@function
debug:                                  # @debug
	.param  	i32, i32, i32, i32, i32, i32, i32, f64, f64, f64, f64, f64, f64, f64, f64, f64, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$17=, __stack_pointer
	i32.load	$17=, 0($17)
	i32.const	$18=, 16
	i32.sub 	$20=, $17, $18
	i32.const	$18=, __stack_pointer
	i32.store	$20=, 0($18), $20
	i32.store	$push0=, 12($20), $16
	i32.const	$push25=, 3
	i32.add 	$push1=, $pop0, $pop25
	i32.const	$push24=, -4
	i32.and 	$push23=, $pop1, $pop24
	tee_local	$push22=, $16=, $pop23
	i32.const	$push21=, 4
	i32.add 	$push2=, $pop22, $pop21
	i32.store	$discard=, 12($20), $pop2
	block
	block
	block
	i32.load	$push3=, 0($16)
	i32.const	$push4=, 8
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label2
# BB#1:                                 # %if.end
	i32.load	$push6=, 12($20)
	i32.const	$push30=, 3
	i32.add 	$push7=, $pop6, $pop30
	i32.const	$push29=, -4
	i32.and 	$push28=, $pop7, $pop29
	tee_local	$push27=, $16=, $pop28
	i32.const	$push26=, 4
	i32.add 	$push8=, $pop27, $pop26
	i32.store	$discard=, 12($20), $pop8
	i32.load	$push9=, 0($16)
	i32.const	$push10=, 9
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	1, $pop11       # 1: down to label1
# BB#2:                                 # %if.end4
	i32.load	$push12=, 12($20)
	i32.const	$push13=, 3
	i32.add 	$push14=, $pop12, $pop13
	i32.const	$push15=, -4
	i32.and 	$push32=, $pop14, $pop15
	tee_local	$push31=, $16=, $pop32
	i32.const	$push16=, 4
	i32.add 	$push17=, $pop31, $pop16
	i32.store	$discard=, 12($20), $pop17
	i32.load	$push18=, 0($16)
	i32.const	$push19=, 10
	i32.ne  	$push20=, $pop18, $pop19
	br_if   	2, $pop20       # 2: down to label0
# BB#3:                                 # %if.end7
	i32.const	$19=, 16
	i32.add 	$20=, $20, $19
	i32.const	$19=, __stack_pointer
	i32.store	$20=, 0($19), $20
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
	.size	debug, .Lfunc_end0-debug

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, f64, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$4=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$4=, 0($3), $4
	i32.const	$push0=, 8
	i32.or  	$push1=, $4, $pop0
	i32.const	$push2=, 10
	i32.store	$discard=, 0($pop1):p2align=3, $pop2
	i64.const	$push3=, 38654705672
	i64.store	$discard=, 0($4):p2align=4, $pop3
	call    	debug@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $1, $1, $1, $1, $1, $1, $1, $1, $1, $4
	i32.const	$push4=, 0
	call    	exit@FUNCTION, $pop4
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
