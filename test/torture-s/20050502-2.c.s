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
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i64, i32, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, __stack_pointer
	i32.load	$6=, 0($6)
	i32.const	$7=, 16
	i32.sub 	$14=, $6, $7
	i32.const	$7=, __stack_pointer
	i32.store	$14=, 0($7), $14
	i32.const	$0=, 0
	i32.const	$1=, 1
	i32.const	$push1=, 10
	i32.const	$9=, 0
	i32.add 	$9=, $14, $9
	i32.add 	$push2=, $9, $pop1
	i32.load8_u	$push0=, .Lmain.x+10($0)
	i32.store8	$discard=, 0($pop2), $pop0
	i32.const	$2=, 8
	i32.const	$10=, 0
	i32.add 	$10=, $14, $10
	i32.add 	$push9=, $10, $2
	i32.const	$push3=, .Lmain.x+8
	i32.add 	$push4=, $pop3, $1
	i32.load8_u	$push5=, 0($pop4)
	i32.shl 	$push6=, $pop5, $2
	i32.load8_u	$push7=, .Lmain.x+8($0)
	i32.or  	$push8=, $pop6, $pop7
	i32.store16	$discard=, 0($pop9), $pop8
	i32.const	$2=, .Lmain.x
	i32.const	$4=, 4
	i64.const	$3=, 8
	i64.const	$5=, 16
	i32.const	$push17=, 7
	i32.add 	$push18=, $2, $pop17
	i64.load8_u	$push19=, 0($pop18)
	i64.shl 	$push20=, $pop19, $3
	i32.const	$push21=, 6
	i32.add 	$push22=, $2, $pop21
	i64.load8_u	$push23=, 0($pop22)
	i64.or  	$push24=, $pop20, $pop23
	i64.shl 	$push25=, $pop24, $5
	i32.const	$push10=, 5
	i32.add 	$push11=, $2, $pop10
	i64.load8_u	$push12=, 0($pop11)
	i64.shl 	$push13=, $pop12, $3
	i32.add 	$push14=, $2, $4
	i64.load8_u	$push15=, 0($pop14)
	i64.or  	$push16=, $pop13, $pop15
	i64.or  	$push26=, $pop25, $pop16
	i64.const	$push27=, 32
	i64.shl 	$push28=, $pop26, $pop27
	i32.const	$push29=, 3
	i32.add 	$push30=, $2, $pop29
	i64.load8_u	$push31=, 0($pop30)
	i64.shl 	$push32=, $pop31, $3
	i32.const	$push33=, 2
	i32.add 	$push34=, $2, $pop33
	i64.load8_u	$push35=, 0($pop34)
	i64.or  	$push36=, $pop32, $pop35
	i64.shl 	$push37=, $pop36, $5
	i32.add 	$push38=, $2, $1
	i64.load8_u	$push39=, 0($pop38)
	i64.shl 	$push40=, $pop39, $3
	i64.load8_u	$push41=, .Lmain.x($0)
	i64.or  	$push42=, $pop40, $pop41
	i64.or  	$push43=, $pop37, $pop42
	i64.or  	$push44=, $pop28, $pop43
	i64.store	$discard=, 0($14), $pop44
	i32.const	$11=, 0
	i32.add 	$11=, $14, $11
	i32.or  	$2=, $11, $4
	i32.const	$1=, 11
	i32.store8	$discard=, 0($2), $0
	i32.const	$push45=, .L.str
	i32.const	$12=, 0
	i32.add 	$12=, $14, $12
	block
	i32.call	$push46=, memcmp@FUNCTION, $12, $pop45, $1
	br_if   	$pop46, 0       # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push47=, 77
	i32.store8	$discard=, 0($2), $pop47
	i32.store8	$2=, 8($14), $0
	i32.const	$push48=, .L.str.1
	i32.const	$13=, 0
	i32.add 	$13=, $14, $13
	block
	i32.call	$push49=, memcmp@FUNCTION, $13, $pop48, $1
	br_if   	$pop49, 0       # 0: down to label1
# BB#2:                                 # %if.end7
	i32.const	$8=, 16
	i32.add 	$14=, $14, $8
	i32.const	$8=, __stack_pointer
	i32.store	$14=, 0($8), $14
	return  	$2
.LBB2_3:                                # %if.then6
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB2_4:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
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


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
