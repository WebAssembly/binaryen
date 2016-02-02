	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000819-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push1=, 0
	i32.sub 	$push0=, $pop1, $1
	tee_local	$push10=, $1=, $pop0
	i32.const	$push9=, 0
	i32.gt_s	$push2=, $pop10, $pop9
	br_if   	$pop2, 0        # 0: down to label0
# BB#1:                                 # %for.body.preheader
	i32.const	$push3=, 2
	i32.shl 	$push4=, $1, $pop3
	i32.add 	$1=, $0, $pop4
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.load	$push5=, 0($1)
	i32.const	$push12=, 1
	i32.le_s	$push6=, $pop5, $pop12
	br_if   	$pop6, 1        # 1: down to label2
# BB#3:                                 # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push11=, 4
	i32.add 	$1=, $1, $pop11
	i32.le_u	$push7=, $1, $0
	br_if   	$pop7, 0        # 0: up to label1
	br      	2               # 2: down to label0
.LBB0_4:                                # %if.then
	end_loop                        # label2:
	i32.const	$push8=, 0
	call    	exit@FUNCTION, $pop8
	unreachable
.LBB0_5:                                # %for.end
	end_block                       # label0:
	return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push1=, a+4
	i32.const	$push0=, 1
	call    	foo@FUNCTION, $pop1, $pop0
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.p2align	2
a:
	.int32	2                       # 0x2
	.int32	0                       # 0x0
	.size	a, 8


	.ident	"clang version 3.9.0 "
