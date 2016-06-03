	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030916-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.local  	i64
# BB#0:                                 # %entry
	i32.const	$push11=, 8
	i32.add 	$push12=, $0, $pop11
	i32.const	$push9=, 16
	i32.add 	$push10=, $0, $pop9
	i32.const	$push7=, 24
	i32.add 	$push8=, $0, $pop7
	i64.const	$push6=, 0
	i64.store	$push0=, 0($0):p2align=2, $pop6
	i64.store	$push1=, 0($pop8):p2align=2, $pop0
	i64.store	$push2=, 0($pop10):p2align=2, $pop1
	i64.store	$1=, 0($pop12):p2align=2, $pop2
	i32.const	$push14=, 1020
	i32.add 	$push15=, $0, $pop14
	i32.const	$push13=, 0
	i32.store	$push3=, 992($0), $pop13
	i32.store	$drop=, 0($pop15), $pop3
	i32.const	$push20=, 996
	i32.add 	$push21=, $0, $pop20
	i32.const	$push18=, 1004
	i32.add 	$push19=, $0, $pop18
	i32.const	$push16=, 1012
	i32.add 	$push17=, $0, $pop16
	i64.store	$push4=, 0($pop17):p2align=2, $1
	i64.store	$push5=, 0($pop19):p2align=2, $pop4
	i64.store	$drop=, 0($pop21):p2align=2, $pop5
                                        # fallthrough-return
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
	i32.const	$push29=, 0
	i32.const	$push26=, 0
	i32.load	$push27=, __stack_pointer($pop26)
	i32.const	$push28=, 1024
	i32.sub 	$push30=, $pop27, $pop28
	i32.store	$1=, __stack_pointer($pop29), $pop30
	i32.const	$2=, 0
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.add 	$push5=, $1, $2
	i32.const	$push35=, 1
	i32.store	$drop=, 0($pop5), $pop35
	i32.const	$push34=, 4
	i32.add 	$push33=, $2, $pop34
	tee_local	$push32=, $2=, $pop33
	i32.const	$push31=, 1024
	i32.ne  	$push6=, $pop32, $pop31
	br_if   	0, $pop6        # 0: up to label0
# BB#2:                                 # %for.end
	end_loop                        # label1:
	i32.const	$push10=, 16
	i32.add 	$push11=, $1, $pop10
	i32.const	$push7=, 24
	i32.add 	$push8=, $1, $pop7
	i64.const	$push9=, 0
	i64.store	$push0=, 0($pop8), $pop9
	i64.store	$0=, 0($pop11), $pop0
	i32.const	$3=, 0
	i32.const	$push12=, 1020
	i32.add 	$push13=, $1, $pop12
	i32.const	$push36=, 0
	i32.store	$2=, 0($pop13), $pop36
	i32.const	$push18=, 996
	i32.add 	$push19=, $1, $pop18
	i32.const	$push16=, 1004
	i32.add 	$push17=, $1, $pop16
	i32.const	$push14=, 1012
	i32.add 	$push15=, $1, $pop14
	i64.store	$push1=, 0($pop15):p2align=2, $0
	i64.store	$push2=, 0($pop17):p2align=2, $pop1
	i64.store	$push3=, 0($pop19):p2align=2, $pop2
	i64.store	$push4=, 8($1), $pop3
	i64.store	$drop=, 0($1), $pop4
	i32.store	$drop=, 992($1), $2
	copy_local	$2=, $1
.LBB1_3:                                # %for.body3
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label3:
	i32.load	$push22=, 0($2)
	i32.const	$push38=, -8
	i32.add 	$push20=, $3, $pop38
	i32.const	$push37=, 240
	i32.lt_u	$push21=, $pop20, $pop37
	i32.ne  	$push23=, $pop22, $pop21
	br_if   	2, $pop23       # 2: down to label2
# BB#4:                                 # %for.cond1
                                        #   in Loop: Header=BB1_3 Depth=1
	i32.const	$push43=, 4
	i32.add 	$2=, $2, $pop43
	i32.const	$push42=, 1
	i32.add 	$push41=, $3, $pop42
	tee_local	$push40=, $3=, $pop41
	i32.const	$push39=, 255
	i32.le_s	$push24=, $pop40, $pop39
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
	.functype	abort, void
	.functype	exit, void, i32
