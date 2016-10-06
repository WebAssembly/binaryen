	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/960405-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push8=, 0
	i64.load	$push3=, x($pop8)
	i32.const	$push7=, 0
	i64.load	$push2=, x+8($pop7)
	i32.const	$push6=, 0
	i64.load	$push1=, y($pop6)
	i32.const	$push5=, 0
	i64.load	$push0=, y+8($pop5)
	i32.call	$push4=, __eqtf2@FUNCTION, $pop3, $pop2, $pop1, $pop0
	i32.eqz 	$push10=, $pop4
	br_if   	0, $pop10       # 0: down to label0
# BB#1:                                 # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB0_2:                                # %if.end
	end_block                       # label0:
	i32.const	$push9=, 0
	call    	exit@FUNCTION, $pop9
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	x                       # @x
	.type	x,@object
	.section	.data.x,"aw",@progbits
	.globl	x
	.p2align	4
x:
	.int64	0                       # fp128 +Inf
	.int64	9223090561878065152
	.size	x, 16

	.hidden	y                       # @y
	.type	y,@object
	.section	.data.y,"aw",@progbits
	.globl	y
	.p2align	4
y:
	.int64	0                       # fp128 +Inf
	.int64	9223090561878065152
	.size	y, 16


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
