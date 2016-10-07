	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/960521-1.c"
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
	loop    	                # label1:
	i32.const	$push15=, -1
	i32.store	0($0), $pop15
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
	end_loop
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
	i32.const	$push18=, 0
	i32.const	$push0=, 130560
	i32.store	n($pop18), $pop0
	i32.const	$push17=, 0
	i32.const	$push1=, 522240
	i32.call	$push16=, malloc@FUNCTION, $pop1
	tee_local	$push15=, $3=, $pop16
	i32.store	a($pop17), $pop15
	i32.const	$push14=, 522240
	i32.call	$push13=, malloc@FUNCTION, $pop14
	tee_local	$push12=, $0=, $pop13
	i32.const	$push11=, 0
	i32.store	0($pop12), $pop11
	i32.const	$push10=, 0
	i32.const	$push9=, 4
	i32.add 	$push8=, $0, $pop9
	tee_local	$push7=, $1=, $pop8
	i32.store	b($pop10), $pop7
	i32.const	$push6=, 0
	i32.load	$2=, n($pop6)
.LBB1_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.const	$push23=, -1
	i32.store	0($3), $pop23
	i32.const	$push22=, 4
	i32.add 	$3=, $3, $pop22
	i32.const	$push21=, 1
	i32.add 	$push20=, $4, $pop21
	tee_local	$push19=, $4=, $pop20
	i32.lt_s	$push2=, $pop19, $2
	br_if   	0, $pop2        # 0: up to label2
# BB#2:                                 # %foo.exit
	end_loop
	i32.load	$3=, 0($0)
	i32.const	$push4=, 255
	i32.const	$push3=, 522236
	i32.call	$drop=, memset@FUNCTION, $1, $pop4, $pop3
	block   	
	br_if   	0, $3           # 0: down to label3
# BB#3:                                 # %if.end
	i32.const	$push5=, 0
	call    	exit@FUNCTION, $pop5
	unreachable
.LBB1_4:                                # %if.then
	end_block                       # label3:
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	malloc, i32, i32
	.functype	abort, void
	.functype	exit, void, i32
