	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr54937.c"
	.section	.text.t,"ax",@progbits
	.hidden	t
	.globl	t
	.type	t,@function
t:                                      # @t
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 1
	i32.lt_s	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %for.body.preheader
	i32.const	$1=, 0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	block
	i32.eqz 	$push10=, $1
	br_if   	0, $pop10       # 0: down to label3
# BB#3:                                 # %if.then
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push4=, 0
	i32.load	$push2=, terminate_me($pop4)
	i32.const	$push3=, 0
	call_indirect	$pop2, $pop3
.LBB0_4:                                # %if.end
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label3:
	i32.const	$push9=, 0
	i32.store	$drop=, a($1), $pop9
	i32.const	$push8=, 4
	i32.add 	$1=, $1, $pop8
	i32.const	$push7=, -1
	i32.add 	$push6=, $0, $pop7
	tee_local	$push5=, $0=, $pop6
	br_if   	0, $pop5        # 0: up to label1
.LBB0_5:                                # %for.end
	end_loop                        # label2:
	end_block                       # label0:
	copy_local	$push11=, $1
                                        # fallthrough-return: $pop11
	.endfunc
.Lfunc_end0:
	.size	t, .Lfunc_end0-t

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, exit@FUNCTION
	i32.store	$drop=, terminate_me($pop1), $pop0
	i32.const	$push2=, 100
	i32.call	$drop=, t@FUNCTION, $pop2
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	terminate_me            # @terminate_me
	.type	terminate_me,@object
	.section	.bss.terminate_me,"aw",@nobits
	.globl	terminate_me
	.p2align	2
terminate_me:
	.int32	0
	.size	terminate_me, 4

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.skip	4
	.size	a, 4


	.ident	"clang version 3.9.0 "
	.functype	exit, void, i32
	.functype	abort, void
