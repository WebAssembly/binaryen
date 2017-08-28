	.text
	.file	"960117-1.c"
	.section	.text.get_id,"ax",@progbits
	.hidden	get_id                  # -- Begin function get_id
	.globl	get_id
	.type	get_id,@function
get_id:                                 # @get_id
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, curval+2($pop0):p2align=1
	i32.store8	0($pop1), $0
	i32.const	$push2=, 0
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end0:
	.size	get_id, .Lfunc_end0-get_id
                                        # -- End function
	.section	.text.get_tok,"ax",@progbits
	.hidden	get_tok                 # -- Begin function get_tok
	.globl	get_tok
	.type	get_tok,@function
get_tok:                                # @get_tok
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, id_space
	i32.store	curval+2($pop1):p2align=1, $pop0
	i32.const	$push6=, 0
	i32.const	$push2=, 99
	i32.store8	id_space($pop6), $pop2
	i32.const	$push5=, 0
	i32.const	$push4=, 0
	i32.store16	curval($pop5), $pop4
	i32.const	$push3=, 0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end1:
	.size	get_tok, .Lfunc_end1-get_tok
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, id_space
	i32.store	curval+2($pop1):p2align=1, $pop0
	i32.const	$push6=, 0
	i32.const	$push2=, 99
	i32.store8	id_space($pop6), $pop2
	i32.const	$push5=, 0
	i32.const	$push4=, 0
	i32.store16	curval($pop5), $pop4
	i32.const	$push3=, 0
	call    	exit@FUNCTION, $pop3
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.hidden	curval                  # @curval
	.type	curval,@object
	.section	.bss.curval,"aw",@nobits
	.globl	curval
	.p2align	1
curval:
	.skip	6
	.size	curval, 6

	.type	id_space,@object        # @id_space
	.section	.bss.id_space,"aw",@nobits
	.p2align	4
id_space:
	.skip	66
	.size	id_space, 66


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	exit, void, i32
