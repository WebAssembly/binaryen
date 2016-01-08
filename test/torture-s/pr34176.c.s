	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr34176.c"
	.section	.text.hash_find_entry,"ax",@progbits
	.hidden	hash_find_entry
	.globl	hash_find_entry
	.type	hash_find_entry,@function
hash_find_entry:                        # @hash_find_entry
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 2
	i32.store	$discard=, 0($0), $pop0
	i32.const	$push1=, 0
	return  	$pop1
.Lfunc_end0:
	.size	hash_find_entry, .Lfunc_end0-hash_find_entry

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.load	$2=, foo.count($1)
	i32.const	$3=, 1
	block   	.LBB1_2
	i32.add 	$push0=, $2, $3
	i32.store	$discard=, foo.count($1), $pop0
	i32.ge_s	$push1=, $2, $3
	br_if   	$pop1, .LBB1_2
# BB#1:                                 # %if.end
	return  	$1
.LBB1_2:                                # %if.then
	call    	abort
	unreachable
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$7=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$7=, 0($3), $7
	i32.const	$5=, 12
	i32.add 	$5=, $7, $5
	i32.call	$discard=, hash_find_entry, $5
.LBB2_1:                                # %if.end
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_2 Depth 2
	loop    	.LBB2_4
	i32.load	$1=, 12($7)
	i32.call	$discard=, foo, $1
	i32.const	$0=, 0
	block   	.LBB2_3
	i32.const	$push3=, 0
	i32.eq  	$push4=, $1, $pop3
	br_if   	$pop4, .LBB2_3
.LBB2_2:                                # %while.body
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	.LBB2_3
	i32.const	$push0=, -1
	i32.add 	$1=, $1, $pop0
	i32.const	$push1=, 8
	i32.add 	$0=, $0, $pop1
	br_if   	$1, .LBB2_2
.LBB2_3:                                # %cleanup.thread
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$6=, 12
	i32.add 	$6=, $7, $6
	i32.call	$discard=, hash_find_entry, $6
	i32.const	$push5=, 0
	i32.eq  	$push6=, $0, $pop5
	br_if   	$pop6, .LBB2_1
.LBB2_4:                                # %for.end
	i32.const	$push2=, 0
	i32.const	$4=, 16
	i32.add 	$7=, $7, $4
	i32.const	$4=, __stack_pointer
	i32.store	$7=, 0($4), $7
	return  	$pop2
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	foo.count,@object       # @foo.count
	.lcomm	foo.count,4,2

	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
