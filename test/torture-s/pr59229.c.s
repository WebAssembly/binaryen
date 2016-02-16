	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr59229.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	block
	block
	i32.const	$push0=, 0
	i32.load	$push17=, i($pop0)
	tee_local	$push16=, $1=, $pop17
	i32.const	$push1=, -1
	i32.add 	$push2=, $pop16, $pop1
	i32.const	$push3=, 6
	i32.ge_u	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label1
# BB#1:                                 # %if.end
	i32.const	$push7=, .L.str
	i32.const	$push5=, 1
	i32.add 	$push6=, $1, $pop5
	i32.call	$push8=, memcmp@FUNCTION, $0, $pop7, $pop6
	br_if   	1, $pop8        # 1: down to label0
# BB#2:                                 # %if.end4
	i32.const	$push9=, 538976288
	i32.store	$discard=, 0($0):p2align=0, $pop9
	i32.const	$push10=, 6
	i32.add 	$push11=, $0, $pop10
	i32.const	$push12=, 32
	i32.store8	$discard=, 0($pop11), $pop12
	i32.const	$push13=, 4
	i32.add 	$push14=, $0, $pop13
	i32.const	$push15=, 8224
	i32.store16	$discard=, 0($pop14):p2align=0, $pop15
	return
.LBB0_3:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_4:                                # %if.then3
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$7=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$7=, 0($3), $7
	block
	i32.const	$push0=, -1
	i32.add 	$push1=, $1, $pop0
	i32.const	$push2=, 5
	i32.gt_u	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label2
# BB#1:                                 # %if.end
	i32.const	$push4=, 1
	i32.add 	$push5=, $1, $pop4
	i32.const	$5=, 9
	i32.add 	$5=, $7, $5
	i32.call	$discard=, memcpy@FUNCTION, $5, $0, $pop5
	i32.const	$6=, 9
	i32.add 	$6=, $7, $6
	call    	bar@FUNCTION, $6
.LBB1_2:                                # %return
	end_block                       # label2:
	i32.const	$4=, 16
	i32.add 	$7=, $7, $4
	i32.const	$4=, __stack_pointer
	i32.store	$7=, 0($4), $7
	return
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push5=, 0
	i32.store	$0=, i($pop1), $pop5
	copy_local	$1=, $0
.LBB2_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	i32.const	$push8=, .L.str.1
	call    	foo@FUNCTION, $pop8, $1
	i32.load	$push2=, i($0)
	i32.const	$push7=, 1
	i32.add 	$push0=, $pop2, $pop7
	i32.store	$1=, i($0), $pop0
	i32.const	$push6=, 16
	i32.lt_s	$push3=, $1, $pop6
	br_if   	0, $pop3        # 0: up to label3
# BB#2:                                 # %for.end
	end_loop                        # label4:
	i32.const	$push4=, 0
	return  	$pop4
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.p2align	2
i:
	.int32	0                       # 0x0
	.size	i, 4

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"abcdefg"
	.size	.L.str, 8

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"abcdefghijklmnop"
	.size	.L.str.1, 17


	.ident	"clang version 3.9.0 "
