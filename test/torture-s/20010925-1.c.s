	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20010925-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64
# BB#0:                                 # %if.end
	i32.const	$0=, 0
	i64.load	$1=, src($0)
	i32.load16_u	$push0=, src+8($0)
	i32.store16	$discard=, dst+8($0), $pop0
	i64.store	$discard=, dst($0), $1
	call    	exit@FUNCTION, $0
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$3=, 1
	block
	i32.const	$push0=, 0
	i32.eq  	$push1=, $2, $pop0
	br_if   	$pop1, 0        # 0: down to label0
# BB#1:                                 # %if.end
	call    	memcpy@FUNCTION, $0, $1, $2
	i32.const	$3=, 0
.LBB1_2:                                # %return
	end_block                       # label0:
	return  	$3
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.hidden	dst                     # @dst
	.type	dst,@object
	.section	.bss.dst,"aw",@nobits
	.globl	dst
	.align	4
dst:
	.skip	40
	.size	dst, 40

	.hidden	src                     # @src
	.type	src,@object
	.section	.bss.src,"aw",@nobits
	.globl	src
	.align	4
src:
	.skip	40
	.size	src, 40


	.ident	"clang version 3.9.0 "
