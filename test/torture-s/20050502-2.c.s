	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20050502-2.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.store8	4($0), $pop0
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
	i32.store8	8($0), $pop0
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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push17=, 0
	i32.const	$push14=, 0
	i32.load	$push15=, __stack_pointer($pop14)
	i32.const	$push16=, 16
	i32.sub 	$push33=, $pop15, $pop16
	tee_local	$push32=, $1=, $pop33
	i32.store	__stack_pointer($pop17), $pop32
	i32.const	$push1=, 14
	i32.add 	$push2=, $1, $pop1
	i32.const	$push31=, 0
	i32.load8_u	$push0=, .Lmain.x+10($pop31)
	i32.store8	0($pop2), $pop0
	i32.const	$push4=, 12
	i32.add 	$push5=, $1, $pop4
	i32.const	$push30=, 0
	i32.load16_u	$push3=, .Lmain.x+8($pop30):p2align=0
	i32.store16	0($pop5), $pop3
	i32.const	$push29=, 0
	i64.load	$push6=, .Lmain.x($pop29):p2align=0
	i64.store	4($1):p2align=2, $pop6
	i32.const	$push7=, 8
	i32.add 	$push28=, $1, $pop7
	tee_local	$push27=, $0=, $pop28
	i32.const	$push26=, 0
	i32.store8	0($pop27), $pop26
	block   	
	i32.const	$push21=, 4
	i32.add 	$push22=, $1, $pop21
	i32.const	$push8=, .L.str
	i32.const	$push25=, 11
	i32.call	$push9=, memcmp@FUNCTION, $pop22, $pop8, $pop25
	br_if   	0, $pop9        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push10=, 77
	i32.store8	0($0), $pop10
	i32.const	$push35=, 0
	i32.store8	12($1), $pop35
	i32.const	$push23=, 4
	i32.add 	$push24=, $1, $pop23
	i32.const	$push11=, .L.str.1
	i32.const	$push34=, 11
	i32.call	$push12=, memcmp@FUNCTION, $pop24, $pop11, $pop34
	br_if   	0, $pop12       # 0: down to label0
# BB#2:                                 # %if.end7
	i32.const	$push20=, 0
	i32.const	$push18=, 16
	i32.add 	$push19=, $1, $pop18
	i32.store	__stack_pointer($pop20), $pop19
	i32.const	$push13=, 0
	return  	$pop13
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	memcmp, i32, i32, i32, i32
	.functype	abort, void
