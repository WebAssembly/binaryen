	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/930930-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i32, i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	copy_local	$5=, $0
	block
	block
	i32.lt_u	$push0=, $3, $4
	br_if   	0, $pop0        # 0: down to label1
.LBB0_1:                                # %if.end
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	block
	i32.load	$push8=, 0($3)
	tee_local	$push7=, $6=, $pop8
	i32.ge_u	$push1=, $pop7, $2
	br_if   	0, $pop1        # 0: down to label4
# BB#2:                                 # %if.end
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.lt_u	$push2=, $6, $1
	br_if   	0, $pop2        # 0: down to label4
# BB#3:                                 # %if.then3
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push3=, -4
	i32.add 	$5=, $5, $pop3
	i32.store	$discard=, 0($5), $6
.LBB0_4:                                # %if.end4
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label4:
	i32.const	$push4=, -4
	i32.add 	$3=, $3, $pop4
	i32.ge_u	$push5=, $3, $4
	br_if   	0, $pop5        # 0: up to label2
# BB#5:                                 # %out
	end_loop                        # label3:
	i32.ne  	$push6=, $5, $0
	br_if   	1, $pop6        # 1: down to label0
.LBB0_6:                                # %if.end8
	end_block                       # label1:
	return  	$3
.LBB0_7:                                # %if.then7
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
# BB#0:                                 # %f.exit
	i32.const	$push1=, 0
	i32.const	$push0=, mem
	i32.store	$discard=, mem+396($pop1), $pop0
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
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


	.ident	"clang version 3.9.0 "
