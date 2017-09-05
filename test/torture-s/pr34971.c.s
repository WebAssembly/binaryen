	.text
	.file	"pr34971.c"
	.section	.text.test1,"ax",@progbits
	.hidden	test1                   # -- Begin function test1
	.globl	test1
	.type	test1,@function
test1:                                  # @test1
	.param  	i64
	.local  	i64
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, 0
	i64.load	$push1=, x($pop0)
	i64.const	$push2=, 1099511627775
	i64.and 	$push10=, $pop1, $pop2
	tee_local	$push9=, $1=, $pop10
	i64.const	$push5=, 8
	i64.shl 	$push6=, $pop9, $pop5
	i64.const	$push3=, 32
	i64.shr_u	$push4=, $1, $pop3
	i64.or  	$push7=, $pop6, $pop4
	i64.ne  	$push8=, $pop7, $0
	br_if   	0, $pop8        # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	test1, .Lfunc_end0-test1
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.then.i
	i32.const	$push0=, 0
	i32.const	$push6=, 0
	i64.load	$push1=, x($pop6)
	i64.const	$push2=, -1099511627776
	i64.and 	$push3=, $pop1, $pop2
	i64.const	$push4=, 4294967297
	i64.or  	$push5=, $pop3, $pop4
	i64.store	x($pop0), $pop5
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	x                       # @x
	.type	x,@object
	.section	.bss.x,"aw",@nobits
	.globl	x
	.p2align	3
x:
	.skip	8
	.size	x, 8


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
