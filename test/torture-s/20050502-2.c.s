	.text
	.file	"20050502-2.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.store8	4($0), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.store8	8($0), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push14=, 0
	i32.load	$push13=, __stack_pointer($pop14)
	i32.const	$push15=, 16
	i32.sub 	$0=, $pop13, $pop15
	i32.const	$push16=, 0
	i32.store	__stack_pointer($pop16), $0
	i32.const	$push1=, 10
	i32.add 	$push2=, $0, $pop1
	i32.const	$push24=, 0
	i32.load8_u	$push0=, .Lmain.x+10($pop24)
	i32.store8	0($pop2), $pop0
	i32.const	$push4=, 8
	i32.add 	$push5=, $0, $pop4
	i32.const	$push23=, 0
	i32.load16_u	$push3=, .Lmain.x+8($pop23):p2align=0
	i32.store16	0($pop5), $pop3
	i32.const	$push22=, 0
	i64.load	$push6=, .Lmain.x($pop22):p2align=0
	i64.store	0($0), $pop6
	i32.const	$push21=, 0
	i32.store8	4($0), $pop21
	block   	
	i32.const	$push7=, .L.str
	i32.const	$push20=, 11
	i32.call	$push8=, memcmp@FUNCTION, $0, $pop7, $pop20
	br_if   	0, $pop8        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push26=, 0
	i32.store8	8($0), $pop26
	i32.const	$push9=, 77
	i32.store8	4($0), $pop9
	i32.const	$push10=, .L.str.1
	i32.const	$push25=, 11
	i32.call	$push11=, memcmp@FUNCTION, $0, $pop10, $pop25
	br_if   	0, $pop11       # 0: down to label0
# %bb.2:                                # %if.end7
	i32.const	$push19=, 0
	i32.const	$push17=, 16
	i32.add 	$push18=, $0, $pop17
	i32.store	__stack_pointer($pop19), $pop18
	i32.const	$push12=, 0
	return  	$pop12
.LBB2_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	memcmp, i32, i32, i32, i32
	.functype	abort, void
