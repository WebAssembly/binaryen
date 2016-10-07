	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000706-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block   	
	i32.load	$push0=, 0($0)
	i32.const	$push1=, 1
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.load	$push3=, 4($0)
	i32.const	$push4=, 2
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label0
# BB#2:                                 # %lor.lhs.false2
	i32.load	$push6=, 8($0)
	i32.const	$push7=, 3
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label0
# BB#3:                                 # %lor.lhs.false4
	i32.load	$push9=, 12($0)
	i32.const	$push10=, 4
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	0, $pop11       # 0: down to label0
# BB#4:                                 # %lor.lhs.false6
	i32.const	$push13=, 10
	i32.ne  	$push14=, $5, $pop13
	br_if   	0, $pop14       # 0: down to label0
# BB#5:                                 # %lor.lhs.false6
	i32.const	$push15=, 9
	i32.ne  	$push16=, $4, $pop15
	br_if   	0, $pop16       # 0: down to label0
# BB#6:                                 # %lor.lhs.false6
	i32.const	$push17=, 8
	i32.ne  	$push18=, $3, $pop17
	br_if   	0, $pop18       # 0: down to label0
# BB#7:                                 # %lor.lhs.false6
	i32.const	$push19=, 7
	i32.ne  	$push20=, $2, $pop19
	br_if   	0, $pop20       # 0: down to label0
# BB#8:                                 # %lor.lhs.false6
	i32.const	$push21=, 6
	i32.ne  	$push22=, $1, $pop21
	br_if   	0, $pop22       # 0: down to label0
# BB#9:                                 # %lor.lhs.false6
	i32.load	$push12=, 16($0)
	i32.const	$push23=, 5
	i32.ne  	$push24=, $pop12, $pop23
	br_if   	0, $pop24       # 0: down to label0
# BB#10:                                # %if.end
	return
.LBB0_11:                               # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	
	i32.load	$push0=, 0($0)
	i32.const	$push1=, 1
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label1
# BB#1:                                 # %lor.lhs.false.i
	i32.load	$push3=, 4($0)
	i32.const	$push4=, 2
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label1
# BB#2:                                 # %lor.lhs.false2.i
	i32.load	$push6=, 8($0)
	i32.const	$push7=, 3
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label1
# BB#3:                                 # %lor.lhs.false4.i
	i32.load	$push9=, 12($0)
	i32.const	$push10=, 4
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	0, $pop11       # 0: down to label1
# BB#4:                                 # %lor.lhs.false6.i
	i32.load	$push12=, 16($0)
	i32.const	$push13=, 5
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	0, $pop14       # 0: down to label1
# BB#5:                                 # %bar.exit
	return
.LBB1_6:                                # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push11=, 0
	i32.const	$push8=, 0
	i32.load	$push9=, __stack_pointer($pop8)
	i32.const	$push10=, 48
	i32.sub 	$push18=, $pop9, $pop10
	tee_local	$push17=, $0=, $pop18
	i32.store	__stack_pointer($pop11), $pop17
	i64.const	$push0=, 17179869187
	i64.store	32($0), $pop0
	i32.const	$push1=, 12
	i32.add 	$push2=, $0, $pop1
	i64.const	$push16=, 17179869187
	i64.store	0($pop2):p2align=2, $pop16
	i32.const	$push3=, 5
	i32.store	40($0), $pop3
	i32.const	$push4=, 20
	i32.add 	$push5=, $0, $pop4
	i32.const	$push15=, 5
	i32.store	0($pop5), $pop15
	i64.const	$push6=, 8589934593
	i64.store	24($0), $pop6
	i64.const	$push14=, 8589934593
	i64.store	4($0):p2align=2, $pop14
	i32.const	$push12=, 4
	i32.add 	$push13=, $0, $pop12
	call    	foo@FUNCTION, $pop13, $0
	i32.const	$push7=, 0
	call    	exit@FUNCTION, $pop7
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
