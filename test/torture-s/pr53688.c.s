	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr53688.c"
	.section	.text.init,"ax",@progbits
	.hidden	init
	.globl	init
	.type	init,@function
init:                                   # @init
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push7=, 0
	i32.load8_u	$push1=, .L.str+8($pop7)
	i32.store8	$drop=, p+8($pop0), $pop1
	i32.const	$push6=, 0
	i32.const	$push5=, 0
	i64.load	$push2=, .L.str($pop5):p2align=0
	i64.store	$drop=, p($pop6):p2align=0, $pop2
	i32.const	$push4=, 0
	i64.const	$push3=, 6147487297207357523
	i64.store	$drop=, p+9($pop4):p2align=0, $pop3
	return
	.endfunc
.Lfunc_end0:
	.size	init, .Lfunc_end0-init

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64
# BB#0:                                 # %entry
	call    	init@FUNCTION
	i32.const	$push17=, 0
	i64.load	$1=, p($pop17):p2align=0
	i32.const	$push16=, 0
	i32.const	$push15=, 0
	i32.load8_u	$push0=, p+8($pop15)
	i32.store8	$drop=, headline+8($pop16), $pop0
	i32.const	$push14=, 0
	i64.store	$drop=, headline($pop14), $1
	i32.const	$push13=, 0
	i32.const	$push1=, 32
	i32.store8	$0=, headline+17($pop13), $pop1
	i32.const	$push12=, 0
	i64.load	$1=, p+9($pop12):p2align=0
	i32.const	$push11=, 0
	i64.const	$push2=, 2314885530818453536
	i64.store	$drop=, headline+9($pop11):p2align=0, $pop2
	i32.const	$push10=, 0
	i64.store	$drop=, headline+10($pop10):p2align=1, $1
	i32.const	$push4=, headline+18
	i32.const	$push3=, 238
	i32.call	$drop=, memset@FUNCTION, $pop4, $0, $pop3
	block
	i32.wrap/i64	$push5=, $1
	i32.const	$push6=, 255
	i32.and 	$push7=, $pop5, $pop6
	i32.const	$push8=, 83
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	0, $pop9        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push18=, 0
	return  	$pop18
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	p                       # @p
	.type	p,@object
	.section	.bss.p,"aw",@nobits
	.globl	p
p:
	.skip	17
	.size	p, 17

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"FOOBARFOO"
	.size	.L.str, 10

	.hidden	headline                # @headline
	.type	headline,@object
	.section	.bss.headline,"aw",@nobits
	.globl	headline
	.p2align	4
headline:
	.skip	256
	.size	headline, 256


	.ident	"clang version 3.9.0 "
