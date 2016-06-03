	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/941014-2.c"
	.section	.text.a1,"ax",@progbits
	.hidden	a1
	.globl	a1
	.type	a1,@function
a1:                                     # @a1
	.param  	i32
# BB#0:                                 # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	a1, .Lfunc_end0-a1

	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push10=, 0
	i32.const	$push7=, 0
	i32.load	$push8=, __stack_pointer($pop7)
	i32.const	$push9=, 16
	i32.sub 	$push14=, $pop8, $pop9
	i32.store	$0=, __stack_pointer($pop10), $pop14
	block
	i32.const	$push0=, 4
	i32.call	$push16=, malloc@FUNCTION, $pop0
	tee_local	$push15=, $1=, $pop16
	i32.load16_u	$push1=, 0($pop15)
	i32.const	$push2=, 4096
	i32.lt_u	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.then
	i32.load16_u	$push4=, 0($1)
	i32.store	$drop=, 0($0), $pop4
	i32.const	$push5=, .L.str
	i32.call	$drop=, printf@FUNCTION, $pop5, $0
.LBB1_2:                                # %if.end
	end_block                       # label0:
	i32.const	$push6=, 256
	i32.store16	$drop=, 2($1), $pop6
	i32.const	$push13=, 0
	i32.const	$push11=, 16
	i32.add 	$push12=, $0, $pop11
	i32.store	$drop=, __stack_pointer($pop13), $pop12
	copy_local	$push17=, $1
                                        # fallthrough-return: $pop17
	.endfunc
.Lfunc_end1:
	.size	f, .Lfunc_end1-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push14=, 0
	i32.const	$push11=, 0
	i32.load	$push12=, __stack_pointer($pop11)
	i32.const	$push13=, 16
	i32.sub 	$push15=, $pop12, $pop13
	i32.store	$0=, __stack_pointer($pop14), $pop15
	block
	i32.const	$push1=, 4
	i32.call	$push17=, malloc@FUNCTION, $pop1
	tee_local	$push16=, $1=, $pop17
	i32.load16_u	$push2=, 0($pop16)
	i32.const	$push3=, 4096
	i32.lt_u	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label1
# BB#1:                                 # %if.then.i
	i32.load16_u	$push5=, 0($1)
	i32.store	$drop=, 0($0), $pop5
	i32.const	$push6=, .L.str
	i32.call	$drop=, printf@FUNCTION, $pop6, $0
.LBB2_2:                                # %f.exit
	end_block                       # label1:
	block
	i32.const	$push7=, 256
	i32.store16	$push0=, 2($1), $pop7
	i32.load16_u	$push8=, 2($1)
	i32.ne  	$push9=, $pop0, $pop8
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
	.functype	malloc, i32, i32
	.functype	printf, i32, i32
	.functype	abort, void
	.functype	exit, void, i32
