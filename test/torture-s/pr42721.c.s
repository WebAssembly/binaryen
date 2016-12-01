	.text
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push5=, 0
	i32.const	$push4=, 0
	i32.load	$push3=, b($pop4)
	tee_local	$push2=, $0=, $pop3
	i32.const	$push0=, 1
	i32.xor 	$push1=, $pop2, $pop0
	i32.store	b($pop5), $pop1
	block   	
	br_if   	0, $0           # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push6=, 0
	return  	$pop6
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	b,@object               # @b
	.section	.bss.b,"aw",@nobits
	.p2align	2
b:
	.int32	0                       # 0x0
	.size	b, 4


	.functype	abort, void
