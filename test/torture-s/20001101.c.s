	.text
	.file	"20001101.c"
	.section	.text.dummy,"ax",@progbits
	.hidden	dummy                   # -- Begin function dummy
	.globl	dummy
	.type	dummy,@function
dummy:                                  # @dummy
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 7
	i32.store	0($1), $pop0
	i32.const	$push1=, 1
	i32.store	0($0), $pop1
	i32.const	$push2=, 1
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end0:
	.size	dummy, .Lfunc_end0-dummy
                                        # -- End function
	.section	.text.bogus,"ax",@progbits
	.hidden	bogus                   # -- Begin function bogus
	.globl	bogus
	.type	bogus,@function
bogus:                                  # @bogus
	.param  	i32, i32, i32
# BB#0:                                 # %if.end5
	i32.load8_u	$push0=, 0($0)
	i32.const	$push1=, 1
	i32.or  	$push2=, $pop0, $pop1
	i32.store8	0($0), $pop2
	block   	
	i32.const	$push3=, 7
	i32.ne  	$push4=, $1, $pop3
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %if.end8
	return
.LBB1_2:                                # %if.then7
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	bogus, .Lfunc_end1-bogus
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
