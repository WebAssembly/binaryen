	.text
	.file	"pr61673.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
# %bb.0:                                # %entry
	block   	
	block   	
	i32.const	$push0=, -121
	i32.eq  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label1
# %bb.1:                                # %entry
	i32.const	$push2=, 84
	i32.ne  	$push3=, $0, $pop2
	br_if   	1, $pop3        # 1: down to label0
.LBB0_2:                                # %if.end
	end_block                       # label1:
	return
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar
                                        # -- End function
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# %bb.0:                                # %entry
	i32.load8_s	$0=, 0($0)
	block   	
	i32.const	$push0=, -1
	i32.le_s	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label2
# %bb.1:                                # %if.end
	call    	bar@FUNCTION, $0
	return
.LBB1_2:                                # %if.then
	end_block                       # label2:
	i32.const	$push2=, 0
	i32.store8	e($pop2), $0
	call    	bar@FUNCTION, $0
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo
                                        # -- End function
	.section	.text.baz,"ax",@progbits
	.hidden	baz                     # -- Begin function baz
	.globl	baz
	.type	baz,@function
baz:                                    # @baz
	.param  	i32
# %bb.0:                                # %entry
	i32.load8_s	$0=, 0($0)
	block   	
	i32.const	$push0=, -1
	i32.le_s	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label3
# %bb.1:                                # %if.end
	return
.LBB2_2:                                # %if.then
	end_block                       # label3:
	i32.const	$push2=, 0
	i32.store8	e($pop2), $0
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	baz, .Lfunc_end2-baz
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push19=, 0
	i32.const	$push0=, 33
	i32.store8	e($pop19), $pop0
	i32.const	$push1=, main.c
	call    	foo@FUNCTION, $pop1
	block   	
	i32.const	$push18=, 0
	i32.load8_u	$push2=, e($pop18)
	i32.const	$push17=, 33
	i32.ne  	$push3=, $pop2, $pop17
	br_if   	0, $pop3        # 0: down to label4
# %bb.1:                                # %if.end
	i32.const	$push4=, main.c+1
	call    	foo@FUNCTION, $pop4
	i32.const	$push20=, 0
	i32.load8_u	$push5=, e($pop20)
	i32.const	$push6=, 135
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label4
# %bb.2:                                # %if.end6
	i32.const	$push23=, 0
	i32.const	$push8=, 33
	i32.store8	e($pop23), $pop8
	i32.const	$push9=, main.c
	call    	baz@FUNCTION, $pop9
	i32.const	$push22=, 0
	i32.load8_u	$push10=, e($pop22)
	i32.const	$push21=, 33
	i32.ne  	$push11=, $pop10, $pop21
	br_if   	0, $pop11       # 0: down to label4
# %bb.3:                                # %if.end11
	i32.const	$push12=, main.c+1
	call    	baz@FUNCTION, $pop12
	i32.const	$push24=, 0
	i32.load8_u	$push13=, e($pop24)
	i32.const	$push14=, 135
	i32.ne  	$push15=, $pop13, $pop14
	br_if   	0, $pop15       # 0: down to label4
# %bb.4:                                # %if.end16
	i32.const	$push16=, 0
	return  	$pop16
.LBB3_5:                                # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main
                                        # -- End function
	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
e:
	.int8	0                       # 0x0
	.size	e, 1

	.type	main.c,@object          # @main.c
	.section	.rodata.main.c,"a",@progbits
main.c:
	.ascii	"T\207"
	.size	main.c, 2


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
