	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr36343.c"
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.store	$discard=, 0($0), $pop0
	return
func_end0:
	.size	bar, func_end0-bar

	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	f32
	.local  	i32, f32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 16
	i32.sub 	$7=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$7=, 0($4), $7
	i32.const	$push0=, 0
	i32.store	$discard=, 12($7), $pop0
	i32.const	$6=, 12
	i32.add 	$6=, $7, $6
	i32.const	$7=, 8
	i32.add 	$7=, $7, $7
	i32.select	$1=, $0, $6, $7
	i32.const	$push1=, 1065353216
	i32.store	$discard=, 8($7), $pop1
	call    	bar, $1
	block   	BB1_3
	block   	BB1_2
	i32.const	$push4=, 0
	i32.eq  	$push5=, $0, $pop4
	br_if   	$pop5, BB1_2
# BB#1:                                 # %if.then2
	i32.load	$push2=, 0($1)
	i32.load	$push3=, 0($pop2)
	f32.convert_s/i32	$2=, $pop3
	br      	BB1_3
BB1_2:                                  # %if.end3
	f32.load	$2=, 8($7)
BB1_3:                                  # %cleanup
	i32.const	$5=, 16
	i32.add 	$7=, $7, $5
	i32.const	$5=, __stack_pointer
	i32.store	$7=, 0($5), $7
	return  	$2
func_end1:
	.size	foo, func_end1-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	BB2_2
	f32.call	$push0=, foo, $0
	f32.const	$push1=, 0x0p0
	f32.ne  	$push2=, $pop0, $pop1
	br_if   	$pop2, BB2_2
# BB#1:                                 # %if.end
	return  	$0
BB2_2:                                  # %if.then
	call    	abort
	unreachable
func_end2:
	.size	main, func_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
