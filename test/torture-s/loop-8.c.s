	.text
	.file	"loop-8.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
# %bb.0:                                # %entry
	block   	
	br_if   	0, $0           # 0: down to label0
# %bb.1:                                # %lor.lhs.false
	f64.load	$push0=, 0($1)
	f64.const	$push1=, 0x1p0
	f64.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# %bb.2:                                # %if.end
	return
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	f64, i32
# %bb.0:                                # %entry
	i32.const	$push8=, 0
	i32.load	$push7=, __stack_pointer($pop8)
	i32.const	$push9=, 16
	i32.sub 	$1=, $pop7, $pop9
	i32.const	$push10=, 0
	i32.store	__stack_pointer($pop10), $1
	i32.const	$push14=, 0
	f64.load	$0=, a($pop14)
	block   	
	block   	
	f64.const	$push13=, 0x0p0
	f64.gt  	$push0=, $0, $pop13
	br_if   	0, $pop0        # 0: down to label2
# %bb.1:                                # %for.cond
	i32.const	$push16=, 0
	f64.load	$0=, a+8($pop16)
	f64.const	$push15=, 0x0p0
	f64.le  	$push1=, $0, $pop15
	f64.ne  	$push2=, $0, $0
	i32.or  	$push3=, $pop1, $pop2
	i32.eqz 	$push19=, $pop3
	br_if   	0, $pop19       # 0: down to label2
# %bb.2:                                # %for.cond.1
	i32.const	$push4=, 0
	f64.load	$0=, a+16($pop4)
	f64.const	$push5=, 0x0p0
	f64.gt  	$push6=, $0, $pop5
	i32.eqz 	$push20=, $pop6
	br_if   	1, $pop20       # 1: down to label1
.LBB1_3:                                # %e
	end_block                       # label2:
	f64.store	8($1), $0
	i32.const	$push18=, 0
	i32.const	$push11=, 8
	i32.add 	$push12=, $1, $pop11
	call    	bar@FUNCTION, $pop18, $pop12
	i32.const	$push17=, 0
	call    	exit@FUNCTION, $pop17
	unreachable
.LBB1_4:                                # %for.cond.2
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
