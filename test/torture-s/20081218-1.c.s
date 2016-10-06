	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20081218-1.c"
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
	i32.store	a+4($pop4), $pop3
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
	loop    	                # label4:
	i32.const	$push17=, a
	i32.add 	$push3=, $0, $pop17
	i32.load8_u	$push4=, 0($pop3)
	i32.const	$push16=, 38
	i32.ne  	$push5=, $pop4, $pop16
	br_if   	1, $pop5        # 1: down to label3
# BB#3:                                 # %for.cond
                                        #   in Loop: Header=BB2_2 Depth=1
	i32.const	$push21=, 1
	i32.add 	$push20=, $0, $pop21
	tee_local	$push19=, $0=, $pop20
	i32.const	$push18=, 519
	i32.le_u	$push6=, $pop19, $pop18
	br_if   	0, $pop6        # 0: up to label4
# BB#4:                                 # %for.end
	end_loop
	call    	bar@FUNCTION
	i32.const	$0=, 0
	i32.const	$push22=, 0
	i32.load	$push7=, a+4($pop22)
	i32.const	$push8=, 909588022
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	3, $pop9        # 3: down to label0
# BB#5:                                 # %if.end9
	i32.const	$push23=, 0
	i32.const	$push10=, 909522486
	i32.store	a+4($pop23), $pop10
.LBB2_6:                                # %for.body13
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label5:
	i32.const	$push25=, a
	i32.add 	$push11=, $0, $pop25
	i32.load8_u	$push12=, 0($pop11)
	i32.const	$push24=, 54
	i32.ne  	$push13=, $pop12, $pop24
	br_if   	2, $pop13       # 2: down to label2
# BB#7:                                 # %for.cond10
                                        #   in Loop: Header=BB2_6 Depth=1
	i32.const	$push29=, 1
	i32.add 	$push28=, $0, $pop29
	tee_local	$push27=, $0=, $pop28
	i32.const	$push26=, 519
	i32.le_u	$push14=, $pop27, $pop26
	br_if   	0, $pop14       # 0: up to label5
# BB#8:                                 # %for.end22
	end_loop
	i32.const	$push15=, 0
	return  	$pop15
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
