	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/960521-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push8=, 0
	i32.load	$push0=, n($pop8)
	i32.const	$push7=, 1
	i32.lt_s	$push1=, $pop0, $pop7
	br_if   	$pop1, 0        # 0: down to label0
# BB#1:                                 # %for.body.lr.ph
	i32.const	$push9=, 0
	i32.load	$0=, a($pop9)
	i32.const	$1=, 0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push14=, -1
	i32.store	$discard=, 0($0), $pop14
	i32.const	$push13=, 1
	i32.add 	$1=, $1, $pop13
	i32.const	$push12=, 4
	i32.add 	$0=, $0, $pop12
	i32.const	$push11=, 0
	i32.load	$push2=, n($pop11)
	i32.lt_s	$push3=, $1, $pop2
	br_if   	$pop3, 0        # 0: up to label1
.LBB0_3:                                # %for.cond1.preheader
	end_loop                        # label2:
	end_block                       # label0:
	i32.const	$push10=, 0
	i32.load	$push4=, b($pop10)
	i32.const	$push6=, 255
	i32.const	$push5=, 131068
	i32.call	$discard=, memset@FUNCTION, $pop4, $pop6, $pop5
	return  	$0
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %for.body.lr.ph.i
	i32.const	$push3=, 0
	i32.const	$push4=, 32768
	i32.store	$discard=, n($pop3), $pop4
	i32.const	$push17=, 0
	i32.const	$push5=, 131072
	i32.call	$push0=, malloc@FUNCTION, $pop5
	i32.store	$2=, a($pop17), $pop0
	i32.const	$push16=, 131072
	i32.call	$push1=, malloc@FUNCTION, $pop16
	tee_local	$push15=, $4=, $pop1
	i32.const	$push14=, 0
	i32.store	$push10=, 0($pop15), $pop14
	tee_local	$push13=, $3=, $pop10
	i32.load	$0=, n($pop13)
	i32.const	$push12=, 0
	i32.const	$push11=, 4
	i32.add 	$push2=, $4, $pop11
	i32.store	$1=, b($pop12), $pop2
.LBB1_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	i32.const	$push20=, -1
	i32.store	$discard=, 0($2), $pop20
	i32.const	$push19=, 1
	i32.add 	$3=, $3, $pop19
	i32.const	$push18=, 4
	i32.add 	$2=, $2, $pop18
	i32.lt_s	$push6=, $3, $0
	br_if   	$pop6, 0        # 0: up to label3
# BB#2:                                 # %foo.exit
	end_loop                        # label4:
	i32.load	$2=, 0($4)
	i32.const	$push8=, 255
	i32.const	$push7=, 131068
	i32.call	$discard=, memset@FUNCTION, $1, $pop8, $pop7
	block
	br_if   	$2, 0           # 0: down to label5
# BB#3:                                 # %if.end
	i32.const	$push9=, 0
	call    	exit@FUNCTION, $pop9
	unreachable
.LBB1_4:                                # %if.then
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	n                       # @n
	.type	n,@object
	.section	.bss.n,"aw",@nobits
	.globl	n
	.p2align	2
n:
	.int32	0                       # 0x0
	.size	n, 4

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.int32	0
	.size	a, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.int32	0
	.size	b, 4


	.ident	"clang version 3.9.0 "
