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
	i32.const	$push27=, 3
	i32.add 	$push1=, $pop0, $pop27
	i32.const	$push26=, -4
	i32.and 	$push2=, $pop1, $pop26
	tee_local	$push25=, $16=, $pop2
	i32.const	$push24=, 4
	i32.add 	$push3=, $pop25, $pop24
	i32.store	$discard=, 12($20), $pop3
	block
	i32.load	$push4=, 0($16)
	i32.const	$push5=, 8
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label0
# BB#1:                                 # %if.end
	i32.load	$push7=, 12($20)
	i32.const	$push31=, 3
	i32.add 	$push8=, $pop7, $pop31
	i32.const	$push30=, -4
	i32.and 	$push9=, $pop8, $pop30
	tee_local	$push29=, $16=, $pop9
	i32.const	$push28=, 4
	i32.add 	$push10=, $pop29, $pop28
	i32.store	$discard=, 12($20), $pop10
	block
	i32.load	$push11=, 0($16)
	i32.const	$push12=, 9
	i32.ne  	$push13=, $pop11, $pop12
	br_if   	0, $pop13       # 0: down to label1
# BB#2:                                 # %if.end4
	i32.load	$push14=, 12($20)
	i32.const	$push15=, 3
	i32.add 	$push16=, $pop14, $pop15
	i32.const	$push17=, -4
	i32.and 	$push18=, $pop16, $pop17
	tee_local	$push32=, $16=, $pop18
	i32.const	$push19=, 4
	i32.add 	$push20=, $pop32, $pop19
	i32.store	$discard=, 12($20), $pop20
	block
	i32.load	$push21=, 0($16)
	i32.const	$push22=, 10
	i32.ne  	$push23=, $pop21, $pop22
	br_if   	0, $pop23       # 0: down to label2
# BB#3:                                 # %if.end7
	i32.const	$19=, 16
	i32.add 	$20=, $20, $19
	i32.const	$19=, __stack_pointer
	i32.store	$20=, 0($19), $20
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
