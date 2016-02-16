	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030916-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.local  	i64, i32
# BB#0:                                 # %entry
	i32.const	$push11=, 1012
	i32.add 	$push12=, $0, $pop11
	i32.const	$push8=, 8
	i32.add 	$push9=, $0, $pop8
	i32.const	$push5=, 16
	i32.add 	$push6=, $0, $pop5
	i32.const	$push2=, 24
	i32.add 	$push3=, $0, $pop2
	i64.const	$push0=, 0
	i64.store	$push1=, 0($0):p2align=2, $pop0
	i64.store	$push4=, 0($pop3):p2align=2, $pop1
	i64.store	$push7=, 0($pop6):p2align=2, $pop4
	i64.store	$push10=, 0($pop9):p2align=2, $pop7
	i64.store	$1=, 0($pop12):p2align=2, $pop10
	i32.const	$push13=, 1020
	i32.add 	$push14=, $0, $pop13
	i32.const	$push15=, 0
	i32.store	$2=, 0($pop14), $pop15
	i32.const	$push19=, 996
	i32.add 	$push20=, $0, $pop19
	i32.const	$push16=, 1004
	i32.add 	$push17=, $0, $pop16
	i64.store	$push18=, 0($pop17):p2align=2, $1
	i64.store	$discard=, 0($pop20):p2align=2, $pop18
	i32.store	$discard=, 992($0), $2
	return
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 1024
	i32.sub 	$5=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
	i32.const	$2=, 0
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.add 	$push0=, $5, $2
	i32.const	$push31=, 1
	i32.store	$discard=, 0($pop0), $pop31
	i32.const	$push30=, 4
	i32.add 	$2=, $2, $pop30
	i32.const	$push29=, 1024
	i32.ne  	$push1=, $2, $pop29
	br_if   	0, $pop1        # 0: up to label0
# BB#2:                                 # %for.end
	end_loop                        # label1:
	i32.const	$push14=, 1012
	i32.add 	$push15=, $5, $pop14
	i32.const	$push10=, 8
	i32.or  	$push11=, $5, $pop10
	i32.const	$push7=, 16
	i32.add 	$push8=, $5, $pop7
	i32.const	$push3=, 24
	i32.add 	$push4=, $5, $pop3
	i64.const	$push5=, 0
	i64.store	$push6=, 0($pop4), $pop5
	i64.store	$push9=, 0($pop8):p2align=4, $pop6
	i64.store	$push12=, 0($pop11), $pop9
	i64.store	$push13=, 0($5):p2align=4, $pop12
	i64.store	$0=, 0($pop15):p2align=2, $pop13
	i32.const	$push16=, 1020
	i32.add 	$push17=, $5, $pop16
	i32.const	$push2=, 0
	i32.store	$2=, 0($pop17), $pop2
	i32.const	$push21=, 996
	i32.add 	$push22=, $5, $pop21
	i32.const	$push18=, 1004
	i32.add 	$push19=, $5, $pop18
	i64.store	$push20=, 0($pop19):p2align=2, $0
	i64.store	$discard=, 0($pop22):p2align=2, $pop20
	i32.store	$discard=, 992($5):p2align=4, $2
	copy_local	$1=, $5
.LBB1_3:                                # %for.body3
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label3:
	i32.load	$push23=, 0($1)
	i32.const	$push36=, -8
	i32.add 	$push24=, $2, $pop36
	i32.const	$push35=, 240
	i32.lt_u	$push25=, $pop24, $pop35
	i32.ne  	$push26=, $pop23, $pop25
	br_if   	2, $pop26       # 2: down to label2
# BB#4:                                 # %for.cond1
                                        #   in Loop: Header=BB1_3 Depth=1
	i32.const	$push34=, 1
	i32.add 	$2=, $2, $pop34
	i32.const	$push33=, 4
	i32.add 	$1=, $1, $pop33
	i32.const	$push32=, 255
	i32.le_s	$push27=, $2, $pop32
	br_if   	0, $pop27       # 0: up to label3
# BB#5:                                 # %for.end10
	end_loop                        # label4:
	i32.const	$push28=, 0
	call    	exit@FUNCTION, $pop28
	unreachable
.LBB1_6:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
