	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-3c.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push1=, 3
	i32.shl 	$push2=, $0, $pop1
	i32.const	$push3=, a
	i32.add 	$1=, $pop2, $pop3
	i32.const	$2=, 256
.LBB0_1:                                # %do.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.const	$push10=, 1
	i32.shr_s	$2=, $2, $pop10
	i32.const	$push9=, 4
	i32.add 	$0=, $0, $pop9
	i32.const	$push8=, 2
	i32.shl 	$push4=, $2, $pop8
	i32.store	$push0=, a($pop4), $1
	i32.const	$push7=, 32
	i32.add 	$1=, $pop0, $pop7
	i32.const	$push6=, 1073741840
	i32.lt_s	$push5=, $0, $pop6
	br_if   	0, $pop5        # 0: up to label0
# BB#2:                                 # %do.end
	end_loop                        # label1:
	return  	$0
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end7
	i32.const	$push1=, 0
	i32.const	$push2=, a
	i32.store	$discard=, a+512($pop1), $pop2
	i32.const	$push10=, 0
	i32.const	$push3=, a+32
	i32.store	$discard=, a+256($pop10), $pop3
	i32.const	$push9=, 0
	i32.const	$push4=, a+64
	i32.store	$discard=, a+128($pop9), $pop4
	i32.const	$push8=, 0
	i32.const	$push5=, a+96
	i32.store	$discard=, a+64($pop8), $pop5
	i32.const	$push7=, 0
	i32.const	$push6=, 0
	i32.store	$push0=, a+32($pop7), $pop6
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	4
a:
	.skip	1020
	.size	a, 1020


	.ident	"clang version 3.9.0 "
