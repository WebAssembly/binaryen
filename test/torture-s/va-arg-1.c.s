	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push16=, __stack_pointer
	i32.const	$push13=, __stack_pointer
	i32.load	$push14=, 0($pop13)
	i32.const	$push15=, 16
	i32.sub 	$push20=, $pop14, $pop15
	i32.store	$12=, 0($pop16), $pop20
	i32.store	$push22=, 12($12), $9
	tee_local	$push21=, $9=, $pop22
	i32.const	$push0=, 4
	i32.add 	$push1=, $pop21, $pop0
	i32.store	$10=, 12($12), $pop1
	block
	i32.load	$push2=, 0($9)
	i32.const	$push3=, 10
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push5=, 8
	i32.add 	$push6=, $9, $pop5
	i32.store	$11=, 12($12), $pop6
	i32.load	$push7=, 0($10)
	i32.const	$push8=, 11
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	0, $pop9        # 0: down to label0
# BB#2:                                 # %if.end6
	i32.const	$push10=, 12
	i32.add 	$push11=, $9, $pop10
	i32.store	$discard=, 12($12), $pop11
	i32.load	$push12=, 0($11)
	br_if   	0, $pop12       # 0: down to label0
# BB#3:                                 # %if.end11
	i32.const	$push19=, __stack_pointer
	i32.const	$push17=, 16
	i32.add 	$push18=, $12, $pop17
	i32.store	$discard=, 0($pop19), $pop18
	return  	$12
.LBB0_4:                                # %if.then10
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push5=, __stack_pointer
	i32.const	$push2=, __stack_pointer
	i32.load	$push3=, 0($pop2)
	i32.const	$push4=, 16
	i32.sub 	$push6=, $pop3, $pop4
	i32.store	$push8=, 0($pop5), $pop6
	tee_local	$push7=, $1=, $pop8
	i32.const	$push0=, 0
	i32.store	$0=, 8($pop7), $pop0
	i64.const	$push1=, 47244640266
	i64.store	$discard=, 0($1), $pop1
	i32.call	$discard=, f@FUNCTION, $1, $1, $1, $1, $1, $1, $1, $1, $1, $1
	call    	exit@FUNCTION, $0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
