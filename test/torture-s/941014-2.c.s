	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/941014-2.c"
	.section	.text.a1,"ax",@progbits
	.hidden	a1
	.globl	a1
	.type	a1,@function
a1:                                     # @a1
	.param  	i32
# BB#0:                                 # %entry
	return
	.endfunc
.Lfunc_end0:
	.size	a1, .Lfunc_end0-a1

	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 16
	i32.sub 	$4=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$4=, 0($2), $4
	block
	i32.const	$push0=, 4
	i32.call	$push8=, malloc@FUNCTION, $pop0
	tee_local	$push7=, $0=, $pop8
	i32.load16_u	$push1=, 0($pop7)
	i32.const	$push2=, 4096
	i32.lt_u	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.then
	i32.load16_u	$push4=, 0($0)
	i32.store	$discard=, 0($4):p2align=4, $pop4
	i32.const	$push5=, .L.str
	i32.call	$discard=, printf@FUNCTION, $pop5, $4
.LBB1_2:                                # %if.end
	end_block                       # label0:
	i32.const	$push6=, 256
	i32.store16	$discard=, 2($0), $pop6
	i32.const	$3=, 16
	i32.add 	$4=, $4, $3
	i32.const	$3=, __stack_pointer
	i32.store	$4=, 0($3), $4
	return  	$0
	.endfunc
.Lfunc_end1:
	.size	f, .Lfunc_end1-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 16
	i32.sub 	$3=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$3=, 0($2), $3
	block
	i32.const	$push0=, 4
	i32.call	$push12=, malloc@FUNCTION, $pop0
	tee_local	$push11=, $0=, $pop12
	i32.load16_u	$push1=, 0($pop11)
	i32.const	$push2=, 4096
	i32.lt_u	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label1
# BB#1:                                 # %if.then.i
	i32.load16_u	$push4=, 0($0)
	i32.store	$discard=, 0($3):p2align=4, $pop4
	i32.const	$push5=, .L.str
	i32.call	$discard=, printf@FUNCTION, $pop5, $3
.LBB2_2:                                # %f.exit
	end_block                       # label1:
	block
	i32.const	$push6=, 256
	i32.store16	$push7=, 2($0), $pop6
	i32.load16_u	$push8=, 2($0)
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	0, $pop9        # 0: down to label2
# BB#3:                                 # %if.end
	i32.const	$push10=, 0
	call    	exit@FUNCTION, $pop10
	unreachable
.LBB2_4:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"%d\n"
	.size	.L.str, 4


	.ident	"clang version 3.9.0 "
