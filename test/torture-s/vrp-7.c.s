	.text
	.file	"vrp-7.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push4=, 0
	i32.const	$push9=, 0
	i32.load8_u	$push5=, t($pop9)
	i32.const	$push6=, 254
	i32.and 	$push7=, $pop5, $pop6
	i32.const	$push0=, 4
	i32.shr_u	$push1=, $0, $pop0
	i32.const	$push2=, 1
	i32.and 	$push3=, $pop1, $pop2
	i32.or  	$push8=, $pop7, $pop3
	i32.store8	t($pop4), $pop8
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 16
	call    	foo@FUNCTION, $pop0
	block   	
	i32.const	$push4=, 0
	i32.load8_u	$push1=, t($pop4)
	i32.const	$push2=, 1
	i32.and 	$push3=, $pop1, $pop2
	i32.eqz 	$push6=, $pop3
	br_if   	0, $pop6        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push5=, 0
	return  	$pop5
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	t                       # @t
	.type	t,@object
	.section	.bss.t,"aw",@nobits
	.globl	t
	.p2align	2
t:
	.skip	4
	.size	t, 4


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
