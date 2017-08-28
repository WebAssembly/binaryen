	.text
	.file	"20030221-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push9=, 0
	i32.const	$push7=, 0
	i32.load	$push6=, __stack_pointer($pop7)
	i32.const	$push8=, 16
	i32.sub 	$push18=, $pop6, $pop8
	tee_local	$push17=, $1=, $pop18
	i32.store	__stack_pointer($pop9), $pop17
	i32.const	$push16=, 0
	i64.load	$push0=, .Lmain.buf+8($pop16)
	i64.store	8($1), $pop0
	i32.const	$push15=, 0
	i64.load	$push1=, .Lmain.buf($pop15)
	i64.store	0($1), $pop1
	i32.call	$push14=, strlen@FUNCTION, $1
	tee_local	$push13=, $0=, $pop14
	i32.store8	0($1), $pop13
	block   	
	i32.const	$push2=, 255
	i32.and 	$push3=, $0, $pop2
	i32.const	$push4=, 10
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push12=, 0
	i32.const	$push10=, 16
	i32.add 	$push11=, $1, $pop10
	i32.store	__stack_pointer($pop12), $pop11
	i32.const	$push19=, 0
	return  	$pop19
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.type	.Lmain.buf,@object      # @main.buf
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4
.Lmain.buf:
	.asciz	"1234567890\000\000\000\000\000"
	.size	.Lmain.buf, 16


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	strlen, i32, i32
	.functype	abort, void
