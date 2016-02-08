	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/980716-1.c"
	.section	.text.stub,"ax",@progbits
	.hidden	stub
	.globl	stub
	.type	stub,@function
stub:                                   # @stub
	.param  	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$5=, $2, $3
	copy_local	$6=, $5
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	i32.store	$discard=, 12($5), $6
.LBB0_1:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.load	$push0=, 12($5)
	i32.const	$push13=, 3
	i32.add 	$push1=, $pop0, $pop13
	i32.const	$push12=, -4
	i32.and 	$push2=, $pop1, $pop12
	tee_local	$push11=, $1=, $pop2
	i32.const	$push10=, 4
	i32.add 	$push3=, $pop11, $pop10
	i32.store	$discard=, 12($5), $pop3
	i32.load	$push4=, 0($1)
	br_if   	0, $pop4        # 0: up to label0
# BB#2:                                 # %while.end
	end_loop                        # label1:
	i32.store	$discard=, 12($5), $6
.LBB0_3:                                # %while.body.1
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.load	$push5=, 12($5)
	i32.const	$push17=, 3
	i32.add 	$push6=, $pop5, $pop17
	i32.const	$push16=, -4
	i32.and 	$push7=, $pop6, $pop16
	tee_local	$push15=, $1=, $pop7
	i32.const	$push14=, 4
	i32.add 	$push8=, $pop15, $pop14
	i32.store	$discard=, 12($5), $pop8
	i32.load	$push9=, 0($1)
	br_if   	0, $pop9        # 0: up to label2
# BB#4:                                 # %while.end.1
	end_loop                        # label3:
	i32.const	$4=, 16
	i32.add 	$5=, $6, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, __stack_pointer
	i32.load	$6=, 0($6)
	i32.const	$7=, 16
	i32.sub 	$8=, $6, $7
	i32.const	$7=, __stack_pointer
	i32.store	$8=, 0($7), $8
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$8=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$8=, 0($3), $8
	i32.const	$push0=, .L.str
	i32.store	$discard=, 0($8), $pop0
	i32.const	$push1=, 12
	i32.add 	$0=, $8, $pop1
	i32.const	$push2=, 0
	i32.store	$0=, 0($0), $pop2
	i32.const	$push3=, 8
	i32.add 	$1=, $8, $pop3
	i32.const	$push4=, .L.str.2
	i32.store	$discard=, 0($1), $pop4
	i32.const	$push5=, 4
	i32.add 	$1=, $8, $pop5
	i32.const	$push6=, .L.str.1
	i32.store	$discard=, 0($1), $pop6
	call    	stub@FUNCTION, $0
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 16
	i32.add 	$8=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$8=, 0($5), $8
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
