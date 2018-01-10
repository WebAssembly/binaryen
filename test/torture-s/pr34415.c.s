	.text
	.file	"pr34415.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# %bb.0:                                # %entry
                                        # implicit-def: %64
	i32.const	$4=, 1
.LBB0_1:                                # %for.cond
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_4 Depth 2
	loop    	i32             # label0:
	copy_local	$1=, $0
	i32.load8_s	$0=, 0($1)
	i32.const	$push18=, -32
	i32.add 	$push0=, $0, $pop18
	i32.const	$push17=, -97
	i32.add 	$push1=, $0, $pop17
	i32.const	$push16=, 255
	i32.and 	$push2=, $pop1, $pop16
	i32.const	$push15=, 26
	i32.lt_u	$push3=, $pop2, $pop15
	i32.select	$2=, $pop0, $0, $pop3
	copy_local	$5=, $1
	block   	
	i32.const	$push14=, 66
	i32.eq  	$push4=, $2, $pop14
	br_if   	0, $pop4        # 0: down to label1
# %bb.2:                                # %for.cond
                                        #   in Loop: Header=BB0_1 Depth=1
	block   	
	i32.const	$push19=, 65
	i32.ne  	$push5=, $2, $pop19
	br_if   	0, $pop5        # 0: down to label2
# %bb.3:                                # %do.body.preheader
                                        #   in Loop: Header=BB0_1 Depth=1
	copy_local	$0=, $1
.LBB0_4:                                # %do.body
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label3:
	i32.const	$push21=, 1
	i32.add 	$5=, $0, $pop21
	i32.load8_u	$2=, 1($0)
	copy_local	$0=, $5
	i32.const	$push20=, 43
	i32.eq  	$push6=, $2, $pop20
	br_if   	0, $pop6        # 0: up to label3
	br      	2               # 2: down to label1
.LBB0_5:                                # %for.end
	end_loop
	end_block                       # label2:
	block   	
	i32.const	$push7=, 3
	i32.lt_u	$push8=, $4, $pop7
	br_if   	0, $pop8        # 0: down to label4
# %bb.6:                                # %land.lhs.true17
	i32.const	$push9=, 58
	i32.eq  	$push10=, $0, $pop9
	i32.select	$push11=, $3, $1, $pop10
	return  	$pop11
.LBB0_7:                                # %if.end22
	end_block                       # label4:
	return  	$1
.LBB0_8:                                # %cleanup.cont
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label1:
	i32.const	$push13=, 1
	i32.add 	$4=, $4, $pop13
	i32.const	$push12=, 1
	i32.add 	$0=, $5, $pop12
	copy_local	$3=, $1
	br      	0               # 0: up to label0
.LBB0_9:
	end_loop
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, .L.str
	i32.call	$push1=, foo@FUNCTION, $pop0
	i32.const	$push2=, .L.str+2
	i32.ne  	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"Bbb:"
	.size	.L.str, 5


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
