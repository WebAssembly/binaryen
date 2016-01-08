	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20111212-1.c"
	.section	.text.frob_entry,"ax",@progbits
	.hidden	frob_entry
	.globl	frob_entry
	.type	frob_entry,@function
frob_entry:                             # @frob_entry
	.param  	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 3
	i32.add 	$1=, $0, $pop0
	i32.const	$push3=, 2
	i32.add 	$3=, $0, $pop3
	i32.const	$2=, 8
	block   	.LBB0_2
	i32.const	$push8=, 1
	i32.add 	$4=, $0, $pop8
	i32.load8_u	$push1=, 0($1)
	i32.shl 	$push2=, $pop1, $2
	i32.load8_u	$push4=, 0($3)
	i32.or  	$push5=, $pop2, $pop4
	i32.const	$push6=, 16
	i32.shl 	$push7=, $pop5, $pop6
	i32.load8_u	$push9=, 0($4)
	i32.shl 	$push10=, $pop9, $2
	i32.load8_u	$push11=, 0($0)
	i32.or  	$push12=, $pop10, $pop11
	i32.or  	$push13=, $pop7, $pop12
	i32.const	$push14=, 63
	i32.gt_u	$push15=, $pop13, $pop14
	br_if   	$pop15, .LBB0_2
# BB#1:                                 # %if.then
	i32.const	$push16=, 255
	i32.store8	$push17=, 0($0), $pop16
	i32.store8	$push18=, 0($1), $pop17
	i32.store8	$push19=, 0($3), $pop18
	i32.store8	$discard=, 0($4), $pop19
.LBB0_2:                                # %if.end
	return
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
	call    	frob_entry, $pop2
	i32.const	$push3=, 0
	i32.const	$2=, 16
	i32.add 	$4=, $4, $2
	i32.const	$2=, __stack_pointer
	i32.store	$4=, 0($2), $4
	return  	$pop3
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
