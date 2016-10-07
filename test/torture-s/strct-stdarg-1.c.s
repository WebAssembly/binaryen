	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/strct-stdarg-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push31=, 0
	i32.const	$push28=, 0
	i32.load	$push29=, __stack_pointer($pop28)
	i32.const	$push30=, 16
	i32.sub 	$push37=, $pop29, $pop30
	tee_local	$push36=, $3=, $pop37
	i32.store	__stack_pointer($pop31), $pop36
	i32.store	12($3), $1
	block   	
	block   	
	block   	
	i32.const	$push35=, 1
	i32.lt_s	$push3=, $0, $pop35
	br_if   	0, $pop3        # 0: down to label2
# BB#1:                                 # %for.body.preheader
	i32.const	$push38=, 8
	i32.add 	$1=, $1, $pop38
	i32.const	$2=, 0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	i32.store	12($3), $1
	i32.const	$push40=, 10
	i32.add 	$push4=, $2, $pop40
	i32.const	$push39=, -8
	i32.add 	$push5=, $1, $pop39
	i32.load8_s	$push6=, 0($pop5)
	i32.ne  	$push7=, $pop4, $pop6
	br_if   	2, $pop7        # 2: down to label1
# BB#3:                                 # %if.end
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push42=, 20
	i32.add 	$push11=, $2, $pop42
	i32.const	$push41=, -7
	i32.add 	$push12=, $1, $pop41
	i32.load8_s	$push13=, 0($pop12)
	i32.ne  	$push14=, $pop11, $pop13
	br_if   	2, $pop14       # 2: down to label1
# BB#4:                                 # %if.end9
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push44=, 30
	i32.add 	$push15=, $2, $pop44
	i32.const	$push43=, -6
	i32.add 	$push10=, $1, $pop43
	i32.load8_s	$push0=, 0($pop10)
	i32.ne  	$push16=, $pop15, $pop0
	br_if   	2, $pop16       # 2: down to label1
# BB#5:                                 # %if.end15
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push46=, 40
	i32.add 	$push17=, $2, $pop46
	i32.const	$push45=, -5
	i32.add 	$push9=, $1, $pop45
	i32.load8_s	$push1=, 0($pop9)
	i32.ne  	$push18=, $pop17, $pop1
	br_if   	2, $pop18       # 2: down to label1
# BB#6:                                 # %if.end21
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push48=, 50
	i32.add 	$push19=, $2, $pop48
	i32.const	$push47=, -4
	i32.add 	$push8=, $1, $pop47
	i32.load8_s	$push2=, 0($pop8)
	i32.ne  	$push20=, $pop19, $pop2
	br_if   	3, $pop20       # 3: down to label0
# BB#7:                                 # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push52=, 8
	i32.add 	$1=, $1, $pop52
	i32.const	$push51=, 1
	i32.add 	$push50=, $2, $pop51
	tee_local	$push49=, $2=, $pop50
	i32.lt_s	$push21=, $pop49, $0
	br_if   	0, $pop21       # 0: up to label3
# BB#8:                                 # %for.end.loopexit
	end_loop
	i32.const	$push22=, -8
	i32.add 	$1=, $1, $pop22
.LBB0_9:                                # %for.end
	end_block                       # label2:
	i32.const	$push23=, 4
	i32.add 	$push24=, $1, $pop23
	i32.store	12($3), $pop24
	i32.load	$push25=, 0($1)
	i32.const	$push26=, 123
	i32.ne  	$push27=, $pop25, $pop26
	br_if   	0, $pop27       # 0: down to label1
# BB#10:                                # %if.end34
	i32.const	$push34=, 0
	i32.const	$push32=, 16
	i32.add 	$push33=, $3, $pop32
	i32.store	__stack_pointer($pop34), $pop33
	return  	$1
.LBB0_11:                               # %if.then33
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_12:                               # %if.then26
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
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push38=, 0
	i32.const	$push35=, 0
	i32.load	$push36=, __stack_pointer($pop35)
	i32.const	$push37=, 64
	i32.sub 	$push64=, $pop36, $pop37
	tee_local	$push63=, $2=, $pop64
	i32.store	__stack_pointer($pop38), $pop63
	i32.const	$push0=, 11
	i32.store8	53($2), $pop0
	i32.const	$push39=, 48
	i32.add 	$push40=, $2, $pop39
	i32.const	$push62=, 11
	i32.add 	$push1=, $pop40, $pop62
	i32.const	$push2=, 22
	i32.store8	0($pop1), $pop2
	i32.const	$push3=, 5130
	i32.store16	48($2), $pop3
	i32.const	$push4=, 21
	i32.store8	54($2), $pop4
	i32.const	$push5=, 30
	i32.store8	50($2), $pop5
	i32.const	$push6=, 12
	i32.store8	58($2), $pop6
	i32.const	$push7=, 31
	i32.store8	55($2), $pop7
	i32.const	$push41=, 48
	i32.add 	$push42=, $2, $pop41
	i32.const	$push61=, 12
	i32.add 	$push8=, $pop42, $pop61
	i32.const	$push9=, 32
	i32.store8	0($pop8), $pop9
	i32.const	$push10=, 40
	i32.store8	51($2), $pop10
	i32.const	$push11=, 56
	i32.add 	$push12=, $2, $pop11
	i32.const	$push13=, 41
	i32.store8	0($pop12), $pop13
	i32.const	$push14=, 61
	i32.add 	$push15=, $2, $pop14
	i32.const	$push16=, 42
	i32.store8	0($pop15), $pop16
	i32.const	$push17=, 50
	i32.store8	52($2), $pop17
	i32.const	$push18=, 57
	i32.add 	$push60=, $2, $pop18
	tee_local	$push59=, $0=, $pop60
	i32.const	$push19=, 51
	i32.store8	0($pop59), $pop19
	i32.const	$push43=, 40
	i32.add 	$push44=, $2, $pop43
	i32.const	$push20=, 4
	i32.add 	$push21=, $pop44, $pop20
	i32.load8_u	$push22=, 52($2)
	i32.store8	0($pop21), $pop22
	i32.const	$push23=, 62
	i32.add 	$push58=, $2, $pop23
	tee_local	$push57=, $1=, $pop58
	i32.const	$push24=, 52
	i32.store8	0($pop57), $pop24
	i32.const	$push45=, 32
	i32.add 	$push46=, $2, $pop45
	i32.const	$push56=, 4
	i32.add 	$push25=, $pop46, $pop56
	i32.load8_u	$push26=, 0($0)
	i32.store8	0($pop25), $pop26
	i32.load	$push27=, 48($2)
	i32.store	40($2), $pop27
	i32.load	$push28=, 53($2):p2align=0
	i32.store	32($2), $pop28
	i32.const	$push47=, 24
	i32.add 	$push48=, $2, $pop47
	i32.const	$push55=, 4
	i32.add 	$push29=, $pop48, $pop55
	i32.load8_u	$push30=, 0($1)
	i32.store8	0($pop29), $pop30
	i32.load	$push31=, 58($2):p2align=1
	i32.store	24($2), $pop31
	i32.const	$push32=, 123
	i32.store	12($2), $pop32
	i32.const	$push49=, 24
	i32.add 	$push50=, $2, $pop49
	i32.store	8($2), $pop50
	i32.const	$push51=, 32
	i32.add 	$push52=, $2, $pop51
	i32.store	4($2), $pop52
	i32.const	$push53=, 40
	i32.add 	$push54=, $2, $pop53
	i32.store	0($2), $pop54
	i32.const	$push33=, 3
	i32.call	$drop=, f@FUNCTION, $pop33, $2
	i32.const	$push34=, 0
	call    	exit@FUNCTION, $pop34
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
