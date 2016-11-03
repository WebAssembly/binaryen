	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr59358.c"
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
	i32.const	$push17=, 0
	i32.const	$push14=, 0
	i32.load	$push15=, __stack_pointer($pop14)
	i32.const	$push16=, 16
	i32.sub 	$push27=, $pop15, $pop16
	tee_local	$push26=, $6=, $pop27
	i32.store	__stack_pointer($pop17), $pop26
	i32.const	$push25=, 1
	i32.store	12($6), $pop25
	i32.const	$0=, 2
	i32.const	$1=, 2
	i32.const	$2=, 1
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label4:
	i32.const	$push21=, 12
	i32.add 	$push22=, $6, $pop21
	i32.const	$push33=, 16
	i32.call	$5=, foo@FUNCTION, $pop22, $pop33
	copy_local	$4=, $0
	block   	
	block   	
	i32.const	$push32=, -1
	i32.add 	$push31=, $1, $pop32
	tee_local	$push30=, $3=, $pop31
	i32.const	$push29=, -8
	i32.and 	$push1=, $pop30, $pop29
	i32.const	$push28=, 8
	i32.eq  	$push2=, $pop1, $pop28
	br_if   	0, $pop2        # 0: down to label6
# BB#2:                                 # %if.else
                                        #   in Loop: Header=BB1_1 Depth=1
	block   	
	i32.const	$push35=, -4
	i32.and 	$push3=, $3, $pop35
	i32.const	$push34=, 4
	i32.ne  	$push4=, $pop3, $pop34
	br_if   	0, $pop4        # 0: down to label7
# BB#3:                                 # %if.then6
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push36=, 2
	i32.shl 	$push13=, $2, $pop36
	i32.eq  	$push6=, $5, $pop13
	br_if   	2, $pop6        # 2: down to label5
	br      	4               # 4: down to label3
.LBB1_4:                                # %if.else10
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label7:
	i32.const	$push39=, 24
	i32.const	$push38=, 16
	i32.const	$push37=, 4
	i32.eq  	$push5=, $1, $pop37
	i32.select	$4=, $pop39, $pop38, $pop5
.LBB1_5:                                # %if.end15
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label6:
	i32.ne  	$push7=, $5, $4
	br_if   	2, $pop7        # 2: down to label3
.LBB1_6:                                # %if.end18
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label5:
	i32.const	$push23=, 12
	i32.add 	$push24=, $6, $pop23
	i32.const	$push41=, 7
	i32.call	$4=, foo@FUNCTION, $pop24, $pop41
	copy_local	$5=, $2
	block   	
	i32.const	$push40=, 6
	i32.gt_s	$push8=, $3, $pop40
	br_if   	0, $pop8        # 0: down to label8
# BB#7:                                 # %if.else22
                                        #   in Loop: Header=BB1_1 Depth=1
	copy_local	$5=, $0
	i32.const	$push42=, 3
	i32.gt_s	$push9=, $3, $pop42
	br_if   	0, $pop9        # 0: down to label8
# BB#8:                                 # %if.else28
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push45=, 12
	i32.const	$push44=, 8
	i32.const	$push43=, 4
	i32.eq  	$push10=, $1, $pop43
	i32.select	$5=, $pop45, $pop44, $pop10
.LBB1_9:                                # %if.end34
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label8:
	i32.ne  	$push11=, $4, $5
	br_if   	1, $pop11       # 1: down to label3
# BB#10:                                # %if.end37
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push49=, 2
	i32.add 	$0=, $0, $pop49
	i32.const	$push48=, 1
	i32.add 	$2=, $2, $pop48
	i32.store	12($6), $1
	i32.const	$push47=, 17
	i32.lt_s	$3=, $1, $pop47
	i32.const	$push46=, 1
	i32.add 	$push0=, $1, $pop46
	copy_local	$1=, $pop0
	br_if   	0, $3           # 0: up to label4
# BB#11:                                # %for.end
	end_loop
	i32.const	$push20=, 0
	i32.const	$push18=, 16
	i32.add 	$push19=, $6, $pop18
	i32.store	__stack_pointer($pop20), $pop19
	i32.const	$push12=, 0
	return  	$pop12
.LBB1_12:                               # %if.then36
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 "
	.functype	abort, void
