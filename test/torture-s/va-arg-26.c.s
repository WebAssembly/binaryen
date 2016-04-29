	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-26.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	f32, f32, f32, f32, f32, f32, i32
	.result 	f64
	.local  	f64, i32
# BB#0:                                 # %entry
	i32.const	$push8=, __stack_pointer
	i32.load	$push9=, 0($pop8)
	i32.const	$push10=, 16
	i32.sub 	$8=, $pop9, $pop10
	i32.store	$push0=, 12($8), $6
	i32.const	$push1=, 7
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -8
	i32.and 	$push7=, $pop2, $pop3
	tee_local	$push6=, $6=, $pop7
	f64.load	$7=, 0($pop6)
	i32.const	$push4=, 8
	i32.add 	$push5=, $6, $pop4
	i32.store	$discard=, 12($8), $pop5
	return  	$7
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	f32, i32
# BB#0:                                 # %entry
	i32.const	$push5=, __stack_pointer
	i32.load	$push6=, 0($pop5)
	i32.const	$push7=, 16
	i32.sub 	$1=, $pop6, $pop7
	i32.const	$push8=, __stack_pointer
	i32.store	$discard=, 0($pop8), $1
	i64.const	$push0=, 4619567317775286272
	i64.store	$discard=, 0($1), $pop0
	block
	f64.call	$push1=, f@FUNCTION, $0, $0, $0, $0, $0, $0, $1
	f64.const	$push2=, 0x1.cp2
	f64.eq  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB1_2:                                # %if.end
	end_block                       # label0:
	i32.const	$push4=, 0
	call    	exit@FUNCTION, $pop4
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
