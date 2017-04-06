	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr59358.c"
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
	i32.const	$push18=, 0
	i32.const	$push16=, 0
	i32.load	$push15=, __stack_pointer($pop16)
	i32.const	$push17=, 16
	i32.sub 	$push28=, $pop15, $pop17
	tee_local	$push27=, $6=, $pop28
	i32.store	__stack_pointer($pop18), $pop27
	i32.const	$push26=, 1
	i32.store	12($6), $pop26
	i32.const	$1=, 0
	i32.const	$0=, 2
	i32.const	$2=, 1
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	block   	
	loop    	                # label5:
	i32.const	$push22=, 12
	i32.add 	$push23=, $6, $pop22
	i32.const	$push34=, 16
	i32.call	$5=, foo@FUNCTION, $pop23, $pop34
	copy_local	$4=, $0
	block   	
	block   	
	block   	
	i32.const	$push33=, 1
	i32.add 	$push32=, $1, $pop33
	tee_local	$push31=, $3=, $pop32
	i32.const	$push30=, -8
	i32.and 	$push0=, $pop31, $pop30
	i32.const	$push29=, 8
	i32.eq  	$push1=, $pop0, $pop29
	br_if   	0, $pop1        # 0: down to label8
# BB#2:                                 # %if.else
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push36=, -4
	i32.and 	$push2=, $3, $pop36
	i32.const	$push35=, 4
	i32.ne  	$push3=, $pop2, $pop35
	br_if   	1, $pop3        # 1: down to label7
# BB#3:                                 # %if.then6
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push37=, 2
	i32.shl 	$4=, $2, $pop37
.LBB1_4:                                # %if.end15
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label8:
	i32.ne  	$push6=, $5, $4
	br_if   	3, $pop6        # 3: down to label4
	br      	1               # 1: down to label6
.LBB1_5:                                # %if.else10
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label7:
	i32.const	$push50=, 24
	i32.const	$push49=, 16
	i32.const	$push48=, 2
	i32.eq  	$push4=, $1, $pop48
	i32.select	$push14=, $pop50, $pop49, $pop4
	i32.ne  	$push5=, $5, $pop14
	br_if   	2, $pop5        # 2: down to label4
.LBB1_6:                                # %if.end18
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label6:
	i32.const	$push24=, 12
	i32.add 	$push25=, $6, $pop24
	i32.const	$push39=, 7
	i32.call	$4=, foo@FUNCTION, $pop25, $pop39
	copy_local	$5=, $2
	block   	
	i32.const	$push38=, 6
	i32.gt_s	$push7=, $3, $pop38
	br_if   	0, $pop7        # 0: down to label9
# BB#7:                                 # %if.else22
                                        #   in Loop: Header=BB1_1 Depth=1
	copy_local	$5=, $0
	i32.const	$push40=, 3
	i32.gt_s	$push8=, $3, $pop40
	br_if   	0, $pop8        # 0: down to label9
# BB#8:                                 # %if.else28
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push43=, 12
	i32.const	$push42=, 8
	i32.const	$push41=, 2
	i32.eq  	$push9=, $1, $pop41
	i32.select	$5=, $pop43, $pop42, $pop9
.LBB1_9:                                # %if.end34
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label9:
	i32.ne  	$push10=, $4, $5
	br_if   	1, $pop10       # 1: down to label4
# BB#10:                                # %if.end37
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push47=, 2
	i32.add 	$push11=, $1, $pop47
	i32.store	12($6), $pop11
	i32.const	$push46=, 2
	i32.add 	$0=, $0, $pop46
	i32.const	$push45=, 1
	i32.add 	$2=, $2, $pop45
	copy_local	$1=, $3
	i32.const	$push44=, 16
	i32.lt_s	$push12=, $3, $pop44
	br_if   	0, $pop12       # 0: up to label5
	br      	2               # 2: down to label3
.LBB1_11:                               # %if.then17
	end_loop
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_12:                               # %for.end
	end_block                       # label3:
	i32.const	$push21=, 0
	i32.const	$push19=, 16
	i32.add 	$push20=, $6, $pop19
	i32.store	__stack_pointer($pop21), $pop20
	i32.const	$push13=, 0
                                        # fallthrough-return: $pop13
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
	.functype	abort, void
