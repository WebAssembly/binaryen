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
	i32.const	$push1=, 0
	i32.load	$push0=, c($pop1)
	tee_local	$push13=, $1=, $pop0
	i32.load	$push2=, 0($pop13)
	i32.const	$push3=, 1
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	$pop4, 0        # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.load	$push5=, 4($1)
	i32.const	$push6=, 2
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	$pop7, 0        # 0: down to label0
# BB#2:                                 # %lor.lhs.false3
	i32.const	$push9=, 4
	i32.ne  	$push10=, $0, $pop9
	br_if   	$pop10, 0       # 0: down to label0
# BB#3:                                 # %lor.lhs.false3
	i32.load	$push8=, 8($1)
	i32.const	$push11=, 3
	i32.ne  	$push12=, $pop8, $pop11
	br_if   	$pop12, 0       # 0: down to label0
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
	i32.store	$push1=, c($pop0), $0
	tee_local	$push13=, $0=, $pop1
	i32.load	$push2=, 0($pop13)
	i32.const	$push3=, 1
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	$pop4, 0        # 0: down to label1
# BB#1:                                 # %lor.lhs.false.i
	i32.load	$push5=, 4($0)
	i32.const	$push6=, 2
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	$pop7, 0        # 0: down to label1
# BB#2:                                 # %lor.lhs.false3.i
	i32.const	$push9=, 4
	i32.ne  	$push10=, $1, $pop9
	br_if   	$pop10, 0       # 0: down to label1
# BB#3:                                 # %lor.lhs.false3.i
	i32.load	$push8=, 8($0)
	i32.const	$push11=, 3
	i32.ne  	$push12=, $pop8, $pop11
	br_if   	$pop12, 0       # 0: down to label1
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
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 16
	i32.sub 	$2=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$2=, 0($1), $2
	i32.const	$push0=, 0
	i32.store	$discard=, c($pop0), $2
	i32.const	$push1=, 0
	call    	exit@FUNCTION, $pop1
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
