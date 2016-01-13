	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr60017.c"
	.section	.text.func,"ax",@progbits
	.hidden	func
	.globl	func
	.type	func,@function
func:                                   # @func
	.param  	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.load	$2=, x+8($1)
	i32.const	$push0=, 12
	i32.add 	$push1=, $0, $pop0
	i32.load	$push2=, x+12($1)
	i32.store	$discard=, 0($pop1), $pop2
	i32.const	$push3=, 8
	i32.add 	$push4=, $0, $pop3
	i32.store	$discard=, 0($pop4), $2
	i32.load	$2=, x($1)
	i32.const	$push5=, 4
	i32.add 	$push6=, $0, $pop5
	i32.load	$push7=, x+4($1)
	i32.store	$discard=, 0($pop6), $pop7
	i32.store	$discard=, 0($0), $2
	return
.Lfunc_end0:
	.size	func, .Lfunc_end0-func

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block
	i32.load16_u	$push0=, x+12($0)
	i32.const	$push1=, 9
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	$pop2, 0        # 0: down to label0
# BB#1:                                 # %if.end
	return  	$0
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	x                       # @x
	.type	x,@object
	.section	.data.x,"aw",@progbits
	.globl	x
	.align	2
x:
	.int8	1                       # 0x1
	.ascii	"\002\003"
	.ascii	"\004\005"
	.skip	1
	.int16	6                       # 0x6
	.int16	7                       # 0x7
	.int16	8                       # 0x8
	.int16	9                       # 0x9
	.skip	2
	.size	x, 16


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
