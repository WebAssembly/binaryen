	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/bf-sign-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64
# BB#0:                                 # %entry
	block   	
	block   	
	i32.const	$push37=, 0
	i32.load8_u	$push0=, x($pop37)
	i32.const	$push1=, 7
	i32.and 	$push2=, $pop0, $pop1
	i32.const	$push36=, -2
	i32.add 	$push3=, $pop2, $pop36
	i32.const	$push35=, 0
	i32.ge_s	$push4=, $pop3, $pop35
	br_if   	0, $pop4        # 0: down to label1
# BB#1:                                 # %if.end
	i32.const	$push41=, 0
	i32.load	$push5=, x+4($pop41)
	i32.const	$push6=, 1
	i32.shl 	$push7=, $pop5, $pop6
	i32.const	$push40=, 1
	i32.shr_s	$push8=, $pop7, $pop40
	i32.const	$push39=, -2
	i32.add 	$push9=, $pop8, $pop39
	i32.const	$push38=, 0
	i32.ge_s	$push10=, $pop9, $pop38
	br_if   	0, $pop10       # 0: down to label1
# BB#2:                                 # %if.end5
	i32.const	$push46=, 0
	i64.load	$push45=, x+8($pop46)
	tee_local	$push44=, $0=, $pop45
	i32.wrap/i64	$push11=, $pop44
	i32.const	$push43=, -2
	i32.add 	$push12=, $pop11, $pop43
	i32.const	$push42=, 0
	i32.ge_s	$push13=, $pop12, $pop42
	br_if   	0, $pop13       # 0: down to label1
# BB#3:                                 # %if.end13
	i32.const	$push49=, 0
	i64.load	$push14=, x+24($pop49)
	i64.const	$push15=, 35
	i64.shr_u	$push16=, $pop14, $pop15
	i32.wrap/i64	$push17=, $pop16
	i32.const	$push18=, 32767
	i32.and 	$push19=, $pop17, $pop18
	i32.const	$push48=, -2
	i32.add 	$push20=, $pop19, $pop48
	i32.const	$push47=, 0
	i32.ge_s	$push21=, $pop20, $pop47
	br_if   	0, $pop21       # 0: down to label1
# BB#4:                                 # %if.end20
	i64.const	$push22=, 32
	i64.shr_u	$push23=, $0, $pop22
	i32.wrap/i64	$push24=, $pop23
	i32.const	$push25=, 2147483647
	i32.and 	$push26=, $pop24, $pop25
	i32.const	$push51=, -2
	i32.add 	$push27=, $pop26, $pop51
	i32.const	$push50=, 0
	i32.ge_s	$push28=, $pop27, $pop50
	br_if   	0, $pop28       # 0: down to label1
# BB#5:                                 # %if.end35
	i32.const	$push54=, 0
	i32.load	$push29=, x+20($pop54)
	i32.const	$push30=, 7
	i32.and 	$push31=, $pop29, $pop30
	i32.const	$push53=, -2
	i32.add 	$push32=, $pop31, $pop53
	i32.const	$push52=, 0
	i32.lt_s	$push33=, $pop32, $pop52
	br_if   	1, $pop33       # 1: down to label0
.LBB0_6:                                # %if.then42
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_7:                                # %if.end50
	end_block                       # label0:
	i32.const	$push34=, 0
	call    	exit@FUNCTION, $pop34
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	x                       # @x
	.type	x,@object
	.section	.bss.x,"aw",@nobits
	.globl	x
	.p2align	3
x:
	.skip	32
	.size	x, 32


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
