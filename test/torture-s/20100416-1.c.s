	.text
	.file	"20100416-1.c"
	.section	.text.movegt,"ax",@progbits
	.hidden	movegt                  # -- Begin function movegt
	.globl	movegt
	.type	movegt,@function
movegt:                                 # @movegt
	.param  	i32, i32, i64
	.result 	i32
# %bb.0:                                # %entry
	i64.const	$push0=, -1152921504606846977
	i64.gt_s	$push1=, $2, $pop0
	i32.select	$push2=, $0, $1, $pop1
	i32.const	$push3=, 0
	i32.const	$push6=, 0
	i32.gt_s	$push4=, $1, $pop6
	i32.select	$push5=, $pop2, $pop3, $pop4
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end0:
	.size	movegt, .Lfunc_end0-movegt
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push32=, -1
	i32.const	$push31=, 1
	i32.const	$push30=, 0
	i64.load	$push0=, tests($pop30)
	i64.const	$push29=, -1152921504606846977
	i64.gt_s	$push1=, $pop0, $pop29
	i32.select	$push2=, $pop32, $pop31, $pop1
	i32.const	$push28=, 0
	i32.load	$push3=, tests+8($pop28)
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label0
# %bb.1:                                # %for.cond
	i32.const	$push37=, -1
	i32.const	$push36=, 1
	i32.const	$push35=, 0
	i64.load	$push5=, tests+16($pop35)
	i64.const	$push34=, -1152921504606846977
	i64.gt_s	$push6=, $pop5, $pop34
	i32.select	$push7=, $pop37, $pop36, $pop6
	i32.const	$push33=, 0
	i32.load	$push8=, tests+24($pop33)
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	0, $pop9        # 0: down to label0
# %bb.2:                                # %for.cond.1
	i32.const	$push42=, -1
	i32.const	$push41=, 1
	i32.const	$push40=, 0
	i64.load	$push10=, tests+32($pop40)
	i64.const	$push39=, -1152921504606846977
	i64.gt_s	$push11=, $pop10, $pop39
	i32.select	$push12=, $pop42, $pop41, $pop11
	i32.const	$push38=, 0
	i32.load	$push13=, tests+40($pop38)
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	0, $pop14       # 0: down to label0
# %bb.3:                                # %for.cond.2
	i32.const	$push47=, -1
	i32.const	$push46=, 1
	i32.const	$push45=, 0
	i64.load	$push15=, tests+48($pop45)
	i64.const	$push44=, -1152921504606846977
	i64.gt_s	$push16=, $pop15, $pop44
	i32.select	$push17=, $pop47, $pop46, $pop16
	i32.const	$push43=, 0
	i32.load	$push18=, tests+56($pop43)
	i32.ne  	$push19=, $pop17, $pop18
	br_if   	0, $pop19       # 0: down to label0
# %bb.4:                                # %for.cond.3
	i32.const	$push24=, -1
	i32.const	$push23=, 1
	i32.const	$push49=, 0
	i64.load	$push20=, tests+64($pop49)
	i64.const	$push21=, -1152921504606846977
	i64.gt_s	$push22=, $pop20, $pop21
	i32.select	$push25=, $pop24, $pop23, $pop22
	i32.const	$push48=, 0
	i32.load	$push26=, tests+72($pop48)
	i32.ne  	$push27=, $pop25, $pop26
	br_if   	0, $pop27       # 0: down to label0
# %bb.5:                                # %for.cond.4
	i32.const	$push50=, 0
	return  	$pop50
.LBB1_6:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	tests                   # @tests
	.type	tests,@object
	.section	.data.tests,"aw",@progbits
	.globl	tests
	.p2align	4
tests:
	.int64	-1152921504606846976    # 0xf000000000000000
	.int32	4294967295              # 0xffffffff
	.skip	4
	.int64	-1152921504606846977    # 0xefffffffffffffff
	.int32	1                       # 0x1
	.skip	4
	.int64	-1152921504606846975    # 0xf000000000000001
	.int32	4294967295              # 0xffffffff
	.skip	4
	.int64	0                       # 0x0
	.int32	4294967295              # 0xffffffff
	.skip	4
	.int64	-9223372036854775808    # 0x8000000000000000
	.int32	1                       # 0x1
	.skip	4
	.size	tests, 80


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
