	.text
	.file	"pr58209.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.eqz 	$push6=, $0
	br_if   	0, $pop6        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push0=, -1
	i32.add 	$push1=, $0, $pop0
	i32.call	$push2=, foo@FUNCTION, $pop1
	i32.const	$push3=, 4
	i32.add 	$push4=, $pop2, $pop3
	return  	$pop4
.LBB0_2:                                # %return
	end_block                       # label0:
	i32.const	$push5=, buf
                                        # fallthrough-return: $pop5
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
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.eqz 	$push6=, $0
	br_if   	0, $pop6        # 0: down to label1
# %bb.1:                                # %if.end
	i32.const	$push0=, -1
	i32.add 	$push1=, $0, $pop0
	i32.call	$push2=, foo@FUNCTION, $pop1
	i32.const	$push3=, 4
	i32.add 	$push4=, $pop2, $pop3
	return  	$pop4
.LBB1_2:
	end_block                       # label1:
	i32.const	$push5=, buf
                                        # fallthrough-return: $pop5
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
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$2=, 0
	i32.const	$1=, buf-4
.LBB2_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label3:
	i32.const	$push9=, 4
	i32.add 	$1=, $1, $pop9
	i32.call	$0=, foo@FUNCTION, $2
	i32.ne  	$push0=, $1, $0
	br_if   	1, $pop0        # 1: down to label2
# %bb.2:                                # %lor.lhs.false
                                        #   in Loop: Header=BB2_1 Depth=1
	block   	
	block   	
	i32.eqz 	$push14=, $2
	br_if   	0, $pop14       # 0: down to label5
# %bb.3:                                # %if.end.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push11=, -1
	i32.add 	$push1=, $2, $pop11
	i32.call	$push2=, foo@FUNCTION, $pop1
	i32.const	$push10=, 4
	i32.add 	$push7=, $pop2, $pop10
	i32.eq  	$push4=, $pop7, $0
	br_if   	1, $pop4        # 1: down to label4
	br      	3               # 3: down to label2
.LBB2_4:                                #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label5:
	i32.const	$push8=, buf
	i32.ne  	$push3=, $pop8, $0
	br_if   	2, $pop3        # 2: down to label2
.LBB2_5:                                # %for.cond
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label4:
	i32.const	$push13=, 1
	i32.add 	$2=, $2, $pop13
	i32.const	$push12=, 26
	i32.le_u	$push5=, $2, $pop12
	br_if   	0, $pop5        # 0: up to label3
# %bb.6:                                # %for.end
	end_loop
	i32.const	$push6=, 0
	return  	$pop6
.LBB2_7:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.hidden	buf                     # @buf
	.type	buf,@object
	.section	.bss.buf,"aw",@nobits
	.globl	buf
	.p2align	4
buf:
	.skip	4096
	.size	buf, 4096


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
