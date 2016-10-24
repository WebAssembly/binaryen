	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20050218-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	block   	
	block   	
	i32.eqz 	$push14=, $2
	br_if   	0, $pop14       # 0: down to label1
# BB#1:                                 # %for.body.lr.ph
	i32.const	$5=, 0
	i32.const	$4=, a
	i32.const	$6=, 0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.add 	$push0=, $0, $5
	i32.load	$push9=, 0($4)
	tee_local	$push8=, $3=, $pop9
	i32.call	$push7=, strlen@FUNCTION, $3
	tee_local	$push6=, $3=, $pop7
	i32.call	$push1=, strncmp@FUNCTION, $pop0, $pop8, $pop6
	br_if   	2, $pop1        # 2: down to label0
# BB#3:                                 # %if.end
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.add 	$5=, $3, $5
	block   	
	i32.eqz 	$push15=, $1
	br_if   	0, $pop15       # 0: down to label3
# BB#4:                                 # %if.then6
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.call	$push2=, strlen@FUNCTION, $1
	i32.add 	$5=, $pop2, $5
.LBB0_5:                                # %for.inc
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label3:
	i32.const	$push13=, 4
	i32.add 	$4=, $4, $pop13
	i32.const	$push12=, 1
	i32.add 	$push11=, $6, $pop12
	tee_local	$push10=, $6=, $pop11
	i32.lt_u	$push3=, $pop10, $2
	br_if   	0, $pop3        # 0: up to label2
.LBB0_6:
	end_loop
	end_block                       # label1:
	i32.const	$push4=, 0
	return  	$pop4
.LBB0_7:
	end_block                       # label0:
	i32.const	$push5=, 2
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push13=, .L.str.4
	i32.const	$push12=, 0
	i32.load	$push11=, a($pop12)
	tee_local	$push10=, $0=, $pop11
	i32.call	$push9=, strlen@FUNCTION, $0
	tee_local	$push8=, $0=, $pop9
	i32.call	$push0=, strncmp@FUNCTION, $pop13, $pop10, $pop8
	br_if   	0, $pop0        # 0: down to label4
# BB#1:                                 # %if.end.i
	i32.const	$push19=, .L.str.4
	i32.add 	$push1=, $0, $pop19
	i32.const	$push18=, 0
	i32.load	$push17=, a+4($pop18)
	tee_local	$push16=, $1=, $pop17
	i32.call	$push15=, strlen@FUNCTION, $1
	tee_local	$push14=, $1=, $pop15
	i32.call	$push2=, strncmp@FUNCTION, $pop1, $pop16, $pop14
	br_if   	0, $pop2        # 0: down to label4
# BB#2:                                 # %if.end.i.1
	i32.add 	$push3=, $1, $0
	i32.const	$push4=, .L.str.4
	i32.add 	$push5=, $pop3, $pop4
	i32.const	$push22=, 0
	i32.load	$push21=, a+8($pop22)
	tee_local	$push20=, $0=, $pop21
	i32.call	$push6=, strlen@FUNCTION, $0
	i32.call	$push7=, strncmp@FUNCTION, $pop5, $pop20, $pop6
	br_if   	0, $pop7        # 0: down to label4
# BB#3:                                 # %if.end.i.2
	i32.const	$push23=, 0
	return  	$pop23
.LBB1_4:                                # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"a"
	.size	.L.str, 2

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"bc"
	.size	.L.str.1, 3

	.type	.L.str.2,@object        # @.str.2
.L.str.2:
	.asciz	"de"
	.size	.L.str.2, 3

	.type	.L.str.3,@object        # @.str.3
.L.str.3:
	.asciz	"fgh"
	.size	.L.str.3, 4

	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.p2align	4
a:
	.int32	.L.str
	.int32	.L.str.1
	.int32	.L.str.2
	.int32	.L.str.3
	.int32	0
	.int32	0
	.int32	0
	.int32	0
	.int32	0
	.int32	0
	.int32	0
	.int32	0
	.int32	0
	.int32	0
	.int32	0
	.int32	0
	.size	a, 64

	.type	.L.str.4,@object        # @.str.4
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str.4:
	.asciz	"abcde"
	.size	.L.str.4, 6


	.ident	"clang version 4.0.0 "
	.functype	strncmp, i32, i32, i32, i32
	.functype	strlen, i32, i32
	.functype	abort, void
