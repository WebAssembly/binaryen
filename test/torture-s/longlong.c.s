	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/longlong.c"
	.section	.text.alpha_ep_extbl_i_eq_0,"ax",@progbits
	.hidden	alpha_ep_extbl_i_eq_0
	.globl	alpha_ep_extbl_i_eq_0
	.type	alpha_ep_extbl_i_eq_0,@function
alpha_ep_extbl_i_eq_0:                  # @alpha_ep_extbl_i_eq_0
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push28=, 0
	i32.load	$push27=, pars($pop28)
	tee_local	$push26=, $1=, $pop27
	i32.const	$push0=, 31
	i32.and 	$push25=, $pop26, $pop0
	tee_local	$push24=, $0=, $pop25
	i32.const	$push23=, 31
	i32.eq  	$push1=, $pop24, $pop23
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.then
	i32.const	$push32=, 0
	i32.load	$push31=, r($pop32)
	tee_local	$push30=, $2=, $pop31
	i32.const	$push20=, 3
	i32.shl 	$push21=, $0, $pop20
	i32.add 	$push22=, $pop30, $pop21
	i32.const	$push2=, 2
	i32.shr_u	$push3=, $1, $pop2
	i32.const	$push4=, 248
	i32.and 	$push5=, $pop3, $pop4
	i32.add 	$push6=, $2, $pop5
	i64.load	$push7=, 0($pop6)
	i32.const	$push8=, 24
	i32.shr_u	$push9=, $1, $pop8
	i32.const	$push29=, 248
	i32.and 	$push10=, $pop9, $pop29
	i32.add 	$push11=, $2, $pop10
	i64.load	$push12=, 0($pop11)
	i64.const	$push13=, 3
	i64.shl 	$push14=, $pop12, $pop13
	i64.const	$push15=, 56
	i64.and 	$push16=, $pop14, $pop15
	i64.shr_u	$push17=, $pop7, $pop16
	i64.const	$push18=, 255
	i64.and 	$push19=, $pop17, $pop18
	i64.store	$discard=, 0($pop22), $pop19
.LBB0_2:                                # %if.end
	end_block                       # label0:
	return
	.endfunc
.Lfunc_end0:
	.size	alpha_ep_extbl_i_eq_0, .Lfunc_end0-alpha_ep_extbl_i_eq_0

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64
# BB#0:                                 # %alpha_ep_extbl_i_eq_0.exit
	i32.const	$push18=, 0
	i32.load	$0=, r($pop18)
	i32.const	$push17=, 0
	i64.const	$push0=, 3160194
	i64.store	$discard=, b+136($pop17), $pop0
	i32.const	$push16=, 0
	i64.const	$push1=, 6003104017374052362
	i64.store	$discard=, b+16($pop16):p2align=4, $pop1
	i64.load	$push3=, 16($0)
	i64.load	$push4=, 136($0)
	i64.const	$push5=, 3
	i64.shl 	$push6=, $pop4, $pop5
	i64.const	$push7=, 56
	i64.and 	$push8=, $pop6, $pop7
	i64.shr_u	$push9=, $pop3, $pop8
	i64.const	$push10=, 255
	i64.and 	$push11=, $pop9, $pop10
	i64.store	$discard=, 16($0), $pop11
	i32.const	$push15=, 0
	i64.load	$1=, b+16($pop15):p2align=4
	i32.const	$push14=, 0
	i32.const	$push2=, -2013265854
	i32.store	$discard=, pars($pop14), $pop2
	block
	i64.const	$push12=, 77
	i64.ne  	$push13=, $1, $pop12
	br_if   	0, $pop13       # 0: down to label1
# BB#1:                                 # %if.end
	i32.const	$push19=, 0
	call    	exit@FUNCTION, $pop19
	unreachable
.LBB1_2:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	4
b:
	.skip	256
	.size	b, 256

	.hidden	r                       # @r
	.type	r,@object
	.section	.data.r,"aw",@progbits
	.globl	r
	.p2align	2
r:
	.int32	b
	.size	r, 4

	.hidden	pars                    # @pars
	.type	pars,@object
	.section	.bss.pars,"aw",@nobits
	.globl	pars
	.p2align	2
pars:
	.int32	0                       # 0x0
	.size	pars, 4


	.ident	"clang version 3.9.0 "
