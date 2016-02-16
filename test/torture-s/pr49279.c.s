	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr49279.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	#APP
	#NO_APP
	return  	$0
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 16
	i32.sub 	$8=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$8=, 0($4), $8
	i32.const	$push1=, 4
	i32.const	$6=, 8
	i32.add 	$6=, $8, $6
	i32.or  	$push8=, $6, $pop1
	tee_local	$push7=, $2=, $pop8
	i32.store	$discard=, 0($pop7), $0
	i32.const	$push0=, 1
	i32.store	$0=, 8($8):p2align=3, $pop0
	i32.const	$7=, 8
	i32.add 	$7=, $8, $7
	i32.call	$push2=, bar@FUNCTION, $7
	i32.store	$discard=, 4($pop2), $1
	i32.load	$push6=, 0($2)
	tee_local	$push5=, $2=, $pop6
	i32.const	$push3=, 0
	i32.store	$discard=, 0($pop5), $pop3
	i32.store	$discard=, 0($1), $0
	i32.load	$push4=, 0($2)
	i32.const	$5=, 16
	i32.add 	$8=, $8, $5
	i32.const	$5=, __stack_pointer
	i32.store	$8=, 0($5), $8
	return  	$pop4
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 16
	i32.sub 	$5=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$5=, 0($1), $5
	i32.const	$3=, 12
	i32.add 	$3=, $5, $3
	i32.const	$4=, 8
	i32.add 	$4=, $5, $4
	block
	i32.call	$push0=, foo@FUNCTION, $3, $4
	i32.const	$push1=, 1
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push3=, 0
	i32.const	$2=, 16
	i32.add 	$5=, $5, $2
	i32.const	$2=, __stack_pointer
	i32.store	$5=, 0($2), $5
	return  	$pop3
.LBB2_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
