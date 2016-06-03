	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr42512.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.load16_u	$2=, g_3($pop1)
	i32.const	$1=, -1
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.const	$push11=, 65535
	i32.and 	$push3=, $2, $pop11
	i32.or  	$2=, $pop3, $1
	i32.const	$push10=, 255
	i32.add 	$push2=, $1, $pop10
	i32.const	$push9=, 255
	i32.and 	$push8=, $pop2, $pop9
	tee_local	$push7=, $0=, $pop8
	copy_local	$1=, $pop7
	br_if   	0, $0           # 0: up to label0
# BB#2:                                 # %for.end
	end_loop                        # label1:
	block
	i32.const	$push13=, 0
	i32.store16	$push0=, g_3($pop13), $2
	i32.const	$push4=, 65535
	i32.and 	$push5=, $pop0, $pop4
	i32.const	$push12=, 65535
	i32.ne  	$push6=, $pop5, $pop12
	br_if   	0, $pop6        # 0: down to label2
# BB#3:                                 # %if.end
	i32.const	$push14=, 0
	return  	$pop14
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
	.functype	abort, void
