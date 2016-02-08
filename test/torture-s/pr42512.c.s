	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr42512.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load16_u	$1=, g_3($pop0)
	i32.const	$0=, -1
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.const	$push8=, 65535
	i32.and 	$push1=, $1, $pop8
	i32.or  	$1=, $pop1, $0
	i32.const	$push7=, 255
	i32.add 	$push2=, $0, $pop7
	i32.const	$push6=, 255
	i32.and 	$0=, $pop2, $pop6
	br_if   	0, $0           # 0: up to label0
# BB#2:                                 # %for.end
	end_loop                        # label1:
	i32.const	$push10=, 0
	i32.store16	$discard=, g_3($pop10), $1
	block
	i32.const	$push3=, 65535
	i32.and 	$push4=, $1, $pop3
	i32.const	$push9=, 65535
	i32.ne  	$push5=, $pop4, $pop9
	br_if   	0, $pop5        # 0: down to label2
# BB#3:                                 # %if.end
	i32.const	$push11=, 0
	return  	$pop11
.LBB0_4:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	g_3                     # @g_3
	.type	g_3,@object
	.section	.bss.g_3,"aw",@nobits
	.globl	g_3
	.p2align	1
g_3:
	.int16	0                       # 0x0
	.size	g_3, 2


	.ident	"clang version 3.9.0 "
