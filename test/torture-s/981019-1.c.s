	.text
	.file	"981019-1.c"
	.section	.text.ff,"ax",@progbits
	.hidden	ff                      # -- Begin function ff
	.globl	ff
	.type	ff,@function
ff:                                     # @ff
	.param  	i32, i32, i32
	.local  	i32
# BB#0:                                 # %entry
	block   	
	block   	
	block   	
	i32.eqz 	$push9=, $0
	br_if   	0, $pop9        # 0: down to label2
# BB#1:                                 # %entry
	br_if   	1, $2           # 1: down to label1
.LBB0_2:                                # %if.end3
	end_block                       # label2:
	i32.const	$push0=, 0
	i32.const	$push8=, 0
	i32.load	$push7=, f3.x($pop8)
	tee_local	$push6=, $0=, $pop7
	i32.eqz 	$push5=, $pop6
	tee_local	$push4=, $3=, $pop5
	i32.store	f3.x($pop0), $pop4
	block   	
	i32.eqz 	$push10=, $0
	br_if   	0, $pop10       # 0: down to label3
# BB#3:                                 # %while.end
	br_if   	1, $2           # 1: down to label1
# BB#4:                                 # %if.end16
	return
.LBB0_5:                                # %while.body.lr.ph
	end_block                       # label3:
	br_if   	1, $2           # 1: down to label0
# BB#6:                                 # %while.end.thread
	i32.const	$push3=, 0
	i32.const	$push1=, 1
	i32.xor 	$push2=, $3, $pop1
	i32.store	f3.x($pop3), $pop2
	return
.LBB0_7:                                # %if.then2
	end_block                       # label1:
	call    	f1@FUNCTION
	unreachable
.LBB0_8:                                # %land.lhs.true.split
	end_block                       # label0:
	i32.call	$drop=, f2@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	ff, .Lfunc_end0-ff
                                        # -- End function
	.section	.text.f1,"ax",@progbits
	.hidden	f1                      # -- Begin function f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
# BB#0:                                 # %entry
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	f1, .Lfunc_end1-f1
                                        # -- End function
	.section	.text.f3,"ax",@progbits
	.hidden	f3                      # -- Begin function f3
	.globl	f3
	.type	f3,@function
f3:                                     # @f3
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, f3.x($pop4)
	i32.eqz 	$push3=, $pop1
	tee_local	$push2=, $0=, $pop3
	i32.store	f3.x($pop0), $pop2
	copy_local	$push5=, $0
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end2:
	.size	f3, .Lfunc_end2-f3
                                        # -- End function
	.section	.text.f2,"ax",@progbits
	.hidden	f2                      # -- Begin function f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.result 	i32
# BB#0:                                 # %entry
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	f2, .Lfunc_end3-f2
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push2=, 0
	i32.store	f3.x($pop0), $pop2
	i32.const	$push1=, 0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end4:
	.size	main, .Lfunc_end4-main
                                        # -- End function
	.type	f3.x,@object            # @f3.x
	.section	.bss.f3.x,"aw",@nobits
	.p2align	2
f3.x:
	.int32	0                       # 0x0
	.size	f3.x, 4


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
