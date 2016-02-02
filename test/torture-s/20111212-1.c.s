	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20111212-1.c"
	.section	.text.frob_entry,"ax",@progbits
	.hidden	frob_entry
	.globl	frob_entry
	.type	frob_entry,@function
frob_entry:                             # @frob_entry
	.param  	i32
# BB#0:                                 # %entry
	block
	i32.load	$push0=, 0($0):p2align=0
	i32.const	$push1=, 63
	i32.gt_u	$push2=, $pop0, $pop1
	br_if   	$pop2, 0        # 0: down to label0
# BB#1:                                 # %if.then
	i32.const	$push3=, -1
	i32.store	$discard=, 0($0):p2align=0, $pop3
.LBB0_2:                                # %if.end
	end_block                       # label0:
	return
	.endfunc
.Lfunc_end0:
	.size	frob_entry, .Lfunc_end0-frob_entry

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 16
	i32.sub 	$4=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$4=, 0($1), $4
	i64.const	$push0=, 0
	i64.store	$discard=, 8($4), $pop0
	i32.const	$push1=, 1
	i32.const	$3=, 8
	i32.add 	$3=, $4, $3
	i32.or  	$push2=, $3, $pop1
	call    	frob_entry@FUNCTION, $pop2
	i32.const	$push3=, 0
	i32.const	$2=, 16
	i32.add 	$4=, $4, $2
	i32.const	$2=, __stack_pointer
	i32.store	$4=, 0($2), $4
	return  	$pop3
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
