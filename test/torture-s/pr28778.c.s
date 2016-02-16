	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr28778.c"
	.section	.text.find,"ax",@progbits
	.hidden	find
	.globl	find
	.type	find,@function
find:                                   # @find
	.param  	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 128
	i32.sub 	$4=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$4=, 0($2), $4
	block
	br_if   	0, $0           # 0: down to label0
# BB#1:                                 # %if.else
	i32.const	$push0=, 12
	i32.or  	$push1=, $4, $pop0
	i32.const	$push2=, 42
	i32.store	$discard=, 0($pop1), $pop2
	copy_local	$0=, $4
.LBB0_2:                                # %if.end
	end_block                       # label0:
	block
	i32.load	$push3=, 12($0)
	i32.const	$push4=, 42
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label1
# BB#3:                                 # %aglChoosePixelFormat.exit
	i32.const	$3=, 128
	i32.add 	$4=, $4, $3
	i32.const	$3=, __stack_pointer
	i32.store	$4=, 0($3), $4
	return
.LBB0_4:                                # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	find, .Lfunc_end0-find

	.section	.text.aglChoosePixelFormat,"ax",@progbits
	.hidden	aglChoosePixelFormat
	.globl	aglChoosePixelFormat
	.type	aglChoosePixelFormat,@function
aglChoosePixelFormat:                   # @aglChoosePixelFormat
	.param  	i32
# BB#0:                                 # %entry
	block
	i32.load	$push0=, 12($0)
	i32.const	$push1=, 42
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label2
# BB#1:                                 # %if.end
	return
.LBB1_2:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	aglChoosePixelFormat, .Lfunc_end1-aglChoosePixelFormat

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %find.exit
	i32.const	$push0=, 0
	return  	$pop0
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
