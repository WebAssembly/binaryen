	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/920908-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push13=, __stack_pointer
	i32.load	$push14=, 0($pop13)
	i32.const	$push15=, 16
	i32.sub 	$3=, $pop14, $pop15
	i32.const	$push16=, __stack_pointer
	i32.store	$discard=, 0($pop16), $3
	i32.store	$push10=, 12($3), $1
	tee_local	$push9=, $1=, $pop10
	i32.const	$push0=, 4
	i32.add 	$push1=, $pop9, $pop0
	i32.store	$2=, 12($3), $pop1
	block
	i32.load	$push2=, 0($1)
	i32.const	$push3=, 10
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push5=, 8
	i32.add 	$push6=, $1, $pop5
	i32.store	$discard=, 12($3), $pop6
	i32.load	$push7=, 0($2)
	i32.const	$push11=, 20
	i32.ne  	$push8=, $pop7, $pop11
	br_if   	0, $pop8        # 0: down to label0
# BB#2:                                 # %if.end7
	i32.const	$push12=, 20
	i32.const	$push19=, __stack_pointer
	i32.const	$push17=, 16
	i32.add 	$push18=, $3, $pop17
	i32.store	$discard=, 0($pop19), $pop18
	return  	$pop12
.LBB0_3:                                # %if.then6
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
	i32.const	$push2=, __stack_pointer
	i32.load	$push3=, 0($pop2)
	i32.const	$push4=, 16
	i32.sub 	$1=, $pop3, $pop4
	i32.const	$push5=, __stack_pointer
	i32.store	$discard=, 0($pop5), $1
	i64.const	$push0=, 85899345930
	i64.store	$discard=, 0($1):p2align=4, $pop0
	i32.call	$discard=, f@FUNCTION, $0, $1
	i32.const	$push1=, 0
	call    	exit@FUNCTION, $pop1
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
