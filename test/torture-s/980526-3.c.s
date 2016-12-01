	.text
	.section	.text.compare,"ax",@progbits
	.hidden	compare
	.globl	compare
	.type	compare,@function
compare:                                # @compare
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.ne  	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	compare, .Lfunc_end0-compare

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.else
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.functype	exit, void, i32
