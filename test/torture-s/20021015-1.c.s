	.text
	.file	"20021015-1.c"
	.section	.text.g,"ax",@progbits
	.hidden	g                       # -- Begin function g
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block   	
	i32.load	$push0=, 0($4)
	i32.const	$push1=, g_list
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push3=, 0
	i32.const	$push4=, 0
	i32.store8	g_list($pop3), $pop4
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	g, .Lfunc_end0-g
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push1=, 0
	i32.load8_u	$push0=, g_list($pop1)
	i32.eqz 	$push5=, $pop0
	br_if   	0, $pop5        # 0: down to label1
# BB#1:                                 # %g.exit
	i32.const	$push3=, 0
	i32.const	$push2=, 0
	i32.store8	g_list($pop3), $pop2
.LBB1_2:                                # %for.end
	end_block                       # label1:
	i32.const	$push4=, 0
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	g_list                  # @g_list
	.type	g_list,@object
	.section	.data.g_list,"aw",@progbits
	.globl	g_list
g_list:
	.int8	49
	.size	g_list, 1


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
