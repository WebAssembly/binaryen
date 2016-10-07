	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr42512.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load16_u	$2=, g_3($pop0)
	i32.const	$1=, -1
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.const	$push10=, 65535
	i32.and 	$push2=, $2, $pop10
	i32.or  	$2=, $pop2, $1
	i32.const	$push9=, 255
	i32.add 	$push1=, $1, $pop9
	i32.const	$push8=, 255
	i32.and 	$push7=, $pop1, $pop8
	tee_local	$push6=, $0=, $pop7
	copy_local	$1=, $pop6
	br_if   	0, $0           # 0: up to label0
# BB#2:                                 # %for.end
	end_loop
	i32.const	$push12=, 0
	i32.store16	g_3($pop12), $2
	block   	
	i32.const	$push3=, 65535
	i32.and 	$push4=, $2, $pop3
	i32.const	$push11=, 65535
	i32.ne  	$push5=, $pop4, $pop11
	br_if   	0, $pop5        # 0: down to label1
# BB#3:                                 # %if.end
	i32.const	$push13=, 0
	return  	$pop13
.LBB0_4:                                # %if.then
	end_block                       # label1:
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
