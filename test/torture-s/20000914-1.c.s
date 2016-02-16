	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000914-1.c"
	.section	.text.blah,"ax",@progbits
	.hidden	blah
	.globl	blah
	.type	blah,@function
blah:                                   # @blah
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	return  	$0
	.endfunc
.Lfunc_end0:
	.size	blah, .Lfunc_end0-blah

	.section	.text.convert_like_real,"ax",@progbits
	.hidden	convert_like_real
	.globl	convert_like_real
	.type	convert_like_real,@function
convert_like_real:                      # @convert_like_real
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.load8_u	$push0=, 8($0):p2align=2
	i32.const	$push1=, 222
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %sw.bb
	return  	$0
.LBB1_2:                                # %sw.epilog
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	convert_like_real, .Lfunc_end1-convert_like_real

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 12
	i32.call	$push4=, malloc@FUNCTION, $pop0
	tee_local	$push3=, $0=, $pop4
	i32.const	$push1=, 222
	i32.store	$discard=, 8($pop3), $pop1
	i32.call	$discard=, convert_like_real@FUNCTION, $0
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
