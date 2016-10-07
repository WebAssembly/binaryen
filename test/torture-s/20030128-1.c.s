	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030128-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push9=, 0
	i32.load16_s	$0=, y($pop9)
	i32.const	$push8=, 0
	i32.const	$push7=, 0
	i32.load8_u	$push0=, x($pop7)
	i32.div_s	$push6=, $pop0, $0
	tee_local	$push5=, $0=, $pop6
	i32.store8	x($pop8), $pop5
	block   	
	i32.const	$push1=, 255
	i32.and 	$push2=, $0, $pop1
	i32.const	$push3=, 246
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push10=, 0
	call    	exit@FUNCTION, $pop10
	unreachable
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	x                       # @x
	.type	x,@object
	.section	.data.x,"aw",@progbits
	.globl	x
x:
	.int8	50                      # 0x32
	.size	x, 1

	.hidden	y                       # @y
	.type	y,@object
	.section	.data.y,"aw",@progbits
	.globl	y
	.p2align	1
y:
	.int16	65531                   # 0xfffb
	.size	y, 2


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
