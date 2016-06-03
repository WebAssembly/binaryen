	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000706-5.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 0
	i32.load	$push13=, c($pop0)
	tee_local	$push12=, $1=, $pop13
	i32.load	$push1=, 0($pop12)
	i32.const	$push2=, 1
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.load	$push4=, 4($1)
	i32.const	$push5=, 2
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label0
# BB#2:                                 # %lor.lhs.false3
	i32.const	$push8=, 4
	i32.ne  	$push9=, $0, $pop8
	br_if   	0, $pop9        # 0: down to label0
# BB#3:                                 # %lor.lhs.false3
	i32.load	$push7=, 8($1)
	i32.const	$push10=, 3
	i32.ne  	$push11=, $pop7, $pop10
	br_if   	0, $pop11       # 0: down to label0
# BB#4:                                 # %if.end
	return
.LBB0_5:                                # %if.then
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
	i32.const	$push0=, 0
	i32.store	$push13=, c($pop0), $0
	tee_local	$push12=, $0=, $pop13
	i32.load	$push1=, 0($pop12)
	i32.const	$push2=, 1
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label1
# BB#1:                                 # %lor.lhs.false.i
	i32.load	$push4=, 4($0)
	i32.const	$push5=, 2
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label1
# BB#2:                                 # %lor.lhs.false3.i
	i32.const	$push8=, 4
	i32.ne  	$push9=, $1, $pop8
	br_if   	0, $pop9        # 0: down to label1
# BB#3:                                 # %lor.lhs.false3.i
	i32.load	$push7=, 8($0)
	i32.const	$push10=, 3
	i32.ne  	$push11=, $pop7, $pop10
	br_if   	0, $pop11       # 0: down to label1
# BB#4:                                 # %bar.exit
	return
.LBB1_5:                                # %if.then.i
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
	i32.const	$push13=, 0
	i32.const	$push10=, 0
	i32.load	$push11=, __stack_pointer($pop10)
	i32.const	$push12=, 32
	i32.sub 	$push18=, $pop11, $pop12
	i32.store	$push21=, __stack_pointer($pop13), $pop18
	tee_local	$push20=, $0=, $pop21
	i32.const	$push2=, 12
	i32.add 	$push3=, $pop20, $pop2
	i32.const	$push1=, 3
	i32.store	$push0=, 24($0), $pop1
	i32.store	$drop=, 0($pop3), $pop0
	i64.const	$push4=, 8589934593
	i64.store	$drop=, 16($0), $pop4
	i32.const	$push14=, 4
	i32.add 	$push15=, $0, $pop14
	i32.const	$push5=, 4
	i32.add 	$push6=, $pop15, $pop5
	i32.load	$push7=, 20($0)
	i32.store	$drop=, 0($pop6), $pop7
	i32.const	$push8=, 1
	i32.store	$drop=, 4($0), $pop8
	i32.const	$push16=, 4
	i32.add 	$push17=, $0, $pop16
	i32.const	$push19=, 4
	call    	foo@FUNCTION, $pop17, $pop19
	i32.const	$push9=, 0
	call    	exit@FUNCTION, $pop9
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.p2align	2
c:
	.int32	0
	.size	c, 4


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
