	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-2c.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push11=, 0
	i32.eq  	$push12=, $0, $pop11
	br_if   	0, $pop12       # 0: down to label0
# BB#1:                                 # %for.body.preheader
	i32.const	$push4=, 2
	i32.shl 	$push5=, $0, $pop4
	i32.const	$push6=, a-4
	i32.add 	$2=, $pop5, $pop6
	i32.const	$push1=, 3
	i32.mul 	$push2=, $0, $pop1
	i32.add 	$push3=, $1, $pop2
	i32.const	$push7=, -3
	i32.add 	$1=, $pop3, $pop7
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push10=, -1
	i32.add 	$0=, $0, $pop10
	i32.store	$push0=, 0($2), $1
	i32.const	$push9=, -3
	i32.add 	$1=, $pop0, $pop9
	i32.const	$push8=, -4
	i32.add 	$2=, $2, $pop8
	br_if   	0, $0           # 0: up to label1
.LBB0_3:                                # %for.end
	end_loop                        # label2:
	end_block                       # label0:
	return  	$0
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.g,"ax",@progbits
	.hidden	g
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push10=, 0
	i32.eq  	$push11=, $0, $pop10
	br_if   	0, $pop11       # 0: down to label3
# BB#1:                                 # %for.body.preheader.i
	i32.const	$push1=, 3
	i32.mul 	$push2=, $0, $pop1
	i32.const	$push3=, a-3
	i32.add 	$2=, $pop2, $pop3
	i32.const	$push4=, 2
	i32.shl 	$push5=, $0, $pop4
	i32.const	$push6=, a-4
	i32.add 	$1=, $pop5, $pop6
.LBB1_2:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.const	$push9=, -1
	i32.add 	$0=, $0, $pop9
	i32.store	$push0=, 0($1), $2
	i32.const	$push8=, -3
	i32.add 	$2=, $pop0, $pop8
	i32.const	$push7=, -4
	i32.add 	$1=, $1, $pop7
	br_if   	0, $0           # 0: up to label4
.LBB1_3:                                # %f.exit
	end_loop                        # label5:
	end_block                       # label3:
	return  	$0
	.endfunc
.Lfunc_end1:
	.size	g, .Lfunc_end1-g

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push1=, 0
	i32.const	$push0=, a+3
	i32.store	$discard=, a+4($pop1), $pop0
	i32.const	$push4=, 0
	i32.const	$push2=, a
	i32.store	$discard=, a($pop4), $pop2
	i32.const	$push3=, 0
	call    	exit@FUNCTION, $pop3
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.skip	8
	.size	a, 8


	.ident	"clang version 3.9.0 "
