	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20081218-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push2=, a
	i32.const	$push1=, 38
	i32.const	$push0=, 520
	i32.call	$drop=, memset@FUNCTION, $pop2, $pop1, $pop0
	i32.const	$push3=, 640034342
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
# BB#0:                                 # %entry
	i32.const	$push2=, a
	i32.const	$push1=, 54
	i32.const	$push0=, 520
	i32.call	$drop=, memset@FUNCTION, $pop2, $pop1, $pop0
	i32.const	$push4=, 0
	i32.const	$push3=, 909588022
	i32.store	$drop=, a+4($pop4), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block
	block
	i32.call	$push1=, foo@FUNCTION
	i32.const	$push0=, 640034342
	i32.ne  	$push2=, $pop1, $pop0
	br_if   	0, $pop2        # 0: down to label1
# BB#1:                                 # %for.body.preheader
	i32.const	$0=, 0
.LBB2_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block
	block
	loop                            # label4:
	i32.load8_u	$push3=, a($0)
	i32.const	$push14=, 38
	i32.ne  	$push4=, $pop3, $pop14
	br_if   	2, $pop4        # 2: down to label3
# BB#3:                                 # %for.cond
                                        #   in Loop: Header=BB2_2 Depth=1
	i32.const	$push18=, 1
	i32.add 	$push17=, $0, $pop18
	tee_local	$push16=, $0=, $pop17
	i32.const	$push15=, 519
	i32.le_u	$push5=, $pop16, $pop15
	br_if   	0, $pop5        # 0: up to label4
# BB#4:                                 # %for.end
	end_loop                        # label5:
	call    	bar@FUNCTION
	i32.const	$0=, 0
	i32.const	$push19=, 0
	i32.load	$push6=, a+4($pop19)
	i32.const	$push7=, 909588022
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	3, $pop8        # 3: down to label0
# BB#5:                                 # %if.end9
	i32.const	$push20=, 0
	i32.const	$push9=, 909522486
	i32.store	$drop=, a+4($pop20), $pop9
.LBB2_6:                                # %for.body13
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label6:
	i32.load8_u	$push10=, a($0)
	i32.const	$push21=, 54
	i32.ne  	$push11=, $pop10, $pop21
	br_if   	3, $pop11       # 3: down to label2
# BB#7:                                 # %for.cond10
                                        #   in Loop: Header=BB2_6 Depth=1
	i32.const	$push25=, 1
	i32.add 	$push24=, $0, $pop25
	tee_local	$push23=, $0=, $pop24
	i32.const	$push22=, 519
	i32.le_u	$push12=, $pop23, $pop22
	br_if   	0, $pop12       # 0: up to label6
# BB#8:                                 # %for.end22
	end_loop                        # label7:
	i32.const	$push13=, 0
	return  	$pop13
.LBB2_9:                                # %if.then4
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB2_10:                               # %if.then18
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB2_11:                               # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB2_12:                               # %if.then8
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.skip	520
	.size	a, 520


	.ident	"clang version 3.9.0 "
	.functype	abort, void
