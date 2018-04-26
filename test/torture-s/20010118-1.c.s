	.text
	.file	"20010118-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32, i32, i32
# %bb.0:                                # %entry
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
	.param  	i32, i32, i32, i32, i32
	.local  	f64
# %bb.0:                                # %entry
	block   	
	block   	
	i32.load	$push0=, 0($0)
	i32.ne  	$push1=, $pop0, $1
	br_if   	0, $pop1        # 0: down to label1
# %bb.1:                                # %lor.lhs.false
	i32.const	$push2=, 4
	i32.add 	$push3=, $0, $pop2
	i32.load	$push4=, 0($pop3)
	i32.eq  	$push5=, $pop4, $2
	br_if   	1, $pop5        # 1: down to label0
.LBB1_2:                                # %if.then
	end_block                       # label1:
	i32.store	8($0), $3
	i32.store	12($0), $4
	i32.load	$push6=, 16($0)
	f64.convert_s/i32	$push7=, $pop6
	f64.const	$push22=, 0x0p0
	f64.mul 	$push8=, $pop7, $pop22
	f64.const	$push21=, 0x1p-1
	f64.mul 	$5=, $pop8, $pop21
	block   	
	block   	
	f64.abs 	$push15=, $5
	f64.const	$push16=, 0x1p31
	f64.lt  	$push17=, $pop15, $pop16
	br_if   	0, $pop17       # 0: down to label3
# %bb.3:                                # %if.then
	i32.const	$3=, -2147483648
	br      	1               # 1: down to label2
.LBB1_4:                                # %if.then
	end_block                       # label3:
	i32.trunc_s/f64	$3=, $5
.LBB1_5:                                # %if.then
	end_block                       # label2:
	i32.add 	$push9=, $3, $1
	i32.store	0($0), $pop9
	i32.const	$push10=, 4
	i32.add 	$1=, $0, $pop10
	i32.load	$push11=, 20($0)
	f64.convert_s/i32	$push12=, $pop11
	f64.const	$push24=, 0x0p0
	f64.mul 	$push13=, $pop12, $pop24
	f64.const	$push23=, 0x1p-1
	f64.mul 	$5=, $pop13, $pop23
	block   	
	block   	
	f64.abs 	$push18=, $5
	f64.const	$push19=, 0x1p31
	f64.lt  	$push20=, $pop18, $pop19
	br_if   	0, $pop20       # 0: down to label5
# %bb.6:                                # %if.then
	i32.const	$0=, -2147483648
	br      	1               # 1: down to label4
.LBB1_7:                                # %if.then
	end_block                       # label5:
	i32.trunc_s/f64	$0=, $5
.LBB1_8:                                # %if.then
	end_block                       # label4:
	i32.add 	$push14=, $0, $2
	i32.store	0($1), $pop14
.LBB1_9:                                # %if.end
	end_block                       # label0:
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
# %bb.0:                                # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
