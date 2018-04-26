	.text
	.file	"pr34176.c"
	.section	.text.hash_find_entry,"ax",@progbits
	.hidden	hash_find_entry         # -- Begin function hash_find_entry
	.globl	hash_find_entry
	.type	hash_find_entry,@function
hash_find_entry:                        # @hash_find_entry
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 2
	i32.store	0($0), $pop0
	i32.const	$push1=, 0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end0:
	.size	hash_find_entry, .Lfunc_end0-hash_find_entry
                                        # -- End function
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push5=, 0
	i32.load	$1=, foo.count($pop5)
	i32.const	$push4=, 0
	i32.const	$push0=, 1
	i32.add 	$push1=, $1, $pop0
	i32.store	foo.count($pop4), $pop1
	block   	
	i32.const	$push3=, 1
	i32.ge_s	$push2=, $1, $pop3
	br_if   	0, $pop2        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push6=, 0
	return  	$pop6
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push2=, 0
	i32.load	$push1=, __stack_pointer($pop2)
	i32.const	$push3=, 16
	i32.sub 	$2=, $pop1, $pop3
	i32.const	$push4=, 0
	i32.store	__stack_pointer($pop4), $2
	i32.const	$push8=, 12
	i32.add 	$push9=, $2, $pop8
	i32.call	$drop=, hash_find_entry@FUNCTION, $pop9
.LBB2_1:                                # %if.end
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_2 Depth 2
	loop    	                # label1:
	i32.load	$0=, 12($2)
	i32.call	$drop=, foo@FUNCTION, $0
	i32.const	$1=, 0
	block   	
	i32.eqz 	$push14=, $0
	br_if   	0, $pop14       # 0: down to label2
.LBB2_2:                                # %while.body
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label3:
	i32.const	$push13=, 8
	i32.add 	$1=, $1, $pop13
	i32.const	$push12=, -1
	i32.add 	$0=, $0, $pop12
	br_if   	0, $0           # 0: up to label3
.LBB2_3:                                # %cleanup.cont7
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop
	end_block                       # label2:
	i32.const	$push10=, 12
	i32.add 	$push11=, $2, $pop10
	i32.call	$drop=, hash_find_entry@FUNCTION, $pop11
	i32.eqz 	$push15=, $1
	br_if   	0, $pop15       # 0: up to label1
# %bb.4:                                # %for.end
	end_loop
	i32.const	$push7=, 0
	i32.const	$push5=, 16
	i32.add 	$push6=, $2, $pop5
	i32.store	__stack_pointer($pop7), $pop6
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.type	foo.count,@object       # @foo.count
	.section	.bss.foo.count,"aw",@nobits
	.p2align	2
foo.count:
	.int32	0                       # 0x0
	.size	foo.count, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
