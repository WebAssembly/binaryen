	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20081218-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, a
	i32.const	$push2=, 38
	i32.const	$push1=, 520
	call    	memset@FUNCTION, $pop0, $pop2, $pop1
	i32.const	$push3=, 640034342
	return  	$pop3
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, a
	i32.const	$push2=, 54
	i32.const	$push1=, 520
	call    	memset@FUNCTION, $pop0, $pop2, $pop1
	i32.const	$0=, 0
	i32.const	$push3=, 909522486
	i32.store	$discard=, a($0), $pop3
	i32.const	$push4=, 909588022
	i32.store	$discard=, a+4($0), $pop4
	return
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.call	$0=, foo@FUNCTION
	i32.const	$3=, 0
	block
	i32.const	$push0=, 640034342
	i32.ne  	$push1=, $0, $pop0
	br_if   	$pop1, 0        # 0: down to label0
.LBB2_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label2:
	i32.const	$0=, a
	i32.add 	$push2=, $0, $3
	i32.load8_u	$push3=, 0($pop2)
	i32.const	$push4=, 38
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	$pop5, 2        # 2: down to label1
# BB#2:                                 # %for.cond
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$1=, 1
	i32.add 	$3=, $3, $1
	i32.const	$2=, 519
	i32.le_u	$push6=, $3, $2
	br_if   	$pop6, 0        # 0: up to label2
# BB#3:                                 # %for.end
	end_loop                        # label3:
	call    	bar@FUNCTION
	i32.const	$3=, 0
	block
	i32.load	$push7=, a+4($3)
	i32.const	$push8=, 909588022
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	$pop9, 0        # 0: down to label4
# BB#4:                                 # %if.end9
	i32.const	$push10=, 909522486
	i32.store	$discard=, a+4($3), $pop10
.LBB2_5:                                # %for.body13
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label6:
	i32.add 	$push11=, $0, $3
	i32.load8_u	$push12=, 0($pop11)
	i32.const	$push13=, 54
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	$pop14, 2       # 2: down to label5
# BB#6:                                 # %for.cond10
                                        #   in Loop: Header=BB2_5 Depth=1
	i32.add 	$3=, $3, $1
	i32.le_u	$push15=, $3, $2
	br_if   	$pop15, 0       # 0: up to label6
# BB#7:                                 # %for.end22
	end_loop                        # label7:
	i32.const	$push16=, 0
	return  	$pop16
.LBB2_8:                                # %if.then18
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB2_9:                                # %if.then8
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB2_10:                               # %if.then4
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB2_11:                               # %if.then
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
	.align	2
a:
	.skip	520
	.size	a, 520


	.ident	"clang version 3.9.0 "
