	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20050218-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$7=, 0
	block
	i32.const	$push8=, 0
	i32.eq  	$push9=, $2, $pop8
	br_if   	0, $pop9        # 0: down to label0
# BB#1:                                 # %for.body.lr.ph
	i32.const	$5=, 0
	i32.const	$4=, a
	i32.const	$6=, 0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.load	$3=, 0($4)
	i32.const	$7=, 2
	i32.add 	$push0=, $0, $5
	i32.call	$push5=, strlen@FUNCTION, $3
	tee_local	$push4=, $8=, $pop5
	i32.call	$push1=, strncmp@FUNCTION, $pop0, $3, $pop4
	br_if   	1, $pop1        # 1: down to label2
# BB#3:                                 # %if.end
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.add 	$5=, $8, $5
	block
	i32.const	$push10=, 0
	i32.eq  	$push11=, $1, $pop10
	br_if   	0, $pop11       # 0: down to label3
# BB#4:                                 # %if.then6
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.call	$push2=, strlen@FUNCTION, $1
	i32.add 	$5=, $pop2, $5
.LBB0_5:                                # %for.inc
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label3:
	i32.const	$push7=, 1
	i32.add 	$6=, $6, $pop7
	i32.const	$push6=, 4
	i32.add 	$4=, $4, $pop6
	i32.const	$7=, 0
	i32.lt_u	$push3=, $6, $2
	br_if   	0, $pop3        # 0: up to label1
.LBB0_6:                                # %cleanup
	end_loop                        # label2:
	end_block                       # label0:
	return  	$7
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push11=, 0
	i32.load	$0=, a($pop11):p2align=4
	block
	i32.const	$push10=, .L.str.4
	i32.call	$push9=, strlen@FUNCTION, $0
	tee_local	$push8=, $1=, $pop9
	i32.call	$push0=, strncmp@FUNCTION, $pop10, $0, $pop8
	br_if   	0, $pop0        # 0: down to label4
# BB#1:                                 # %if.end.i
	i32.const	$push15=, 0
	i32.load	$0=, a+4($pop15)
	i32.const	$push14=, .L.str.4
	i32.add 	$push1=, $1, $pop14
	i32.call	$push13=, strlen@FUNCTION, $0
	tee_local	$push12=, $2=, $pop13
	i32.call	$push2=, strncmp@FUNCTION, $pop1, $0, $pop12
	br_if   	0, $pop2        # 0: down to label4
# BB#2:                                 # %if.end.i.1
	i32.const	$push16=, 0
	i32.load	$0=, a+8($pop16):p2align=3
	i32.add 	$push3=, $2, $1
	i32.const	$push4=, .L.str.4
	i32.add 	$push5=, $pop3, $pop4
	i32.call	$push6=, strlen@FUNCTION, $0
	i32.call	$push7=, strncmp@FUNCTION, $pop5, $0, $pop6
	br_if   	0, $pop7        # 0: down to label4
# BB#3:                                 # %if.end.i.2
	i32.const	$push17=, 0
	return  	$pop17
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


	.ident	"clang version 3.9.0 "
