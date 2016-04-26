	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030916-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push13=, 1020
	i32.add 	$push14=, $0, $pop13
	i32.const	$push11=, 0
	i32.store	$push12=, 992($0), $pop11
	i32.store	$discard=, 0($pop14), $pop12
	i32.const	$push21=, 996
	i32.add 	$push22=, $0, $pop21
	i32.const	$push18=, 1004
	i32.add 	$push19=, $0, $pop18
	i32.const	$push15=, 1012
	i32.add 	$push16=, $0, $pop15
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
	i64.store	$push17=, 0($pop16):p2align=2, $pop10
	i64.store	$push20=, 0($pop19):p2align=2, $pop17
	i64.store	$discard=, 0($pop22):p2align=2, $pop20
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
	.local  	i64, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push35=, __stack_pointer
	i32.load	$push36=, 0($pop35)
	i32.const	$push37=, 1024
	i32.sub 	$3=, $pop36, $pop37
	i32.const	$push38=, __stack_pointer
	i32.store	$discard=, 0($pop38), $3
	i32.const	$2=, 0
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.add 	$push0=, $3, $2
	i32.const	$push29=, 1
	i32.store	$discard=, 0($pop0), $pop29
	i32.const	$push28=, 4
	i32.add 	$2=, $2, $pop28
	i32.const	$push27=, 1024
	i32.ne  	$push1=, $2, $pop27
	br_if   	0, $pop1        # 0: up to label0
# BB#2:                                 # %for.end
	end_loop                        # label1:
	i32.const	$push7=, 16
	i32.add 	$push8=, $3, $pop7
	i32.const	$push3=, 24
	i32.add 	$push4=, $3, $pop3
	i64.const	$push5=, 0
	i64.store	$push6=, 0($pop4), $pop5
	i64.store	$0=, 0($pop8), $pop6
	i32.const	$push11=, 1020
	i32.add 	$push12=, $3, $pop11
	i32.const	$push2=, 0
	i32.store	$2=, 0($pop12), $pop2
	i32.const	$push19=, 996
	i32.add 	$push20=, $3, $pop19
	i32.const	$push16=, 1004
	i32.add 	$push17=, $3, $pop16
	i32.const	$push13=, 1012
	i32.add 	$push14=, $3, $pop13
	i64.store	$push9=, 8($3), $0
	i64.store	$push10=, 0($3), $pop9
	i64.store	$push15=, 0($pop14):p2align=2, $pop10
	i64.store	$push18=, 0($pop17):p2align=2, $pop15
	i64.store	$discard=, 0($pop20):p2align=2, $pop18
	i32.store	$discard=, 992($3), $2
	copy_local	$1=, $3
.LBB1_3:                                # %for.body3
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label3:
	i32.load	$push21=, 0($1)
	i32.const	$push34=, -8
	i32.add 	$push22=, $2, $pop34
	i32.const	$push33=, 240
	i32.lt_u	$push23=, $pop22, $pop33
	i32.ne  	$push24=, $pop21, $pop23
	br_if   	2, $pop24       # 2: down to label2
# BB#4:                                 # %for.cond1
                                        #   in Loop: Header=BB1_3 Depth=1
	i32.const	$push32=, 1
	i32.add 	$2=, $2, $pop32
	i32.const	$push31=, 4
	i32.add 	$1=, $1, $pop31
	i32.const	$push30=, 255
	i32.le_s	$push25=, $2, $pop30
	br_if   	0, $pop25       # 0: up to label3
# BB#5:                                 # %for.end10
	end_loop                        # label4:
	i32.const	$push26=, 0
	call    	exit@FUNCTION, $pop26
	unreachable
.LBB1_6:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
