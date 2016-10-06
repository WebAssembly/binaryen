	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-8.c"
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
	.local  	f64, i32
# BB#0:                                 # %entry
	i32.const	$push11=, 0
	i32.const	$push8=, 0
	i32.load	$push9=, __stack_pointer($pop8)
	i32.const	$push10=, 16
	i32.sub 	$push21=, $pop9, $pop10
	tee_local	$push20=, $1=, $pop21
	i32.store	__stack_pointer($pop11), $pop20
	block   	
	block   	
	i32.const	$push19=, 0
	f64.load	$push18=, a($pop19)
	tee_local	$push17=, $0=, $pop18
	f64.const	$push16=, 0x0p0
	f64.gt  	$push0=, $pop17, $pop16
	br_if   	0, $pop0        # 0: down to label2
# BB#1:                                 # %for.cond
	i32.const	$push25=, 0
	f64.load	$push24=, a+8($pop25)
	tee_local	$push23=, $0=, $pop24
	f64.const	$push22=, 0x0p0
	f64.le  	$push1=, $pop23, $pop22
	f64.ne  	$push2=, $0, $0
	i32.or  	$push3=, $pop1, $pop2
	i32.eqz 	$push31=, $pop3
	br_if   	0, $pop31       # 0: down to label2
# BB#2:                                 # %for.cond.1
	i32.const	$push4=, 0
	f64.load	$push27=, a+16($pop4)
	tee_local	$push26=, $0=, $pop27
	f64.const	$push5=, 0x0p0
	f64.gt  	$push6=, $pop26, $pop5
	i32.eqz 	$push32=, $pop6
	br_if   	1, $pop32       # 1: down to label1
.LBB1_3:                                # %e
	end_block                       # label2:
	f64.store	8($1), $0
	i32.const	$push29=, 0
	i32.const	$push12=, 8
	i32.add 	$push13=, $1, $pop12
	call    	bar@FUNCTION, $pop29, $pop13
	i32.const	$push28=, 0
	call    	exit@FUNCTION, $pop28
	unreachable
.LBB1_4:                                # %for.cond.2
	end_block                       # label1:
	f64.store	8($1), $0
	i32.const	$push7=, 1
	i32.const	$push14=, 8
	i32.add 	$push15=, $1, $pop14
	call    	bar@FUNCTION, $pop7, $pop15
	i32.const	$push30=, 1
	call    	exit@FUNCTION, $pop30
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
