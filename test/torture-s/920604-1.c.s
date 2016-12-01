	.text
	.section	.text.mod,"ax",@progbits
	.hidden	mod
	.globl	mod
	.type	mod,@function
mod:                                    # @mod
	.param  	i64, i64
	.result 	i64
# BB#0:                                 # %entry
	i64.rem_s	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	mod, .Lfunc_end0-mod

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
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.functype	exit, void, i32
