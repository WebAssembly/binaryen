	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr27260.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push3=, buf
	i32.const	$push0=, 2
	i32.ne  	$push1=, $0, $pop0
	i32.const	$push2=, 64
	i32.call	$drop=, memset@FUNCTION, $pop3, $pop1, $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.const	$push14=, 0
	i32.const	$push2=, 2
	i32.store8	$drop=, buf+64($pop14), $pop2
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label1:
	i32.load8_u	$push3=, buf($1)
	br_if   	2, $pop3        # 2: down to label0
# BB#2:                                 # %for.cond
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push18=, 1
	i32.add 	$push17=, $1, $pop18
	tee_local	$push16=, $1=, $pop17
	i32.const	$push15=, 63
	i32.le_s	$push4=, $pop16, $pop15
	br_if   	0, $pop4        # 0: up to label1
# BB#3:                                 # %for.end
	end_loop                        # label2:
	i32.const	$push6=, buf
	i32.const	$push19=, 1
	i32.const	$push5=, 64
	i32.call	$drop=, memset@FUNCTION, $pop6, $pop19, $pop5
	i32.const	$1=, 1
.LBB1_4:                                # %for.cond3
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label4:
	i32.const	$push20=, 63
	i32.gt_s	$push7=, $1, $pop20
	br_if   	2, $pop7        # 2: down to label3
# BB#5:                                 # %for.cond3.for.body6_crit_edge
                                        #   in Loop: Header=BB1_4 Depth=1
	i32.load8_u	$0=, buf($1)
	i32.const	$push22=, 1
	i32.add 	$push0=, $1, $pop22
	copy_local	$1=, $pop0
	i32.const	$push21=, 1
	i32.eq  	$push13=, $0, $pop21
	br_if   	0, $pop13       # 0: up to label4
# BB#6:                                 # %if.then11
	end_loop                        # label5:
	call    	abort@FUNCTION
	unreachable
.LBB1_7:                                # %for.end15
	end_block                       # label3:
	i32.const	$push10=, buf
	i32.const	$push9=, 0
	i32.const	$push8=, 64
	i32.call	$drop=, memset@FUNCTION, $pop10, $pop9, $pop8
	i32.const	$1=, 1
.LBB1_8:                                # %for.cond16
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label7:
	i32.const	$push23=, 63
	i32.gt_s	$push11=, $1, $pop23
	br_if   	2, $pop11       # 2: down to label6
# BB#9:                                 # %for.cond16.for.body19_crit_edge
                                        #   in Loop: Header=BB1_8 Depth=1
	i32.load8_u	$0=, buf($1)
	i32.const	$push24=, 1
	i32.add 	$push1=, $1, $pop24
	copy_local	$1=, $pop1
	i32.eqz 	$push25=, $0
	br_if   	0, $pop25       # 0: up to label7
# BB#10:                                # %if.then24
	end_loop                        # label8:
	call    	abort@FUNCTION
	unreachable
.LBB1_11:                               # %if.end33
	end_block                       # label6:
	i32.const	$push12=, 0
	return  	$pop12
.LBB1_12:                               # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	buf                     # @buf
	.type	buf,@object
	.section	.bss.buf,"aw",@nobits
	.globl	buf
	.p2align	4
buf:
	.skip	65
	.size	buf, 65


	.ident	"clang version 3.9.0 "
	.functype	abort, void
