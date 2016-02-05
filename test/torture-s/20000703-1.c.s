	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000703-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 19
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 0
	i32.load8_u	$push3=, .L.str+2($pop2)
	i32.store8	$discard=, 0($pop1), $pop3
	i32.const	$push5=, 0
	i32.load16_u	$push4=, .L.str($pop5):p2align=0
	i32.store16	$discard=, 17($0):p2align=0, $pop4
	i32.store	$discard=, 20($0), $1
	i32.store	$discard=, 24($0), $2
	return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push10=, 16
	i32.add 	$push11=, $0, $pop10
	i32.const	$push6=, 25
	i32.add 	$push7=, $0, $pop6
	i32.const	$push2=, 27
	i32.add 	$push3=, $0, $pop2
	i32.const	$push4=, 0
	i32.store8	$push5=, 0($pop3), $pop4
	i32.store16	$push8=, 0($pop7):p2align=0, $pop5
	tee_local	$push22=, $4=, $pop8
	i32.load8_u	$push12=, .L.str.1+16($pop22)
	i32.store8	$discard=, 0($pop11), $pop12
	i32.const	$push0=, 17
	i32.add 	$push1=, $0, $pop0
	tee_local	$push21=, $3=, $pop1
	i64.const	$push9=, 0
	i64.store	$discard=, 0($pop21):p2align=0, $pop9
	i32.const	$push17=, 19
	i32.add 	$push18=, $0, $pop17
	i32.load8_u	$push19=, .L.str+2($4)
	i32.store8	$discard=, 0($pop18), $pop19
	i32.load16_u	$push20=, .L.str($4):p2align=0
	i32.store16	$discard=, 0($3):p2align=0, $pop20
	i32.const	$push13=, 8
	i32.add 	$push14=, $0, $pop13
	i64.load	$push15=, .L.str.1+8($4):p2align=0
	i64.store	$discard=, 0($pop14):p2align=0, $pop15
	i32.store	$discard=, 20($0), $1
	i32.store	$discard=, 24($0), $2
	i64.load	$push16=, .L.str.1($4):p2align=0
	i64.store	$discard=, 0($0):p2align=0, $pop16
	return
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


	.ident	"clang version 3.9.0 "
