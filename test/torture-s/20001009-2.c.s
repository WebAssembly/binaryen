	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20001009-2.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block
	i32.load	$push0=, b($0)
	i32.const	$push6=, 0
	i32.eq  	$push7=, $pop0, $pop6
	br_if   	$pop7, 0        # 0: down to label0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$1=, 1
	#APP
	#NO_APP
	i32.load	$push1=, b($0)
	i32.const	$push2=, -1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	$push4=, b($0), $pop3
	br_if   	$pop4, 0        # 0: up to label1
.LBB0_2:                                # %if.end
	end_loop                        # label2:
	end_block                       # label0:
	i32.const	$push5=, -1
	return  	$pop5
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block
	i32.load	$push0=, b($0)
	i32.const	$push5=, 0
	i32.eq  	$push6=, $pop0, $pop5
	br_if   	$pop6, 0        # 0: down to label3
.LBB1_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.const	$1=, 1
	#APP
	#NO_APP
	i32.load	$push1=, b($0)
	i32.const	$push2=, -1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	$push4=, b($0), $pop3
	br_if   	$pop4, 0        # 0: up to label4
.LBB1_2:                                # %foo.exit
	end_loop                        # label5:
	end_block                       # label3:
	return  	$0
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	b                       # @b
	.type	b,@object
	.section	.data.b,"aw",@progbits
	.globl	b
	.align	2
b:
	.int32	1                       # 0x1
	.size	b, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
