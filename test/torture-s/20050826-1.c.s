	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20050826-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	block   	
	i64.load	$push0=, 0($0):p2align=0
	i64.const	$push1=, 368664092428289
	i64.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %for.body.preheader
	i32.const	$push3=, 7
	i32.add 	$1=, $0, $pop3
	i32.const	$0=, 0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label2:
	i32.add 	$push4=, $1, $0
	i32.load8_u	$push5=, 0($pop4)
	br_if   	1, $pop5        # 1: down to label1
# BB#3:                                 # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push10=, 1
	i32.add 	$push9=, $0, $pop10
	tee_local	$push8=, $0=, $pop9
	i32.const	$push7=, 2040
	i32.le_u	$push6=, $pop8, $pop7
	br_if   	0, $pop6        # 0: up to label2
# BB#4:                                 # %for.end
	end_loop
	return
.LBB0_5:                                # %if.then2
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_6:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push3=, a+7
	i32.const	$push2=, 0
	i32.const	$push1=, 2041
	i32.call	$drop=, memset@FUNCTION, $pop3, $pop2, $pop1
	i32.const	$push21=, 0
	i32.const	$push20=, 1
	i32.store8	a($pop21), $pop20
	i32.const	$push19=, 0
	i32.const	$push18=, 1
	i32.store8	a+6($pop19), $pop18
	i32.const	$push17=, 0
	i32.const	$push16=, 0
	i32.load8_u	$push4=, .L.str.1+4($pop16)
	i32.store8	a+5($pop17), $pop4
	i32.const	$push15=, 0
	i32.const	$push14=, 0
	i32.load	$push5=, .L.str.1($pop14):p2align=0
	i32.store	a+1($pop15):p2align=0, $pop5
	block   	
	i32.const	$push13=, 0
	i64.load	$push6=, a($pop13):p2align=0
	i64.const	$push7=, 368664092428289
	i64.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label3
# BB#1:                                 # %for.cond.i.preheader
	i32.const	$1=, 8
.LBB1_2:                                # %for.cond.i
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label5:
	i32.const	$push23=, -7
	i32.add 	$push9=, $1, $pop23
	i32.const	$push22=, 2040
	i32.gt_u	$push10=, $pop9, $pop22
	br_if   	1, $pop10       # 1: down to label4
# BB#3:                                 # %for.cond.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.const	$push25=, a
	i32.add 	$0=, $1, $pop25
	i32.const	$push24=, 1
	i32.add 	$push0=, $1, $pop24
	copy_local	$1=, $pop0
	i32.load8_u	$push12=, 0($0)
	i32.eqz 	$push26=, $pop12
	br_if   	0, $pop26       # 0: up to label5
# BB#4:                                 # %if.then2.i
	end_loop
	call    	abort@FUNCTION
	unreachable
.LBB1_5:                                # %bar.exit
	end_block                       # label4:
	i32.const	$push11=, 0
	return  	$pop11
.LBB1_6:                                # %if.then.i
	end_block                       # label3:
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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push3=, a+7
	i32.const	$push2=, 0
	i32.const	$push1=, 2041
	i32.call	$drop=, memset@FUNCTION, $pop3, $pop2, $pop1
	i32.const	$push21=, 0
	i32.const	$push20=, 1
	i32.store8	a($pop21), $pop20
	i32.const	$push19=, 0
	i32.const	$push18=, 1
	i32.store8	a+6($pop19), $pop18
	i32.const	$push17=, 0
	i32.const	$push16=, 0
	i32.load8_u	$push4=, .L.str.1+4($pop16)
	i32.store8	a+5($pop17), $pop4
	i32.const	$push15=, 0
	i32.const	$push14=, 0
	i32.load	$push5=, .L.str.1($pop14):p2align=0
	i32.store	a+1($pop15):p2align=0, $pop5
	block   	
	i32.const	$push13=, 0
	i64.load	$push6=, a($pop13):p2align=0
	i64.const	$push7=, 368664092428289
	i64.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label6
# BB#1:                                 # %for.cond.i.i.preheader
	i32.const	$1=, 8
.LBB2_2:                                # %for.cond.i.i
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label8:
	i32.const	$push23=, -7
	i32.add 	$push9=, $1, $pop23
	i32.const	$push22=, 2040
	i32.gt_u	$push10=, $pop9, $pop22
	br_if   	1, $pop10       # 1: down to label7
# BB#3:                                 # %for.cond.i.for.body.i_crit_edge.i
                                        #   in Loop: Header=BB2_2 Depth=1
	i32.const	$push25=, a
	i32.add 	$0=, $1, $pop25
	i32.const	$push24=, 1
	i32.add 	$push0=, $1, $pop24
	copy_local	$1=, $pop0
	i32.load8_u	$push12=, 0($0)
	i32.eqz 	$push26=, $pop12
	br_if   	0, $pop26       # 0: up to label8
# BB#4:                                 # %if.then2.i.i
	end_loop
	call    	abort@FUNCTION
	unreachable
.LBB2_5:                                # %foo.exit
	end_block                       # label7:
	i32.const	$push11=, 0
	return  	$pop11
.LBB2_6:                                # %if.then.i.i
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"\001HELLO\001"
	.size	.L.str, 8

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
a:
	.skip	2048
	.size	a, 2048

	.type	.L.str.1,@object        # @.str.1
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str.1:
	.asciz	"HELLO"
	.size	.L.str.1, 6


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	memcmp, i32, i32, i32, i32
	.functype	abort, void
