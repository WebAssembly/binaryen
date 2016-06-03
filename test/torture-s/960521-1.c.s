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
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %for.body.lr.ph
	i32.const	$push9=, 0
	i32.load	$0=, a($pop9)
	i32.const	$1=, 0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push15=, -1
	i32.store	$drop=, 0($0), $pop15
	i32.const	$push14=, 4
	i32.add 	$0=, $0, $pop14
	i32.const	$push13=, 1
	i32.add 	$push12=, $1, $pop13
	tee_local	$push11=, $1=, $pop12
	i32.const	$push10=, 0
	i32.load	$push2=, n($pop10)
	i32.lt_s	$push3=, $pop11, $pop2
	br_if   	0, $pop3        # 0: up to label1
.LBB0_3:                                # %for.cond1.preheader
	end_loop                        # label2:
	end_block                       # label0:
	i32.const	$push16=, 0
	i32.load	$push4=, b($pop16)
	i32.const	$push6=, 255
	i32.const	$push5=, 522236
	i32.call	$drop=, memset@FUNCTION, $pop4, $pop6, $pop5
	copy_local	$push17=, $0
                                        # fallthrough-return: $pop17
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
	i32.const	$4=, 0
	i32.const	$push17=, 0
	i32.const	$push1=, 130560
	i32.store	$drop=, n($pop17), $pop1
	i32.const	$push16=, 0
	i32.const	$push2=, 522240
	i32.call	$push15=, malloc@FUNCTION, $pop2
	tee_local	$push14=, $3=, $pop15
	i32.store	$drop=, a($pop16), $pop14
	i32.const	$push13=, 522240
	i32.call	$push12=, malloc@FUNCTION, $pop13
	tee_local	$push11=, $1=, $pop12
	i32.const	$push10=, 0
	i32.store	$push9=, 0($pop11), $pop10
	tee_local	$push8=, $2=, $pop9
	i32.const	$push7=, 4
	i32.add 	$push0=, $1, $pop7
	i32.store	$0=, b($pop8), $pop0
	i32.load	$2=, n($2)
.LBB1_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	i32.const	$push22=, -1
	i32.store	$drop=, 0($3), $pop22
	i32.const	$push21=, 4
	i32.add 	$3=, $3, $pop21
	i32.const	$push20=, 1
	i32.add 	$push19=, $4, $pop20
	tee_local	$push18=, $4=, $pop19
	i32.lt_s	$push3=, $pop18, $2
	br_if   	0, $pop3        # 0: up to label3
# BB#2:                                 # %foo.exit
	end_loop                        # label4:
	i32.load	$3=, 0($1)
	i32.const	$push5=, 255
	i32.const	$push4=, 522236
	i32.call	$drop=, memset@FUNCTION, $0, $pop5, $pop4
	block
	br_if   	0, $3           # 0: down to label5
# BB#3:                                 # %if.end
	i32.const	$push6=, 0
	call    	exit@FUNCTION, $pop6
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
	.functype	malloc, i32, i32
	.functype	abort, void
	.functype	exit, void, i32
