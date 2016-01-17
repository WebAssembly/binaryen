	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/960521-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, 0
	i32.const	$0=, 1
	block
	i32.load	$push0=, n($4)
	i32.lt_s	$push1=, $pop0, $0
	br_if   	$pop1, 0        # 0: down to label0
# BB#1:                                 # %for.body.lr.ph
	i32.const	$1=, 0
	i32.load	$2=, a($1)
	copy_local	$3=, $1
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push2=, -1
	i32.store	$discard=, 0($2), $pop2
	i32.const	$push4=, 4
	i32.add 	$2=, $2, $pop4
	i32.add 	$3=, $3, $0
	i32.load	$push3=, n($1)
	i32.lt_s	$push5=, $3, $pop3
	br_if   	$pop5, 0        # 0: up to label1
.LBB0_3:                                # %for.cond1.preheader
	end_loop                        # label2:
	end_block                       # label0:
	i32.load	$2=, b($4)
.LBB0_4:                                # %for.body3
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	i32.add 	$push6=, $2, $4
	i32.const	$push7=, -1
	i32.store	$discard=, 0($pop6), $pop7
	i32.const	$push8=, 4
	i32.add 	$4=, $4, $pop8
	i32.const	$push9=, 131068
	i32.ne  	$push10=, $4, $pop9
	br_if   	$pop10, 0       # 0: up to label3
# BB#5:                                 # %for.end7
	end_loop                        # label4:
	return  	$4
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %for.body.lr.ph.i
	i32.const	$4=, 0
	i32.const	$5=, 131072
	i32.const	$push1=, 32768
	i32.store	$discard=, n($4), $pop1
	i32.call	$push0=, malloc@FUNCTION, $5
	i32.store	$1=, a($4), $pop0
	i32.call	$2=, malloc@FUNCTION, $5
	i32.store	$5=, 0($2), $4
	i32.load	$0=, n($5)
	i32.const	$3=, 4
	i32.add 	$push2=, $2, $3
	i32.store	$discard=, b($4), $pop2
.LBB1_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label5:
	i32.const	$push4=, 1
	i32.add 	$5=, $5, $pop4
	i32.const	$push3=, -1
	i32.store	$4=, 0($1), $pop3
	i32.add 	$1=, $1, $3
	i32.lt_s	$push5=, $5, $0
	br_if   	$pop5, 0        # 0: up to label5
# BB#2:                                 # %for.cond1.preheader.i
	end_loop                        # label6:
	i32.const	$5=, 0
	i32.load	$1=, b($5)
.LBB1_3:                                # %for.body3.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label7:
	i32.add 	$push6=, $1, $5
	i32.store	$discard=, 0($pop6), $4
	i32.add 	$5=, $5, $3
	i32.const	$push7=, 131068
	i32.ne  	$push8=, $5, $pop7
	br_if   	$pop8, 0        # 0: up to label7
# BB#4:                                 # %foo.exit
	end_loop                        # label8:
	block
	i32.const	$push9=, -4
	i32.add 	$push10=, $1, $pop9
	i32.load	$push11=, 0($pop10)
	br_if   	$pop11, 0       # 0: down to label9
# BB#5:                                 # %if.end
	i32.const	$push12=, 0
	call    	exit@FUNCTION, $pop12
	unreachable
.LBB1_6:                                # %if.then
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	n                       # @n
	.type	n,@object
	.section	.bss.n,"aw",@nobits
	.globl	n
	.align	2
n:
	.int32	0                       # 0x0
	.size	n, 4

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.align	2
a:
	.int32	0
	.size	a, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.align	2
b:
	.int32	0
	.size	b, 4


	.ident	"clang version 3.9.0 "
