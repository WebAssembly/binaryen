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
	i32.call	$push0=, strlen@FUNCTION, $1
	i32.add 	$2=, $1, $pop0
.LBB0_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.ge_u	$push1=, $1, $2
	br_if   	1, $pop1        # 1: down to label1
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push11=, 1
	i32.add 	$3=, $1, $pop11
	block
	i32.load8_s	$push10=, 0($1)
	tee_local	$push9=, $4=, $pop10
	i32.const	$push8=, 108
	i32.eq  	$push3=, $pop9, $pop8
	br_if   	0, $pop3        # 0: down to label2
# BB#3:                                 # %while.body
                                        #   in Loop: Header=BB0_1 Depth=1
	copy_local	$1=, $3
	i32.const	$push12=, 115
	i32.ne  	$push4=, $4, $pop12
	br_if   	1, $pop4        # 1: up to label0
# BB#4:                                 # %sw.bb4
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.load16_s	$push6=, 0($0):p2align=0
	call    	do_something@FUNCTION, $pop6
	i32.const	$push7=, 2
	i32.add 	$0=, $0, $pop7
	copy_local	$1=, $3
	br      	1               # 1: up to label0
.LBB0_5:                                # %sw.bb8
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i32.load	$push5=, 0($0):p2align=0
	call    	do_something@FUNCTION, $pop5
	i32.const	$push13=, 4
	i32.add 	$0=, $0, $pop13
	copy_local	$1=, $3
	br      	0               # 0: up to label0
.LBB0_6:                                # %while.end
	end_loop                        # label1:
	i32.load8_s	$push2=, 0($0)
                                        # fallthrough-return: $pop2
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
                                        # fallthrough-return
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
	i32.const	$3=, .L.str
	i32.const	$2=, .L.str.1
.LBB2_1:                                # %while.cond.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	i32.const	$push8=, .L.str.1+2
	i32.ge_u	$push0=, $2, $pop8
	br_if   	1, $pop0        # 1: down to label4
# BB#2:                                 # %while.body.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push12=, 1
	i32.add 	$0=, $2, $pop12
	block
	i32.load8_s	$push11=, 0($2)
	tee_local	$push10=, $1=, $pop11
	i32.const	$push9=, 108
	i32.ne  	$push3=, $pop10, $pop9
	br_if   	0, $pop3        # 0: down to label5
# BB#3:                                 # %sw.bb8.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load	$push5=, 0($3):p2align=0
	call    	do_something@FUNCTION, $pop5
	i32.const	$push7=, 4
	i32.add 	$3=, $3, $pop7
	copy_local	$2=, $0
	br      	1               # 1: up to label3
.LBB2_4:                                # %while.body.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label5:
	copy_local	$2=, $0
	i32.const	$push13=, 115
	i32.ne  	$push4=, $1, $pop13
	br_if   	0, $pop4        # 0: up to label3
# BB#5:                                 # %sw.bb4.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load16_s	$push6=, 0($3):p2align=0
	call    	do_something@FUNCTION, $pop6
	i32.const	$push14=, 2
	i32.add 	$3=, $3, $pop14
	copy_local	$2=, $0
	br      	0               # 0: up to label3
.LBB2_6:                                # %pack_unpack.exit
	end_loop                        # label4:
	block
	i32.load8_u	$push1=, 0($3)
	br_if   	0, $pop1        # 0: down to label6
# BB#7:                                 # %if.end
	i32.const	$push2=, 0
	return  	$pop2
.LBB2_8:                                # %if.then
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
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
	.functype	strlen, i32, i32
	.functype	abort, void
