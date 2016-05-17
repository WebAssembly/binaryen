	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr27260.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push2=, buf
	i32.const	$push0=, 2
	i32.ne  	$push1=, $0, $pop0
	i32.const	$push3=, 64
	i32.call	$drop=, memset@FUNCTION, $pop2, $pop1, $pop3
	return
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
	i32.const	$push12=, 0
	i32.const	$push0=, 2
	i32.store8	$drop=, buf+64($pop12), $pop0
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label1:
	i32.load8_u	$push1=, buf($1)
	br_if   	2, $pop1        # 2: down to label0
# BB#2:                                 # %for.cond
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push14=, 1
	i32.add 	$1=, $1, $pop14
	i32.const	$push13=, 63
	i32.le_s	$push2=, $1, $pop13
	br_if   	0, $pop2        # 0: up to label1
# BB#3:                                 # %for.end
	end_loop                        # label2:
	i32.const	$push3=, buf
	i32.const	$push15=, 1
	i32.const	$push4=, 64
	i32.call	$drop=, memset@FUNCTION, $pop3, $pop15, $pop4
	i32.const	$1=, 1
.LBB1_4:                                # %for.cond3
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label4:
	i32.const	$push16=, 63
	i32.gt_s	$push5=, $1, $pop16
	br_if   	2, $pop5        # 2: down to label3
# BB#5:                                 # %for.cond3.for.body6_crit_edge
                                        #   in Loop: Header=BB1_4 Depth=1
	i32.load8_u	$0=, buf($1)
	i32.const	$push18=, 1
	i32.add 	$1=, $1, $pop18
	i32.const	$push17=, 1
	i32.eq  	$push11=, $0, $pop17
	br_if   	0, $pop11       # 0: up to label4
# BB#6:                                 # %if.then11
	end_loop                        # label5:
	call    	abort@FUNCTION
	unreachable
.LBB1_7:                                # %for.end15
	end_block                       # label3:
	i32.const	$push6=, buf
	i32.const	$push8=, 0
	i32.const	$push7=, 64
	i32.call	$drop=, memset@FUNCTION, $pop6, $pop8, $pop7
	i32.const	$1=, 1
.LBB1_8:                                # %for.cond16
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label7:
	i32.const	$push19=, 63
	i32.gt_s	$push9=, $1, $pop19
	br_if   	2, $pop9        # 2: down to label6
# BB#9:                                 # %for.cond16.for.body19_crit_edge
                                        #   in Loop: Header=BB1_8 Depth=1
	i32.load8_u	$0=, buf($1)
	i32.const	$push20=, 1
	i32.add 	$1=, $1, $pop20
	i32.eqz 	$push21=, $0
	br_if   	0, $pop21       # 0: up to label7
# BB#10:                                # %if.then24
	end_loop                        # label8:
	call    	abort@FUNCTION
	unreachable
.LBB1_11:                               # %if.end33
	end_block                       # label6:
	i32.const	$push10=, 0
	return  	$pop10
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
