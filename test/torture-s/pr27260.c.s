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
	call    	memset@FUNCTION, $pop2, $pop1, $pop3
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
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, 0
	i32.const	$push0=, 2
	i32.store8	$discard=, buf+64($4), $pop0
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label1:
	i32.const	$0=, buf
	i32.add 	$push1=, $0, $4
	i32.load8_u	$push2=, 0($pop1)
	br_if   	$pop2, 2        # 2: down to label0
# BB#2:                                 # %for.cond
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$5=, 1
	i32.add 	$4=, $4, $5
	i32.const	$1=, 63
	i32.le_s	$push3=, $4, $1
	br_if   	$pop3, 0        # 0: up to label1
# BB#3:                                 # %for.end
	end_loop                        # label2:
	i32.const	$2=, 64
	call    	memset@FUNCTION, $0, $5, $2
.LBB1_4:                                # %for.cond3
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label4:
	i32.gt_s	$push4=, $5, $1
	br_if   	$pop4, 2        # 2: down to label3
# BB#5:                                 # %for.cond3.for.body6_crit_edge
                                        #   in Loop: Header=BB1_4 Depth=1
	i32.add 	$3=, $0, $5
	i32.const	$4=, 1
	i32.add 	$5=, $5, $4
	i32.load8_u	$push8=, 0($3)
	i32.eq  	$push9=, $pop8, $4
	br_if   	$pop9, 0        # 0: up to label4
# BB#6:                                 # %if.then11
	end_loop                        # label5:
	call    	abort@FUNCTION
	unreachable
.LBB1_7:                                # %for.end15
	end_block                       # label3:
	i32.const	$3=, 0
	call    	memset@FUNCTION, $0, $3, $2
	i32.const	$5=, 1
.LBB1_8:                                # %for.cond16
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label7:
	i32.gt_s	$push5=, $5, $1
	br_if   	$pop5, 2        # 2: down to label6
# BB#9:                                 # %for.cond16.for.body19_crit_edge
                                        #   in Loop: Header=BB1_8 Depth=1
	i32.add 	$4=, $0, $5
	i32.const	$push7=, 1
	i32.add 	$5=, $5, $pop7
	i32.load8_u	$push6=, 0($4)
	i32.const	$push10=, 0
	i32.eq  	$push11=, $pop6, $pop10
	br_if   	$pop11, 0       # 0: up to label7
# BB#10:                                # %if.then24
	end_loop                        # label8:
	call    	abort@FUNCTION
	unreachable
.LBB1_11:                               # %if.end33
	end_block                       # label6:
	return  	$3
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
	.align	4
buf:
	.skip	65
	.size	buf, 65


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
