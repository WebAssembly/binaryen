	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-12.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	f64, f64, f64, f64, f64, f64, f64, f64, f64, i32
	.local  	i32, f64, i32
# BB#0:                                 # %entry
	i32.const	$push18=, __stack_pointer
	i32.load	$push19=, 0($pop18)
	i32.const	$push20=, 16
	i32.sub 	$12=, $pop19, $pop20
	i32.const	$push21=, __stack_pointer
	i32.store	$discard=, 0($pop21), $12
	i32.store	$push0=, 12($12), $9
	i32.const	$push1=, 7
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -8
	i32.and 	$push17=, $pop2, $pop3
	tee_local	$push16=, $9=, $pop17
	f64.load	$11=, 0($pop16)
	i32.const	$push4=, 8
	i32.add 	$push5=, $9, $pop4
	i32.store	$10=, 12($12), $pop5
	block
	f64.const	$push6=, 0x1.4p3
	f64.ne  	$push7=, $11, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#1:                                 # %if.end
	f64.load	$11=, 0($10)
	i32.const	$push8=, 16
	i32.add 	$push9=, $9, $pop8
	i32.store	$10=, 12($12), $pop9
	f64.const	$push10=, 0x1.6p3
	f64.ne  	$push11=, $11, $pop10
	br_if   	0, $pop11       # 0: down to label0
# BB#2:                                 # %if.end6
	f64.load	$11=, 0($10)
	i32.const	$push12=, 24
	i32.add 	$push13=, $9, $pop12
	i32.store	$discard=, 12($12), $pop13
	f64.const	$push14=, 0x0p0
	f64.ne  	$push15=, $11, $pop14
	br_if   	0, $pop15       # 0: down to label0
# BB#3:                                 # %if.end11
	i32.const	$push22=, 16
	i32.add 	$12=, $12, $pop22
	i32.const	$push23=, __stack_pointer
	i32.store	$discard=, 0($pop23), $12
	return
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
	.local  	f64, i32
# BB#0:                                 # %entry
	i32.const	$push6=, __stack_pointer
	i32.load	$push7=, 0($pop6)
	i32.const	$push8=, 32
	i32.sub 	$1=, $pop7, $pop8
	i32.const	$push9=, __stack_pointer
	i32.store	$discard=, 0($pop9), $1
	i32.const	$push0=, 16
	i32.add 	$push1=, $1, $pop0
	i64.const	$push2=, 0
	i64.store	$discard=, 0($pop1):p2align=4, $pop2
	i64.const	$push3=, 4622382067542392832
	i64.store	$discard=, 8($1), $pop3
	i64.const	$push4=, 4621819117588971520
	i64.store	$discard=, 0($1):p2align=4, $pop4
	call    	f@FUNCTION, $0, $0, $0, $0, $0, $0, $0, $0, $0, $1
	i32.const	$push5=, 0
	call    	exit@FUNCTION, $pop5
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
