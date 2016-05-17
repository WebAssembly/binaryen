	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030916-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push15=, 1020
	i32.add 	$push16=, $0, $pop15
	i32.const	$push14=, 0
	i32.store	$push4=, 992($0), $pop14
	i32.store	$drop=, 0($pop16), $pop4
	i32.const	$push21=, 996
	i32.add 	$push22=, $0, $pop21
	i32.const	$push19=, 1004
	i32.add 	$push20=, $0, $pop19
	i32.const	$push17=, 1012
	i32.add 	$push18=, $0, $pop17
	i32.const	$push12=, 8
	i32.add 	$push13=, $0, $pop12
	i32.const	$push10=, 16
	i32.add 	$push11=, $0, $pop10
	i32.const	$push8=, 24
	i32.add 	$push9=, $0, $pop8
	i64.const	$push7=, 0
	i64.store	$push0=, 0($0):p2align=2, $pop7
	i64.store	$push1=, 0($pop9):p2align=2, $pop0
	i64.store	$push2=, 0($pop11):p2align=2, $pop1
	i64.store	$push3=, 0($pop13):p2align=2, $pop2
	i64.store	$push5=, 0($pop18):p2align=2, $pop3
	i64.store	$push6=, 0($pop20):p2align=2, $pop5
	i64.store	$drop=, 0($pop22):p2align=2, $pop6
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
	i32.const	$push29=, __stack_pointer
	i32.const	$push26=, __stack_pointer
	i32.load	$push27=, 0($pop26)
	i32.const	$push28=, 1024
	i32.sub 	$push30=, $pop27, $pop28
	i32.store	$2=, 0($pop29), $pop30
	i32.const	$3=, 0
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.add 	$push5=, $2, $3
	i32.const	$push33=, 1
	i32.store	$drop=, 0($pop5), $pop33
	i32.const	$push32=, 4
	i32.add 	$3=, $3, $pop32
	i32.const	$push31=, 1024
	i32.ne  	$push6=, $3, $pop31
	br_if   	0, $pop6        # 0: up to label0
# BB#2:                                 # %for.end
	end_loop                        # label1:
	i32.const	$push10=, 16
	i32.add 	$push11=, $2, $pop10
	i32.const	$push7=, 24
	i32.add 	$push8=, $2, $pop7
	i64.const	$push9=, 0
	i64.store	$push0=, 0($pop8), $pop9
	i64.store	$0=, 0($pop11), $pop0
	i32.const	$3=, 0
	i32.const	$push12=, 1020
	i32.add 	$push13=, $2, $pop12
	i32.const	$push34=, 0
	i32.store	$1=, 0($pop13), $pop34
	i32.const	$push18=, 996
	i32.add 	$push19=, $2, $pop18
	i32.const	$push16=, 1004
	i32.add 	$push17=, $2, $pop16
	i32.const	$push14=, 1012
	i32.add 	$push15=, $2, $pop14
	i64.store	$push2=, 0($pop15):p2align=2, $0
	i64.store	$push3=, 0($pop17):p2align=2, $pop2
	i64.store	$push4=, 0($pop19):p2align=2, $pop3
	i64.store	$push1=, 8($2), $pop4
	i64.store	$drop=, 0($2), $pop1
	i32.store	$drop=, 992($2), $1
	copy_local	$2=, $2
.LBB1_3:                                # %for.body3
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label3:
	i32.load	$push20=, 0($2)
	i32.const	$push36=, -8
	i32.add 	$push21=, $3, $pop36
	i32.const	$push35=, 240
	i32.lt_u	$push22=, $pop21, $pop35
	i32.ne  	$push23=, $pop20, $pop22
	br_if   	2, $pop23       # 2: down to label2
# BB#4:                                 # %for.cond1
                                        #   in Loop: Header=BB1_3 Depth=1
	i32.const	$push39=, 1
	i32.add 	$3=, $3, $pop39
	i32.const	$push38=, 4
	i32.add 	$2=, $2, $pop38
	i32.const	$push37=, 255
	i32.le_s	$push24=, $3, $pop37
	br_if   	0, $pop24       # 0: up to label3
# BB#5:                                 # %for.end10
	end_loop                        # label4:
	i32.const	$push25=, 0
	call    	exit@FUNCTION, $pop25
	unreachable
.LBB1_6:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
