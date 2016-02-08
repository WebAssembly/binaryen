	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20040625-1.c"
	.section	.text.maybe_next,"ax",@progbits
	.hidden	maybe_next
	.globl	maybe_next
	.type	maybe_next,@function
maybe_next:                             # @maybe_next
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 0
	i32.eq  	$push1=, $1, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.then
	i32.load	$0=, 0($0):p2align=0
.LBB0_2:                                # %if.end
	end_block                       # label0:
	return  	$0
	.endfunc
.Lfunc_end0:
	.size	maybe_next, .Lfunc_end0-maybe_next

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 16
	i32.sub 	$3=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$3=, 0($1), $3
	i32.store	$discard=, 8($3):p2align=3, $3
	i32.const	$push0=, 1
	i32.const	$2=, 8
	i32.add 	$2=, $3, $2
	block
	i32.call	$push1=, maybe_next@FUNCTION, $2, $pop0
	i32.ne  	$push2=, $pop1, $3
	br_if   	0, $pop2        # 0: down to label1
# BB#1:                                 # %if.end
	i32.const	$push3=, 0
	call    	exit@FUNCTION, $pop3
	unreachable
.LBB1_2:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
