	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20100805-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 1
	i32.and 	$0=, $0, $pop2
	block
	i32.const	$push6=, 0
	i32.eq  	$push7=, $1, $pop6
	br_if   	0, $pop7        # 0: down to label0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push5=, 1
	i32.shl 	$push0=, $0, $pop5
	i32.const	$push4=, 31
	i32.shr_u	$push1=, $0, $pop4
	i32.or  	$0=, $pop0, $pop1
	i32.const	$push3=, -1
	i32.add 	$1=, $1, $pop3
	br_if   	0, $1           # 0: up to label1
.LBB0_2:                                # %for.end
	end_loop                        # label2:
	end_block                       # label0:
	return  	$0
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
