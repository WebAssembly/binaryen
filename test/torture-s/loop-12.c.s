	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-12.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push8=, 0
	i32.load	$0=, p($pop8)
.LBB0_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	block
	i32.load8_u	$push2=, 0($0)
	i32.const	$push13=, -10
	i32.add 	$push0=, $pop2, $pop13
	i32.const	$push12=, 255
	i32.and 	$push11=, $pop0, $pop12
	tee_local	$push10=, $1=, $pop11
	i32.const	$push9=, 49
	i32.gt_u	$push3=, $pop10, $pop9
	br_if   	0, $pop3        # 0: down to label2
# BB#2:                                 # %is_end_of_statement.exit
                                        #   in Loop: Header=BB0_1 Depth=1
	i64.const	$push15=, 562949961809921
	i64.extend_u/i32	$push4=, $1
	i64.shr_u	$push5=, $pop15, $pop4
	i64.const	$push14=, 1
	i64.and 	$push6=, $pop5, $pop14
	i32.wrap/i64	$push7=, $pop6
	br_if   	2, $pop7        # 2: down to label1
.LBB0_3:                                # %while.body
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i32.const	$push17=, 0
	i32.const	$push16=, 1
	i32.add 	$push1=, $0, $pop16
	i32.store	$0=, p($pop17), $pop1
	br      	0               # 0: up to label0
.LBB0_4:                                # %while.end
	end_loop                        # label1:
	return
	.endfunc
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
	i32.const	$0=, .L.str
.LBB1_1:                                # %while.cond.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	block
	i32.const	$push15=, 0
	i32.store	$push14=, p($pop15), $0
	tee_local	$push13=, $0=, $pop14
	i32.load8_u	$push1=, 0($pop13)
	i32.const	$push12=, -10
	i32.add 	$push0=, $pop1, $pop12
	i32.const	$push11=, 255
	i32.and 	$push10=, $pop0, $pop11
	tee_local	$push9=, $1=, $pop10
	i32.const	$push8=, 49
	i32.gt_u	$push2=, $pop9, $pop8
	br_if   	0, $pop2        # 0: down to label5
# BB#2:                                 # %is_end_of_statement.exit.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i64.const	$push17=, 562949961809921
	i64.extend_u/i32	$push3=, $1
	i64.shr_u	$push4=, $pop17, $pop3
	i64.const	$push16=, 1
	i64.and 	$push5=, $pop4, $pop16
	i32.wrap/i64	$push6=, $pop5
	br_if   	2, $pop6        # 2: down to label4
.LBB1_3:                                # %while.body.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label5:
	i32.const	$push18=, 1
	i32.add 	$0=, $0, $pop18
	br      	0               # 0: up to label3
.LBB1_4:                                # %foo.exit
	end_loop                        # label4:
	i32.const	$push7=, 0
	return  	$pop7
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	p                       # @p
	.type	p,@object
	.section	.bss.p,"aw",@nobits
	.globl	p
	.p2align	2
p:
	.int32	0
	.size	p, 4

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"abc\n"
	.size	.L.str, 5


	.ident	"clang version 3.9.0 "
