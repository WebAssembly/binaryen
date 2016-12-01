	.text
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.llabs,"ax",@progbits
	.hidden	llabs
	.globl	llabs
	.type	llabs,@function
llabs:                                  # @llabs
	.param  	i64
	.result 	i64
# BB#0:                                 # %entry
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	llabs, .Lfunc_end1-llabs

	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.p2align	3
a:
	.int64	-1                      # 0xffffffffffffffff
	.size	a, 8


	.functype	abort, void
