	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/930930-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i32, i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	block   	
	block   	
	i32.lt_u	$push0=, $3, $4
	br_if   	0, $pop0        # 0: down to label1
# BB#1:                                 # %if.end.preheader
	copy_local	$6=, $0
.LBB0_2:                                # %if.end
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	block   	
	i32.load	$push6=, 0($3)
	tee_local	$push5=, $5=, $pop6
	i32.ge_u	$push1=, $pop5, $2
	br_if   	0, $pop1        # 0: down to label3
# BB#3:                                 # %if.end
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.lt_u	$push2=, $5, $1
	br_if   	0, $pop2        # 0: down to label3
# BB#4:                                 # %if.then3
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push9=, -4
	i32.add 	$push8=, $6, $pop9
	tee_local	$push7=, $6=, $pop8
	i32.store	0($pop7), $5
.LBB0_5:                                # %if.end4
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label3:
	i32.const	$push12=, -4
	i32.add 	$push11=, $3, $pop12
	tee_local	$push10=, $3=, $pop11
	i32.ge_u	$push3=, $pop10, $4
	br_if   	0, $pop3        # 0: up to label2
# BB#6:                                 # %out
	end_loop
	i32.ne  	$push4=, $6, $0
	br_if   	1, $pop4        # 1: down to label0
.LBB0_7:                                # %if.end8
	end_block                       # label1:
	return  	$3
.LBB0_8:                                # %if.then7
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, mem
	i32.store	mem+396($pop1), $pop0
	i32.const	$push5=, mem+400
	i32.const	$push4=, mem+24
	i32.const	$push3=, mem+32
	i32.const	$push2=, mem+396
	i32.const	$push7=, mem+396
	i32.call	$drop=, f@FUNCTION, $pop5, $pop4, $pop3, $pop2, $pop7
	i32.const	$push6=, 0
	call    	exit@FUNCTION, $pop6
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	mem                     # @mem
	.type	mem,@object
	.section	.bss.mem,"aw",@nobits
	.globl	mem
	.p2align	4
mem:
	.skip	400
	.size	mem, 400

	.hidden	wm_TR                   # @wm_TR
	.type	wm_TR,@object
	.section	.bss.wm_TR,"aw",@nobits
	.globl	wm_TR
	.p2align	2
wm_TR:
	.int32	0
	.size	wm_TR, 4

	.hidden	wm_HB                   # @wm_HB
	.type	wm_HB,@object
	.section	.bss.wm_HB,"aw",@nobits
	.globl	wm_HB
	.p2align	2
wm_HB:
	.int32	0
	.size	wm_HB, 4

	.hidden	wm_SPB                  # @wm_SPB
	.type	wm_SPB,@object
	.section	.bss.wm_SPB,"aw",@nobits
	.globl	wm_SPB
	.p2align	2
wm_SPB:
	.int32	0
	.size	wm_SPB, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
