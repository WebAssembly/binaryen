	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr36038.c"
	.globl	doit
	.type	doit,@function
doit:                                   # @doit
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, 0
	i32.load	$0=, markstack_ptr($5)
	block   	BB0_3
	i32.const	$push2=, -4
	i32.add 	$push3=, $0, $pop2
	i32.load	$1=, 0($pop3)
	i32.const	$push4=, 6
	i32.eq  	$push5=, $1, $pop4
	br_if   	$pop5, BB0_3
# BB#1:                                 # %while.body.preheader
	i32.load	$push0=, stack_base($5)
	i32.const	$push1=, 40
	i32.add 	$5=, $pop0, $pop1
	i32.const	$2=, -8
	i32.const	$push8=, -6
	i32.add 	$4=, $1, $pop8
	i32.const	$3=, 3
	i32.add 	$push6=, $0, $2
	i32.load	$push7=, 0($pop6)
	i32.shl 	$push9=, $pop7, $3
	i32.shl 	$push10=, $1, $3
	i32.sub 	$1=, $pop9, $pop10
BB0_2:                                  # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB0_3
	i32.add 	$push12=, $5, $1
	i32.const	$push13=, 16
	i32.add 	$push14=, $pop12, $pop13
	i64.load	$push11=, 0($5)
	i64.store	$discard=, 0($pop14), $pop11
	i32.add 	$5=, $5, $2
	i32.const	$push15=, 1
	i32.add 	$4=, $4, $pop15
	br_if   	$4, BB0_2
BB0_3:                                  # %while.end
	return
func_end0:
	.size	doit, func_end0-doit

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	BB1_2
	i32.const	$push8=, indices+36
	i32.store	$discard=, markstack_ptr($0), $pop8
	i32.const	$push9=, 2
	i32.store	$discard=, indices+32($0), $pop9
	i32.const	$push10=, 1
	i32.store	$discard=, indices+28($0), $pop10
	i32.const	$push11=, list+16
	i32.store	$discard=, stack_base($0), $pop11
	i64.const	$push0=, 0
	i64.store	$discard=, list($0), $pop0
	i64.const	$push2=, 1
	i64.store	$discard=, list+8($0), $pop2
	i64.const	$push3=, 2
	i64.store	$discard=, list+16($0), $pop3
	i64.const	$push4=, 3
	i64.store	$discard=, list+24($0), $pop4
	i64.const	$push7=, 9
	i64.store	$discard=, list+72($0), $pop7
	i64.const	$push12=, 7
	i64.store	$discard=, list+64($0), $pop12
	i64.const	$push13=, 6
	i64.store	$discard=, list+56($0), $pop13
	i64.const	$push14=, 5
	i64.store	$discard=, list+48($0), $pop14
	i64.const	$push5=, 4
	i64.store	$push6=, list+32($0), $pop5
	i64.store	$discard=, list+40($0), $pop6
	i32.const	$push15=, expect
	i32.const	$push1=, list
	i32.const	$push16=, 80
	i32.call	$push17=, memcmp, $pop15, $pop1, $pop16
	br_if   	$pop17, BB1_2
# BB#1:                                 # %if.end
	return  	$0
BB1_2:                                  # %if.then
	call    	abort
	unreachable
func_end1:
	.size	main, func_end1-main

	.type	expect,@object          # @expect
	.data
	.globl	expect
	.align	4
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

	.type	stack_base,@object      # @stack_base
	.bss
	.globl	stack_base
	.align	2
stack_base:
	.int32	0
	.size	stack_base, 4

	.type	markstack_ptr,@object   # @markstack_ptr
	.globl	markstack_ptr
	.align	2
markstack_ptr:
	.int32	0
	.size	markstack_ptr, 4

	.type	list,@object            # @list
	.globl	list
	.align	4
list:
	.zero	80
	.size	list, 80

	.type	indices,@object         # @indices
	.globl	indices
	.align	4
indices:
	.zero	40
	.size	indices, 40


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
