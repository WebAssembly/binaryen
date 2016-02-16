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
	.endfunc
.Lfunc_end0:
	.size	hash_find_entry, .Lfunc_end0-hash_find_entry

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push7=, 0
	i32.const	$push6=, 0
	i32.load	$push5=, foo.count($pop6)
	tee_local	$push4=, $1=, $pop5
	i32.const	$push0=, 1
	i32.add 	$push1=, $pop4, $pop0
	i32.store	$discard=, foo.count($pop7), $pop1
	block
	i32.const	$push3=, 1
	i32.ge_s	$push2=, $1, $pop3
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push8=, 0
	return  	$pop8
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
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
	i32.call	$discard=, hash_find_entry@FUNCTION, $5
.LBB2_1:                                # %if.end
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_2 Depth 2
	loop                            # label1:
	i32.load	$1=, 12($7)
	i32.call	$discard=, foo@FUNCTION, $1
	i32.const	$0=, 0
	block
	i32.const	$push3=, 0
	i32.eq  	$push4=, $1, $pop3
	br_if   	0, $pop4        # 0: down to label3
.LBB2_2:                                # %while.body
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label4:
	i32.const	$push2=, -1
	i32.add 	$1=, $1, $pop2
	i32.const	$push1=, 8
	i32.add 	$0=, $0, $pop1
	br_if   	0, $1           # 0: up to label4
.LBB2_3:                                # %cleanup.thread
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label5:
	end_block                       # label3:
	i32.const	$6=, 12
	i32.add 	$6=, $7, $6
	i32.call	$discard=, hash_find_entry@FUNCTION, $6
	i32.const	$push5=, 0
	i32.eq  	$push6=, $0, $pop5
	br_if   	0, $pop6        # 0: up to label1
# BB#4:                                 # %for.end
	end_loop                        # label2:
	i32.const	$push0=, 0
	i32.const	$4=, 16
	i32.add 	$7=, $7, $4
	i32.const	$4=, __stack_pointer
	i32.store	$7=, 0($4), $7
	return  	$pop0
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	foo.count,@object       # @foo.count
	.lcomm	foo.count,4,2

	.ident	"clang version 3.9.0 "
