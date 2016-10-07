	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr59358.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.load	$0=, 0($0)
	block   	
	block   	
	i32.const	$push0=, 16
	i32.gt_s	$push1=, $1, $pop0
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %entry
	i32.ge_s	$push2=, $0, $1
	br_if   	1, $pop2        # 1: down to label0
# BB#2:                                 # %while.cond.preheader
.LBB0_3:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	copy_local	$push8=, $0
	tee_local	$push7=, $2=, $pop8
	i32.const	$push6=, 1
	i32.shl 	$0=, $pop7, $pop6
	i32.lt_s	$push3=, $2, $1
	br_if   	0, $pop3        # 0: up to label2
# BB#4:                                 # %if.end
	end_loop
	return  	$2
.LBB0_5:
	end_block                       # label1:
	copy_local	$push5=, $0
	return  	$pop5
.LBB0_6:
	end_block                       # label0:
	copy_local	$push4=, $0
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push15=, 0
	i32.const	$push12=, 0
	i32.load	$push13=, __stack_pointer($pop12)
	i32.const	$push14=, 16
	i32.sub 	$push25=, $pop13, $pop14
	tee_local	$push24=, $6=, $pop25
	i32.store	__stack_pointer($pop15), $pop24
	i32.const	$push23=, 1
	i32.store	12($6), $pop23
	i32.const	$0=, 2
	i32.const	$1=, 2
	i32.const	$2=, 1
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label4:
	i32.const	$push19=, 12
	i32.add 	$push20=, $6, $pop19
	i32.const	$push31=, 16
	i32.call	$4=, foo@FUNCTION, $pop20, $pop31
	copy_local	$5=, $0
	block   	
	i32.const	$push30=, -1
	i32.add 	$push29=, $1, $pop30
	tee_local	$push28=, $3=, $pop29
	i32.const	$push27=, -8
	i32.and 	$push1=, $pop28, $pop27
	i32.const	$push26=, 8
	i32.eq  	$push2=, $pop1, $pop26
	br_if   	0, $pop2        # 0: down to label5
# BB#2:                                 # %if.else
                                        #   in Loop: Header=BB1_1 Depth=1
	block   	
	i32.const	$push33=, -4
	i32.and 	$push3=, $3, $pop33
	i32.const	$push32=, 4
	i32.ne  	$push4=, $pop3, $pop32
	br_if   	0, $pop4        # 0: down to label6
# BB#3:                                 # %if.then6
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push34=, 2
	i32.shl 	$5=, $2, $pop34
	br      	1               # 1: down to label5
.LBB1_4:                                # %if.else10
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label6:
	i32.const	$push37=, 24
	i32.const	$push36=, 16
	i32.const	$push35=, 4
	i32.eq  	$push5=, $1, $pop35
	i32.select	$5=, $pop37, $pop36, $pop5
.LBB1_5:                                # %if.end15
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label5:
	i32.ne  	$push6=, $4, $5
	br_if   	1, $pop6        # 1: down to label3
# BB#6:                                 # %if.end18
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push21=, 12
	i32.add 	$push22=, $6, $pop21
	i32.const	$push39=, 7
	i32.call	$4=, foo@FUNCTION, $pop22, $pop39
	copy_local	$5=, $2
	block   	
	i32.const	$push38=, 6
	i32.gt_s	$push7=, $3, $pop38
	br_if   	0, $pop7        # 0: down to label7
# BB#7:                                 # %if.else22
                                        #   in Loop: Header=BB1_1 Depth=1
	copy_local	$5=, $0
	i32.const	$push40=, 3
	i32.gt_s	$push8=, $3, $pop40
	br_if   	0, $pop8        # 0: down to label7
# BB#8:                                 # %if.else28
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push43=, 12
	i32.const	$push42=, 8
	i32.const	$push41=, 4
	i32.eq  	$push9=, $1, $pop41
	i32.select	$5=, $pop43, $pop42, $pop9
.LBB1_9:                                # %if.end34
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label7:
	i32.ne  	$push10=, $4, $5
	br_if   	1, $pop10       # 1: down to label3
# BB#10:                                # %if.end37
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push47=, 2
	i32.add 	$0=, $0, $pop47
	i32.const	$push46=, 1
	i32.add 	$2=, $2, $pop46
	i32.store	12($6), $1
	i32.const	$push45=, 17
	i32.lt_s	$3=, $1, $pop45
	i32.const	$push44=, 1
	i32.add 	$push0=, $1, $pop44
	copy_local	$1=, $pop0
	br_if   	0, $3           # 0: up to label4
# BB#11:                                # %for.end
	end_loop
	i32.const	$push18=, 0
	i32.const	$push16=, 16
	i32.add 	$push17=, $6, $pop16
	i32.store	__stack_pointer($pop18), $pop17
	i32.const	$push11=, 0
	return  	$pop11
.LBB1_12:                               # %if.then36
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
