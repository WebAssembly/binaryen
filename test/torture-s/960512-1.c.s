	.text
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
# BB#0:                                 # %entry
	i64.const	$push0=, 0
	i64.store	0($0), $pop0
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i64.const	$push3=, 0
	i64.store	0($pop2), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.functype	exit, void, i32
