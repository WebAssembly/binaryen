	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr36038.c"
	.section	.text.doit,"ax",@progbits
	.hidden	doit
	.globl	doit
	.type	doit,@function
doit:                                   # @doit
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push19=, 0
	i32.load	$push18=, markstack_ptr($pop19)
	tee_local	$push17=, $0=, $pop18
	i32.const	$push2=, -4
	i32.add 	$push3=, $pop17, $pop2
	i32.load	$push16=, 0($pop3)
	tee_local	$push15=, $1=, $pop16
	i32.const	$push4=, 6
	i32.eq  	$push5=, $pop15, $pop4
	br_if   	0, $pop5        # 0: down to label0
# BB#1:                                 # %while.body.preheader
	i32.const	$push22=, 0
	i32.load	$push0=, stack_base($pop22)
	i32.const	$push1=, 40
	i32.add 	$2=, $pop0, $pop1
	i32.const	$push21=, -8
	i32.add 	$push8=, $0, $pop21
	i32.load	$push9=, 0($pop8)
	i32.const	$push6=, 3
	i32.shl 	$push10=, $pop9, $pop6
	i32.const	$push20=, 3
	i32.shl 	$push7=, $1, $pop20
	i32.sub 	$0=, $pop10, $pop7
	i32.const	$push11=, -6
	i32.add 	$1=, $1, $pop11
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.add 	$push12=, $2, $0
	i32.const	$push27=, 16
	i32.add 	$push13=, $pop12, $pop27
	i64.load	$push14=, 0($2)
	i64.store	0($pop13), $pop14
	i32.const	$push26=, -8
	i32.add 	$2=, $2, $pop26
	i32.const	$push25=, 1
	i32.add 	$push24=, $1, $pop25
	tee_local	$push23=, $1=, $pop24
	br_if   	0, $pop23       # 0: up to label1
.LBB0_3:                                # %while.end
	end_loop
	end_block                       # label0:
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	doit, .Lfunc_end0-doit

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push31=, 0
	i64.const	$push0=, 1
	i64.store	list+8($pop31), $pop0
	i32.const	$push30=, 0
	i64.const	$push1=, 0
	i64.store	list($pop30), $pop1
	i32.const	$push29=, 0
	i64.const	$push2=, 2
	i64.store	list+16($pop29), $pop2
	i32.const	$push28=, 0
	i64.const	$push3=, 3
	i64.store	list+24($pop28), $pop3
	i32.const	$push27=, 0
	i64.const	$push4=, 4
	i64.store	list+32($pop27), $pop4
	i32.const	$push26=, 0
	i64.const	$push5=, 9
	i64.store	list+72($pop26), $pop5
	i32.const	$push25=, 0
	i32.const	$push6=, indices+36
	i32.store	markstack_ptr($pop25), $pop6
	i32.const	$push24=, 0
	i32.const	$push7=, 2
	i32.store	indices+32($pop24), $pop7
	i32.const	$push23=, 0
	i32.const	$push8=, 1
	i32.store	indices+28($pop23), $pop8
	i32.const	$push22=, 0
	i32.const	$push9=, list+16
	i32.store	stack_base($pop22), $pop9
	i32.const	$push21=, 0
	i64.const	$push10=, 7
	i64.store	list+64($pop21), $pop10
	i32.const	$push20=, 0
	i64.const	$push11=, 6
	i64.store	list+56($pop20), $pop11
	i32.const	$push19=, 0
	i64.const	$push12=, 5
	i64.store	list+48($pop19), $pop12
	i32.const	$push18=, 0
	i64.const	$push17=, 4
	i64.store	list+40($pop18), $pop17
	block   	
	i32.const	$push15=, expect
	i32.const	$push14=, list
	i32.const	$push13=, 80
	i32.call	$push16=, memcmp@FUNCTION, $pop15, $pop14, $pop13
	br_if   	0, $pop16       # 0: down to label2
# BB#1:                                 # %if.end
	i32.const	$push32=, 0
	return  	$pop32
.LBB1_2:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	memcmp, i32, i32, i32, i32
	.functype	abort, void
