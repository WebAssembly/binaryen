	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20120919-1.c"
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
	i32.store	0($1), $pop0
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
	.local  	i32, i32, i32, f64, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push13=, 0
	i32.const	$push10=, 0
	i32.load	$push11=, __stack_pointer($pop10)
	i32.const	$push12=, 6144
	i32.sub 	$push26=, $pop11, $pop12
	tee_local	$push25=, $7=, $pop26
	i32.store	__stack_pointer($pop13), $pop25
	i32.const	$push24=, 1
	i32.store	12($7), $pop24
	i32.const	$push17=, 12
	i32.add 	$push18=, $7, $pop17
	i32.const	$push19=, 16
	i32.add 	$push20=, $7, $pop19
	call    	init@FUNCTION, $pop18, $pop20
	block   	
	i32.load	$push23=, 12($7)
	tee_local	$push22=, $0=, $pop23
	i32.const	$push21=, 0
	i32.lt_s	$push0=, $pop22, $pop21
	br_if   	0, $pop0        # 0: down to label1
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push28=, 0
	i32.load	$2=, pi($pop28)
	i32.const	$push27=, 0
	i32.load	$1=, pd($pop27)
	i32.const	$6=, -1
	i32.const	$5=, 0
.LBB1_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	block   	
	br_if   	0, $6           # 0: down to label3
# BB#3:                                 # %if.then
                                        #   in Loop: Header=BB1_2 Depth=1
	f64.load	$3=, 0($1)
	i32.load	$push34=, 0($2)
	tee_local	$push33=, $4=, $pop34
	f64.convert_s/i32	$push1=, $pop33
	f64.store	0($1), $pop1
	i32.const	$push32=, 0
	i32.const	$push31=, 0
	i32.gt_s	$push2=, $4, $pop31
	i32.select	$push3=, $4, $pop32, $pop2
	i32.const	$push30=, 0
	f64.const	$push29=, 0x0p0
	f64.gt  	$push4=, $3, $pop29
	i32.select	$push5=, $pop3, $pop30, $pop4
	i32.add 	$5=, $pop5, $5
.LBB1_4:                                # %if.end11
                                        #   in Loop: Header=BB1_2 Depth=1
	end_block                       # label3:
	i32.const	$push37=, 1
	i32.add 	$push36=, $6, $pop37
	tee_local	$push35=, $6=, $pop36
	i32.lt_s	$push6=, $pop35, $0
	br_if   	0, $pop6        # 0: up to label2
# BB#5:                                 # %while.end
	end_loop
	i32.const	$push7=, 1234567890
	i32.ne  	$push8=, $5, $pop7
	br_if   	0, $pop8        # 0: down to label1
# BB#6:                                 # %if.end15
	i32.const	$push16=, 0
	i32.const	$push14=, 6144
	i32.add 	$push15=, $7, $pop14
	i32.store	__stack_pointer($pop16), $pop15
	i32.const	$push9=, 0
	return  	$pop9
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
