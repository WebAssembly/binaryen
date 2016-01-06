	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr42512.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load16_u	$4=, g_3($0)
	i32.const	$3=, -1
BB0_1:                                  # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB0_2
	i32.const	$1=, 65535
	i32.and 	$push0=, $4, $1
	i32.or  	$4=, $pop0, $3
	i32.const	$2=, 255
	i32.add 	$push1=, $3, $2
	i32.and 	$3=, $pop1, $2
	br_if   	$3, BB0_1
BB0_2:                                  # %for.end
	i32.store16	$discard=, g_3($0), $4
	block   	BB0_4
	i32.and 	$push2=, $4, $1
	i32.ne  	$push3=, $pop2, $1
	br_if   	$pop3, BB0_4
# BB#3:                                 # %if.end
	return  	$0
BB0_4:                                  # %if.then
	call    	abort
	unreachable
func_end0:
	.size	main, func_end0-main

	.type	g_3,@object             # @g_3
	.bss
	.globl	g_3
	.align	1
g_3:
	.int16	0                       # 0x0
	.size	g_3, 2


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
