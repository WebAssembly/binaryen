	.text
	.file	"920726-1.c"
	.section	.text.first,"ax",@progbits
	.hidden	first                   # -- Begin function first
	.globl	first
	.type	first,@function
first:                                  # @first
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push8=, 0
	i32.const	$push6=, 0
	i32.load	$push5=, __stack_pointer($pop6)
	i32.const	$push7=, 16
	i32.sub 	$push13=, $pop5, $pop7
	tee_local	$push12=, $3=, $pop13
	i32.store	__stack_pointer($pop8), $pop12
	i32.store	12($3), $2
.LBB0_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	block   	
	i32.load8_u	$push21=, 0($1)
	tee_local	$push20=, $2=, $pop21
	i32.const	$push19=, 105
	i32.ne  	$push0=, $pop20, $pop19
	br_if   	0, $pop0        # 0: down to label1
# BB#2:                                 # %if.then
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.load	$push18=, 12($3)
	tee_local	$push17=, $2=, $pop18
	i32.const	$push16=, 4
	i32.add 	$push1=, $pop17, $pop16
	i32.store	12($3), $pop1
	i32.load	$push2=, 0($2)
	i32.store	0($3), $pop2
	i32.const	$push15=, .L.str
	i32.call	$drop=, sprintf@FUNCTION, $0, $pop15, $3
	i32.call	$push3=, strlen@FUNCTION, $0
	i32.add 	$0=, $0, $pop3
	i32.const	$push14=, 1
	i32.add 	$1=, $1, $pop14
	br      	1               # 1: up to label0
.LBB0_3:                                # %for.cond
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label1:
	block   	
	i32.eqz 	$push24=, $2
	br_if   	0, $pop24       # 0: down to label2
# BB#4:                                 # %if.else
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.store8	0($0), $2
	i32.const	$push23=, 1
	i32.add 	$0=, $0, $pop23
	i32.const	$push22=, 1
	i32.add 	$1=, $1, $pop22
	br      	1               # 1: up to label0
.LBB0_5:                                # %for.end
	end_block                       # label2:
	end_loop
	i32.const	$push4=, 0
	i32.store8	0($0), $pop4
	i32.const	$push11=, 0
	i32.const	$push9=, 16
	i32.add 	$push10=, $3, $pop9
	i32.store	__stack_pointer($pop11), $pop10
	copy_local	$push25=, $0
                                        # fallthrough-return: $pop25
	.endfunc
.Lfunc_end0:
	.size	first, .Lfunc_end0-first
                                        # -- End function
	.section	.text.second,"ax",@progbits
	.hidden	second                  # -- Begin function second
	.globl	second
	.type	second,@function
second:                                 # @second
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push8=, 0
	i32.const	$push6=, 0
	i32.load	$push5=, __stack_pointer($pop6)
	i32.const	$push7=, 16
	i32.sub 	$push13=, $pop5, $pop7
	tee_local	$push12=, $3=, $pop13
	i32.store	__stack_pointer($pop8), $pop12
	i32.store	12($3), $2
.LBB1_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	block   	
	i32.load8_u	$push21=, 0($1)
	tee_local	$push20=, $2=, $pop21
	i32.const	$push19=, 105
	i32.ne  	$push0=, $pop20, $pop19
	br_if   	0, $pop0        # 0: down to label4
# BB#2:                                 # %if.then
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$push18=, 12($3)
	tee_local	$push17=, $2=, $pop18
	i32.const	$push16=, 4
	i32.add 	$push1=, $pop17, $pop16
	i32.store	12($3), $pop1
	i32.load	$push2=, 0($2)
	i32.store	0($3), $pop2
	i32.const	$push15=, .L.str
	i32.call	$drop=, sprintf@FUNCTION, $0, $pop15, $3
	i32.call	$push3=, strlen@FUNCTION, $0
	i32.add 	$0=, $0, $pop3
	i32.const	$push14=, 1
	i32.add 	$1=, $1, $pop14
	br      	1               # 1: up to label3
.LBB1_3:                                # %for.cond
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label4:
	block   	
	i32.eqz 	$push24=, $2
	br_if   	0, $pop24       # 0: down to label5
# BB#4:                                 # %if.else
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.store8	0($0), $2
	i32.const	$push23=, 1
	i32.add 	$0=, $0, $pop23
	i32.const	$push22=, 1
	i32.add 	$1=, $1, $pop22
	br      	1               # 1: up to label3
.LBB1_5:                                # %for.end
	end_block                       # label5:
	end_loop
	i32.const	$push4=, 0
	i32.store8	0($0), $pop4
	i32.const	$push11=, 0
	i32.const	$push9=, 16
	i32.add 	$push10=, $3, $pop9
	i32.store	__stack_pointer($pop11), $pop10
	copy_local	$push25=, $0
                                        # fallthrough-return: $pop25
	.endfunc
.Lfunc_end1:
	.size	second, .Lfunc_end1-second
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push8=, 0
	i32.const	$push6=, 0
	i32.load	$push5=, __stack_pointer($pop6)
	i32.const	$push7=, 256
	i32.sub 	$push23=, $pop5, $pop7
	tee_local	$push22=, $0=, $pop23
	i32.store	__stack_pointer($pop8), $pop22
	i64.const	$push0=, 85899345925
	i64.store	16($0), $pop0
	i32.const	$push9=, 144
	i32.add 	$push10=, $0, $pop9
	i32.const	$push1=, .L.str.1
	i32.const	$push11=, 16
	i32.add 	$push12=, $0, $pop11
	i32.call	$drop=, first@FUNCTION, $pop10, $pop1, $pop12
	i64.const	$push21=, 85899345925
	i64.store	0($0), $pop21
	i32.const	$push13=, 32
	i32.add 	$push14=, $0, $pop13
	i32.const	$push20=, .L.str.1
	i32.call	$drop=, second@FUNCTION, $pop14, $pop20, $0
	block   	
	i32.const	$push19=, .L.str.2
	i32.const	$push15=, 144
	i32.add 	$push16=, $0, $pop15
	i32.call	$push2=, strcmp@FUNCTION, $pop19, $pop16
	br_if   	0, $pop2        # 0: down to label6
# BB#1:                                 # %lor.lhs.false
	i32.const	$push24=, .L.str.2
	i32.const	$push17=, 32
	i32.add 	$push18=, $0, $pop17
	i32.call	$push3=, strcmp@FUNCTION, $pop24, $pop18
	br_if   	0, $pop3        # 0: down to label6
# BB#2:                                 # %if.end
	i32.const	$push4=, 0
	call    	exit@FUNCTION, $pop4
	unreachable
.LBB2_3:                                # %if.then
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"%d"
	.size	.L.str, 3

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"i i "
	.size	.L.str.1, 5

	.type	.L.str.2,@object        # @.str.2
.L.str.2:
	.asciz	"5 20 "
	.size	.L.str.2, 6


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	sprintf, i32, i32, i32
	.functype	strlen, i32, i32
	.functype	strcmp, i32, i32, i32
	.functype	abort, void
	.functype	exit, void, i32
