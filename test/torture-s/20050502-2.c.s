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
	i32.store8	$drop=, 4($0), $pop0
                                        # fallthrough-return
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
	i32.store8	$drop=, 8($0), $pop0
                                        # fallthrough-return
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
	i32.const	$push18=, 0
	i32.const	$push15=, 0
	i32.load	$push16=, __stack_pointer($pop15)
	i32.const	$push17=, 16
	i32.sub 	$push26=, $pop16, $pop17
	i32.store	$push34=, __stack_pointer($pop18), $pop26
	tee_local	$push33=, $1=, $pop34
	i32.const	$push2=, 14
	i32.add 	$push3=, $pop33, $pop2
	i32.const	$push0=, 0
	i32.load8_u	$push1=, .Lmain.x+10($pop0)
	i32.store8	$drop=, 0($pop3), $pop1
	i32.const	$push5=, 12
	i32.add 	$push6=, $1, $pop5
	i32.const	$push32=, 0
	i32.load16_u	$push4=, .Lmain.x+8($pop32):p2align=0
	i32.store16	$drop=, 0($pop6), $pop4
	i32.const	$push31=, 0
	i64.load	$push7=, .Lmain.x($pop31):p2align=0
	i64.store	$drop=, 4($1):p2align=2, $pop7
	i32.const	$push8=, 8
	i32.add 	$push30=, $1, $pop8
	tee_local	$push29=, $2=, $pop30
	i32.const	$push28=, 0
	i32.store8	$0=, 0($pop29), $pop28
	block
	i32.const	$push22=, 4
	i32.add 	$push23=, $1, $pop22
	i32.const	$push9=, .L.str
	i32.const	$push27=, 11
	i32.call	$push10=, memcmp@FUNCTION, $pop23, $pop9, $pop27
	br_if   	0, $pop10       # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push11=, 77
	i32.store8	$drop=, 0($2), $pop11
	i32.store8	$drop=, 12($1), $0
	i32.const	$push24=, 4
	i32.add 	$push25=, $1, $pop24
	i32.const	$push12=, .L.str.1
	i32.const	$push35=, 11
	i32.call	$push13=, memcmp@FUNCTION, $pop25, $pop12, $pop35
	br_if   	0, $pop13       # 0: down to label0
# BB#2:                                 # %if.end7
	i32.const	$push21=, 0
	i32.const	$push19=, 16
	i32.add 	$push20=, $1, $pop19
	i32.store	$drop=, __stack_pointer($pop21), $pop20
	i32.const	$push14=, 0
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
	.functype	memcmp, i32, i32, i32, i32
	.functype	abort, void
