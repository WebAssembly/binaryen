	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-26.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	f32, f32, f32, f32, f32, f32
	.result 	f64
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$7=, __stack_pointer
	i32.load	$7=, 0($7)
	i32.const	$8=, 16
	i32.sub 	$10=, $7, $8
	copy_local	$11=, $10
	i32.const	$8=, __stack_pointer
	i32.store	$10=, 0($8), $10
	i32.store	$push0=, 12($10), $11
	i32.const	$push1=, 7
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -8
	i32.and 	$push4=, $pop2, $pop3
	tee_local	$push8=, $6=, $pop4
	i32.const	$push5=, 8
	i32.add 	$push6=, $pop8, $pop5
	i32.store	$discard=, 12($10), $pop6
	f64.load	$push7=, 0($6)
	i32.const	$9=, 16
	i32.add 	$10=, $11, $9
	i32.const	$9=, __stack_pointer
	i32.store	$10=, 0($9), $10
	return  	$pop7
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	f64, f32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, __stack_pointer
	i32.load	$6=, 0($6)
	i32.const	$7=, 16
	i32.sub 	$8=, $6, $7
	i32.const	$7=, __stack_pointer
	i32.store	$8=, 0($7), $8
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 8
	i32.sub 	$8=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$8=, 0($3), $8
	i64.const	$push0=, 4619567317775286272
	i64.store	$discard=, 0($8), $pop0
	f64.call	$0=, f@FUNCTION, $1, $1, $1, $1, $1, $1
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 8
	i32.add 	$8=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$8=, 0($5), $8
	block
	f64.const	$push1=, 0x1.cp2
	f64.eq  	$push2=, $0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB1_2:                                # %if.end
	end_block                       # label0:
	i32.const	$push3=, 0
	call    	exit@FUNCTION, $pop3
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
