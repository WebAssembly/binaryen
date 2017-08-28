	.text
	.file	"pr35800.c"
	.section	.text.stab_xcoff_builtin_type,"ax",@progbits
	.hidden	stab_xcoff_builtin_type # -- Begin function stab_xcoff_builtin_type
	.globl	stab_xcoff_builtin_type
	.type	stab_xcoff_builtin_type,@function
stab_xcoff_builtin_type:                # @stab_xcoff_builtin_type
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	block   	
	i32.const	$push0=, -34
	i32.lt_u	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$1=, .L.str
	block   	
	i32.const	$push2=, -2
	i32.sub 	$push10=, $pop2, $0
	tee_local	$push9=, $0=, $pop10
	i32.const	$push3=, 32
	i32.gt_u	$push4=, $pop9, $pop3
	br_if   	0, $pop4        # 0: down to label1
# BB#2:                                 # %switch.lookup
	i32.const	$push5=, 2
	i32.shl 	$push6=, $0, $pop5
	i32.const	$push7=, .Lswitch.table.main
	i32.add 	$push8=, $pop6, $pop7
	i32.load	$1=, 0($pop8)
.LBB0_3:                                # %sw.epilog
	end_block                       # label1:
	i32.load8_s	$1=, 0($1)
.LBB0_4:                                # %cleanup
	end_block                       # label0:
	copy_local	$push11=, $1
                                        # fallthrough-return: $pop11
	.endfunc
.Lfunc_end0:
	.size	stab_xcoff_builtin_type, .Lfunc_end0-stab_xcoff_builtin_type
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %if.end12
	i32.const	$2=, .Lswitch.table.main+8
	i32.const	$1=, 2
	i32.const	$0=, -3
.LBB1_1:                                # %if.end.i
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label3:
	i32.const	$3=, .L.str
	block   	
	i32.const	$push5=, 32
	i32.gt_u	$push0=, $1, $pop5
	br_if   	0, $pop0        # 0: down to label4
# BB#2:                                 # %switch.lookup
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$3=, 0($2)
.LBB1_3:                                # %stab_xcoff_builtin_type.exit
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label4:
	i32.load8_u	$push1=, 0($3)
	i32.const	$push6=, 105
	i32.ne  	$push2=, $pop1, $pop6
	br_if   	1, $pop2        # 1: down to label2
# BB#4:                                 # %for.cond
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push12=, 1
	i32.add 	$1=, $1, $pop12
	i32.const	$push11=, 4
	i32.add 	$2=, $2, $pop11
	i32.const	$push10=, -1
	i32.add 	$push9=, $0, $pop10
	tee_local	$push8=, $0=, $pop9
	i32.const	$push7=, -33
	i32.ge_s	$push3=, $pop8, $pop7
	br_if   	0, $pop3        # 0: up to label3
# BB#5:                                 # %if.end21
	end_loop
	i32.const	$push4=, 0
	return  	$pop4
.LBB1_6:                                # %if.then16
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"int"
	.size	.L.str, 4

	.type	.L.str.2,@object        # @.str.2
.L.str.2:
	.asciz	"short"
	.size	.L.str.2, 6

	.type	.L.str.33,@object       # @.str.33
.L.str.33:
	.asciz	"integer*8"
	.size	.L.str.33, 10

	.type	.Lswitch.table.main,@object # @switch.table.main
	.section	.rodata..Lswitch.table.main,"a",@progbits
	.p2align	4
.Lswitch.table.main:
	.int32	.L.str.2
	.int32	.L.str.2
	.int32	.L.str.33
	.int32	.L.str.33
	.int32	.L.str.33
	.int32	.L.str.33
	.int32	.L.str.33
	.int32	.L.str.33
	.int32	.L.str.33
	.int32	.L.str.33
	.int32	.L.str.33
	.int32	.L.str.33
	.int32	.L.str.33
	.int32	.L.str.33
	.int32	.L.str.33
	.int32	.L.str.33
	.int32	.L.str.33
	.int32	.L.str.33
	.int32	.L.str.33
	.int32	.L.str.33
	.int32	.L.str.33
	.int32	.L.str.33
	.int32	.L.str.33
	.int32	.L.str.33
	.int32	.L.str.33
	.int32	.L.str.33
	.int32	.L.str.33
	.int32	.L.str.33
	.int32	.L.str.33
	.int32	.L.str.33
	.int32	.L.str.33
	.int32	.L.str.33
	.int32	.L.str.33
	.size	.Lswitch.table.main, 132


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
