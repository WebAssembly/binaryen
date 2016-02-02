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
	.endfunc
.Lfunc_end0:
	.size	init, .Lfunc_end0-init

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, f64, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$8=, __stack_pointer
	i32.load	$8=, 0($8)
	i32.const	$9=, 6144
	i32.sub 	$13=, $8, $9
	i32.const	$9=, __stack_pointer
	i32.store	$13=, 0($9), $13
	i32.const	$push1=, 1
	i32.store	$3=, 12($13), $pop1
	i32.const	$11=, 12
	i32.add 	$11=, $13, $11
	i32.const	$12=, 16
	i32.add 	$12=, $13, $12
	call    	init@FUNCTION, $11, $12
	block
	i32.load	$push0=, 12($13)
	tee_local	$push15=, $6=, $pop0
	i32.const	$push14=, 0
	i32.lt_s	$push2=, $pop15, $pop14
	br_if   	$pop2, 0        # 0: down to label1
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push17=, 0
	i32.load	$0=, pd($pop17)
	i32.const	$push16=, 0
	i32.load	$1=, pi($pop16)
	i32.const	$4=, -1
	i32.const	$5=, 0
.LBB1_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	block
	br_if   	$4, 0           # 0: down to label4
# BB#3:                                 # %if.then
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.load	$2=, 0($1)
	block
	f64.load	$push3=, 0($0)
	tee_local	$push19=, $7=, $pop3
	f64.const	$push18=, 0x0p0
	f64.le  	$push4=, $pop19, $pop18
	f64.ne  	$push5=, $7, $7
	i32.or  	$push6=, $pop4, $pop5
	br_if   	$pop6, 0        # 0: down to label5
# BB#4:                                 # %if.then3
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.const	$push21=, 0
	i32.gt_s	$push7=, $2, $pop21
	i32.const	$push20=, 0
	i32.select	$push8=, $pop7, $2, $pop20
	i32.add 	$5=, $pop8, $5
.LBB1_5:                                # %if.end8
                                        #   in Loop: Header=BB1_2 Depth=1
	end_block                       # label5:
	f64.convert_s/i32	$push9=, $2
	f64.store	$discard=, 0($0), $pop9
.LBB1_6:                                # %if.end11
                                        #   in Loop: Header=BB1_2 Depth=1
	end_block                       # label4:
	i32.add 	$4=, $4, $3
	i32.lt_s	$push10=, $4, $6
	br_if   	$pop10, 0       # 0: up to label2
# BB#7:                                 # %while.end
	end_loop                        # label3:
	i32.const	$push11=, 1234567890
	i32.ne  	$push12=, $5, $pop11
	br_if   	$pop12, 0       # 0: down to label1
# BB#8:                                 # %if.end15
	i32.const	$push13=, 0
	i32.const	$10=, 6144
	i32.add 	$13=, $13, $10
	i32.const	$10=, __stack_pointer
	i32.store	$13=, 0($10), $13
	return  	$pop13
.LBB1_9:                                # %if.then14
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	vd                      # @vd
	.type	vd,@object
	.section	.data.vd,"aw",@progbits
	.globl	vd
	.p2align	4
vd:
	.int64	4607182418800017408     # double 1
	.int64	0                       # double 0
	.size	vd, 16

	.hidden	vi                      # @vi
	.type	vi,@object
	.section	.data.vi,"aw",@progbits
	.globl	vi
	.p2align	2
vi:
	.int32	1234567890              # 0x499602d2
	.int32	0                       # 0x0
	.size	vi, 8

	.hidden	pd                      # @pd
	.type	pd,@object
	.section	.data.pd,"aw",@progbits
	.globl	pd
	.p2align	2
pd:
	.int32	vd
	.size	pd, 4

	.hidden	pi                      # @pi
	.type	pi,@object
	.section	.data.pi,"aw",@progbits
	.globl	pi
	.p2align	2
pi:
	.int32	vi
	.size	pi, 4


	.ident	"clang version 3.9.0 "
