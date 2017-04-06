	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-8.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	
	br_if   	0, $0           # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	f64.load	$push0=, 0($1)
	f64.const	$push1=, 0x1p0
	f64.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#2:                                 # %if.end
	return
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	f64
# BB#0:                                 # %entry
	block   	
	block   	
	block   	
	i32.const	$push13=, 0
	f64.load	$push12=, a($pop13)
	tee_local	$push11=, $0=, $pop12
	f64.const	$push10=, 0x0p0
	f64.gt  	$push0=, $pop11, $pop10
	br_if   	0, $pop0        # 0: down to label3
# BB#1:                                 # %for.cond
	i32.const	$push17=, 0
	f64.load	$push16=, a+8($pop17)
	tee_local	$push15=, $0=, $pop16
	f64.const	$push14=, 0x0p0
	f64.le  	$push1=, $pop15, $pop14
	f64.ne  	$push2=, $0, $0
	i32.or  	$push3=, $pop1, $pop2
	i32.eqz 	$push20=, $pop3
	br_if   	0, $pop20       # 0: down to label3
# BB#2:                                 # %for.cond.1
	i32.const	$push4=, 0
	f64.load	$push19=, a+16($pop4)
	tee_local	$push18=, $0=, $pop19
	f64.const	$push5=, 0x0p0
	f64.gt  	$push6=, $pop18, $pop5
	i32.eqz 	$push21=, $pop6
	br_if   	1, $pop21       # 1: down to label2
.LBB1_3:                                # %e
	end_block                       # label3:
	f64.const	$push7=, 0x1p0
	f64.eq  	$push8=, $0, $pop7
	br_if   	1, $pop8        # 1: down to label1
.LBB1_4:                                # %if.then.i
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB1_5:                                # %bar.exit4
	end_block                       # label1:
	i32.const	$push9=, 0
	call    	exit@FUNCTION, $pop9
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.p2align	4
a:
	.int64	0                       # double 0
	.int64	4607182418800017408     # double 1
	.int64	4611686018427387904     # double 2
	.size	a, 24


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
	.functype	abort, void
	.functype	exit, void, i32
