	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/931004-12.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push23=, 0
	i32.const	$push20=, 0
	i32.load	$push21=, __stack_pointer($pop20)
	i32.const	$push22=, 16
	i32.sub 	$push30=, $pop21, $pop22
	tee_local	$push29=, $3=, $pop30
	i32.store	__stack_pointer($pop23), $pop29
	i32.store	12($3), $1
	i32.const	$push28=, 4
	i32.add 	$push1=, $1, $pop28
	i32.store	12($3), $pop1
	block   	
	block   	
	block   	
	i32.const	$push27=, 1
	i32.lt_s	$push2=, $0, $pop27
	br_if   	0, $pop2        # 0: down to label2
# BB#1:                                 # %for.body.preheader
	i32.const	$push3=, 8
	i32.add 	$1=, $1, $pop3
	i32.const	$2=, 0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	i32.const	$push32=, 10
	i32.add 	$push4=, $2, $pop32
	i32.const	$push31=, -8
	i32.add 	$push5=, $1, $pop31
	i32.load8_s	$push6=, 0($pop5)
	i32.ne  	$push7=, $pop4, $pop6
	br_if   	2, $pop7        # 2: down to label1
# BB#3:                                 # %if.end
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push34=, 20
	i32.add 	$push9=, $2, $pop34
	i32.const	$push33=, -7
	i32.add 	$push10=, $1, $pop33
	i32.load8_s	$push11=, 0($pop10)
	i32.ne  	$push12=, $pop9, $pop11
	br_if   	2, $pop12       # 2: down to label1
# BB#4:                                 # %if.end9
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push36=, 30
	i32.add 	$push13=, $2, $pop36
	i32.const	$push35=, -6
	i32.add 	$push8=, $1, $pop35
	i32.load8_s	$push0=, 0($pop8)
	i32.ne  	$push14=, $pop13, $pop0
	br_if   	3, $pop14       # 3: down to label0
# BB#5:                                 # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.store	12($3), $1
	i32.const	$push40=, 4
	i32.add 	$1=, $1, $pop40
	i32.const	$push39=, 1
	i32.add 	$push38=, $2, $pop39
	tee_local	$push37=, $2=, $pop38
	i32.lt_s	$push15=, $pop37, $0
	br_if   	0, $pop15       # 0: up to label3
# BB#6:                                 # %for.end.loopexit
	end_loop
	i32.const	$push16=, -8
	i32.add 	$1=, $1, $pop16
.LBB0_7:                                # %for.end
	end_block                       # label2:
	i32.load	$push17=, 0($1)
	i32.const	$push18=, 123
	i32.ne  	$push19=, $pop17, $pop18
	br_if   	0, $pop19       # 0: down to label1
# BB#8:                                 # %if.end22
	i32.const	$push26=, 0
	i32.const	$push24=, 16
	i32.add 	$push25=, $3, $pop24
	i32.store	__stack_pointer($pop26), $pop25
	return  	$1
.LBB0_9:                                # %if.then21
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_10:                               # %if.then14
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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push25=, 0
	i32.const	$push22=, 0
	i32.load	$push23=, __stack_pointer($pop22)
	i32.const	$push24=, 48
	i32.sub 	$push43=, $pop23, $pop24
	tee_local	$push42=, $1=, $pop43
	i32.store	__stack_pointer($pop25), $pop42
	i32.const	$push0=, 30
	i32.store8	34($1), $pop0
	i32.const	$push1=, 11
	i32.store8	35($1), $pop1
	i32.const	$push2=, 12
	i32.store8	38($1), $pop2
	i32.const	$push3=, 5130
	i32.store16	32($1), $pop3
	i32.const	$push4=, 21
	i32.store8	36($1), $pop4
	i32.const	$push5=, 22
	i32.store8	39($1), $pop5
	i32.const	$push26=, 28
	i32.add 	$push27=, $1, $pop26
	i32.const	$push6=, 2
	i32.add 	$push7=, $pop27, $pop6
	i32.load8_u	$push8=, 34($1)
	i32.store8	0($pop7), $pop8
	i32.const	$push9=, 31
	i32.store8	37($1), $pop9
	i32.const	$push10=, 40
	i32.add 	$push41=, $1, $pop10
	tee_local	$push40=, $0=, $pop41
	i32.const	$push11=, 32
	i32.store8	0($pop40), $pop11
	i32.const	$push28=, 24
	i32.add 	$push29=, $1, $pop28
	i32.const	$push39=, 2
	i32.add 	$push12=, $pop29, $pop39
	i32.load8_u	$push13=, 37($1)
	i32.store8	0($pop12), $pop13
	i32.load16_u	$push14=, 32($1)
	i32.store16	28($1), $pop14
	i32.load16_u	$push15=, 35($1):p2align=0
	i32.store16	24($1), $pop15
	i32.const	$push30=, 20
	i32.add 	$push31=, $1, $pop30
	i32.const	$push38=, 2
	i32.add 	$push16=, $pop31, $pop38
	i32.load8_u	$push17=, 0($0)
	i32.store8	0($pop16), $pop17
	i32.load16_u	$push18=, 38($1)
	i32.store16	20($1), $pop18
	i32.const	$push19=, 123
	i32.store	12($1), $pop19
	i32.const	$push32=, 28
	i32.add 	$push33=, $1, $pop32
	i32.store	0($1), $pop33
	i32.const	$push34=, 20
	i32.add 	$push35=, $1, $pop34
	i32.store	8($1), $pop35
	i32.const	$push36=, 24
	i32.add 	$push37=, $1, $pop36
	i32.store	4($1), $pop37
	i32.const	$push20=, 3
	i32.call	$drop=, f@FUNCTION, $pop20, $1
	i32.const	$push21=, 0
	call    	exit@FUNCTION, $pop21
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
