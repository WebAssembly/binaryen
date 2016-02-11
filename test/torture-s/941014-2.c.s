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
	i32.const	$push1=, 4
	i32.call	$push0=, malloc@FUNCTION, $pop1
	tee_local	$push8=, $0=, $pop0
	i32.load16_u	$push2=, 0($pop8)
	i32.const	$push3=, 4096
	i32.lt_u	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %if.then
	i32.load16_u	$push5=, 0($0)
	i32.store	$discard=, 0($4):p2align=4, $pop5
	i32.const	$push6=, .L.str
	i32.call	$discard=, printf@FUNCTION, $pop6, $4
.LBB1_2:                                # %if.end
	end_block                       # label0:
	i32.const	$push7=, 256
	i32.store16	$discard=, 2($0), $pop7
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
	i32.const	$push1=, 4
	i32.call	$push0=, malloc@FUNCTION, $pop1
	tee_local	$push12=, $0=, $pop0
	i32.load16_u	$push2=, 0($pop12)
	i32.const	$push3=, 4096
	i32.lt_u	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label1
# BB#1:                                 # %if.then.i
	i32.load16_u	$push5=, 0($0)
	i32.store	$discard=, 0($3):p2align=4, $pop5
	i32.const	$push6=, .L.str
	i32.call	$discard=, printf@FUNCTION, $pop6, $3
.LBB2_2:                                # %f.exit
	end_block                       # label1:
	block
	i32.const	$push7=, 256
	i32.store16	$push8=, 2($0), $pop7
	i32.load16_u	$push9=, 2($0)
	i32.ne  	$push10=, $pop8, $pop9
	br_if   	0, $pop10       # 0: down to label2
# BB#3:                                 # %if.end
	i32.const	$push11=, 0
	call    	exit@FUNCTION, $pop11
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
