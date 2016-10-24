	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/strlen-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.const	$2=, u
.LBB0_1:                                # %for.cond1.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_2 Depth 2
	block   	
	loop    	                # label1:
	i32.const	$push7=, u
	i32.add 	$0=, $1, $pop7
	i32.const	$3=, 0
.LBB0_2:                                # %for.cond4.preheader
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label2:
	block   	
	block   	
	block   	
	i32.eqz 	$push23=, $1
	br_if   	0, $pop23       # 0: down to label5
# BB#3:                                 # %for.body6.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push9=, u
	i32.const	$push8=, 0
	i32.call	$drop=, memset@FUNCTION, $pop9, $pop8, $1
	copy_local	$4=, $2
	br_if   	1, $3           # 1: down to label4
	br      	2               # 2: down to label3
.LBB0_4:                                #   in Loop: Header=BB0_2 Depth=2
	end_block                       # label5:
	i32.const	$4=, u
	i32.eqz 	$push24=, $3
	br_if   	1, $pop24       # 1: down to label3
.LBB0_5:                                # %for.body9.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_block                       # label4:
	i32.const	$push10=, 97
	i32.call	$push0=, memset@FUNCTION, $4, $pop10, $3
	i32.add 	$4=, $pop0, $3
.LBB0_6:                                # %for.end13
                                        #   in Loop: Header=BB0_2 Depth=2
	end_block                       # label3:
	i32.const	$push13=, 0
	i32.store8	0($4), $pop13
	i32.const	$push12=, 1
	i32.add 	$push6=, $4, $pop12
	i64.const	$push11=, 7089336938131513954
	i64.store	0($pop6):p2align=0, $pop11
	i32.call	$push1=, strlen@FUNCTION, $0
	i32.ne  	$push2=, $3, $pop1
	br_if   	2, $pop2        # 2: down to label0
# BB#7:                                 # %for.cond1
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push17=, 1
	i32.add 	$push16=, $3, $pop17
	tee_local	$push15=, $3=, $pop16
	i32.const	$push14=, 63
	i32.le_u	$push3=, $pop15, $pop14
	br_if   	0, $pop3        # 0: up to label2
# BB#8:                                 # %for.inc26
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop
	i32.const	$push22=, 1
	i32.add 	$2=, $2, $pop22
	i32.const	$push21=, 1
	i32.add 	$push20=, $1, $pop21
	tee_local	$push19=, $1=, $pop20
	i32.const	$push18=, 8
	i32.lt_u	$push4=, $pop19, $pop18
	br_if   	0, $pop4        # 0: up to label1
# BB#9:                                 # %for.end28
	end_loop
	i32.const	$push5=, 0
	call    	exit@FUNCTION, $pop5
	unreachable
.LBB0_10:                               # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	u,@object               # @u
	.section	.bss.u,"aw",@nobits
	.p2align	4
u:
	.skip	96
	.size	u, 96


	.ident	"clang version 4.0.0 "
	.functype	strlen, i32, i32
	.functype	abort, void
	.functype	exit, void, i32
