	.text
	.file	"20111227-2.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
# %bb.0:                                # %entry
	block   	
	block   	
	i32.const	$push1=, 2
	i32.ne  	$push2=, $0, $pop1
	br_if   	0, $pop2        # 0: down to label1
# %bb.1:                                # %entry
	i32.const	$push16=, 0
	i32.load16_u	$push0=, s($pop16)
	i32.const	$push3=, 65535
	i32.and 	$push4=, $pop0, $pop3
	i32.const	$push5=, 255
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	1, $pop6        # 1: down to label0
.LBB0_2:                                # %if.end
	end_block                       # label1:
	block   	
	i32.const	$push8=, 1
	i32.ne  	$push9=, $0, $pop8
	br_if   	0, $pop9        # 0: down to label2
# %bb.3:                                # %if.end
	i32.const	$push17=, 0
	i32.load	$push7=, i($pop17)
	i32.const	$push10=, 255
	i32.ne  	$push11=, $pop7, $pop10
	br_if   	1, $pop11       # 1: down to label0
.LBB0_4:                                # %if.end9
	end_block                       # label2:
	block   	
	br_if   	0, $0           # 0: down to label3
# %bb.5:                                # %if.end9
	i32.const	$push13=, 0
	i32.load	$push12=, l($pop13)
	i32.const	$push14=, 255
	i32.ne  	$push15=, $pop12, $pop14
	br_if   	1, $pop15       # 1: down to label0
.LBB0_6:                                # %if.end16
	end_block                       # label3:
	return
.LBB0_7:                                # %if.then
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
	.param  	i32, i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push6=, 0
	i32.load8_u	$2=, v($pop6)
	block   	
	block   	
	block   	
	i32.eqz 	$push8=, $1
	br_if   	0, $pop8        # 0: down to label6
# %bb.1:                                # %entry
	i32.const	$push0=, 1
	i32.eq  	$push1=, $1, $pop0
	br_if   	2, $pop1        # 2: down to label4
# %bb.2:                                # %entry
	i32.const	$push2=, 2
	i32.ne  	$push3=, $1, $pop2
	br_if   	1, $pop3        # 1: down to label5
# %bb.3:                                # %if.then
	i32.const	$push5=, 0
	i32.store16	s($pop5), $2
	call    	bar@FUNCTION, $1
	return
.LBB1_4:                                # %if.then8
	end_block                       # label6:
	i32.const	$push7=, 0
	i32.store	l($pop7), $2
.LBB1_5:                                # %if.end11
	end_block                       # label5:
	call    	bar@FUNCTION, $1
	return
.LBB1_6:                                # %if.then3
	end_block                       # label4:
	i32.const	$push4=, 0
	i32.store	i($pop4), $2
	call    	bar@FUNCTION, $1
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	call    	foo@FUNCTION, $0, $pop0
	i32.const	$push1=, 1
	call    	foo@FUNCTION, $0, $pop1
	i32.const	$push2=, 2
	call    	foo@FUNCTION, $0, $pop2
	i32.const	$push3=, 0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.hidden	v                       # @v
	.type	v,@object
	.section	.data.v,"aw",@progbits
	.globl	v
v:
	.int8	255                     # 0xff
	.size	v, 1

	.hidden	s                       # @s
	.type	s,@object
	.section	.bss.s,"aw",@nobits
	.globl	s
	.p2align	1
s:
	.int16	0                       # 0x0
	.size	s, 2

	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.p2align	2
i:
	.int32	0                       # 0x0
	.size	i, 4

	.hidden	l                       # @l
	.type	l,@object
	.section	.bss.l,"aw",@nobits
	.globl	l
	.p2align	2
l:
	.int32	0                       # 0x0
	.size	l, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
