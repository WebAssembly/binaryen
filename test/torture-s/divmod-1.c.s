	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/divmod-1.c"
	.section	.text.div1,"ax",@progbits
	.hidden	div1
	.globl	div1
	.type	div1,@function
div1:                                   # @div1
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.sub 	$push1=, $pop0, $0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end0:
	.size	div1, .Lfunc_end0-div1

	.section	.text.div2,"ax",@progbits
	.hidden	div2
	.globl	div2
	.type	div2,@function
div2:                                   # @div2
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.sub 	$push1=, $pop0, $0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end1:
	.size	div2, .Lfunc_end1-div2

	.section	.text.div3,"ax",@progbits
	.hidden	div3
	.globl	div3
	.type	div3,@function
div3:                                   # @div3
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.div_s	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	div3, .Lfunc_end2-div3

	.section	.text.div4,"ax",@progbits
	.hidden	div4
	.globl	div4
	.type	div4,@function
div4:                                   # @div4
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.div_s	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end3:
	.size	div4, .Lfunc_end3-div4

	.section	.text.mod1,"ax",@progbits
	.hidden	mod1
	.globl	mod1
	.type	mod1,@function
mod1:                                   # @mod1
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end4:
	.size	mod1, .Lfunc_end4-mod1

	.section	.text.mod2,"ax",@progbits
	.hidden	mod2
	.globl	mod2
	.type	mod2,@function
mod2:                                   # @mod2
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end5:
	.size	mod2, .Lfunc_end5-mod2

	.section	.text.mod3,"ax",@progbits
	.hidden	mod3
	.globl	mod3
	.type	mod3,@function
mod3:                                   # @mod3
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.rem_s	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end6:
	.size	mod3, .Lfunc_end6-mod3

	.section	.text.mod4,"ax",@progbits
	.hidden	mod4
	.globl	mod4
	.type	mod4,@function
mod4:                                   # @mod4
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.rem_s	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end7:
	.size	mod4, .Lfunc_end7-mod4

	.section	.text.mod5,"ax",@progbits
	.hidden	mod5
	.globl	mod5
	.type	mod5,@function
mod5:                                   # @mod5
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.rem_s	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end8:
	.size	mod5, .Lfunc_end8-mod5

	.section	.text.mod6,"ax",@progbits
	.hidden	mod6
	.globl	mod6
	.type	mod6,@function
mod6:                                   # @mod6
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.rem_u	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end9:
	.size	mod6, .Lfunc_end9-mod6

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end36
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end10:
	.size	main, .Lfunc_end10-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
