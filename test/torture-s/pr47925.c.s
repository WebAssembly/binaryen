	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr47925.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
# BB#0:                                 # %entry
	#APP
	#NO_APP
	return
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
# BB#0:                                 # %entry
	call    	bar@FUNCTION, $1, $1
	block
	i32.const	$push0=, 1
	i32.lt_s	$push1=, $1, $pop0
	br_if   	0, $pop1        # 0: down to label0
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.load	$0=, 0($0)
	i32.const	$push2=, -1
	i32.add 	$1=, $1, $pop2
	br_if   	0, $1           # 0: up to label1
.LBB1_2:                                # %for.end
	end_loop                        # label2:
	end_block                       # label0:
	return  	$1
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push2=, __stack_pointer
	i32.load	$push3=, 0($pop2)
	i32.const	$push4=, 16
	i32.sub 	$2=, $pop3, $pop4
	i32.const	$push5=, __stack_pointer
	i32.store	$discard=, 0($pop5), $2
	i32.const	$0=, 8
	i32.add 	$0=, $2, $0
	i32.store	$discard=, 8($2):p2align=3, $0
	i32.const	$push0=, 10
	i32.const	$1=, 8
	i32.add 	$1=, $2, $1
	i32.call	$discard=, foo@FUNCTION, $1, $pop0
	i32.const	$push1=, 0
	i32.const	$push6=, 16
	i32.add 	$2=, $2, $pop6
	i32.const	$push7=, __stack_pointer
	i32.store	$discard=, 0($pop7), $2
	return  	$pop1
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
