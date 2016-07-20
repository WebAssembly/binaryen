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
	.local  	i32, i32, i32, i32, i32, f64, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push14=, 0
	i32.const	$push11=, 0
	i32.load	$push12=, __stack_pointer($pop11)
	i32.const	$push13=, 6144
	i32.sub 	$push22=, $pop12, $pop13
	i32.store	$push27=, __stack_pointer($pop14), $pop22
	tee_local	$push26=, $1=, $pop27
	i32.const	$push0=, 1
	i32.store	$0=, 12($pop26), $pop0
	i32.const	$push18=, 12
	i32.add 	$push19=, $1, $pop18
	i32.const	$push20=, 16
	i32.add 	$push21=, $1, $pop20
	call    	init@FUNCTION, $pop19, $pop21
	block
	i32.load	$push25=, 12($1)
	tee_local	$push24=, $2=, $pop25
	i32.const	$push23=, 0
	i32.lt_s	$push1=, $pop24, $pop23
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push29=, 0
	i32.load	$4=, pi($pop29)
	i32.const	$push28=, 0
	i32.load	$3=, pd($pop28)
	i32.const	$8=, -1
	i32.const	$7=, 0
.LBB1_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	block
	br_if   	0, $8           # 0: down to label4
# BB#3:                                 # %if.then
                                        #   in Loop: Header=BB1_2 Depth=1
	f64.load	$5=, 0($3)
	i32.load	$push35=, 0($4)
	tee_local	$push34=, $6=, $pop35
	f64.convert_s/i32	$push2=, $pop34
	f64.store	$drop=, 0($3), $pop2
	i32.const	$push33=, 0
	i32.const	$push32=, 0
	i32.gt_s	$push3=, $6, $pop32
	i32.select	$push4=, $6, $pop33, $pop3
	i32.const	$push31=, 0
	f64.const	$push30=, 0x0p0
	f64.gt  	$push5=, $5, $pop30
	i32.select	$push6=, $pop4, $pop31, $pop5
	i32.add 	$7=, $pop6, $7
.LBB1_4:                                # %if.end11
                                        #   in Loop: Header=BB1_2 Depth=1
	end_block                       # label4:
	i32.add 	$push37=, $8, $0
	tee_local	$push36=, $8=, $pop37
	i32.lt_s	$push7=, $pop36, $2
	br_if   	0, $pop7        # 0: up to label2
# BB#5:                                 # %while.end
	end_loop                        # label3:
	i32.const	$push8=, 1234567890
	i32.ne  	$push9=, $7, $pop8
	br_if   	0, $pop9        # 0: down to label1
# BB#6:                                 # %if.end15
	i32.const	$push17=, 0
	i32.const	$push15=, 6144
	i32.add 	$push16=, $1, $pop15
	i32.store	$drop=, __stack_pointer($pop17), $pop16
	i32.const	$push10=, 0
	return  	$pop10
.LBB1_7:                                # %if.then14
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


	.ident	"clang version 4.0.0 "
	.functype	abort, void
