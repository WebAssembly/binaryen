	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20080506-2.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.load	$1=, 0($1)
	i32.load	$push6=, 0($0)
	tee_local	$push5=, $0=, $pop6
	i32.const	$push0=, 1
	i32.store	$discard=, 0($pop5), $pop0
	block
	i32.const	$push1=, 2
	i32.store	$push2=, 0($1), $pop1
	i32.load	$push3=, 0($0)
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 16
	i32.sub 	$7=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$7=, 0($1), $7
	i32.const	$3=, 12
	i32.add 	$3=, $7, $3
	i32.store	$discard=, 8($7), $3
	i32.const	$4=, 12
	i32.add 	$4=, $7, $4
	i32.store	$discard=, 4($7), $4
	i32.const	$5=, 8
	i32.add 	$5=, $7, $5
	i32.const	$6=, 4
	i32.add 	$6=, $7, $6
	call    	foo@FUNCTION, $5, $6
	i32.const	$push0=, 0
	i32.const	$2=, 16
	i32.add 	$7=, $7, $2
	i32.const	$2=, __stack_pointer
	i32.store	$7=, 0($2), $7
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
