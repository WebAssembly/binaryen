	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/991112-1.c"
	.globl	rl_show_char
	.type	rl_show_char,@function
rl_show_char:                           # @rl_show_char
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
func_end0:
	.size	rl_show_char, func_end0-rl_show_char

	.globl	rl_character_len
	.type	rl_character_len,@function
rl_character_len:                       # @rl_character_len
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.call	$push0=, isprint, $0
	i32.const	$push2=, 1
	i32.const	$push1=, 2
	i32.select	$push3=, $pop0, $pop2, $pop1
	return  	$pop3
func_end1:
	.size	rl_character_len, func_end1-rl_character_len

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block   	BB2_4
	i32.const	$push0=, 97
	i32.call	$push1=, isprint, $pop0
	i32.const	$push5=, 0
	i32.eq  	$push6=, $pop1, $pop5
	br_if   	$pop6, BB2_4
# BB#1:                                 # %if.end
	block   	BB2_3
	i32.const	$push2=, 2
	i32.call	$push3=, isprint, $pop2
	br_if   	$pop3, BB2_3
# BB#2:                                 # %if.end4
	i32.const	$push4=, 0
	return  	$pop4
BB2_3:                                  # %if.then3
	call    	abort
	unreachable
BB2_4:                                  # %if.then
	call    	abort
	unreachable
func_end2:
	.size	main, func_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
