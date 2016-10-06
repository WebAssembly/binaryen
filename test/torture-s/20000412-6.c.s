	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000412-6.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, buf
	i32.const	$0=, 512
.LBB0_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.load16_u	$push0=, 0($1)
	i32.sub 	$push1=, $0, $pop0
	i32.const	$push10=, 65535
	i32.and 	$0=, $pop1, $pop10
	i32.const	$push9=, 2
	i32.add 	$push8=, $1, $pop9
	tee_local	$push7=, $1=, $pop8
	i32.const	$push6=, buf+6
	i32.lt_u	$push2=, $pop7, $pop6
	br_if   	0, $pop2        # 0: up to label0
# BB#2:                                 # %bug.exit
	end_loop
	block   	
	i32.const	$push3=, 491
	i32.ne  	$push4=, $0, $pop3
	br_if   	0, $pop4        # 0: down to label1
# BB#3:                                 # %if.end
	i32.const	$push5=, 0
	call    	exit@FUNCTION, $pop5
	unreachable
.LBB0_4:                                # %if.then
	end_block                       # label1:
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
	br_if   	0, $pop0        # 0: down to label2
# BB#1:                                 # %for.body.preheader
.LBB1_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	i32.load16_u	$push1=, 0($1)
	i32.sub 	$push2=, $0, $pop1
	i32.const	$push7=, 65535
	i32.and 	$0=, $pop2, $pop7
	i32.const	$push6=, 2
	i32.add 	$push5=, $1, $pop6
	tee_local	$push4=, $1=, $pop5
	i32.lt_u	$push3=, $pop4, $2
	br_if   	0, $pop3        # 0: up to label3
.LBB1_3:                                # %for.end
	end_loop
	end_block                       # label2:
	copy_local	$push8=, $0
                                        # fallthrough-return: $pop8
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
