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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, __stack_pointer
	i32.load	$6=, 0($6)
	i32.const	$7=, 16
	i32.sub 	$9=, $6, $7
	i32.const	$7=, __stack_pointer
	i32.store	$9=, 0($7), $9
	block
	i32.const	$push0=, 4
	i32.call	$0=, malloc@FUNCTION, $pop0
	i32.load16_u	$push1=, 0($0)
	i32.const	$push2=, 4096
	i32.lt_u	$push3=, $pop1, $pop2
	br_if   	$pop3, 0        # 0: down to label0
# BB#1:                                 # %if.then
	i32.load16_u	$1=, 0($0)
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 4
	i32.sub 	$9=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$9=, 0($3), $9
	i32.store	$discard=, 0($9), $1
	i32.const	$push4=, .L.str
	i32.call	$discard=, iprintf@FUNCTION, $pop4
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 4
	i32.add 	$9=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$9=, 0($5), $9
.LBB1_2:                                # %if.end
	end_block                       # label0:
	i32.const	$push5=, 256
	i32.store16	$discard=, 2($0), $pop5
	i32.const	$8=, 16
	i32.add 	$9=, $9, $8
	i32.const	$8=, __stack_pointer
	i32.store	$9=, 0($8), $9
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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, __stack_pointer
	i32.load	$6=, 0($6)
	i32.const	$7=, 16
	i32.sub 	$8=, $6, $7
	i32.const	$7=, __stack_pointer
	i32.store	$8=, 0($7), $8
	block
	i32.const	$push0=, 4
	i32.call	$0=, malloc@FUNCTION, $pop0
	i32.load16_u	$push1=, 0($0)
	i32.const	$push2=, 4096
	i32.lt_u	$push3=, $pop1, $pop2
	br_if   	$pop3, 0        # 0: down to label1
# BB#1:                                 # %if.then.i
	i32.load16_u	$1=, 0($0)
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 4
	i32.sub 	$8=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$8=, 0($3), $8
	i32.store	$discard=, 0($8), $1
	i32.const	$push4=, .L.str
	i32.call	$discard=, iprintf@FUNCTION, $pop4
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 4
	i32.add 	$8=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$8=, 0($5), $8
.LBB2_2:                                # %f.exit
	end_block                       # label1:
	block
	i32.load16_u	$push7=, 2($0)
	i32.const	$push5=, 256
	i32.store16	$push6=, 2($0), $pop5
	i32.ne  	$push8=, $pop7, $pop6
	br_if   	$pop8, 0        # 0: down to label2
# BB#3:                                 # %if.end
	i32.const	$push9=, 0
	call    	exit@FUNCTION, $pop9
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
	.section	".note.GNU-stack","",@progbits
