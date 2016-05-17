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
	i32.const	$push20=, 0
	i32.load	$push19=, markstack_ptr($pop20)
	tee_local	$push18=, $3=, $pop19
	i32.const	$push3=, -4
	i32.add 	$push4=, $pop18, $pop3
	i32.load	$push17=, 0($pop4)
	tee_local	$push16=, $0=, $pop17
	i32.const	$push5=, 6
	i32.eq  	$push6=, $pop16, $pop5
	br_if   	0, $pop6        # 0: down to label0
# BB#1:                                 # %while.body.preheader
	i32.const	$push23=, 0
	i32.load	$push1=, stack_base($pop23)
	i32.const	$push2=, 40
	i32.add 	$2=, $pop1, $pop2
	i32.const	$push9=, -6
	i32.add 	$1=, $0, $pop9
	i32.const	$push22=, -8
	i32.add 	$push7=, $3, $pop22
	i32.load	$push8=, 0($pop7)
	i32.const	$push10=, 3
	i32.shl 	$push11=, $pop8, $pop10
	i32.const	$push21=, 3
	i32.shl 	$push12=, $0, $pop21
	i32.sub 	$0=, $pop11, $pop12
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.add 	$push14=, $2, $0
	i32.const	$push26=, 16
	i32.add 	$push15=, $pop14, $pop26
	i64.load	$push13=, 0($2)
	i64.store	$drop=, 0($pop15), $pop13
	i32.const	$push25=, 1
	i32.add 	$1=, $1, $pop25
	i32.const	$push24=, -8
	i32.add 	$push0=, $2, $pop24
	copy_local	$2=, $pop0
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
	i32.store	$drop=, markstack_ptr($pop31), $pop8
	i32.const	$push30=, 0
	i32.const	$push9=, 2
	i32.store	$drop=, indices+32($pop30), $pop9
	i32.const	$push29=, 0
	i32.const	$push10=, 1
	i32.store	$drop=, indices+28($pop29), $pop10
	i32.const	$push28=, 0
	i32.const	$push11=, list+16
	i32.store	$drop=, stack_base($pop28), $pop11
	i32.const	$push27=, 0
	i64.const	$push1=, 0
	i64.store	$drop=, list($pop27), $pop1
	i32.const	$push26=, 0
	i64.const	$push3=, 1
	i64.store	$drop=, list+8($pop26), $pop3
	i32.const	$push25=, 0
	i64.const	$push4=, 2
	i64.store	$drop=, list+16($pop25), $pop4
	i32.const	$push24=, 0
	i64.const	$push5=, 3
	i64.store	$drop=, list+24($pop24), $pop5
	i32.const	$push23=, 0
	i64.const	$push7=, 9
	i64.store	$drop=, list+72($pop23), $pop7
	i32.const	$push22=, 0
	i64.const	$push12=, 7
	i64.store	$drop=, list+64($pop22), $pop12
	i32.const	$push21=, 0
	i64.const	$push13=, 6
	i64.store	$drop=, list+56($pop21), $pop13
	i32.const	$push20=, 0
	i64.const	$push14=, 5
	i64.store	$drop=, list+48($pop20), $pop14
	i32.const	$push19=, 0
	i32.const	$push18=, 0
	i64.const	$push6=, 4
	i64.store	$push0=, list+32($pop18), $pop6
	i64.store	$drop=, list+40($pop19), $pop0
	block
	i32.const	$push15=, expect
	i32.const	$push2=, list
	i32.const	$push16=, 80
	i32.call	$push17=, memcmp@FUNCTION, $pop15, $pop2, $pop16
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
