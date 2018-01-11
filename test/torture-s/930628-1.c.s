	.text
	.file	"930628-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.eq  	$push0=, $0, $1
	br_if   	0, $pop0        # 0: down to label0
# %bb.1:                                # %if.end
	return  	$0
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$0=, 0
	i32.const	$1=, 0
.LBB1_1:                                # %for.body3
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label2:
	block   	
	i32.eqz 	$push17=, $0
	br_if   	0, $pop17       # 0: down to label3
# %bb.2:                                # %if.else
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.eqz 	$push18=, $0
	br_if   	2, $pop18       # 2: down to label1
.LBB1_3:                                # %for.inc36.1.1
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label3:
	i32.const	$push7=, -64
	i32.add 	$0=, $0, $pop7
	i32.const	$push6=, 1
	i32.add 	$1=, $1, $pop6
	i32.const	$push5=, 4
	i32.lt_u	$push0=, $1, $pop5
	br_if   	0, $pop0        # 0: up to label2
# %bb.4:                                # %for.inc45
	end_loop
	i32.const	$0=, 0
	i32.const	$1=, 1
.LBB1_5:                                # %for.body3.1
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label4:
	block   	
	i32.eqz 	$push19=, $0
	br_if   	0, $pop19       # 0: down to label5
# %bb.6:                                # %if.else.1
                                        #   in Loop: Header=BB1_5 Depth=1
	i32.eqz 	$push20=, $0
	br_if   	2, $pop20       # 2: down to label1
.LBB1_7:                                # %for.inc36.1.1.1
                                        #   in Loop: Header=BB1_5 Depth=1
	end_block                       # label5:
	i32.const	$push10=, -64
	i32.add 	$0=, $0, $pop10
	i32.const	$push9=, 1
	i32.add 	$1=, $1, $pop9
	i32.const	$push8=, 4
	i32.lt_u	$push1=, $1, $pop8
	br_if   	0, $pop1        # 0: up to label4
# %bb.8:                                # %for.inc45.1
	end_loop
	i32.const	$1=, 2
	i32.const	$0=, 0
.LBB1_9:                                # %for.body3.2
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label6:
	block   	
	i32.eqz 	$push21=, $0
	br_if   	0, $pop21       # 0: down to label7
# %bb.10:                               # %if.else.2
                                        #   in Loop: Header=BB1_9 Depth=1
	i32.eqz 	$push22=, $0
	br_if   	2, $pop22       # 2: down to label1
.LBB1_11:                               # %for.inc36.1.1.2
                                        #   in Loop: Header=BB1_9 Depth=1
	end_block                       # label7:
	i32.const	$push13=, -64
	i32.add 	$0=, $0, $pop13
	i32.const	$push12=, 1
	i32.add 	$1=, $1, $pop12
	i32.const	$push11=, 4
	i32.lt_u	$push2=, $1, $pop11
	br_if   	0, $pop2        # 0: up to label6
# %bb.12:                               # %for.inc45.2
	end_loop
	i32.const	$1=, 3
	i32.const	$0=, 0
.LBB1_13:                               # %for.body3.3
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label8:
	block   	
	i32.eqz 	$push23=, $0
	br_if   	0, $pop23       # 0: down to label9
# %bb.14:                               # %if.else.3
                                        #   in Loop: Header=BB1_13 Depth=1
	i32.eqz 	$push24=, $0
	br_if   	2, $pop24       # 2: down to label1
.LBB1_15:                               # %for.inc36.1.1.3
                                        #   in Loop: Header=BB1_13 Depth=1
	end_block                       # label9:
	i32.const	$push16=, -64
	i32.add 	$0=, $0, $pop16
	i32.const	$push15=, 1
	i32.add 	$1=, $1, $pop15
	i32.const	$push14=, 4
	i32.lt_u	$push3=, $1, $pop14
	br_if   	0, $pop3        # 0: up to label8
# %bb.16:                               # %for.inc45.3
	end_loop
	i32.const	$push4=, 0
	call    	exit@FUNCTION, $pop4
	unreachable
.LBB1_17:                               # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
