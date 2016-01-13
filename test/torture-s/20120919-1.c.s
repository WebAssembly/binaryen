	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20120919-1.c"
	.section	.text.init,"ax",@progbits
	.hidden	init
	.globl	init
	.type	init,@function
init:                                   # @init
	.param  	i32, i32
# BB#0:                                 # %entry
	block
	br_if   	$0, 0           # 0: down to label0
# BB#1:                                 # %if.then
	i32.const	$push0=, 0
	i32.store	$discard=, 0($1), $pop0
.LBB0_2:                                # %if.end
	end_block                       # label0:
	return
.Lfunc_end0:
	.size	init, .Lfunc_end0-init

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, f64, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$9=, __stack_pointer
	i32.load	$9=, 0($9)
	i32.const	$10=, 6144
	i32.sub 	$14=, $9, $10
	i32.const	$10=, __stack_pointer
	i32.store	$14=, 0($10), $14
	i32.const	$push0=, 1
	i32.store	$4=, 12($14), $pop0
	i32.const	$12=, 12
	i32.add 	$12=, $14, $12
	i32.const	$13=, 16
	i32.add 	$13=, $14, $13
	call    	init@FUNCTION, $12, $13
	i32.load	$0=, 12($14)
	i32.const	$8=, 0
	block
	i32.lt_s	$push1=, $0, $8
	br_if   	$pop1, 0        # 0: down to label1
# BB#1:                                 # %while.body.lr.ph
	i32.load	$1=, pd($8)
	i32.load	$2=, pi($8)
	i32.const	$7=, -1
.LBB1_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	block
	br_if   	$7, 0           # 0: down to label4
# BB#3:                                 # %if.then
                                        #   in Loop: Header=BB1_2 Depth=1
	f64.load	$5=, 0($1)
	i32.load	$3=, 0($2)
	block
	f64.const	$push2=, 0x0p0
	f64.le  	$push3=, $5, $pop2
	f64.ne  	$push4=, $5, $5
	i32.or  	$push5=, $pop3, $pop4
	br_if   	$pop5, 0        # 0: down to label5
# BB#4:                                 # %if.then3
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.const	$6=, 0
	i32.gt_s	$push6=, $3, $6
	i32.select	$push7=, $pop6, $3, $6
	i32.add 	$8=, $pop7, $8
.LBB1_5:                                # %if.end8
                                        #   in Loop: Header=BB1_2 Depth=1
	end_block                       # label5:
	f64.convert_s/i32	$push8=, $3
	f64.store	$discard=, 0($1), $pop8
.LBB1_6:                                # %if.end11
                                        #   in Loop: Header=BB1_2 Depth=1
	end_block                       # label4:
	i32.add 	$7=, $7, $4
	i32.lt_s	$push9=, $7, $0
	br_if   	$pop9, 0        # 0: up to label2
# BB#7:                                 # %while.end
	end_loop                        # label3:
	i32.const	$push10=, 1234567890
	i32.ne  	$push11=, $8, $pop10
	br_if   	$pop11, 0       # 0: down to label1
# BB#8:                                 # %if.end15
	i32.const	$push12=, 0
	i32.const	$11=, 6144
	i32.add 	$14=, $14, $11
	i32.const	$11=, __stack_pointer
	i32.store	$14=, 0($11), $14
	return  	$pop12
.LBB1_9:                                # %if.then14
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	vd                      # @vd
	.type	vd,@object
	.section	.data.vd,"aw",@progbits
	.globl	vd
	.align	4
vd:
	.int64	4607182418800017408     # double 1
	.int64	0                       # double 0
	.size	vd, 16

	.hidden	vi                      # @vi
	.type	vi,@object
	.section	.data.vi,"aw",@progbits
	.globl	vi
	.align	2
vi:
	.int32	1234567890              # 0x499602d2
	.int32	0                       # 0x0
	.size	vi, 8

	.hidden	pd                      # @pd
	.type	pd,@object
	.section	.data.pd,"aw",@progbits
	.globl	pd
	.align	2
pd:
	.int32	vd
	.size	pd, 4

	.hidden	pi                      # @pi
	.type	pi,@object
	.section	.data.pi,"aw",@progbits
	.globl	pi
	.align	2
pi:
	.int32	vi
	.size	pi, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
