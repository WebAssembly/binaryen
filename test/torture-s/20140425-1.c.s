	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20140425-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 16
	i32.sub 	$5=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$5=, 0($2), $5
	i32.const	$4=, 12
	i32.add 	$4=, $5, $4
	call    	set@FUNCTION, $4
	i32.const	$push1=, 2
	i32.load	$push0=, 12($5)
	tee_local	$push6=, $0=, $pop0
	i32.shl 	$push2=, $pop1, $pop6
	i32.store	$discard=, 12($5), $pop2
	block
	i32.const	$push3=, 30
	i32.le_u	$push4=, $0, $pop3
	br_if   	$pop4, 0        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push5=, 0
	i32.const	$3=, 16
	i32.add 	$5=, $5, $3
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	return  	$pop5
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.set,"ax",@progbits
	.type	set,@function
set:                                    # @set
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 31
	i32.store	$discard=, 0($0), $pop0
	return
	.endfunc
.Lfunc_end1:
	.size	set, .Lfunc_end1-set


	.ident	"clang version 3.9.0 "
