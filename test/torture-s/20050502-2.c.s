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
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push22=, __stack_pointer
	i32.load	$push23=, 0($pop22)
	i32.const	$push24=, 16
	i32.sub 	$2=, $pop23, $pop24
	i32.const	$push25=, __stack_pointer
	i32.store	$discard=, 0($pop25), $2
	i32.const	$push29=, 4
	i32.add 	$push30=, $2, $pop29
	i32.const	$push2=, 10
	i32.add 	$push3=, $pop30, $pop2
	i32.const	$push0=, 0
	i32.load8_u	$push1=, .Lmain.x+10($pop0)
	i32.store8	$discard=, 0($pop3):p2align=1, $pop1
	i32.const	$push31=, 4
	i32.add 	$push32=, $2, $pop31
	i32.const	$push5=, 8
	i32.add 	$push6=, $pop32, $pop5
	i32.const	$push20=, 0
	i32.load16_u	$push4=, .Lmain.x+8($pop20):p2align=0
	i32.store16	$discard=, 0($pop6):p2align=2, $pop4
	i32.const	$push19=, 0
	i64.load	$push7=, .Lmain.x($pop19):p2align=0
	i64.store	$discard=, 4($2):p2align=2, $pop7
	i32.const	$push33=, 4
	i32.add 	$push34=, $2, $pop33
	i32.const	$push8=, 4
	i32.add 	$push18=, $pop34, $pop8
	tee_local	$push17=, $1=, $pop18
	i32.const	$push16=, 0
	i32.store8	$0=, 0($pop17):p2align=2, $pop16
	block
	i32.const	$push35=, 4
	i32.add 	$push36=, $2, $pop35
	i32.const	$push9=, .L.str
	i32.const	$push15=, 11
	i32.call	$push10=, memcmp@FUNCTION, $pop36, $pop9, $pop15
	br_if   	0, $pop10       # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push11=, 77
	i32.store8	$discard=, 0($1):p2align=2, $pop11
	i32.store8	$discard=, 12($2):p2align=2, $0
	i32.const	$push37=, 4
	i32.add 	$push38=, $2, $pop37
	i32.const	$push12=, .L.str.1
	i32.const	$push21=, 11
	i32.call	$push13=, memcmp@FUNCTION, $pop38, $pop12, $pop21
	br_if   	0, $pop13       # 0: down to label0
# BB#2:                                 # %if.end7
	i32.const	$push14=, 0
	i32.const	$push28=, __stack_pointer
	i32.const	$push26=, 16
	i32.add 	$push27=, $2, $pop26
	i32.store	$discard=, 0($pop28), $pop27
	return  	$pop14
.LBB2_3:                                # %if.then6
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
