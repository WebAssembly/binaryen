	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-2d.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push8=, 0
	i32.eq  	$push9=, $0, $pop8
	br_if   	$pop9, 0        # 0: down to label0
# BB#1:                                 # %for.body.preheader
	i32.const	$3=, a
	i32.const	$1=, -3
	i32.const	$push0=, 3
	i32.mul 	$push1=, $0, $pop0
	i32.add 	$push5=, $pop1, $3
	i32.add 	$4=, $pop5, $1
	i32.const	$2=, -4
	i32.const	$push2=, 2
	i32.shl 	$push3=, $0, $pop2
	i32.add 	$push4=, $pop3, $3
	i32.add 	$3=, $pop4, $2
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push6=, -1
	i32.add 	$0=, $0, $pop6
	i32.store	$push7=, 0($3), $4
	i32.add 	$4=, $pop7, $1
	i32.add 	$3=, $3, $2
	br_if   	$0, 0           # 0: up to label1
.LBB0_3:                                # %for.end
	end_loop                        # label2:
	end_block                       # label0:
	return  	$0
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end
	i32.const	$0=, 0
	i32.const	$push0=, a+3
	i32.store	$discard=, a+4($0), $pop0
	i32.const	$push1=, a
	i32.store	$discard=, a($0), $pop1
	call    	exit@FUNCTION, $0
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.align	2
a:
	.skip	8
	.size	a, 8


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
