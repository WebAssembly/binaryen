	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20001009-2.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push5=, 0
	i32.load	$push1=, b($pop5)
	i32.const	$push9=, 0
	i32.eq  	$push10=, $pop1, $pop9
	br_if   	0, $pop10       # 0: down to label0
# BB#1:                                 # %for.body.preheader
	i32.const	$0=, 1
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	#APP
	#NO_APP
	i32.const	$push8=, 0
	i32.const	$push7=, 0
	i32.load	$push2=, b($pop7)
	i32.const	$push6=, -1
	i32.add 	$push3=, $pop2, $pop6
	i32.store	$push0=, b($pop8), $pop3
	br_if   	0, $pop0        # 0: up to label1
.LBB0_3:                                # %if.end
	end_loop                        # label2:
	end_block                       # label0:
	i32.const	$push4=, -1
	return  	$pop4
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push4=, 0
	i32.load	$push1=, b($pop4)
	i32.const	$push9=, 0
	i32.eq  	$push10=, $pop1, $pop9
	br_if   	0, $pop10       # 0: down to label3
# BB#1:                                 # %for.body.i.preheader
	i32.const	$0=, 1
.LBB1_2:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	#APP
	#NO_APP
	i32.const	$push7=, 0
	i32.const	$push6=, 0
	i32.load	$push2=, b($pop6)
	i32.const	$push5=, -1
	i32.add 	$push3=, $pop2, $pop5
	i32.store	$push0=, b($pop7), $pop3
	br_if   	0, $pop0        # 0: up to label4
.LBB1_3:                                # %foo.exit
	end_loop                        # label5:
	end_block                       # label3:
	i32.const	$push8=, 0
	return  	$pop8
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	b                       # @b
	.type	b,@object
	.section	.data.b,"aw",@progbits
	.globl	b
	.p2align	2
b:
	.int32	1                       # 0x1
	.size	b, 4


	.ident	"clang version 3.9.0 "
