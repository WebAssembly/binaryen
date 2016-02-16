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
	i32.load	$push0=, 12($5)
	i32.const	$push12=, 3
	i32.add 	$push1=, $pop0, $pop12
	i32.const	$push11=, -4
	i32.and 	$push10=, $pop1, $pop11
	tee_local	$push9=, $1=, $pop10
	i32.const	$push8=, 4
	i32.add 	$push2=, $pop9, $pop8
	i32.store	$discard=, 12($5), $pop2
	i32.load	$push7=, 0($1)
	tee_local	$push6=, $1=, $pop7
	i32.const	$push5=, 10
	i32.gt_s	$push3=, $pop6, $pop5
	br_if   	0, $pop3        # 0: up to label0
# BB#2:                                 # %do.end
	end_loop                        # label1:
	i32.add 	$push4=, $1, $0
	i32.const	$4=, 16
	i32.add 	$5=, $5, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
	return  	$pop4
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
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$5=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	i32.store	$push0=, 8($5), $1
	i32.store	$discard=, 12($5), $pop0
.LBB1_1:                                # %do.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.load	$push1=, 12($5)
	i32.const	$push13=, 3
	i32.add 	$push2=, $pop1, $pop13
	i32.const	$push12=, -4
	i32.and 	$push11=, $pop2, $pop12
	tee_local	$push10=, $1=, $pop11
	i32.const	$push9=, 4
	i32.add 	$push3=, $pop10, $pop9
	i32.store	$discard=, 12($5), $pop3
	i32.load	$push8=, 0($1)
	tee_local	$push7=, $1=, $pop8
	i32.const	$push6=, 10
	i32.gt_s	$push4=, $pop7, $pop6
	br_if   	0, $pop4        # 0: up to label2
# BB#2:                                 # %bar.exit
	end_loop                        # label3:
	i32.add 	$push5=, $1, $0
	i32.const	$4=, 16
	i32.add 	$5=, $5, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
	return  	$pop5
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 16
	i32.sub 	$3=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$3=, 0($1), $3
	i64.const	$push0=, 12884901890
	i64.store	$discard=, 0($3):p2align=4, $pop0
	block
	i32.const	$push1=, 1
	i32.call	$push2=, foo@FUNCTION, $pop1, $3
	i32.const	$push3=, 3
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label4
# BB#1:                                 # %if.end
	i32.const	$push5=, 0
	i32.const	$2=, 16
	i32.add 	$3=, $3, $2
	i32.const	$2=, __stack_pointer
	i32.store	$3=, 0($2), $3
	return  	$pop5
.LBB2_2:                                # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
