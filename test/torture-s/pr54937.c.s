	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr54937.c"
	.section	.text.t,"ax",@progbits
	.hidden	t
	.globl	t
	.type	t,@function
t:                                      # @t
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	block
	i32.const	$push0=, 1
	i32.lt_s	$push1=, $0, $pop0
	br_if   	$pop1, 0        # 0: down to label0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	block
	i32.const	$push8=, 0
	i32.eq  	$push9=, $2, $pop8
	br_if   	$pop9, 0        # 0: down to label3
# BB#2:                                 # %if.then
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$1=, 0
	i32.load	$push2=, terminate_me($1)
	call_indirect	$pop2, $1
.LBB0_3:                                # %if.end
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label3:
	i32.const	$push3=, a
	i32.add 	$push4=, $pop3, $2
	i32.const	$push5=, 0
	i32.store	$discard=, 0($pop4), $pop5
	i32.const	$push6=, 4
	i32.add 	$2=, $2, $pop6
	i32.const	$push7=, -1
	i32.add 	$0=, $0, $pop7
	br_if   	$0, 0           # 0: up to label1
.LBB0_4:                                # %for.end
	end_loop                        # label2:
	end_block                       # label0:
	return  	$2
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
	i32.store	$discard=, terminate_me($pop1), $pop0
	i32.const	$push2=, 100
	i32.call	$discard=, t@FUNCTION, $pop2
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	terminate_me            # @terminate_me
	.type	terminate_me,@object
	.section	.bss.terminate_me,"aw",@nobits
	.globl	terminate_me
	.align	2
terminate_me:
	.int32	0
	.size	terminate_me, 4

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.align	2
a:
	.skip	4
	.size	a, 4


	.ident	"clang version 3.9.0 "
