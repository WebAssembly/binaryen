	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20011024-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push6=, 0
	i32.const	$push0=, 6513249
	i32.store	buf($pop6), $pop0
	block   	
	i32.const	$push2=, buf
	i32.const	$push1=, .L.str
	i32.call	$push3=, strcmp@FUNCTION, $pop2, $pop1
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %foo.exit
	i32.const	$push11=, 0
	i32.const	$push10=, 0
	i32.load8_u	$push4=, .L.str.1+8($pop10)
	i32.store8	buf+8($pop11), $pop4
	i32.const	$push9=, 0
	i32.const	$push8=, 0
	i64.load	$push5=, .L.str.1($pop8):p2align=0
	i64.store	buf($pop9), $pop5
	i32.const	$push7=, 0
	return  	$pop7
.LBB0_2:                                # %if.then1.i
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	buf                     # @buf
	.type	buf,@object
	.section	.bss.buf,"aw",@nobits
	.globl	buf
	.p2align	4
buf:
	.skip	50
	.size	buf, 50

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"abc"
	.size	.L.str, 4

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"abcdefgh"
	.size	.L.str.1, 9


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	strcmp, i32, i32, i32
