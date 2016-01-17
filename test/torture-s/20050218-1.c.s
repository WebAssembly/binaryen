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
	i32.const	$4=, 0
	block
	i32.const	$push5=, 0
	i32.eq  	$push6=, $2, $pop5
	br_if   	$pop6, 0        # 0: down to label0
# BB#1:                                 # %for.body.lr.ph
	i32.const	$7=, 0
	i32.const	$6=, a
	copy_local	$8=, $7
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.load	$4=, 0($6)
	i32.call	$3=, strlen@FUNCTION, $4
	i32.add 	$push0=, $0, $7
	i32.call	$5=, strncmp@FUNCTION, $pop0, $4, $3
	i32.const	$4=, 2
	br_if   	$5, 1           # 1: down to label2
# BB#3:                                 # %if.end
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.add 	$7=, $3, $7
	block
	i32.const	$push7=, 0
	i32.eq  	$push8=, $1, $pop7
	br_if   	$pop8, 0        # 0: down to label3
# BB#4:                                 # %if.then6
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.call	$push1=, strlen@FUNCTION, $1
	i32.add 	$7=, $pop1, $7
.LBB0_5:                                # %for.inc
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label3:
	i32.const	$push2=, 1
	i32.add 	$8=, $8, $pop2
	i32.const	$push3=, 4
	i32.add 	$6=, $6, $pop3
	i32.const	$4=, 0
	i32.lt_u	$push4=, $8, $2
	br_if   	$pop4, 0        # 0: up to label1
.LBB0_6:                                # %cleanup
	end_loop                        # label2:
	end_block                       # label0:
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
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	i32.load	$3=, a($2)
	i32.call	$0=, strlen@FUNCTION, $3
	i32.const	$4=, .L.str.4
	block
	i32.call	$push0=, strncmp@FUNCTION, $4, $3, $0
	br_if   	$pop0, 0        # 0: down to label4
# BB#1:                                 # %if.end.i
	i32.load	$3=, a+4($2)
	i32.call	$1=, strlen@FUNCTION, $3
	i32.add 	$push1=, $4, $0
	i32.call	$push2=, strncmp@FUNCTION, $pop1, $3, $1
	br_if   	$pop2, 0        # 0: down to label4
# BB#2:                                 # %if.end.i.1
	i32.load	$3=, a+8($2)
	i32.add 	$push3=, $1, $0
	i32.add 	$push4=, $4, $pop3
	i32.call	$push5=, strlen@FUNCTION, $3
	i32.call	$push6=, strncmp@FUNCTION, $pop4, $3, $pop5
	br_if   	$pop6, 0        # 0: down to label4
# BB#3:                                 # %if.end.i.2
	return  	$2
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
	.align	4
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
