	.text
	.file	"va-arg-21.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push5=, 0
	i32.const	$push3=, 0
	i32.load	$push2=, __stack_pointer($pop3)
	i32.const	$push4=, 16
	i32.sub 	$push7=, $pop2, $pop4
	tee_local	$push6=, $0=, $pop7
	i32.store	__stack_pointer($pop5), $pop6
	i32.const	$push0=, .L.str.1
	i32.store	0($0), $pop0
	call    	doit@FUNCTION, $0, $0
	i32.const	$push1=, 0
	call    	exit@FUNCTION, $pop1
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.section	.text.doit,"ax",@progbits
	.type	doit,@function          # -- Begin function doit
doit:                                   # @doit
	.param  	i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 4
	i32.call	$2=, malloc@FUNCTION, $pop0
	i32.const	$push3=, 4
	i32.call	$3=, malloc@FUNCTION, $pop3
	i32.store	0($2), $1
	i32.const	$push1=, .L.str
	i32.call	$drop=, vprintf@FUNCTION, $pop1, $1
	i32.store	0($3), $1
	i32.const	$push2=, .L.str
	i32.call	$drop=, vprintf@FUNCTION, $pop2, $1
	block   	
	i32.eqz 	$push4=, $3
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	doit, .Lfunc_end1-doit
                                        # -- End function
	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"%s"
	.size	.L.str, 3

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"hello world\n"
	.size	.L.str.1, 13


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	exit, void, i32
	.functype	malloc, i32, i32
	.functype	vprintf, i32, i32, i32
	.functype	abort, void
