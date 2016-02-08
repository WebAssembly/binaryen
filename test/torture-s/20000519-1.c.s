	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000519-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$5=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	i32.store	$discard=, 12($5), $1
.LBB0_1:                                # %do.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.load	$push1=, 12($5)
	i32.const	$push12=, 3
	i32.add 	$push2=, $pop1, $pop12
	i32.const	$push11=, -4
	i32.and 	$push3=, $pop2, $pop11
	tee_local	$push10=, $1=, $pop3
	i32.const	$push9=, 4
	i32.add 	$push4=, $pop10, $pop9
	i32.store	$discard=, 12($5), $pop4
	i32.load	$push0=, 0($1)
	tee_local	$push8=, $1=, $pop0
	i32.const	$push7=, 10
	i32.gt_s	$push5=, $pop8, $pop7
	br_if   	0, $pop5        # 0: up to label0
# BB#2:                                 # %do.end
	end_loop                        # label1:
	i32.add 	$push6=, $1, $0
	i32.const	$4=, 16
	i32.add 	$5=, $5, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
	return  	$pop6
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$5=, $2, $3
	copy_local	$6=, $5
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	i32.store	$push1=, 8($5), $6
	i32.store	$discard=, 12($5), $pop1
.LBB1_1:                                # %do.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.load	$push2=, 12($5)
	i32.const	$push13=, 3
	i32.add 	$push3=, $pop2, $pop13
	i32.const	$push12=, -4
	i32.and 	$push4=, $pop3, $pop12
	tee_local	$push11=, $1=, $pop4
	i32.const	$push10=, 4
	i32.add 	$push5=, $pop11, $pop10
	i32.store	$discard=, 12($5), $pop5
	i32.load	$push0=, 0($1)
	tee_local	$push9=, $1=, $pop0
	i32.const	$push8=, 10
	i32.gt_s	$push6=, $pop9, $pop8
	br_if   	0, $pop6        # 0: up to label2
# BB#2:                                 # %bar.exit
	end_loop                        # label3:
	i32.add 	$push7=, $1, $0
	i32.const	$4=, 16
	i32.add 	$5=, $6, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
	return  	$pop7
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 16
	i32.sub 	$8=, $5, $6
	i32.const	$6=, __stack_pointer
	i32.store	$8=, 0($6), $8
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 8
	i32.sub 	$8=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$8=, 0($2), $8
	i64.const	$push0=, 12884901890
	i64.store	$discard=, 0($8):p2align=2, $pop0
	i32.const	$push1=, 1
	i32.call	$0=, foo@FUNCTION, $pop1
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 8
	i32.add 	$8=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$8=, 0($4), $8
	block
	i32.const	$push2=, 3
	i32.ne  	$push3=, $0, $pop2
	br_if   	0, $pop3        # 0: down to label4
# BB#1:                                 # %if.end
	i32.const	$push4=, 0
	i32.const	$7=, 16
	i32.add 	$8=, $8, $7
	i32.const	$7=, __stack_pointer
	i32.store	$8=, 0($7), $8
	return  	$pop4
.LBB2_2:                                # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
