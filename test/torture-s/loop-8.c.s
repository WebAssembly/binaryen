	.text
	.file	"loop-8.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
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
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	f64, i32
# BB#0:                                 # %entry
	i32.const	$push10=, 0
	i32.const	$push8=, 0
	i32.load	$push7=, __stack_pointer($pop8)
	i32.const	$push9=, 16
	i32.sub 	$push18=, $pop7, $pop9
	tee_local	$push17=, $1=, $pop18
	i32.store	__stack_pointer($pop10), $pop17
	block   	
	block   	
	i32.const	$push16=, 0
	f64.load	$push15=, a($pop16)
	tee_local	$push14=, $0=, $pop15
	f64.const	$push13=, 0x0p0
	f64.gt  	$push0=, $pop14, $pop13
	br_if   	0, $pop0        # 0: down to label2
# BB#1:                                 # %for.cond
	i32.const	$push22=, 0
	f64.load	$push21=, a+8($pop22)
	tee_local	$push20=, $0=, $pop21
	f64.const	$push19=, 0x0p0
	f64.le  	$push1=, $pop20, $pop19
	f64.ne  	$push2=, $0, $0
	i32.or  	$push3=, $pop1, $pop2
	i32.eqz 	$push27=, $pop3
	br_if   	0, $pop27       # 0: down to label2
# BB#2:                                 # %for.cond.1
	i32.const	$push4=, 0
	f64.load	$push24=, a+16($pop4)
	tee_local	$push23=, $0=, $pop24
	f64.const	$push5=, 0x0p0
	f64.gt  	$push6=, $pop23, $pop5
	i32.eqz 	$push28=, $pop6
	br_if   	1, $pop28       # 1: down to label1
.LBB1_3:                                # %e
	end_block                       # label2:
	f64.store	8($1), $0
	i32.const	$push26=, 0
	i32.const	$push11=, 8
	i32.add 	$push12=, $1, $pop11
	call    	bar@FUNCTION, $pop26, $pop12
	i32.const	$push25=, 0
	call    	exit@FUNCTION, $pop25
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


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
