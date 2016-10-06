	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/931004-6.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push17=, 0
	i32.const	$push14=, 0
	i32.load	$push15=, __stack_pointer($pop14)
	i32.const	$push16=, 16
	i32.sub 	$push24=, $pop15, $pop16
	tee_local	$push23=, $4=, $pop24
	i32.store	__stack_pointer($pop17), $pop23
	i32.store	12($4), $1
	i32.const	$push22=, 4
	i32.add 	$push1=, $1, $pop22
	i32.store	12($4), $pop1
	block   	
	block   	
	block   	
	i32.const	$push21=, 1
	i32.lt_s	$push2=, $0, $pop21
	br_if   	0, $pop2        # 0: down to label2
# BB#1:                                 # %for.body.preheader
	i32.const	$2=, 10
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	i32.load16_s	$push3=, 0($1)
	i32.ne  	$push4=, $2, $pop3
	br_if   	3, $pop4        # 3: down to label0
# BB#3:                                 # %if.end
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push26=, 10
	i32.add 	$push5=, $2, $pop26
	i32.const	$push25=, 2
	i32.add 	$push6=, $1, $pop25
	i32.load16_s	$push7=, 0($pop6)
	i32.ne  	$push8=, $pop5, $pop7
	br_if   	2, $pop8        # 2: down to label1
# BB#4:                                 # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push30=, 8
	i32.add 	$push9=, $1, $pop30
	i32.store	12($4), $pop9
	i32.const	$push29=, 4
	i32.add 	$1=, $1, $pop29
	i32.const	$push28=, -9
	i32.add 	$3=, $2, $pop28
	i32.const	$push27=, 1
	i32.add 	$push0=, $2, $pop27
	copy_local	$2=, $pop0
	i32.lt_s	$push10=, $3, $0
	br_if   	0, $pop10       # 0: up to label3
.LBB0_5:                                # %for.end
	end_loop
	end_block                       # label2:
	i32.load	$push11=, 0($1)
	i32.const	$push12=, 123
	i32.ne  	$push13=, $pop11, $pop12
	br_if   	1, $pop13       # 1: down to label0
# BB#6:                                 # %if.end16
	i32.const	$push20=, 0
	i32.const	$push18=, 16
	i32.add 	$push19=, $4, $pop18
	i32.store	__stack_pointer($pop20), $pop19
	return  	$1
.LBB0_7:                                # %if.then8
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_8:                                # %if.then15
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push13=, 0
	i32.const	$push10=, 0
	i32.load	$push11=, __stack_pointer($pop10)
	i32.const	$push12=, 48
	i32.sub 	$push21=, $pop11, $pop12
	tee_local	$push20=, $0=, $pop21
	i32.store	__stack_pointer($pop13), $pop20
	i32.const	$push0=, 1310730
	i32.store	32($0), $pop0
	i32.const	$push1=, 21
	i32.store16	38($0), $pop1
	i32.const	$push2=, 11
	i32.store16	36($0), $pop2
	i32.const	$push3=, 1441804
	i32.store	40($0), $pop3
	i32.load	$push4=, 32($0)
	i32.store	28($0), $pop4
	i32.load	$push5=, 36($0)
	i32.store	24($0), $pop5
	i32.load	$push6=, 40($0)
	i32.store	20($0), $pop6
	i32.const	$push7=, 123
	i32.store	12($0), $pop7
	i32.const	$push14=, 28
	i32.add 	$push15=, $0, $pop14
	i32.store	0($0), $pop15
	i32.const	$push16=, 20
	i32.add 	$push17=, $0, $pop16
	i32.store	8($0), $pop17
	i32.const	$push18=, 24
	i32.add 	$push19=, $0, $pop18
	i32.store	4($0), $pop19
	i32.const	$push8=, 3
	i32.call	$drop=, f@FUNCTION, $pop8, $0
	i32.const	$push9=, 0
	call    	exit@FUNCTION, $pop9
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
