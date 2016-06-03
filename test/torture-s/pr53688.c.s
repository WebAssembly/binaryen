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
	i32.const	$push19=, 0
	i32.const	$push0=, 32
	i32.store8	$0=, headline+17($pop19), $pop0
	i32.const	$push18=, 0
	i64.const	$push1=, 2314885530818453536
	i64.store	$drop=, headline+9($pop18):p2align=0, $pop1
	i32.const	$push17=, 0
	i32.const	$push16=, 0
	i32.load8_u	$push2=, p+8($pop16)
	i32.store8	$drop=, headline+8($pop17), $pop2
	i32.const	$push15=, 0
	i32.const	$push14=, 0
	i64.load	$push3=, p($pop14):p2align=0
	i64.store	$drop=, headline($pop15), $pop3
	i32.const	$push13=, 0
	i32.const	$push12=, 0
	i64.load	$push4=, p+9($pop12):p2align=0
	i64.store	$1=, headline+10($pop13):p2align=1, $pop4
	i32.const	$push6=, headline+18
	i32.const	$push5=, 238
	i32.call	$drop=, memset@FUNCTION, $pop6, $0, $pop5
	block
	i32.wrap/i64	$push7=, $1
	i32.const	$push8=, 255
	i32.and 	$push9=, $pop7, $pop8
	i32.const	$push10=, 83
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	0, $pop11       # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push20=, 0
	return  	$pop20
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
	.functype	abort, void
