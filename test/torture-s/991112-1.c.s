	.text
	.file	"991112-1.c"
	.section	.text.rl_show_char,"ax",@progbits
	.hidden	rl_show_char            # -- Begin function rl_show_char
	.globl	rl_show_char
	.type	rl_show_char,@function
rl_show_char:                           # @rl_show_char
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	rl_show_char, .Lfunc_end0-rl_show_char
                                        # -- End function
	.section	.text.rl_character_len,"ax",@progbits
	.hidden	rl_character_len        # -- Begin function rl_character_len
	.globl	rl_character_len
	.type	rl_character_len,@function
rl_character_len:                       # @rl_character_len
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 1
	i32.const	$push1=, 2
	i32.call	$push0=, isprint@FUNCTION, $0
	i32.select	$push3=, $pop2, $pop1, $pop0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end1:
	.size	rl_character_len, .Lfunc_end1-rl_character_len
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, 97
	i32.call	$push1=, isprint@FUNCTION, $pop0
	i32.eqz 	$push5=, $pop1
	br_if   	0, $pop5        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push2=, 2
	i32.call	$push3=, isprint@FUNCTION, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#2:                                 # %if.end4
	i32.const	$push4=, 0
	return  	$pop4
.LBB2_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	isprint, i32, i32
	.functype	abort, void
