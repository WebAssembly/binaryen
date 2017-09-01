	.text
	.file	"20120919-1.c"
	.section	.text.init,"ax",@progbits
	.hidden	init                    # -- Begin function init
	.globl	init
	.type	init,@function
init:                                   # @init
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	
	i32.eqz 	$push1=, $0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	i32.const	$push0=, 0
	i32.store	0($1), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	init, .Lfunc_end0-init
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, f64, i32, i32
# BB#0:                                 # %entry
	i32.const	$push14=, 0
	i32.const	$push12=, 0
	i32.load	$push11=, __stack_pointer($pop12)
	i32.const	$push13=, 6144
	i32.sub 	$push27=, $pop11, $pop13
	tee_local	$push26=, $7=, $pop27
	i32.store	__stack_pointer($pop14), $pop26
	i32.const	$push25=, 1
	i32.store	12($7), $pop25
	i32.const	$push18=, 12
	i32.add 	$push19=, $7, $pop18
	i32.const	$push20=, 16
	i32.add 	$push21=, $7, $pop20
	call    	init@FUNCTION, $pop19, $pop21
	block   	
	i32.load	$push24=, 12($7)
	tee_local	$push23=, $0=, $pop24
	i32.const	$push22=, 0
	i32.lt_s	$push0=, $pop23, $pop22
	br_if   	0, $pop0        # 0: down to label1
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push29=, 0
	i32.load	$2=, pi($pop29)
	i32.const	$push28=, 0
	i32.load	$1=, pd($pop28)
	i32.const	$6=, -1
	i32.const	$3=, 0
.LBB1_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	block   	
	br_if   	0, $6           # 0: down to label3
# BB#3:                                 # %if.then
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.load	$4=, 0($2)
	block   	
	f64.load	$push32=, 0($1)
	tee_local	$push31=, $5=, $pop32
	f64.const	$push30=, 0x0p0
	f64.le  	$push1=, $pop31, $pop30
	f64.ne  	$push2=, $5, $5
	i32.or  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label4
# BB#4:                                 # %if.then3
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.const	$push34=, 0
	i32.const	$push33=, 0
	i32.gt_s	$push4=, $4, $pop33
	i32.select	$push5=, $4, $pop34, $pop4
	i32.add 	$3=, $pop5, $3
.LBB1_5:                                # %if.end8
                                        #   in Loop: Header=BB1_2 Depth=1
	end_block                       # label4:
	f64.convert_s/i32	$push6=, $4
	f64.store	0($1), $pop6
.LBB1_6:                                # %if.end11
                                        #   in Loop: Header=BB1_2 Depth=1
	end_block                       # label3:
	i32.const	$push37=, 1
	i32.add 	$push36=, $6, $pop37
	tee_local	$push35=, $6=, $pop36
	i32.lt_s	$push7=, $pop35, $0
	br_if   	0, $pop7        # 0: up to label2
# BB#7:                                 # %while.end
	end_loop
	i32.const	$push8=, 1234567890
	i32.ne  	$push9=, $3, $pop8
	br_if   	0, $pop9        # 0: down to label1
# BB#8:                                 # %if.end15
	i32.const	$push17=, 0
	i32.const	$push15=, 6144
	i32.add 	$push16=, $7, $pop15
	i32.store	__stack_pointer($pop17), $pop16
	i32.const	$push10=, 0
	return  	$pop10
.LBB1_9:                                # %if.then14
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
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


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
