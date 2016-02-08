	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr38969.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1):p2align=2
	i64.store	$discard=, 0($0):p2align=2, $pop0
	return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 32
	i32.sub 	$10=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$10=, 0($4), $10
	i32.load	$2=, 4($1)
	i32.load	$push0=, 0($1)
	i32.store	$discard=, 16($10):p2align=3, $pop0
	i32.const	$push1=, 4
	i32.const	$6=, 8
	i32.add 	$6=, $10, $6
	i32.add 	$push4=, $6, $pop1
	i32.const	$push7=, 4
	i32.const	$7=, 16
	i32.add 	$7=, $10, $7
	i32.or  	$push2=, $7, $pop7
	i32.store	$push3=, 0($pop2), $2
	i32.store	$discard=, 0($pop4), $pop3
	i32.load	$push5=, 16($10):p2align=3
	i32.store	$discard=, 8($10), $pop5
	i32.const	$8=, 24
	i32.add 	$8=, $10, $8
	i32.const	$9=, 8
	i32.add 	$9=, $10, $9
	call    	foo@FUNCTION, $8, $9
	i64.load	$push6=, 24($10)
	i64.store	$discard=, 0($0):p2align=2, $pop6
	i32.const	$5=, 32
	i32.add 	$10=, $10, $5
	i32.const	$5=, __stack_pointer
	i32.store	$10=, 0($5), $10
	return
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 32
	i32.sub 	$6=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$6=, 0($1), $6
	i64.const	$push1=, 4767060206663237632
	i64.store	$push2=, 16($6), $pop1
	i64.store	$discard=, 8($6):p2align=2, $pop2
	i32.const	$3=, 24
	i32.add 	$3=, $6, $3
	i32.const	$4=, 8
	i32.add 	$4=, $6, $4
	call    	bar@FUNCTION, $3, $4
	block
	f32.load	$push3=, 24($6):p2align=3
	f32.const	$push6=, 0x1.2p3
	f32.ne  	$push7=, $pop3, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$push4=, 4
	i32.const	$5=, 24
	i32.add 	$5=, $6, $5
	i32.or  	$push5=, $5, $pop4
	f32.load	$push0=, 0($pop5)
	f32.const	$push8=, 0x1.5p5
	f32.ne  	$push9=, $pop0, $pop8
	br_if   	0, $pop9        # 0: down to label0
# BB#2:                                 # %if.end
	i32.const	$push10=, 0
	i32.const	$2=, 32
	i32.add 	$6=, $6, $2
	i32.const	$2=, __stack_pointer
	i32.store	$6=, 0($2), $6
	return  	$pop10
.LBB2_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
