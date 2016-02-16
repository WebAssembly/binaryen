	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr36038.c"
	.section	.text.doit,"ax",@progbits
	.hidden	doit
	.globl	doit
	.type	doit,@function
doit:                                   # @doit
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push19=, 0
	i32.load	$push18=, markstack_ptr($pop19)
	tee_local	$push17=, $3=, $pop18
	i32.const	$push2=, -4
	i32.add 	$push3=, $pop17, $pop2
	i32.load	$push16=, 0($pop3)
	tee_local	$push15=, $0=, $pop16
	i32.const	$push4=, 6
	i32.eq  	$push5=, $pop15, $pop4
	br_if   	0, $pop5        # 0: down to label0
# BB#1:                                 # %while.body.preheader
	i32.const	$push22=, 0
	i32.load	$push0=, stack_base($pop22)
	i32.const	$push1=, 40
	i32.add 	$2=, $pop0, $pop1
	i32.const	$push8=, -6
	i32.add 	$1=, $0, $pop8
	i32.const	$push21=, -8
	i32.add 	$push6=, $3, $pop21
	i32.load	$push7=, 0($pop6)
	i32.const	$push9=, 3
	i32.shl 	$push10=, $pop7, $pop9
	i32.const	$push20=, 3
	i32.shl 	$push11=, $0, $pop20
	i32.sub 	$0=, $pop10, $pop11
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.add 	$push13=, $2, $0
	i32.const	$push25=, 16
	i32.add 	$push14=, $pop13, $pop25
	i64.load	$push12=, 0($2)
	i64.store	$discard=, 0($pop14), $pop12
	i32.const	$push24=, -8
	i32.add 	$2=, $2, $pop24
	i32.const	$push23=, 1
	i32.add 	$1=, $1, $pop23
	br_if   	0, $1           # 0: up to label1
.LBB0_3:                                # %while.end
	end_loop                        # label2:
	end_block                       # label0:
	return
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
	i32.const	$push8=, indices+36
	i32.store	$discard=, markstack_ptr($pop31), $pop8
	i32.const	$push30=, 0
	i32.const	$push9=, 2
	i32.store	$discard=, indices+32($pop30):p2align=4, $pop9
	i32.const	$push29=, 0
	i32.const	$push10=, 1
	i32.store	$discard=, indices+28($pop29), $pop10
	i32.const	$push28=, 0
	i32.const	$push11=, list+16
	i32.store	$discard=, stack_base($pop28), $pop11
	i32.const	$push27=, 0
	i64.const	$push0=, 0
	i64.store	$discard=, list($pop27):p2align=4, $pop0
	i32.const	$push26=, 0
	i64.const	$push2=, 1
	i64.store	$discard=, list+8($pop26), $pop2
	i32.const	$push25=, 0
	i64.const	$push3=, 2
	i64.store	$discard=, list+16($pop25):p2align=4, $pop3
	i32.const	$push24=, 0
	i64.const	$push4=, 3
	i64.store	$discard=, list+24($pop24), $pop4
	i32.const	$push23=, 0
	i64.const	$push7=, 9
	i64.store	$discard=, list+72($pop23), $pop7
	i32.const	$push22=, 0
	i64.const	$push12=, 7
	i64.store	$discard=, list+64($pop22):p2align=4, $pop12
	i32.const	$push21=, 0
	i64.const	$push13=, 6
	i64.store	$discard=, list+56($pop21), $pop13
	i32.const	$push20=, 0
	i64.const	$push14=, 5
	i64.store	$discard=, list+48($pop20):p2align=4, $pop14
	i32.const	$push19=, 0
	i32.const	$push18=, 0
	i64.const	$push5=, 4
	i64.store	$push6=, list+32($pop18):p2align=4, $pop5
	i64.store	$discard=, list+40($pop19), $pop6
	block
	i32.const	$push15=, expect
	i32.const	$push1=, list
	i32.const	$push16=, 80
	i32.call	$push17=, memcmp@FUNCTION, $pop15, $pop1, $pop16
	br_if   	0, $pop17       # 0: down to label3
# BB#1:                                 # %if.end
	i32.const	$push32=, 0
	return  	$pop32
.LBB1_2:                                # %if.then
	end_block                       # label3:
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


	.ident	"clang version 3.9.0 "
