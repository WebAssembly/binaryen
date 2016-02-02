	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-7.c"
	.section	.text.debug,"ax",@progbits
	.hidden	debug
	.globl	debug
	.type	debug,@function
debug:                                  # @debug
	.param  	i32, i32, i32, i32, i32, i32, i32, f64, f64, f64, f64, f64, f64, f64, f64, f64
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$17=, __stack_pointer
	i32.load	$17=, 0($17)
	i32.const	$18=, 16
	i32.sub 	$20=, $17, $18
	copy_local	$21=, $20
	i32.const	$18=, __stack_pointer
	i32.store	$20=, 0($18), $20
	i32.store	$push0=, 12($20), $21
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
	br_if   	$pop6, 0        # 0: down to label0
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
	br_if   	$pop13, 0       # 0: down to label1
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
	br_if   	$pop23, 0       # 0: down to label2
# BB#3:                                 # %if.end7
	i32.const	$19=, 16
	i32.add 	$20=, $21, $19
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
	.local  	i32, f64, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, __stack_pointer
	i32.load	$6=, 0($6)
	i32.const	$7=, 16
	i32.sub 	$8=, $6, $7
	i32.const	$7=, __stack_pointer
	i32.store	$8=, 0($7), $8
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 12
	i32.sub 	$8=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$8=, 0($3), $8
	i64.const	$push0=, 38654705672
	i64.store	$discard=, 0($8):p2align=2, $pop0
	i32.const	$push1=, 8
	i32.add 	$0=, $8, $pop1
	i32.const	$push2=, 10
	i32.store	$discard=, 0($0), $pop2
	call    	debug@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $1, $1, $1, $1, $1, $1, $1, $1, $1
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 12
	i32.add 	$8=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$8=, 0($5), $8
	i32.const	$push3=, 0
	call    	exit@FUNCTION, $pop3
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
