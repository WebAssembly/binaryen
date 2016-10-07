	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000703-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
# BB#0:                                 # %entry
	i32.store	20($0), $1
	i32.store	24($0), $2
	i32.const	$push0=, 19
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 0
	i32.load8_u	$push3=, .L.str+2($pop2)
	i32.store8	0($pop1), $pop3
	i32.const	$push5=, 0
	i32.load16_u	$push4=, .L.str($pop5):p2align=0
	i32.store16	17($0):p2align=0, $pop4
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 16
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 0
	i32.load8_u	$push3=, .L.str.1+16($pop2)
	i32.store8	0($pop1), $pop3
	i32.const	$push4=, 8
	i32.add 	$push5=, $0, $pop4
	i32.const	$push15=, 0
	i64.load	$push6=, .L.str.1+8($pop15):p2align=0
	i64.store	0($pop5):p2align=0, $pop6
	i32.const	$push14=, 0
	i64.load	$push7=, .L.str.1($pop14):p2align=0
	i64.store	0($0):p2align=0, $pop7
	i32.const	$push8=, 19
	i32.add 	$push9=, $0, $pop8
	i32.const	$push13=, 0
	i32.load8_u	$push10=, .L.str+2($pop13)
	i32.store8	0($pop9), $pop10
	i32.const	$push12=, 0
	i32.load16_u	$push11=, .L.str($pop12):p2align=0
	i32.store16	17($0):p2align=0, $pop11
	i32.store	20($0), $1
	i32.store	24($0), $2
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end8
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"abc"
	.size	.L.str, 4

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"01234567890123456"
	.size	.L.str.1, 18


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
