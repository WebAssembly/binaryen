	.text
	.file	"20001111-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push2=, 52783
	i32.const	$push0=, 0
	i32.const	$push5=, 0
	i32.load8_u	$push1=, next_buffer($pop5)
	i32.select	$push3=, $pop2, $pop0, $pop1
	i32.add 	$push4=, $pop3, $0
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
# %bb.0:                                # %entry
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
# %bb.0:                                # %entry
	block   	
	i32.const	$push2=, 0
	i32.load8_u	$push0=, next_buffer($pop2)
	i32.eqz 	$push5=, $pop0
	br_if   	0, $pop5        # 0: down to label0
# %bb.1:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB2_2:                                # %if.end4
	end_block                       # label0:
	i32.const	$push4=, 0
	i32.const	$push1=, 1
	i32.store8	next_buffer($pop4), $pop1
	i32.const	$push3=, 0
	call    	exit@FUNCTION, $pop3
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.type	next_buffer,@object     # @next_buffer
	.section	.bss.next_buffer,"aw",@nobits
	.p2align	2
next_buffer:
	.int8	0                       # 0x0
	.size	next_buffer, 1


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
