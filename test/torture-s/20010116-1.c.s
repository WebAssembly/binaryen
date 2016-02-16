	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20010116-1.c"
	.section	.text.find,"ax",@progbits
	.hidden	find
	.globl	find
	.type	find,@function
find:                                   # @find
	.param  	i32, i32
# BB#0:                                 # %for.cond
	block
	i32.sub 	$push0=, $1, $0
	i32.const	$push1=, 2
	i32.shr_s	$push2=, $pop0, $pop1
	i32.const	$push3=, -1431655765
	i32.mul 	$push4=, $pop2, $pop3
	i32.const	$push9=, 2
	i32.shr_s	$push8=, $pop4, $pop9
	tee_local	$push7=, $0=, $pop8
	i32.const	$push5=, 1
	i32.lt_s	$push6=, $pop7, $pop5
	br_if   	0, $pop6        # 0: down to label0
# BB#1:                                 # %for.body
	call    	ok@FUNCTION, $0
	unreachable
.LBB0_2:                                # %for.end
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	find, .Lfunc_end0-find

	.section	.text.ok,"ax",@progbits
	.hidden	ok
	.globl	ok
	.type	ok,@function
ok:                                     # @ok
	.param  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 1
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %if.end
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
.LBB1_2:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	ok, .Lfunc_end1-ok

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 48
	i32.sub 	$2=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$2=, 0($1), $2
	i32.const	$push0=, 48
	i32.add 	$push1=, $2, $pop0
	call    	find@FUNCTION, $2, $pop1
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
