	.text
	.file	"pr36038.c"
	.section	.text.doit,"ax",@progbits
	.hidden	doit                    # -- Begin function doit
	.globl	doit
	.type	doit,@function
doit:                                   # @doit
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push15=, 0
	i32.load	$0=, markstack_ptr($pop15)
	i32.const	$push2=, -4
	i32.add 	$push3=, $0, $pop2
	i32.load	$1=, 0($pop3)
	block   	
	i32.const	$push4=, 6
	i32.eq  	$push5=, $1, $pop4
	br_if   	0, $pop5        # 0: down to label0
# %bb.1:                                # %while.body.lr.ph
	i32.const	$push18=, 0
	i32.load	$push0=, stack_base($pop18)
	i32.const	$push1=, 40
	i32.add 	$2=, $pop0, $pop1
	i32.const	$push17=, -8
	i32.add 	$push8=, $0, $pop17
	i32.load	$push9=, 0($pop8)
	i32.const	$push6=, 3
	i32.shl 	$push10=, $pop9, $pop6
	i32.const	$push16=, 3
	i32.shl 	$push7=, $1, $pop16
	i32.sub 	$0=, $pop10, $pop7
	i32.const	$push11=, -6
	i32.add 	$1=, $1, $pop11
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.add 	$push12=, $2, $0
	i32.const	$push21=, 16
	i32.add 	$push13=, $pop12, $pop21
	i64.load	$push14=, 0($2)
	i64.store	0($pop13), $pop14
	i32.const	$push20=, 1
	i32.add 	$1=, $1, $pop20
	i32.const	$push19=, -8
	i32.add 	$2=, $2, $pop19
	br_if   	0, $1           # 0: up to label1
.LBB0_3:                                # %while.end
	end_loop
	end_block                       # label0:
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	doit, .Lfunc_end0-doit
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push29=, 0
	i64.const	$push0=, 1
	i64.store	list+8($pop29), $pop0
	i32.const	$push28=, 0
	i64.const	$push1=, 0
	i64.store	list($pop28), $pop1
	i32.const	$push27=, 0
	i64.const	$push2=, 2
	i64.store	list+16($pop27), $pop2
	i32.const	$push26=, 0
	i64.const	$push3=, 3
	i64.store	list+24($pop26), $pop3
	i32.const	$push25=, 0
	i64.const	$push4=, 4
	i64.store	list+32($pop25), $pop4
	i32.const	$push24=, 0
	i64.const	$push5=, 9
	i64.store	list+72($pop24), $pop5
	i32.const	$push23=, 0
	i32.const	$push6=, indices+36
	i32.store	markstack_ptr($pop23), $pop6
	i32.const	$push22=, 0
	i64.const	$push7=, 8589934593
	i64.store	indices+28($pop22):p2align=2, $pop7
	i32.const	$push21=, 0
	i32.const	$push8=, list+16
	i32.store	stack_base($pop21), $pop8
	i32.const	$push20=, 0
	i64.const	$push9=, 7
	i64.store	list+64($pop20), $pop9
	i32.const	$push19=, 0
	i64.const	$push10=, 6
	i64.store	list+56($pop19), $pop10
	i32.const	$push18=, 0
	i64.const	$push11=, 5
	i64.store	list+48($pop18), $pop11
	i32.const	$push17=, 0
	i64.const	$push16=, 4
	i64.store	list+40($pop17), $pop16
	block   	
	i32.const	$push14=, expect
	i32.const	$push13=, list
	i32.const	$push12=, 80
	i32.call	$push15=, memcmp@FUNCTION, $pop14, $pop13, $pop12
	br_if   	0, $pop15       # 0: down to label2
# %bb.1:                                # %if.end
	i32.const	$push30=, 0
	return  	$pop30
.LBB1_2:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	expect                  # @expect
	.type	expect,@object
	.section	.data.expect,"aw",@progbits
	.globl	expect
	.p2align	4
expect:
	.int64	0                       # 0x0
	.int64	1                       # 0x1
	.int64	2                       # 0x2
	.int64	3                       # 0x3
	.int64	4                       # 0x4
	.int64	4                       # 0x4
	.int64	5                       # 0x5
	.int64	6                       # 0x6
	.int64	7                       # 0x7
	.int64	9                       # 0x9
	.size	expect, 80

	.hidden	stack_base              # @stack_base
	.type	stack_base,@object
	.section	.bss.stack_base,"aw",@nobits
	.globl	stack_base
	.p2align	2
stack_base:
	.int32	0
	.size	stack_base, 4

	.hidden	markstack_ptr           # @markstack_ptr
	.type	markstack_ptr,@object
	.section	.bss.markstack_ptr,"aw",@nobits
	.globl	markstack_ptr
	.p2align	2
markstack_ptr:
	.int32	0
	.size	markstack_ptr, 4

	.hidden	list                    # @list
	.type	list,@object
	.section	.bss.list,"aw",@nobits
	.globl	list
	.p2align	4
list:
	.skip	80
	.size	list, 80

	.hidden	indices                 # @indices
	.type	indices,@object
	.section	.bss.indices,"aw",@nobits
	.globl	indices
	.p2align	4
indices:
	.skip	40
	.size	indices, 40


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	memcmp, i32, i32, i32, i32
	.functype	abort, void
