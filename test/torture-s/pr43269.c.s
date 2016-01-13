	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr43269.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	call    	func_32@FUNCTION
	i32.const	$0=, 0
	block
	i32.load	$push0=, g_261($0)
	i32.const	$push1=, -1
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	$pop2, 0        # 0: down to label0
# BB#1:                                 # %if.end
	return  	$0
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.func_32,"ax",@progbits
	.type	func_32,@function
func_32:                                # @func_32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block
	i32.load	$push2=, g_211($0)
	i32.const	$push0=, -1
	i32.store	$push1=, g_261($0), $pop0
	i32.eq  	$push3=, $pop2, $pop1
	br_if   	$pop3, 0        # 0: down to label1
# BB#1:                                 # %for.end
	return
.LBB1_2:                                # %if.else
                                        # =>This Inner Loop Header: Depth=1
	end_block                       # label1:
	loop                            # label2:
	br      	0               # 0: up to label2
.LBB1_3:
	end_loop                        # label3:
.Lfunc_end1:
	.size	func_32, .Lfunc_end1-func_32

	.hidden	g_261                   # @g_261
	.type	g_261,@object
	.section	.bss.g_261,"aw",@nobits
	.globl	g_261
	.align	2
g_261:
	.int32	0                       # 0x0
	.size	g_261, 4

	.hidden	g_21                    # @g_21
	.type	g_21,@object
	.section	.bss.g_21,"aw",@nobits
	.globl	g_21
	.align	2
g_21:
	.int32	0                       # 0x0
	.size	g_21, 4

	.hidden	g_211                   # @g_211
	.type	g_211,@object
	.section	.bss.g_211,"aw",@nobits
	.globl	g_211
	.align	2
g_211:
	.int32	0                       # 0x0
	.size	g_211, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
