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
	.local  	f64, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 16
	i32.sub 	$4=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$4=, 0($2), $4
	block
	block
	i32.const	$push15=, 0
	f64.load	$push14=, a($pop15):p2align=4
	tee_local	$push13=, $0=, $pop14
	f64.const	$push12=, 0x0p0
	f64.gt  	$push0=, $pop13, $pop12
	br_if   	0, $pop0        # 0: down to label2
# BB#1:                                 # %for.cond
	i32.const	$push17=, 0
	f64.load	$0=, a+8($pop17)
	f64.const	$push16=, 0x0p0
	f64.le  	$push1=, $0, $pop16
	f64.ne  	$push2=, $0, $0
	i32.or  	$push3=, $pop1, $pop2
	i32.const	$push19=, 0
	i32.eq  	$push20=, $pop3, $pop19
	br_if   	0, $pop20       # 0: down to label2
# BB#2:                                 # %for.cond.1
	i32.const	$push4=, 0
	f64.load	$0=, a+16($pop4):p2align=4
	f64.const	$push5=, 0x0p0
	f64.gt  	$push6=, $0, $pop5
	i32.const	$push21=, 0
	i32.eq  	$push22=, $pop6, $pop21
	br_if   	1, $pop22       # 1: down to label1
.LBB1_3:                                # %e
	end_block                       # label2:
	block
	f64.store	$push8=, 8($4), $0
	f64.const	$push9=, 0x1p0
	f64.eq  	$push10=, $pop8, $pop9
	br_if   	0, $pop10       # 0: down to label3
# BB#4:                                 # %if.then.i
	call    	abort@FUNCTION
	unreachable
.LBB1_5:                                # %bar.exit
	end_block                       # label3:
	i32.const	$push11=, 0
	call    	exit@FUNCTION, $pop11
	unreachable
.LBB1_6:                                # %for.cond.2
	end_block                       # label1:
	f64.store	$discard=, 8($4), $0
	i32.const	$push7=, 1
	i32.const	$3=, 8
	i32.add 	$3=, $4, $3
	call    	bar@FUNCTION, $pop7, $3
	i32.const	$push18=, 1
	call    	exit@FUNCTION, $pop18
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
