	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/divmod-1.c"
	.globl	div1
	.type	div1,@function
div1:                                   # @div1
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.sub 	$push1=, $pop0, $0
	return  	$pop1
func_end0:
	.size	div1, func_end0-div1

	.globl	div2
	.type	div2,@function
div2:                                   # @div2
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.sub 	$push1=, $pop0, $0
	return  	$pop1
func_end1:
	.size	div2, func_end1-div2

	.globl	div3
	.type	div3,@function
div3:                                   # @div3
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.div_s	$push0=, $0, $1
	return  	$pop0
func_end2:
	.size	div3, func_end2-div3

	.globl	div4
	.type	div4,@function
div4:                                   # @div4
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.div_s	$push0=, $0, $1
	return  	$pop0
func_end3:
	.size	div4, func_end3-div4

	.globl	mod1
	.type	mod1,@function
mod1:                                   # @mod1
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
func_end4:
	.size	mod1, func_end4-mod1

	.globl	mod2
	.type	mod2,@function
mod2:                                   # @mod2
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
func_end5:
	.size	mod2, func_end5-mod2

	.globl	mod3
	.type	mod3,@function
mod3:                                   # @mod3
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.rem_s	$push0=, $0, $1
	return  	$pop0
func_end6:
	.size	mod3, func_end6-mod3

	.globl	mod4
	.type	mod4,@function
mod4:                                   # @mod4
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.rem_s	$push0=, $0, $1
	return  	$pop0
func_end7:
	.size	mod4, func_end7-mod4

	.globl	mod5
	.type	mod5,@function
mod5:                                   # @mod5
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.rem_s	$push0=, $0, $1
	return  	$pop0
func_end8:
	.size	mod5, func_end8-mod5

	.globl	mod6
	.type	mod6,@function
mod6:                                   # @mod6
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.rem_u	$push0=, $0, $1
	return  	$pop0
func_end9:
	.size	mod6, func_end9-mod6

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end36
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
func_end10:
	.size	main, func_end10-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
