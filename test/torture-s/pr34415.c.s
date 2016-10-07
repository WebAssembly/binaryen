	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr34415.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
                                        # implicit-def: %vreg64
	i32.const	$5=, 1
.LBB0_1:                                # %for.cond
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_4 Depth 2
	loop    	i32             # label0:
	copy_local	$push25=, $0
	tee_local	$push24=, $1=, $pop25
	copy_local	$0=, $pop24
	block   	
	i32.load8_s	$push23=, 0($1)
	tee_local	$push22=, $2=, $pop23
	i32.const	$push21=, -32
	i32.add 	$push0=, $pop22, $pop21
	i32.const	$push20=, -97
	i32.add 	$push1=, $2, $pop20
	i32.const	$push19=, 255
	i32.and 	$push2=, $pop1, $pop19
	i32.const	$push18=, 26
	i32.lt_u	$push3=, $pop2, $pop18
	i32.select	$push17=, $pop0, $2, $pop3
	tee_local	$push16=, $3=, $pop17
	i32.const	$push15=, 66
	i32.eq  	$push4=, $pop16, $pop15
	br_if   	0, $pop4        # 0: down to label1
# BB#2:                                 # %for.cond
                                        #   in Loop: Header=BB0_1 Depth=1
	block   	
	i32.const	$push26=, 65
	i32.ne  	$push5=, $3, $pop26
	br_if   	0, $pop5        # 0: down to label2
# BB#3:                                 # %do.body.preheader
                                        #   in Loop: Header=BB0_1 Depth=1
	copy_local	$0=, $1
.LBB0_4:                                # %do.body
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label3:
	i32.const	$push30=, 1
	i32.add 	$push29=, $0, $pop30
	tee_local	$push28=, $0=, $pop29
	i32.load8_u	$push6=, 0($pop28)
	i32.const	$push27=, 43
	i32.eq  	$push7=, $pop6, $pop27
	br_if   	0, $pop7        # 0: up to label3
	br      	2               # 2: down to label1
.LBB0_5:                                # %for.end
	end_loop
	end_block                       # label2:
	block   	
	i32.const	$push8=, 3
	i32.lt_s	$push9=, $5, $pop8
	br_if   	0, $pop9        # 0: down to label4
# BB#6:                                 # %land.lhs.true17
	i32.const	$push10=, 58
	i32.eq  	$push11=, $2, $pop10
	i32.select	$push12=, $4, $1, $pop11
	return  	$pop12
.LBB0_7:                                # %if.end22
	end_block                       # label4:
	return  	$1
.LBB0_8:                                # %cleanup.thread
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label1:
	i32.const	$push14=, 1
	i32.add 	$5=, $5, $pop14
	i32.const	$push13=, 1
	i32.add 	$0=, $0, $pop13
	copy_local	$4=, $1
	br      	0               # 0: up to label0
.LBB0_9:
	end_loop
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, .L.str
	i32.call	$push1=, foo@FUNCTION, $pop0
	i32.const	$push2=, .L.str+2
	i32.ne  	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"Bbb:"
	.size	.L.str, 5


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
