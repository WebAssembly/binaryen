	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030916-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
# BB#0:                                 # %entry
	i64.const	$push0=, 0
	i64.store	0($0):p2align=2, $pop0
	i32.const	$push1=, 24
	i32.add 	$push2=, $0, $pop1
	i64.const	$push22=, 0
	i64.store	0($pop2):p2align=2, $pop22
	i32.const	$push3=, 16
	i32.add 	$push4=, $0, $pop3
	i64.const	$push21=, 0
	i64.store	0($pop4):p2align=2, $pop21
	i32.const	$push5=, 8
	i32.add 	$push6=, $0, $pop5
	i64.const	$push20=, 0
	i64.store	0($pop6):p2align=2, $pop20
	i32.const	$push7=, 0
	i32.store	992($0), $pop7
	i32.const	$push8=, 1020
	i32.add 	$push9=, $0, $pop8
	i32.const	$push19=, 0
	i32.store	0($pop9), $pop19
	i32.const	$push10=, 1012
	i32.add 	$push11=, $0, $pop10
	i64.const	$push18=, 0
	i64.store	0($pop11):p2align=2, $pop18
	i32.const	$push12=, 1004
	i32.add 	$push13=, $0, $pop12
	i64.const	$push17=, 0
	i64.store	0($pop13):p2align=2, $pop17
	i32.const	$push14=, 996
	i32.add 	$push15=, $0, $pop14
	i64.const	$push16=, 0
	i64.store	0($pop15):p2align=2, $pop16
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
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push24=, 0
	i32.const	$push21=, 0
	i32.load	$push22=, __stack_pointer($pop21)
	i32.const	$push23=, 1024
	i32.sub 	$push26=, $pop22, $pop23
	tee_local	$push25=, $2=, $pop26
	i32.store	__stack_pointer($pop24), $pop25
	i32.const	$0=, 0
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.add 	$push0=, $2, $0
	i32.const	$push31=, 1
	i32.store	0($pop0), $pop31
	i32.const	$push30=, 4
	i32.add 	$push29=, $0, $pop30
	tee_local	$push28=, $0=, $pop29
	i32.const	$push27=, 1024
	i32.ne  	$push1=, $pop28, $pop27
	br_if   	0, $pop1        # 0: up to label0
# BB#2:                                 # %for.end
	end_loop
	i32.const	$push2=, 24
	i32.add 	$push3=, $2, $pop2
	i64.const	$push4=, 0
	i64.store	0($pop3), $pop4
	i32.const	$push5=, 16
	i32.add 	$push6=, $2, $pop5
	i64.const	$push39=, 0
	i64.store	0($pop6), $pop39
	i32.const	$1=, 0
	i32.const	$push7=, 1020
	i32.add 	$push8=, $2, $pop7
	i32.const	$push38=, 0
	i32.store	0($pop8), $pop38
	i32.const	$push9=, 1012
	i32.add 	$push10=, $2, $pop9
	i64.const	$push37=, 0
	i64.store	0($pop10):p2align=2, $pop37
	i32.const	$push11=, 1004
	i32.add 	$push12=, $2, $pop11
	i64.const	$push36=, 0
	i64.store	0($pop12):p2align=2, $pop36
	i32.const	$push13=, 996
	i32.add 	$push14=, $2, $pop13
	i64.const	$push35=, 0
	i64.store	0($pop14):p2align=2, $pop35
	i64.const	$push34=, 0
	i64.store	8($2), $pop34
	i64.const	$push33=, 0
	i64.store	0($2), $pop33
	i32.const	$push32=, 0
	i32.store	992($2), $pop32
	copy_local	$0=, $2
.LBB1_3:                                # %for.body3
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label2:
	i32.load	$push17=, 0($0)
	i32.const	$push41=, -8
	i32.add 	$push15=, $1, $pop41
	i32.const	$push40=, 240
	i32.lt_u	$push16=, $pop15, $pop40
	i32.ne  	$push18=, $pop17, $pop16
	br_if   	1, $pop18       # 1: down to label1
# BB#4:                                 # %for.cond1
                                        #   in Loop: Header=BB1_3 Depth=1
	i32.const	$push46=, 4
	i32.add 	$0=, $0, $pop46
	i32.const	$push45=, 1
	i32.add 	$push44=, $1, $pop45
	tee_local	$push43=, $1=, $pop44
	i32.const	$push42=, 255
	i32.le_s	$push19=, $pop43, $pop42
	br_if   	0, $pop19       # 0: up to label2
# BB#5:                                 # %for.end10
	end_loop
	i32.const	$push20=, 0
	call    	exit@FUNCTION, $pop20
	unreachable
.LBB1_6:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
