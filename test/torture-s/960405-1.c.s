	.text
	.file	"960405-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
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
                                        # -- End function
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


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
