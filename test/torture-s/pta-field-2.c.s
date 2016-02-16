	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pta-field-2.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, -4
	i32.add 	$push1=, $0, $pop0
	i32.load	$push2=, 0($pop1)
	i32.const	$push3=, 0
	i32.store	$discard=, 0($pop2), $pop3
	return
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 16
	i32.sub 	$6=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$6=, 0($2), $6
	i32.const	$push0=, 1
	i32.store	$discard=, 4($6), $pop0
	i32.const	$push1=, 2
	i32.store	$discard=, 0($6), $pop1
	i32.const	$4=, 4
	i32.add 	$4=, $6, $4
	i32.store	$discard=, 8($6):p2align=3, $4
	i32.const	$push2=, 4
	i32.const	$5=, 8
	i32.add 	$5=, $6, $5
	i32.or  	$push5=, $5, $pop2
	tee_local	$push4=, $0=, $pop5
	i32.store	$discard=, 0($pop4), $6
	call    	bar@FUNCTION, $0
	i32.load	$push3=, 4($6)
	i32.const	$3=, 16
	i32.add 	$6=, $6, $3
	i32.const	$3=, __stack_pointer
	i32.store	$6=, 0($3), $6
	return  	$pop3
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 16
	i32.sub 	$6=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$6=, 0($2), $6
	i32.const	$push0=, 1
	i32.store	$discard=, 4($6), $pop0
	i32.const	$push1=, 2
	i32.store	$discard=, 0($6), $pop1
	i32.const	$4=, 4
	i32.add 	$4=, $6, $4
	i32.store	$discard=, 8($6):p2align=3, $4
	i32.const	$push2=, 4
	i32.const	$5=, 8
	i32.add 	$5=, $6, $5
	i32.or  	$push6=, $5, $pop2
	tee_local	$push5=, $0=, $pop6
	i32.store	$discard=, 0($pop5), $6
	call    	bar@FUNCTION, $0
	block
	i32.load	$push3=, 4($6)
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push4=, 0
	i32.const	$3=, 16
	i32.add 	$6=, $6, $3
	i32.const	$3=, __stack_pointer
	i32.store	$6=, 0($3), $6
	return  	$pop4
.LBB2_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
