	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/980716-1.c"
	.section	.text.stub,"ax",@progbits
	.hidden	stub
	.globl	stub
	.type	stub,@function
stub:                                   # @stub
	.param  	i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push4=, __stack_pointer
	i32.load	$push5=, 0($pop4)
	i32.const	$push6=, 16
	i32.sub 	$5=, $pop5, $pop6
	i32.store	$2=, 12($5), $1
	copy_local	$1=, $2
.LBB0_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.const	$push2=, 4
	i32.add 	$push0=, $1, $pop2
	i32.store	$3=, 12($5), $pop0
	i32.load	$4=, 0($1)
	copy_local	$1=, $3
	br_if   	0, $4           # 0: up to label0
# BB#2:                                 # %while.end
	end_loop                        # label1:
	i32.store	$1=, 12($5), $2
.LBB0_3:                                # %while.cond.1
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.const	$push3=, 4
	i32.add 	$push1=, $1, $pop3
	i32.store	$3=, 12($5), $pop1
	i32.load	$4=, 0($1)
	copy_local	$1=, $3
	br_if   	0, $4           # 0: up to label2
# BB#4:                                 # %while.end.1
	end_loop                        # label3:
	return
	.endfunc
.Lfunc_end0:
	.size	stub, .Lfunc_end0-stub

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push4=, __stack_pointer
	i32.load	$push5=, 0($pop4)
	i32.const	$push6=, 16
	i32.sub 	$1=, $pop5, $pop6
	i32.const	$push7=, __stack_pointer
	i32.store	$discard=, 0($pop7), $1
	i32.const	$push0=, 0
	i32.store	$0=, 12($1), $pop0
	i32.const	$push1=, .L.str.2
	i32.store	$discard=, 8($1), $pop1
	i32.const	$push2=, .L.str.1
	i32.store	$discard=, 4($1), $pop2
	i32.const	$push3=, .L.str
	i32.store	$discard=, 0($1), $pop3
	call    	stub@FUNCTION, $0, $1
	call    	exit@FUNCTION, $0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"ab"
	.size	.L.str, 3

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"bc"
	.size	.L.str.1, 3

	.type	.L.str.2,@object        # @.str.2
.L.str.2:
	.asciz	"cx"
	.size	.L.str.2, 3


	.ident	"clang version 3.9.0 "
