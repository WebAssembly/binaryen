	.text
	.file	"pr28289.c"
	.section	.text.ix86_split_ashr,"ax",@progbits
	.hidden	ix86_split_ashr         # -- Begin function ix86_split_ashr
	.globl	ix86_split_ashr
	.type	ix86_split_ashr,@function
ix86_split_ashr:                        # @ix86_split_ashr
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push3=, 0
	i32.const	$push1=, ok@FUNCTION
	i32.const	$push0=, gen_x86_64_shrd@FUNCTION
	i32.select	$push2=, $pop1, $pop0, $0
	i32.call_indirect	$drop=, $pop3, $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	ix86_split_ashr, .Lfunc_end0-ix86_split_ashr
                                        # -- End function
	.section	.text.ok,"ax",@progbits
	.hidden	ok                      # -- Begin function ok
	.globl	ok
	.type	ok,@function
ok:                                     # @ok
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	call    	exit@FUNCTION, $0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	ok, .Lfunc_end1-ok
                                        # -- End function
	.section	.text.gen_x86_64_shrd,"ax",@progbits
	.type	gen_x86_64_shrd,@function # -- Begin function gen_x86_64_shrd
gen_x86_64_shrd:                        # @gen_x86_64_shrd
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	gen_x86_64_shrd, .Lfunc_end2-gen_x86_64_shrd
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push3=, ok@FUNCTION
	i32.const	$push2=, gen_x86_64_shrd@FUNCTION
	i32.const	$push6=, 0
	i32.load	$push1=, one($pop6)
	i32.select	$push4=, $pop3, $pop2, $pop1
	i32.call_indirect	$drop=, $pop0, $pop4
	i32.const	$push5=, 1
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main
                                        # -- End function
	.hidden	one                     # @one
	.type	one,@object
	.section	.data.one,"aw",@progbits
	.globl	one
	.p2align	2
one:
	.int32	1                       # 0x1
	.size	one, 4


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	exit, void, i32
