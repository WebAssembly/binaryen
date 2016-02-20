	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-2.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push5=, 0
	i32.eq  	$push6=, $0, $pop5
	br_if   	0, $pop6        # 0: down to label0
# BB#1:
	i32.const	$2=, 0
	i32.const	$1=, a
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push4=, -2
	i32.add 	$push0=, $2, $pop4
	i32.store	$discard=, 0($1), $pop0
	i32.const	$push3=, 1
	i32.add 	$2=, $2, $pop3
	i32.const	$push2=, 4
	i32.add 	$1=, $1, $pop2
	i32.ne  	$push1=, $0, $2
	br_if   	0, $pop1        # 0: up to label1
.LBB0_3:                                # %for.end
	end_loop                        # label2:
	end_block                       # label0:
	return  	$2
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
	i32.const	$push1=, 0
	i64.const	$push0=, -2
	i64.store	$discard=, a($pop1):p2align=2, $pop0
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.skip	8
	.size	a, 8


	.ident	"clang version 3.9.0 "
