	.text
	.file	"pr45070.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push12=, 0
	i32.const	$push10=, 0
	i32.load	$push9=, __stack_pointer($pop10)
	i32.const	$push11=, 16
	i32.sub 	$push17=, $pop9, $pop11
	tee_local	$push16=, $2=, $pop17
	i32.store	__stack_pointer($pop12), $pop16
	i32.const	$push0=, 0
	i32.store	8($2), $pop0
	i64.const	$push1=, 0
	i64.store	0($2), $pop1
	i32.const	$1=, -1
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label1:
	i32.call	$0=, next@FUNCTION, $2
	block   	
	i32.const	$push18=, -1
	i32.ne  	$push2=, $1, $pop18
	br_if   	0, $pop2        # 0: down to label2
# BB#2:                                 # %for.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push20=, 65535
	i32.and 	$push3=, $0, $pop20
	i32.const	$push19=, 65535
	i32.ne  	$push4=, $pop3, $pop19
	br_if   	2, $pop4        # 2: down to label0
.LBB0_3:                                # %lor.lhs.false
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	block   	
	i32.const	$push21=, -1
	i32.eq  	$push5=, $1, $pop21
	br_if   	0, $pop5        # 0: down to label3
# BB#4:                                 # %lor.lhs.false
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push22=, 65535
	i32.and 	$push6=, $0, $pop22
	br_if   	2, $pop6        # 2: down to label0
.LBB0_5:                                # %for.cond
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label3:
	i32.const	$push26=, 1
	i32.add 	$push25=, $1, $pop26
	tee_local	$push24=, $1=, $pop25
	i32.const	$push23=, 14
	i32.le_u	$push7=, $pop24, $pop23
	br_if   	0, $pop7        # 0: up to label1
# BB#6:                                 # %for.end
	end_loop
	i32.const	$push15=, 0
	i32.const	$push13=, 16
	i32.add 	$push14=, $2, $pop13
	i32.store	__stack_pointer($pop15), $pop14
	i32.const	$push8=, 0
	return  	$pop8
.LBB0_7:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.section	.text.next,"ax",@progbits
	.type	next,@function          # -- Begin function next
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
                                        # -- End function
	.section	.text.fetch,"ax",@progbits
	.type	fetch,@function         # -- Begin function fetch
fetch:                                  # @fetch
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 128
	i32.store	4($0), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	fetch, .Lfunc_end2-fetch
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
