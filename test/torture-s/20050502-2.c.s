	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20050502-2.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.store8	$discard=, 4($0), $pop0
	return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.store8	$discard=, 8($0), $pop0
	return
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$10=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$10=, 0($3), $10
	i32.const	$push2=, 10
	i32.const	$5=, 4
	i32.add 	$5=, $10, $5
	i32.add 	$push3=, $5, $pop2
	i32.const	$push0=, 0
	i32.load8_u	$push1=, .Lmain.x+10($pop0)
	i32.store8	$discard=, 0($pop3):p2align=1, $pop1
	i32.const	$push5=, 8
	i32.const	$6=, 4
	i32.add 	$6=, $10, $6
	i32.add 	$push6=, $6, $pop5
	i32.const	$push20=, 0
	i32.load16_u	$push4=, .Lmain.x+8($pop20):p2align=0
	i32.store16	$discard=, 0($pop6):p2align=2, $pop4
	i32.const	$push19=, 0
	i64.load	$push7=, .Lmain.x($pop19):p2align=0
	i64.store	$discard=, 4($10):p2align=2, $pop7
	i32.const	$push8=, 4
	i32.const	$7=, 4
	i32.add 	$7=, $10, $7
	i32.add 	$push18=, $7, $pop8
	tee_local	$push17=, $1=, $pop18
	i32.const	$push16=, 0
	i32.store8	$0=, 0($pop17):p2align=2, $pop16
	i32.const	$push9=, .L.str
	i32.const	$push15=, 11
	i32.const	$8=, 4
	i32.add 	$8=, $10, $8
	block
	block
	i32.call	$push10=, memcmp@FUNCTION, $8, $pop9, $pop15
	br_if   	0, $pop10       # 0: down to label1
# BB#1:                                 # %if.end
	i32.const	$push11=, 77
	i32.store8	$discard=, 0($1):p2align=2, $pop11
	i32.store8	$discard=, 12($10):p2align=2, $0
	i32.const	$push12=, .L.str.1
	i32.const	$push21=, 11
	i32.const	$9=, 4
	i32.add 	$9=, $10, $9
	i32.call	$push13=, memcmp@FUNCTION, $9, $pop12, $pop21
	br_if   	1, $pop13       # 1: down to label0
# BB#2:                                 # %if.end7
	i32.const	$push14=, 0
	i32.const	$4=, 16
	i32.add 	$10=, $10, $4
	i32.const	$4=, __stack_pointer
	i32.store	$10=, 0($4), $10
	return  	$pop14
.LBB2_3:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB2_4:                                # %if.then6
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	.Lmain.x,@object        # @main.x
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lmain.x:
	.asciz	"IJKLMNOPQR"
	.size	.Lmain.x, 11

	.type	.L.str,@object          # @.str
	.section	.rodata..L.str,"a",@progbits
.L.str:
	.asciz	"IJKL\000NOPQR"
	.size	.L.str, 11

	.type	.L.str.1,@object        # @.str.1
	.section	.rodata..L.str.1,"a",@progbits
.L.str.1:
	.asciz	"IJKLMNOP\000R"
	.size	.L.str.1, 11


	.ident	"clang version 3.9.0 "
