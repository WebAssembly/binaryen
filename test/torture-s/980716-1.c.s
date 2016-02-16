	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/980716-1.c"
	.section	.text.stub,"ax",@progbits
	.hidden	stub
	.globl	stub
	.type	stub,@function
stub:                                   # @stub
	.param  	i32, i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 16
	i32.sub 	$6=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$6=, 0($4), $6
	i32.store	$2=, 12($6), $1
.LBB0_1:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.load	$push0=, 12($6)
	i32.const	$push12=, 3
	i32.add 	$push1=, $pop0, $pop12
	i32.const	$push11=, -4
	i32.and 	$push10=, $pop1, $pop11
	tee_local	$push9=, $1=, $pop10
	i32.const	$push8=, 4
	i32.add 	$push2=, $pop9, $pop8
	i32.store	$discard=, 12($6), $pop2
	i32.load	$push3=, 0($1)
	br_if   	0, $pop3        # 0: up to label0
# BB#2:                                 # %while.end
	end_loop                        # label1:
	i32.store	$discard=, 12($6), $2
.LBB0_3:                                # %while.body.1
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.load	$push4=, 12($6)
	i32.const	$push17=, 3
	i32.add 	$push5=, $pop4, $pop17
	i32.const	$push16=, -4
	i32.and 	$push15=, $pop5, $pop16
	tee_local	$push14=, $1=, $pop15
	i32.const	$push13=, 4
	i32.add 	$push6=, $pop14, $pop13
	i32.store	$discard=, 12($6), $pop6
	i32.load	$push7=, 0($1)
	br_if   	0, $pop7        # 0: up to label2
# BB#4:                                 # %while.end.1
	end_loop                        # label3:
	i32.const	$5=, 16
	i32.add 	$6=, $6, $5
	i32.const	$5=, __stack_pointer
	i32.store	$6=, 0($5), $6
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
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 16
	i32.sub 	$3=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$3=, 0($2), $3
	i32.const	$push0=, 12
	i32.or  	$push1=, $3, $pop0
	i32.const	$push2=, 0
	i32.store	$0=, 0($pop1), $pop2
	i32.const	$push3=, 8
	i32.or  	$push4=, $3, $pop3
	i32.const	$push5=, .L.str.2
	i32.store	$discard=, 0($pop4):p2align=3, $pop5
	i32.const	$push6=, 4
	i32.or  	$push7=, $3, $pop6
	i32.const	$push8=, .L.str.1
	i32.store	$discard=, 0($pop7), $pop8
	i32.const	$push9=, .L.str
	i32.store	$discard=, 0($3):p2align=4, $pop9
	call    	stub@FUNCTION, $0, $3
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
