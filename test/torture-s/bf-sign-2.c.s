	.text
	.file	"bf-sign-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64
# BB#0:                                 # %entry
	block   	
	i32.const	$push21=, 0
	i32.load8_u	$push0=, x($pop21)
	i32.const	$push1=, 6
	i32.and 	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push22=, 0
	i32.load	$push3=, x+4($pop22)
	i32.const	$push4=, 1
	i32.shl 	$push5=, $pop3, $pop4
	i32.const	$push6=, 3
	i32.ge_s	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#2:                                 # %if.end5
	i32.const	$push25=, 0
	i64.load	$push24=, x+8($pop25)
	tee_local	$push23=, $0=, $pop24
	i32.wrap/i64	$push8=, $pop23
	i32.const	$push9=, 2
	i32.ge_s	$push10=, $pop8, $pop9
	br_if   	0, $pop10       # 0: down to label0
# BB#3:                                 # %if.end13
	i32.const	$push26=, 0
	i32.load	$push11=, x+28($pop26)
	i32.const	$push12=, 262128
	i32.and 	$push13=, $pop11, $pop12
	br_if   	0, $pop13       # 0: down to label0
# BB#4:                                 # %if.end20
	i64.const	$push14=, 9223372028264841216
	i64.and 	$push15=, $0, $pop14
	i64.const	$push16=, 4294967297
	i64.ge_u	$push17=, $pop15, $pop16
	br_if   	0, $pop17       # 0: down to label0
# BB#5:                                 # %if.end35
	i32.const	$push27=, 0
	i32.load8_u	$push18=, x+20($pop27)
	i32.const	$push19=, 6
	i32.and 	$push20=, $pop18, $pop19
	br_if   	0, $pop20       # 0: down to label0
# BB#6:                                 # %if.end50
	i32.const	$push28=, 0
	call    	exit@FUNCTION, $pop28
	unreachable
.LBB0_7:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	x                       # @x
	.type	x,@object
	.section	.bss.x,"aw",@nobits
	.globl	x
	.p2align	3
x:
	.skip	32
	.size	x, 32


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
