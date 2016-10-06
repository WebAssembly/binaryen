	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/931004-14.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push27=, 0
	i32.const	$push24=, 0
	i32.load	$push25=, __stack_pointer($pop24)
	i32.const	$push26=, 16
	i32.sub 	$push34=, $pop25, $pop26
	tee_local	$push33=, $3=, $pop34
	i32.store	__stack_pointer($pop27), $pop33
	i32.store	12($3), $1
	i32.const	$push32=, 4
	i32.add 	$push2=, $1, $pop32
	i32.store	12($3), $pop2
	block   	
	block   	
	block   	
	i32.const	$push31=, 1
	i32.lt_s	$push3=, $0, $pop31
	br_if   	0, $pop3        # 0: down to label2
# BB#1:                                 # %for.body.preheader
	i32.const	$push4=, 8
	i32.add 	$1=, $1, $pop4
	i32.const	$2=, 0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	i32.const	$push36=, 10
	i32.add 	$push5=, $2, $pop36
	i32.const	$push35=, -8
	i32.add 	$push6=, $1, $pop35
	i32.load8_s	$push7=, 0($pop6)
	i32.ne  	$push8=, $pop5, $pop7
	br_if   	2, $pop8        # 2: down to label1
# BB#3:                                 # %if.end
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push38=, 20
	i32.add 	$push11=, $2, $pop38
	i32.const	$push37=, -7
	i32.add 	$push12=, $1, $pop37
	i32.load8_s	$push13=, 0($pop12)
	i32.ne  	$push14=, $pop11, $pop13
	br_if   	2, $pop14       # 2: down to label1
# BB#4:                                 # %if.end9
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push40=, 30
	i32.add 	$push15=, $2, $pop40
	i32.const	$push39=, -6
	i32.add 	$push10=, $1, $pop39
	i32.load8_s	$push0=, 0($pop10)
	i32.ne  	$push16=, $pop15, $pop0
	br_if   	2, $pop16       # 2: down to label1
# BB#5:                                 # %if.end15
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push42=, 40
	i32.add 	$push17=, $2, $pop42
	i32.const	$push41=, -5
	i32.add 	$push9=, $1, $pop41
	i32.load8_s	$push1=, 0($pop9)
	i32.ne  	$push18=, $pop17, $pop1
	br_if   	3, $pop18       # 3: down to label0
# BB#6:                                 # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.store	12($3), $1
	i32.const	$push46=, 4
	i32.add 	$1=, $1, $pop46
	i32.const	$push45=, 1
	i32.add 	$push44=, $2, $pop45
	tee_local	$push43=, $2=, $pop44
	i32.lt_s	$push19=, $pop43, $0
	br_if   	0, $pop19       # 0: up to label3
# BB#7:                                 # %for.end.loopexit
	end_loop
	i32.const	$push20=, -8
	i32.add 	$1=, $1, $pop20
.LBB0_8:                                # %for.end
	end_block                       # label2:
	i32.load	$push21=, 0($1)
	i32.const	$push22=, 123
	i32.ne  	$push23=, $pop21, $pop22
	br_if   	0, $pop23       # 0: down to label1
# BB#9:                                 # %if.end28
	i32.const	$push30=, 0
	i32.const	$push28=, 16
	i32.add 	$push29=, $3, $pop28
	i32.store	__stack_pointer($pop30), $pop29
	return  	$1
.LBB0_10:                               # %if.then27
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_11:                               # %if.then20
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
	i32.const	$push25=, 0
	i32.const	$push22=, 0
	i32.load	$push23=, __stack_pointer($pop22)
	i32.const	$push24=, 48
	i32.sub 	$push36=, $pop23, $pop24
	tee_local	$push35=, $0=, $pop36
	i32.store	__stack_pointer($pop25), $pop35
	i32.const	$push0=, 41
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 22
	i32.store8	0($pop1), $pop2
	i32.const	$push3=, 12
	i32.store8	40($0), $pop3
	i32.const	$push4=, 5130
	i32.store16	32($0), $pop4
	i32.const	$push5=, 21
	i32.store8	37($0), $pop5
	i32.const	$push6=, 30
	i32.store8	34($0), $pop6
	i32.const	$push7=, 11
	i32.store8	36($0), $pop7
	i32.const	$push8=, 31
	i32.store8	38($0), $pop8
	i32.const	$push9=, 42
	i32.add 	$push10=, $0, $pop9
	i32.const	$push11=, 32
	i32.store8	0($pop10), $pop11
	i32.const	$push12=, 40
	i32.store8	35($0), $pop12
	i32.const	$push13=, 41
	i32.store8	39($0), $pop13
	i32.const	$push26=, 32
	i32.add 	$push27=, $0, $pop26
	i32.const	$push34=, 11
	i32.add 	$push14=, $pop27, $pop34
	i32.const	$push15=, 42
	i32.store8	0($pop14), $pop15
	i32.load	$push16=, 32($0)
	i32.store	28($0), $pop16
	i32.load	$push17=, 36($0)
	i32.store	24($0), $pop17
	i32.load	$push18=, 40($0)
	i32.store	20($0), $pop18
	i32.const	$push19=, 123
	i32.store	12($0), $pop19
	i32.const	$push28=, 20
	i32.add 	$push29=, $0, $pop28
	i32.store	8($0), $pop29
	i32.const	$push30=, 24
	i32.add 	$push31=, $0, $pop30
	i32.store	4($0), $pop31
	i32.const	$push32=, 28
	i32.add 	$push33=, $0, $pop32
	i32.store	0($0), $pop33
	i32.const	$push20=, 3
	i32.call	$drop=, f@FUNCTION, $pop20, $0
	i32.const	$push21=, 0
	call    	exit@FUNCTION, $pop21
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
