	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20111208-1.c"
	.section	.text.pack_unpack,"ax",@progbits
	.hidden	pack_unpack
	.globl	pack_unpack
	.type	pack_unpack,@function
pack_unpack:                            # @pack_unpack
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.call	$push1=, strlen@FUNCTION, $1
	i32.add 	$2=, $1, $pop1
.LBB0_1:                                # %while.cond.outer
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_2 Depth 2
	loop                            # label0:
	copy_local	$3=, $1
.LBB0_2:                                # %while.cond
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block
	block
	loop                            # label4:
	i32.ge_u	$push2=, $3, $2
	br_if   	2, $pop2        # 2: down to label3
# BB#3:                                 # %while.body
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push11=, 1
	i32.add 	$1=, $3, $pop11
	i32.load8_s	$push10=, 0($3)
	tee_local	$push9=, $4=, $pop10
	i32.const	$push8=, 108
	i32.eq  	$push4=, $pop9, $pop8
	br_if   	3, $pop4        # 3: down to label2
# BB#4:                                 # %while.body
                                        #   in Loop: Header=BB0_2 Depth=2
	copy_local	$3=, $1
	i32.const	$push12=, 115
	i32.ne  	$push5=, $4, $pop12
	br_if   	0, $pop5        # 0: up to label4
# BB#5:                                 # %sw.bb4
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop                        # label5:
	i32.load16_s	$push6=, 0($0):p2align=0
	call    	do_something@FUNCTION, $pop6
	i32.const	$push13=, 2
	i32.add 	$push0=, $0, $pop13
	copy_local	$0=, $pop0
	br      	2               # 2: up to label0
.LBB0_6:                                # %while.end
	end_block                       # label3:
	i32.load8_s	$push3=, 0($0)
	return  	$pop3
.LBB0_7:                                # %sw.bb8
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i32.load	$3=, 0($0):p2align=0
	i32.const	$push7=, 4
	i32.add 	$0=, $0, $pop7
	call    	do_something@FUNCTION, $3
	br      	0               # 0: up to label0
.LBB0_8:
	end_loop                        # label1:
	.endfunc
.Lfunc_end0:
	.size	pack_unpack, .Lfunc_end0-pack_unpack

	.section	.text.do_something,"ax",@progbits
	.type	do_something,@function
do_something:                           # @do_something
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.store	$drop=, a($pop0), $0
	return
	.endfunc
.Lfunc_end1:
	.size	do_something, .Lfunc_end1-do_something

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, .L.str
	i32.const	$0=, .L.str.1
.LBB2_1:                                # %while.cond.outer.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_2 Depth 2
	loop                            # label6:
	copy_local	$2=, $0
.LBB2_2:                                # %while.cond.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block
	block
	loop                            # label10:
	i32.const	$push8=, .L.str.1+2
	i32.ge_u	$push1=, $2, $pop8
	br_if   	2, $pop1        # 2: down to label9
# BB#3:                                 # %while.body.i
                                        #   in Loop: Header=BB2_2 Depth=2
	i32.const	$push12=, 1
	i32.add 	$0=, $2, $pop12
	i32.load8_s	$push11=, 0($2)
	tee_local	$push10=, $3=, $pop11
	i32.const	$push9=, 108
	i32.eq  	$push4=, $pop10, $pop9
	br_if   	3, $pop4        # 3: down to label8
# BB#4:                                 # %while.body.i
                                        #   in Loop: Header=BB2_2 Depth=2
	copy_local	$2=, $0
	i32.const	$push13=, 115
	i32.ne  	$push5=, $3, $pop13
	br_if   	0, $pop5        # 0: up to label10
# BB#5:                                 # %sw.bb4.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label11:
	i32.load16_s	$push6=, 0($1):p2align=0
	call    	do_something@FUNCTION, $pop6
	i32.const	$push14=, 2
	i32.add 	$push0=, $1, $pop14
	copy_local	$1=, $pop0
	br      	2               # 2: up to label6
.LBB2_6:                                # %pack_unpack.exit
	end_block                       # label9:
	block
	i32.load8_u	$push2=, 0($1)
	br_if   	0, $pop2        # 0: down to label12
# BB#7:                                 # %if.end
	i32.const	$push3=, 0
	return  	$pop3
.LBB2_8:                                # %if.then
	end_block                       # label12:
	call    	abort@FUNCTION
	unreachable
.LBB2_9:                                # %sw.bb8.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label8:
	i32.load	$2=, 0($1):p2align=0
	i32.const	$push7=, 4
	i32.add 	$1=, $1, $pop7
	call    	do_something@FUNCTION, $2
	br      	0               # 0: up to label6
.LBB2_10:
	end_loop                        # label7:
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"\200\001\377\376\035\300"
	.size	.L.str, 7

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"sl"
	.size	.L.str.1, 3

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.int32	0                       # 0x0
	.size	a, 4


	.ident	"clang version 3.9.0 "
