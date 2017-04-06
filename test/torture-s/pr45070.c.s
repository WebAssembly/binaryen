	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr45070.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push10=, 0
	i32.const	$push8=, 0
	i32.load	$push7=, __stack_pointer($pop8)
	i32.const	$push9=, 16
	i32.sub 	$push16=, $pop7, $pop9
	tee_local	$push15=, $3=, $pop16
	i32.store	__stack_pointer($pop10), $pop15
	i32.const	$2=, 0
	i32.const	$push14=, 0
	i32.store	8($3), $pop14
	i64.const	$push0=, 0
	i64.store	0($3), $pop0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label1:
	i32.call	$1=, next@FUNCTION, $3
	block   	
	copy_local	$push18=, $2
	tee_local	$push17=, $0=, $pop18
	br_if   	0, $pop17       # 0: down to label2
# BB#2:                                 # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push20=, 65535
	i32.and 	$push1=, $1, $pop20
	i32.const	$push19=, 65535
	i32.ne  	$push2=, $pop1, $pop19
	br_if   	2, $pop2        # 2: down to label0
.LBB0_3:                                # %lor.lhs.false
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	block   	
	i32.const	$push21=, 1
	i32.lt_s	$push3=, $0, $pop21
	br_if   	0, $pop3        # 0: down to label3
# BB#4:                                 # %lor.lhs.false
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push22=, 65535
	i32.and 	$push4=, $1, $pop22
	br_if   	2, $pop4        # 2: down to label0
.LBB0_5:                                # %for.cond
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label3:
	i32.const	$push24=, 1
	i32.add 	$2=, $0, $pop24
	i32.const	$push23=, 14
	i32.le_s	$push5=, $0, $pop23
	br_if   	0, $pop5        # 0: up to label1
# BB#6:                                 # %for.end
	end_loop
	i32.const	$push13=, 0
	i32.const	$push11=, 16
	i32.add 	$push12=, $3, $pop11
	i32.store	__stack_pointer($pop13), $pop12
	i32.const	$push6=, 0
	return  	$pop6
.LBB0_7:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.next,"ax",@progbits
	.type	next,@function
next:                                   # @next
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 0
	block   	
	block   	
	i32.load	$push1=, 0($0)
	i32.load	$push0=, 4($0)
	i32.lt_s	$push2=, $pop1, $pop0
	br_if   	0, $pop2        # 0: down to label5
# BB#1:                                 # %if.then.lr.ph
	i32.const	$push3=, 8
	i32.add 	$1=, $0, $pop3
	i32.const	$push5=, 4
	i32.add 	$2=, $0, $pop5
.LBB1_2:                                # %if.then
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label6:
	i32.load	$push4=, 0($1)
	i32.eqz 	$push14=, $pop4
	br_if   	2, $pop14       # 2: down to label4
# BB#3:                                 # %if.then1
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.const	$3=, 0
	i32.const	$push13=, 0
	i32.store	0($1), $pop13
	call    	fetch@FUNCTION, $0
	i32.load	$push7=, 0($0)
	i32.load	$push6=, 0($2)
	i32.ge_s	$push8=, $pop7, $pop6
	br_if   	0, $pop8        # 0: up to label6
.LBB1_4:                                # %cleanup
	end_loop
	end_block                       # label5:
	return  	$3
.LBB1_5:                                # %if.end
	end_block                       # label4:
	i32.const	$push9=, 8
	i32.add 	$push10=, $0, $pop9
	i32.const	$push11=, 1
	i32.store	0($pop10), $pop11
	i32.const	$push12=, 65535
                                        # fallthrough-return: $pop12
	.endfunc
.Lfunc_end1:
	.size	next, .Lfunc_end1-next

	.section	.text.fetch,"ax",@progbits
	.type	fetch,@function
fetch:                                  # @fetch
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 128
	i32.store	4($0), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	fetch, .Lfunc_end2-fetch


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
	.functype	abort, void
