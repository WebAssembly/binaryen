	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20050826-1.c"
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
	loop                            # label2:
	i32.add 	$push4=, $1, $0
	i32.load8_u	$push5=, 0($pop4)
	br_if   	2, $pop5        # 2: down to label1
# BB#3:                                 # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push10=, 1
	i32.add 	$push9=, $0, $pop10
	tee_local	$push8=, $0=, $pop9
	i32.const	$push7=, 2040
	i32.le_u	$push6=, $pop8, $pop7
	br_if   	0, $pop6        # 0: up to label2
# BB#4:                                 # %for.end
	end_loop                        # label3:
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
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push4=, a+7
	i32.const	$push3=, 0
	i32.const	$push2=, 2041
	i32.call	$drop=, memset@FUNCTION, $pop4, $pop3, $pop2
	i32.const	$push20=, 0
	i32.const	$push19=, 0
	i32.const	$push5=, 1
	i32.store8	$push0=, a($pop19), $pop5
	i32.store8	$0=, a+6($pop20), $pop0
	i32.const	$push18=, 0
	i32.const	$push17=, 0
	i32.load8_u	$push6=, .L.str.1+4($pop17)
	i32.store8	$drop=, a+5($pop18), $pop6
	i32.const	$push16=, 0
	i32.const	$push15=, 0
	i32.load	$push7=, .L.str.1($pop15):p2align=0
	i32.store	$drop=, a+1($pop16):p2align=0, $pop7
	block
	i32.const	$push14=, 0
	i64.load	$push8=, a($pop14):p2align=0
	i64.const	$push9=, 368664092428289
	i64.ne  	$push10=, $pop8, $pop9
	br_if   	0, $pop10       # 0: down to label4
# BB#1:                                 # %for.cond.i.preheader
	i32.const	$2=, 8
.LBB1_2:                                # %for.cond.i
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label6:
	i32.const	$push22=, -7
	i32.add 	$push11=, $2, $pop22
	i32.const	$push21=, 2040
	i32.gt_u	$push12=, $pop11, $pop21
	br_if   	2, $pop12       # 2: down to label5
# BB#3:                                 # %for.cond.i.for.body.i_crit_edge
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.load8_u	$1=, a($2)
	i32.add 	$push1=, $2, $0
	copy_local	$2=, $pop1
	i32.eqz 	$push23=, $1
	br_if   	0, $pop23       # 0: up to label6
# BB#4:                                 # %if.then2.i
	end_loop                        # label7:
	call    	abort@FUNCTION
	unreachable
.LBB1_5:                                # %bar.exit
	end_block                       # label5:
	i32.const	$push13=, 0
	return  	$pop13
.LBB1_6:                                # %if.then.i
	end_block                       # label4:
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
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push4=, a+7
	i32.const	$push3=, 0
	i32.const	$push2=, 2041
	i32.call	$drop=, memset@FUNCTION, $pop4, $pop3, $pop2
	i32.const	$push20=, 0
	i32.const	$push19=, 0
	i32.const	$push5=, 1
	i32.store8	$push0=, a($pop19), $pop5
	i32.store8	$0=, a+6($pop20), $pop0
	i32.const	$push18=, 0
	i32.const	$push17=, 0
	i32.load8_u	$push6=, .L.str.1+4($pop17)
	i32.store8	$drop=, a+5($pop18), $pop6
	i32.const	$push16=, 0
	i32.const	$push15=, 0
	i32.load	$push7=, .L.str.1($pop15):p2align=0
	i32.store	$drop=, a+1($pop16):p2align=0, $pop7
	block
	i32.const	$push14=, 0
	i64.load	$push8=, a($pop14):p2align=0
	i64.const	$push9=, 368664092428289
	i64.ne  	$push10=, $pop8, $pop9
	br_if   	0, $pop10       # 0: down to label8
# BB#1:                                 # %for.cond.i.i.preheader
	i32.const	$2=, 8
.LBB2_2:                                # %for.cond.i.i
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label10:
	i32.const	$push22=, -7
	i32.add 	$push11=, $2, $pop22
	i32.const	$push21=, 2040
	i32.gt_u	$push12=, $pop11, $pop21
	br_if   	2, $pop12       # 2: down to label9
# BB#3:                                 # %for.cond.i.for.body.i_crit_edge.i
                                        #   in Loop: Header=BB2_2 Depth=1
	i32.load8_u	$1=, a($2)
	i32.add 	$push1=, $2, $0
	copy_local	$2=, $pop1
	i32.eqz 	$push23=, $1
	br_if   	0, $pop23       # 0: up to label10
# BB#4:                                 # %if.then2.i.i
	end_loop                        # label11:
	call    	abort@FUNCTION
	unreachable
.LBB2_5:                                # %foo.exit
	end_block                       # label9:
	i32.const	$push13=, 0
	return  	$pop13
.LBB2_6:                                # %if.then.i.i
	end_block                       # label8:
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


	.ident	"clang version 3.9.0 "
	.functype	memcmp, i32, i32, i32, i32
	.functype	abort, void
