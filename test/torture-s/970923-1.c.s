	.text
	.section	.text.ts,"ax",@progbits
	.hidden	ts
	.globl	ts
	.type	ts,@function
ts:                                     # @ts
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	ts, .Lfunc_end0-ts

	.section	.text.tu,"ax",@progbits
	.hidden	tu
	.globl	tu
	.type	tu,@function
tu:                                     # @tu
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	tu, .Lfunc_end1-tu

	.section	.text.main,"ax",@progbits
	.hidden	main
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


	.functype	exit, void, i32
