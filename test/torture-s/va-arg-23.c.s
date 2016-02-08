	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-23.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32, i32, i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$8=, __stack_pointer
	i32.load	$8=, 0($8)
	i32.const	$9=, 16
	i32.sub 	$11=, $8, $9
	copy_local	$12=, $11
	i32.const	$9=, __stack_pointer
	i32.store	$11=, 0($9), $11
	i32.store	$push1=, 12($11), $12
	i32.const	$push2=, 3
	i32.add 	$push3=, $pop1, $pop2
	i32.const	$push4=, -4
	i32.and 	$push5=, $pop3, $pop4
	tee_local	$push12=, $7=, $pop5
	i32.const	$push6=, 4
	i32.add 	$push7=, $pop12, $pop6
	i32.store	$discard=, 12($11), $pop7
	block
	i32.const	$push8=, 1
	i32.ne  	$push9=, $6, $pop8
	br_if   	0, $pop9        # 0: down to label0
# BB#1:                                 # %entry
	i32.load	$push0=, 0($7)
	i32.const	$push10=, 2
	i32.ne  	$push11=, $pop0, $pop10
	br_if   	0, $pop11       # 0: down to label0
# BB#2:                                 # %if.end
	i32.const	$10=, 16
	i32.add 	$11=, $12, $10
	i32.const	$10=, __stack_pointer
	i32.store	$11=, 0($10), $11
	return
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 32
	i32.sub 	$9=, $5, $6
	i32.const	$6=, __stack_pointer
	i32.store	$9=, 0($6), $9
	i64.load	$push0=, 24($9)
	i64.store	$discard=, 16($9):p2align=2, $pop0
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 4
	i32.sub 	$9=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$9=, 0($2), $9
	i32.const	$push1=, 2
	i32.store	$discard=, 0($9), $pop1
	i32.const	$push2=, 1
	i32.const	$8=, 16
	i32.add 	$8=, $9, $8
	call    	foo@FUNCTION, $0, $0, $0, $0, $0, $8, $pop2
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 4
	i32.add 	$9=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$9=, 0($4), $9
	i32.const	$push3=, 0
	i32.const	$7=, 32
	i32.add 	$9=, $9, $7
	i32.const	$7=, __stack_pointer
	i32.store	$9=, 0($7), $9
	return  	$pop3
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
