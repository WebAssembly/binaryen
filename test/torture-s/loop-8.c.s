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
	.local  	i32, f64
# BB#0:                                 # %entry
	i32.const	$push11=, 0
	i32.const	$push8=, 0
	i32.load	$push9=, __stack_pointer($pop8)
	i32.const	$push10=, 16
	i32.sub 	$push16=, $pop9, $pop10
	i32.store	$0=, __stack_pointer($pop11), $pop16
	block
	block
	i32.const	$push20=, 0
	f64.load	$push19=, a($pop20)
	tee_local	$push18=, $1=, $pop19
	f64.const	$push17=, 0x0p0
	f64.gt  	$push0=, $pop18, $pop17
	br_if   	0, $pop0        # 0: down to label2
# BB#1:                                 # %for.cond
	i32.const	$push24=, 0
	f64.load	$push23=, a+8($pop24)
	tee_local	$push22=, $1=, $pop23
	f64.const	$push21=, 0x0p0
	f64.le  	$push1=, $pop22, $pop21
	f64.ne  	$push2=, $1, $1
	i32.or  	$push3=, $pop1, $pop2
	i32.eqz 	$push30=, $pop3
	br_if   	0, $pop30       # 0: down to label2
# BB#2:                                 # %for.cond.1
	i32.const	$push4=, 0
	f64.load	$push26=, a+16($pop4)
	tee_local	$push25=, $1=, $pop26
	f64.const	$push5=, 0x0p0
	f64.gt  	$push6=, $pop25, $pop5
	i32.eqz 	$push31=, $pop6
	br_if   	1, $pop31       # 1: down to label1
.LBB1_3:                                # %e
	end_block                       # label2:
	f64.store	$drop=, 8($0), $1
	i32.const	$push28=, 0
	i32.const	$push12=, 8
	i32.add 	$push13=, $0, $pop12
	call    	bar@FUNCTION, $pop28, $pop13
	i32.const	$push27=, 0
	call    	exit@FUNCTION, $pop27
	unreachable
.LBB1_4:                                # %for.cond.2
	end_block                       # label1:
	f64.store	$drop=, 8($0), $1
	i32.const	$push7=, 1
	i32.const	$push14=, 8
	i32.add 	$push15=, $0, $pop14
	call    	bar@FUNCTION, $pop7, $pop15
	i32.const	$push29=, 1
	call    	exit@FUNCTION, $pop29
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


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
