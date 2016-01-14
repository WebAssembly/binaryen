	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000819-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	i32.sub 	$1=, $2, $1
	block
	i32.gt_s	$push0=, $1, $2
	br_if   	$pop0, 0        # 0: down to label0
# BB#1:                                 # %for.body.preheader
	i32.const	$push1=, 2
	i32.shl 	$push2=, $1, $pop1
	i32.add 	$1=, $0, $pop2
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.load	$push3=, 0($1)
	i32.const	$push5=, 1
	i32.le_s	$push6=, $pop3, $pop5
	br_if   	$pop6, 1        # 1: down to label2
# BB#3:                                 # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push4=, 4
	i32.add 	$1=, $1, $pop4
	i32.le_u	$push7=, $1, $0
	br_if   	$pop7, 0        # 0: up to label1
	br      	2               # 2: down to label0
.LBB0_4:                                # %if.then
	end_loop                        # label2:
	call    	exit@FUNCTION, $2
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block
	i32.load	$push1=, a($0)
	i32.const	$push2=, 2
	i32.lt_s	$push3=, $pop1, $pop2
	br_if   	$pop3, 0        # 0: down to label3
# BB#1:                                 # %entry
	i32.load	$push0=, a+4($0)
	i32.const	$push4=, 1
	i32.le_s	$push5=, $pop0, $pop4
	br_if   	$pop5, 0        # 0: down to label3
# BB#2:                                 # %for.cond.i.1
	call    	abort@FUNCTION
	unreachable
.LBB1_3:                                # %if.then.i
	end_block                       # label3:
	call    	exit@FUNCTION, $0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.align	2
a:
	.int32	2                       # 0x2
	.int32	0                       # 0x0
	.size	a, 8


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
