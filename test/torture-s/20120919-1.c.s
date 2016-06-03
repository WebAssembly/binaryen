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
	br_if   	0, $0           # 0: down to label0
# BB#1:                                 # %if.then
	i32.const	$push0=, 0
	i32.store	$drop=, 0($1), $pop0
.LBB0_2:                                # %if.end
	end_block                       # label0:
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	init, .Lfunc_end0-init

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, f64, i32
# BB#0:                                 # %entry
	i32.const	$push15=, 0
	i32.const	$push12=, 0
	i32.load	$push13=, __stack_pointer($pop12)
	i32.const	$push14=, 6144
	i32.sub 	$push23=, $pop13, $pop14
	i32.store	$push28=, __stack_pointer($pop15), $pop23
	tee_local	$push27=, $1=, $pop28
	i32.const	$push0=, 1
	i32.store	$0=, 12($pop27), $pop0
	i32.const	$push19=, 12
	i32.add 	$push20=, $1, $pop19
	i32.const	$push21=, 16
	i32.add 	$push22=, $1, $pop21
	call    	init@FUNCTION, $pop20, $pop22
	block
	i32.load	$push26=, 12($1)
	tee_local	$push25=, $2=, $pop26
	i32.const	$push24=, 0
	i32.lt_s	$push1=, $pop25, $pop24
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push30=, 0
	i32.load	$4=, pi($pop30)
	i32.const	$push29=, 0
	i32.load	$3=, pd($pop29)
	i32.const	$8=, -1
	i32.const	$5=, 0
.LBB1_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	block
	br_if   	0, $8           # 0: down to label4
# BB#3:                                 # %if.then
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.load	$6=, 0($4)
	block
	f64.load	$push33=, 0($3)
	tee_local	$push32=, $7=, $pop33
	f64.const	$push31=, 0x0p0
	f64.le  	$push2=, $pop32, $pop31
	f64.ne  	$push3=, $7, $7
	i32.or  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label5
# BB#4:                                 # %if.then3
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.const	$push35=, 0
	i32.const	$push34=, 0
	i32.gt_s	$push5=, $6, $pop34
	i32.select	$push6=, $6, $pop35, $pop5
	i32.add 	$5=, $pop6, $5
.LBB1_5:                                # %if.end8
                                        #   in Loop: Header=BB1_2 Depth=1
	end_block                       # label5:
	f64.convert_s/i32	$push7=, $6
	f64.store	$drop=, 0($3), $pop7
.LBB1_6:                                # %if.end11
                                        #   in Loop: Header=BB1_2 Depth=1
	end_block                       # label4:
	i32.add 	$push37=, $8, $0
	tee_local	$push36=, $8=, $pop37
	i32.lt_s	$push8=, $pop36, $2
	br_if   	0, $pop8        # 0: up to label2
# BB#7:                                 # %while.end
	end_loop                        # label3:
	i32.const	$push9=, 1234567890
	i32.ne  	$push10=, $5, $pop9
	br_if   	0, $pop10       # 0: down to label1
# BB#8:                                 # %if.end15
	i32.const	$push18=, 0
	i32.const	$push16=, 6144
	i32.add 	$push17=, $1, $pop16
	i32.store	$drop=, __stack_pointer($pop18), $pop17
	i32.const	$push11=, 0
	return  	$pop11
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
	.functype	abort, void
