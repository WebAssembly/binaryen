	.text
	.file	"930628-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.eq  	$push0=, $0, $1
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %if.end
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
# BB#0:                                 # %entry
	i32.const	$1=, -1
	i32.const	$0=, 0
.LBB1_1:                                # %for.body3
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label2:
	block   	
	i32.eqz 	$push25=, $0
	br_if   	0, $pop25       # 0: down to label3
# BB#2:                                 # %if.else
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.eqz 	$push26=, $0
	br_if   	2, $pop26       # 2: down to label1
.LBB1_3:                                # %if.end.1.1
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label3:
	i32.const	$push9=, -64
	i32.add 	$0=, $0, $pop9
	i32.const	$push8=, 1
	i32.add 	$push7=, $1, $pop8
	tee_local	$push6=, $1=, $pop7
	i32.const	$push5=, 3
	i32.lt_u	$push0=, $pop6, $pop5
	br_if   	0, $pop0        # 0: up to label2
# BB#4:                                 # %for.inc45
	end_loop
	i32.const	$0=, 0
	i32.const	$1=, 0
.LBB1_5:                                # %for.body3.1
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label4:
	block   	
	i32.eqz 	$push27=, $0
	br_if   	0, $pop27       # 0: down to label5
# BB#6:                                 # %if.else.1
                                        #   in Loop: Header=BB1_5 Depth=1
	i32.eqz 	$push28=, $0
	br_if   	2, $pop28       # 2: down to label1
.LBB1_7:                                # %if.end.1.1.1
                                        #   in Loop: Header=BB1_5 Depth=1
	end_block                       # label5:
	i32.const	$push14=, -64
	i32.add 	$0=, $0, $pop14
	i32.const	$push13=, 1
	i32.add 	$push12=, $1, $pop13
	tee_local	$push11=, $1=, $pop12
	i32.const	$push10=, 3
	i32.lt_u	$push1=, $pop11, $pop10
	br_if   	0, $pop1        # 0: up to label4
# BB#8:                                 # %for.inc45.1
	end_loop
	i32.const	$0=, 0
	i32.const	$1=, 1
.LBB1_9:                                # %for.body3.2
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label6:
	block   	
	i32.eqz 	$push29=, $0
	br_if   	0, $pop29       # 0: down to label7
# BB#10:                                # %if.else.2
                                        #   in Loop: Header=BB1_9 Depth=1
	i32.eqz 	$push30=, $0
	br_if   	2, $pop30       # 2: down to label1
.LBB1_11:                               # %if.end.1.1.2
                                        #   in Loop: Header=BB1_9 Depth=1
	end_block                       # label7:
	i32.const	$push19=, -64
	i32.add 	$0=, $0, $pop19
	i32.const	$push18=, 1
	i32.add 	$push17=, $1, $pop18
	tee_local	$push16=, $1=, $pop17
	i32.const	$push15=, 3
	i32.lt_u	$push2=, $pop16, $pop15
	br_if   	0, $pop2        # 0: up to label6
# BB#12:                                # %for.inc45.2
	end_loop
	i32.const	$1=, 2
	i32.const	$0=, 0
.LBB1_13:                               # %for.body3.3
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label8:
	block   	
	i32.eqz 	$push31=, $0
	br_if   	0, $pop31       # 0: down to label9
# BB#14:                                # %if.else.3
                                        #   in Loop: Header=BB1_13 Depth=1
	i32.eqz 	$push32=, $0
	br_if   	2, $pop32       # 2: down to label1
.LBB1_15:                               # %if.end.1.1.3
                                        #   in Loop: Header=BB1_13 Depth=1
	end_block                       # label9:
	i32.const	$push24=, -64
	i32.add 	$0=, $0, $pop24
	i32.const	$push23=, 1
	i32.add 	$push22=, $1, $pop23
	tee_local	$push21=, $1=, $pop22
	i32.const	$push20=, 3
	i32.lt_u	$push3=, $pop21, $pop20
	br_if   	0, $pop3        # 0: up to label8
# BB#16:                                # %for.inc45.3
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

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
