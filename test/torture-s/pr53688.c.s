	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr53688.c"
	.section	.text.init,"ax",@progbits
	.hidden	init
	.globl	init
	.type	init,@function
init:                                   # @init
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i64.const	$push0=, 6147487297207357523
	i64.store	$drop=, p+9($pop1):p2align=0, $pop0
	i32.const	$push7=, 0
	i32.const	$push6=, 0
	i32.load8_u	$push2=, .L.str+8($pop6)
	i32.store8	$drop=, p+8($pop7), $pop2
	i32.const	$push5=, 0
	i32.const	$push4=, 0
	i64.load	$push3=, .L.str($pop4):p2align=0
	i64.store	$drop=, p($pop5):p2align=0, $pop3
                                        # fallthrough-return
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
	i32.const	$push0=, 32
	i32.store8	$0=, headline+9($pop17), $pop0
	i32.const	$push16=, 0
	i32.const	$push15=, 0
	i32.load8_u	$push1=, p+8($pop15)
	i32.store8	$drop=, headline+8($pop16), $pop1
	i32.const	$push14=, 0
	i32.const	$push13=, 0
	i64.load	$push2=, p($pop13):p2align=0
	i64.store	$drop=, headline($pop14), $pop2
	i32.const	$push12=, 0
	i32.const	$push11=, 0
	i64.load	$push3=, p+9($pop11):p2align=0
	i64.store	$1=, headline+10($pop12):p2align=1, $pop3
	i32.const	$push5=, headline+18
	i32.const	$push4=, 238
	i32.call	$drop=, memset@FUNCTION, $pop5, $0, $pop4
	block
	i32.wrap/i64	$push6=, $1
	i32.const	$push7=, 255
	i32.and 	$push8=, $pop6, $pop7
	i32.const	$push9=, 83
	i32.ne  	$push10=, $pop8, $pop9
	br_if   	0, $pop10       # 0: down to label0
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


	.ident	"clang version 4.0.0 "
	.functype	abort, void
