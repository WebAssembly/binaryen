	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000412-6.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 512
	i32.const	$2=, buf
.LBB0_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	copy_local	$push16=, $3
	tee_local	$push15=, $0=, $pop16
	i32.const	$push14=, 65535
	i32.and 	$push0=, $pop15, $pop14
	i32.load16_u	$push13=, 0($2)
	tee_local	$push12=, $1=, $pop13
	i32.sub 	$3=, $pop0, $pop12
	i32.const	$push11=, 2
	i32.add 	$push10=, $2, $pop11
	tee_local	$push9=, $2=, $pop10
	i32.const	$push8=, buf+6
	i32.lt_u	$push1=, $pop9, $pop8
	br_if   	0, $pop1        # 0: up to label0
# BB#2:                                 # %bug.exit
	end_loop                        # label1:
	block
	i32.sub 	$push2=, $0, $1
	i32.const	$push3=, 65535
	i32.and 	$push4=, $pop2, $pop3
	i32.const	$push5=, 491
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label2
# BB#3:                                 # %if.end
	i32.const	$push7=, 0
	call    	exit@FUNCTION, $pop7
	unreachable
.LBB0_4:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.bug,"ax",@progbits
	.hidden	bug
	.globl	bug
	.type	bug,@function
bug:                                    # @bug
	.param  	i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.ge_u	$push0=, $1, $2
	br_if   	0, $pop0        # 0: down to label3
# BB#1:                                 # %for.body.preheader
.LBB1_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.const	$push9=, 65535
	i32.and 	$push1=, $0, $pop9
	i32.load16_u	$push2=, 0($1)
	i32.sub 	$0=, $pop1, $pop2
	i32.const	$push8=, 2
	i32.add 	$push7=, $1, $pop8
	tee_local	$push6=, $1=, $pop7
	i32.lt_u	$push3=, $pop6, $2
	br_if   	0, $pop3        # 0: up to label4
.LBB1_3:                                # %for.end
	end_loop                        # label5:
	end_block                       # label3:
	i32.const	$push4=, 65535
	i32.and 	$push5=, $0, $pop4
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end1:
	.size	bug, .Lfunc_end1-bug

	.hidden	buf                     # @buf
	.type	buf,@object
	.section	.data.buf,"aw",@progbits
	.globl	buf
	.p2align	1
buf:
	.int16	1                       # 0x1
	.int16	4                       # 0x4
	.int16	16                      # 0x10
	.int16	64                      # 0x40
	.int16	256                     # 0x100
	.size	buf, 10


	.ident	"clang version 4.0.0 "
	.functype	abort, void
	.functype	exit, void, i32
