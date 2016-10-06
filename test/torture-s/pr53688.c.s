	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr53688.c"
	.section	.text.init,"ax",@progbits
	.hidden	init
	.globl	init
	.type	init,@function
init:                                   # @init
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i64.const	$push0=, 6147487297207357523
	i64.store	p+9($pop1):p2align=0, $pop0
	i32.const	$push7=, 0
	i32.const	$push6=, 0
	i32.load8_u	$push2=, .L.str+8($pop6)
	i32.store8	p+8($pop7), $pop2
	i32.const	$push5=, 0
	i32.const	$push4=, 0
	i64.load	$push3=, .L.str($pop4):p2align=0
	i64.store	p($pop5):p2align=0, $pop3
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
	.local  	i64
# BB#0:                                 # %entry
	call    	init@FUNCTION
	i32.const	$push19=, 0
	i32.const	$push0=, 32
	i32.store8	headline+9($pop19), $pop0
	i32.const	$push18=, 0
	i32.const	$push17=, 0
	i32.load8_u	$push1=, p+8($pop17)
	i32.store8	headline+8($pop18), $pop1
	i32.const	$push16=, 0
	i32.const	$push15=, 0
	i64.load	$push2=, p($pop15):p2align=0
	i64.store	headline($pop16), $pop2
	i32.const	$push14=, 0
	i32.const	$push13=, 0
	i64.load	$push12=, p+9($pop13):p2align=0
	tee_local	$push11=, $0=, $pop12
	i64.store	headline+10($pop14):p2align=1, $pop11
	i32.const	$push4=, headline+18
	i32.const	$push10=, 32
	i32.const	$push3=, 238
	i32.call	$drop=, memset@FUNCTION, $pop4, $pop10, $pop3
	block   	
	i32.wrap/i64	$push5=, $0
	i32.const	$push6=, 255
	i32.and 	$push7=, $pop5, $pop6
	i32.const	$push8=, 83
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	0, $pop9        # 0: down to label0
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
