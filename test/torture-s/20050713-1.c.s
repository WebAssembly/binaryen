	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20050713-1.c"
	.section	.text.foo2,"ax",@progbits
	.hidden	foo2
	.globl	foo2
	.type	foo2,@function
foo2:                                   # @foo2
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.load	$push0=, 0($0)
	i32.const	$push1=, 3
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.load	$push3=, 4($0)
	i32.const	$push4=, 4
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label0
# BB#2:                                 # %lor.lhs.false2
	i32.load	$push6=, 8($0)
	i32.const	$push7=, 5
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label0
# BB#3:                                 # %if.end
	i32.load	$push9=, 0($1)
	i32.const	$push10=, 6
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	0, $pop11       # 0: down to label0
# BB#4:                                 # %lor.lhs.false6
	i32.load	$push12=, 4($1)
	i32.const	$push13=, 7
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	0, $pop14       # 0: down to label0
# BB#5:                                 # %lor.lhs.false9
	i32.load	$push15=, 8($1)
	i32.const	$push16=, 8
	i32.ne  	$push17=, $pop15, $pop16
	br_if   	0, $pop17       # 0: down to label0
# BB#6:                                 # %if.end13
	i32.const	$push18=, 0
	return  	$pop18
.LBB0_7:                                # %if.then12
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo2, .Lfunc_end0-foo2

	.section	.text.foo3,"ax",@progbits
	.hidden	foo3
	.globl	foo3
	.type	foo3,@function
foo3:                                   # @foo3
	.param  	i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.load	$push2=, 0($0)
	i32.const	$push3=, 3
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label1
# BB#1:                                 # %entry
	i32.load	$push0=, 4($0)
	i32.const	$push5=, 4
	i32.ne  	$push6=, $pop0, $pop5
	br_if   	0, $pop6        # 0: down to label1
# BB#2:                                 # %entry
	i32.load	$push1=, 8($0)
	i32.const	$push7=, 5
	i32.ne  	$push8=, $pop1, $pop7
	br_if   	0, $pop8        # 0: down to label1
# BB#3:                                 # %if.end.i
	i32.load	$push11=, 8($1)
	i32.const	$push12=, 8
	i32.ne  	$push13=, $pop11, $pop12
	br_if   	0, $pop13       # 0: down to label1
# BB#4:                                 # %if.end.i
	i32.load	$push9=, 4($1)
	i32.const	$push14=, 7
	i32.ne  	$push15=, $pop9, $pop14
	br_if   	0, $pop15       # 0: down to label1
# BB#5:                                 # %if.end.i
	i32.load	$push10=, 0($1)
	i32.const	$push16=, 6
	i32.ne  	$push17=, $pop10, $pop16
	br_if   	0, $pop17       # 0: down to label1
# BB#6:                                 # %foo2.exit
	i32.load	$push18=, 0($2)
	i32.const	$push19=, 9
	i32.ne  	$push20=, $pop18, $pop19
	br_if   	0, $pop20       # 0: down to label1
# BB#7:                                 # %lor.lhs.false
	i32.load	$push21=, 4($2)
	i32.const	$push22=, 10
	i32.ne  	$push23=, $pop21, $pop22
	br_if   	0, $pop23       # 0: down to label1
# BB#8:                                 # %lor.lhs.false2
	i32.load	$push24=, 8($2)
	i32.const	$push25=, 11
	i32.ne  	$push26=, $pop24, $pop25
	br_if   	0, $pop26       # 0: down to label1
# BB#9:                                 # %if.end
	i32.const	$push27=, 0
	return  	$pop27
.LBB1_10:                               # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	foo3, .Lfunc_end1-foo3

	.section	.text.bar2,"ax",@progbits
	.hidden	bar2
	.globl	bar2
	.type	bar2,@function
bar2:                                   # @bar2
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.load	$push2=, 0($1)
	i32.const	$push3=, 3
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label2
# BB#1:                                 # %entry
	i32.load	$push0=, 4($1)
	i32.const	$push5=, 4
	i32.ne  	$push6=, $pop0, $pop5
	br_if   	0, $pop6        # 0: down to label2
# BB#2:                                 # %entry
	i32.load	$push1=, 8($1)
	i32.const	$push7=, 5
	i32.ne  	$push8=, $pop1, $pop7
	br_if   	0, $pop8        # 0: down to label2
# BB#3:                                 # %if.end.i
	i32.load	$push11=, 8($0)
	i32.const	$push12=, 8
	i32.ne  	$push13=, $pop11, $pop12
	br_if   	0, $pop13       # 0: down to label2
# BB#4:                                 # %if.end.i
	i32.load	$push9=, 4($0)
	i32.const	$push14=, 7
	i32.ne  	$push15=, $pop9, $pop14
	br_if   	0, $pop15       # 0: down to label2
# BB#5:                                 # %if.end.i
	i32.load	$push10=, 0($0)
	i32.const	$push16=, 6
	i32.ne  	$push17=, $pop10, $pop16
	br_if   	0, $pop17       # 0: down to label2
# BB#6:                                 # %foo2.exit
	i32.const	$push18=, 0
	return  	$pop18
.LBB2_7:                                # %if.then12.i
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	bar2, .Lfunc_end2-bar2

	.section	.text.bar3,"ax",@progbits
	.hidden	bar3
	.globl	bar3
	.type	bar3,@function
bar3:                                   # @bar3
	.param  	i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.load	$push5=, 0($1)
	i32.const	$push6=, 3
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label3
# BB#1:                                 # %entry
	i32.load	$push3=, 4($1)
	i32.const	$push8=, 4
	i32.ne  	$push9=, $pop3, $pop8
	br_if   	0, $pop9        # 0: down to label3
# BB#2:                                 # %entry
	i32.load	$push4=, 8($1)
	i32.const	$push10=, 5
	i32.ne  	$push11=, $pop4, $pop10
	br_if   	0, $pop11       # 0: down to label3
# BB#3:                                 # %if.end.i.i
	i32.load	$push14=, 8($0)
	i32.const	$push15=, 8
	i32.ne  	$push16=, $pop14, $pop15
	br_if   	0, $pop16       # 0: down to label3
# BB#4:                                 # %if.end.i.i
	i32.load	$push12=, 4($0)
	i32.const	$push17=, 7
	i32.ne  	$push18=, $pop12, $pop17
	br_if   	0, $pop18       # 0: down to label3
# BB#5:                                 # %if.end.i.i
	i32.load	$push13=, 0($0)
	i32.const	$push19=, 6
	i32.ne  	$push20=, $pop13, $pop19
	br_if   	0, $pop20       # 0: down to label3
# BB#6:                                 # %foo2.exit.i
	i32.load	$push0=, 0($2)
	i32.const	$push21=, 9
	i32.ne  	$push22=, $pop0, $pop21
	br_if   	0, $pop22       # 0: down to label3
# BB#7:                                 # %foo2.exit.i
	i32.load	$push1=, 4($2)
	i32.const	$push23=, 10
	i32.ne  	$push24=, $pop1, $pop23
	br_if   	0, $pop24       # 0: down to label3
# BB#8:                                 # %foo2.exit.i
	i32.load	$push2=, 8($2)
	i32.const	$push25=, 11
	i32.ne  	$push26=, $pop2, $pop25
	br_if   	0, $pop26       # 0: down to label3
# BB#9:                                 # %foo3.exit
	i32.const	$push27=, 0
	return  	$pop27
.LBB3_10:                               # %if.then.i
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	bar3, .Lfunc_end3-bar3

	.section	.text.baz3,"ax",@progbits
	.hidden	baz3
	.globl	baz3
	.type	baz3,@function
baz3:                                   # @baz3
	.param  	i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.load	$push5=, 0($1)
	i32.const	$push6=, 3
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label4
# BB#1:                                 # %entry
	i32.load	$push3=, 4($1)
	i32.const	$push8=, 4
	i32.ne  	$push9=, $pop3, $pop8
	br_if   	0, $pop9        # 0: down to label4
# BB#2:                                 # %entry
	i32.load	$push4=, 8($1)
	i32.const	$push10=, 5
	i32.ne  	$push11=, $pop4, $pop10
	br_if   	0, $pop11       # 0: down to label4
# BB#3:                                 # %if.end.i.i
	i32.load	$push14=, 8($2)
	i32.const	$push15=, 8
	i32.ne  	$push16=, $pop14, $pop15
	br_if   	0, $pop16       # 0: down to label4
# BB#4:                                 # %if.end.i.i
	i32.load	$push12=, 4($2)
	i32.const	$push17=, 7
	i32.ne  	$push18=, $pop12, $pop17
	br_if   	0, $pop18       # 0: down to label4
# BB#5:                                 # %if.end.i.i
	i32.load	$push13=, 0($2)
	i32.const	$push19=, 6
	i32.ne  	$push20=, $pop13, $pop19
	br_if   	0, $pop20       # 0: down to label4
# BB#6:                                 # %foo2.exit.i
	i32.load	$push0=, 0($0)
	i32.const	$push21=, 9
	i32.ne  	$push22=, $pop0, $pop21
	br_if   	0, $pop22       # 0: down to label4
# BB#7:                                 # %foo2.exit.i
	i32.load	$push1=, 4($0)
	i32.const	$push23=, 10
	i32.ne  	$push24=, $pop1, $pop23
	br_if   	0, $pop24       # 0: down to label4
# BB#8:                                 # %foo2.exit.i
	i32.load	$push2=, 8($0)
	i32.const	$push25=, 11
	i32.ne  	$push26=, $pop2, $pop25
	br_if   	0, $pop26       # 0: down to label4
# BB#9:                                 # %foo3.exit
	i32.const	$push27=, 0
	return  	$pop27
.LBB4_10:                               # %if.then.i
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end4:
	.size	baz3, .Lfunc_end4-baz3

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %baz3.exit
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end5:
	.size	main, .Lfunc_end5-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
