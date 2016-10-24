	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20111208-1.c"
	.section	.text.pack_unpack,"ax",@progbits
	.hidden	pack_unpack
	.globl	pack_unpack
	.type	pack_unpack,@function
pack_unpack:                            # @pack_unpack
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	block   	
	i32.call	$push0=, strlen@FUNCTION, $1
	i32.add 	$push10=, $1, $pop0
	tee_local	$push9=, $2=, $pop10
	i32.ge_u	$push1=, $1, $pop9
	br_if   	0, $pop1        # 0: down to label0
.LBB0_1:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push15=, 1
	i32.add 	$3=, $1, $pop15
	block   	
	i32.load8_s	$push14=, 0($1)
	tee_local	$push13=, $4=, $pop14
	i32.const	$push12=, 108
	i32.eq  	$push5=, $pop13, $pop12
	br_if   	0, $pop5        # 0: down to label2
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB0_1 Depth=1
	copy_local	$1=, $3
	block   	
	i32.const	$push16=, 115
	i32.ne  	$push6=, $4, $pop16
	br_if   	0, $pop6        # 0: down to label3
# BB#3:                                 # %sw.bb4
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.load16_s	$push8=, 0($0):p2align=0
	call    	do_something@FUNCTION, $pop8
	i32.const	$push11=, 2
	i32.add 	$0=, $0, $pop11
	copy_local	$1=, $3
.LBB0_4:                                # %while.cond
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label3:
	i32.ge_u	$push3=, $1, $2
	br_if   	2, $pop3        # 2: down to label0
	br      	1               # 1: up to label1
.LBB0_5:                                # %sw.bb7
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i32.load	$push7=, 0($0):p2align=0
	call    	do_something@FUNCTION, $pop7
	i32.const	$push19=, 4
	i32.add 	$0=, $0, $pop19
	copy_local	$push18=, $3
	tee_local	$push17=, $1=, $pop18
	i32.lt_u	$push2=, $pop17, $2
	br_if   	0, $pop2        # 0: up to label1
.LBB0_6:                                # %while.end
	end_loop
	end_block                       # label0:
	i32.load8_s	$push4=, 0($0)
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end0:
	.size	pack_unpack, .Lfunc_end0-pack_unpack

	.section	.text.do_something,"ax",@progbits
	.type	do_something,@function
do_something:                           # @do_something
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.store	a($pop0), $0
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
	block   	
	i32.const	$push10=, .L.str.1
	i32.const	$push9=, .L.str.1+2
	i32.ge_u	$push0=, $pop10, $pop9
	br_if   	0, $pop0        # 0: down to label4
.LBB2_1:                                # %while.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label5:
	i32.const	$push16=, 1
	i32.add 	$0=, $2, $pop16
	block   	
	block   	
	block   	
	i32.load8_s	$push15=, 0($2)
	tee_local	$push14=, $1=, $pop15
	i32.const	$push13=, 108
	i32.ne  	$push5=, $pop14, $pop13
	br_if   	0, $pop5        # 0: down to label8
# BB#2:                                 # %sw.bb7.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load	$push7=, 0($3):p2align=0
	call    	do_something@FUNCTION, $pop7
	i32.const	$push11=, 4
	i32.add 	$3=, $3, $pop11
	copy_local	$2=, $0
	br      	1               # 1: down to label7
.LBB2_3:                                # %while.body.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label8:
	copy_local	$2=, $0
	i32.const	$push17=, 115
	i32.eq  	$push6=, $1, $pop17
	br_if   	1, $pop6        # 1: down to label6
.LBB2_4:                                # %while.cond.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label7:
	i32.const	$push12=, .L.str.1+2
	i32.ge_u	$push2=, $2, $pop12
	br_if   	2, $pop2        # 2: down to label4
	br      	1               # 1: up to label5
.LBB2_5:                                # %sw.bb4.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label6:
	i32.load16_s	$push8=, 0($3):p2align=0
	call    	do_something@FUNCTION, $pop8
	i32.const	$push21=, 2
	i32.add 	$3=, $3, $pop21
	copy_local	$push20=, $0
	tee_local	$push19=, $2=, $pop20
	i32.const	$push18=, .L.str.1+2
	i32.lt_u	$push1=, $pop19, $pop18
	br_if   	0, $pop1        # 0: up to label5
.LBB2_6:                                # %pack_unpack.exit
	end_loop
	end_block                       # label4:
	block   	
	i32.load8_u	$push3=, 0($3)
	br_if   	0, $pop3        # 0: down to label9
# BB#7:                                 # %if.end
	i32.const	$push4=, 0
	return  	$pop4
.LBB2_8:                                # %if.then
	end_block                       # label9:
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


	.ident	"clang version 4.0.0 "
	.functype	strlen, i32, i32
	.functype	abort, void
