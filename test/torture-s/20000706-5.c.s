	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000706-5.c"
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
	i32.const	$push0=, 0
	i32.store	c($pop0), $0
	block   	
	i32.load	$push1=, 0($0)
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
	i32.const	$push9=, 0
	i32.const	$push6=, 0
	i32.load	$push7=, __stack_pointer($pop6)
	i32.const	$push8=, 32
	i32.sub 	$push15=, $pop7, $pop8
	tee_local	$push14=, $0=, $pop15
	i32.store	__stack_pointer($pop9), $pop14
	i32.const	$push0=, 3
	i32.store	24($0), $pop0
	i32.const	$push1=, 12
	i32.add 	$push2=, $0, $pop1
	i32.const	$push13=, 3
	i32.store	0($pop2), $pop13
	i64.const	$push3=, 8589934593
	i64.store	16($0), $pop3
	i64.const	$push12=, 8589934593
	i64.store	4($0):p2align=2, $pop12
	i32.const	$push10=, 4
	i32.add 	$push11=, $0, $pop10
	i32.const	$push4=, 4
	call    	foo@FUNCTION, $pop11, $pop4
	i32.const	$push5=, 0
	call    	exit@FUNCTION, $pop5
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
