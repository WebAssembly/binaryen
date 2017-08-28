	.text
	.file	"pr59358.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.load	$0=, 0($0)
	block   	
	block   	
	i32.const	$push0=, 16
	i32.gt_s	$push1=, $1, $pop0
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %entry
	i32.ge_s	$push2=, $0, $1
	br_if   	1, $pop2        # 1: down to label0
# BB#2:                                 # %while.cond.preheader
.LBB0_3:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	copy_local	$push8=, $0
	tee_local	$push7=, $2=, $pop8
	i32.const	$push6=, 1
	i32.shl 	$0=, $pop7, $pop6
	i32.lt_s	$push3=, $2, $1
	br_if   	0, $pop3        # 0: up to label2
# BB#4:                                 # %if.end
	end_loop
	return  	$2
.LBB0_5:
	end_block                       # label1:
	copy_local	$push5=, $0
	return  	$pop5
.LBB0_6:
	end_block                       # label0:
	copy_local	$push4=, $0
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push20=, 0
	i32.const	$push18=, 0
	i32.load	$push17=, __stack_pointer($pop18)
	i32.const	$push19=, 16
	i32.sub 	$push30=, $pop17, $pop19
	tee_local	$push29=, $6=, $pop30
	i32.store	__stack_pointer($pop20), $pop29
	i32.const	$push28=, 1
	i32.store	12($6), $pop28
	i32.const	$1=, 0
	i32.const	$0=, 2
	i32.const	$2=, 1
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label4:
	i32.const	$push24=, 12
	i32.add 	$push25=, $6, $pop24
	i32.const	$push36=, 16
	i32.call	$3=, foo@FUNCTION, $pop25, $pop36
	copy_local	$4=, $0
	block   	
	block   	
	i32.const	$push35=, 1
	i32.add 	$push34=, $1, $pop35
	tee_local	$push33=, $5=, $pop34
	i32.const	$push32=, -8
	i32.and 	$push1=, $pop33, $pop32
	i32.const	$push31=, 8
	i32.eq  	$push2=, $pop1, $pop31
	br_if   	0, $pop2        # 0: down to label6
# BB#2:                                 # %if.else
                                        #   in Loop: Header=BB1_1 Depth=1
	block   	
	i32.const	$push38=, -4
	i32.and 	$push3=, $5, $pop38
	i32.const	$push37=, 4
	i32.ne  	$push4=, $pop3, $pop37
	br_if   	0, $pop4        # 0: down to label7
# BB#3:                                 # %if.then6
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push39=, 2
	i32.shl 	$push15=, $2, $pop39
	i32.eq  	$push6=, $3, $pop15
	br_if   	2, $pop6        # 2: down to label5
	br      	4               # 4: down to label3
.LBB1_4:                                # %if.else10
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label7:
	i32.const	$push42=, 24
	i32.const	$push41=, 16
	i32.const	$push40=, 2
	i32.eq  	$push5=, $1, $pop40
	i32.select	$4=, $pop42, $pop41, $pop5
.LBB1_5:                                # %if.end15
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label6:
	i32.ne  	$push7=, $3, $4
	br_if   	2, $pop7        # 2: down to label3
.LBB1_6:                                # %if.end18
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label5:
	i32.const	$push26=, 12
	i32.add 	$push27=, $6, $pop26
	i32.const	$push44=, 7
	i32.call	$3=, foo@FUNCTION, $pop27, $pop44
	block   	
	block   	
	i32.const	$push43=, 6
	i32.gt_u	$push8=, $5, $pop43
	br_if   	0, $pop8        # 0: down to label9
# BB#7:                                 # %if.else22
                                        #   in Loop: Header=BB1_1 Depth=1
	block   	
	i32.const	$push45=, 4
	i32.lt_u	$push9=, $5, $pop45
	br_if   	0, $pop9        # 0: down to label10
# BB#8:                                 # %if.then24
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push46=, 1
	i32.shl 	$push16=, $2, $pop46
	i32.eq  	$push11=, $3, $pop16
	br_if   	2, $pop11       # 2: down to label8
	br      	4               # 4: down to label3
.LBB1_9:                                # %if.else28
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label10:
	i32.const	$push49=, 12
	i32.const	$push48=, 8
	i32.const	$push47=, 2
	i32.eq  	$push10=, $1, $pop47
	i32.select	$5=, $pop49, $pop48, $pop10
.LBB1_10:                               # %if.end34
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label9:
	i32.ne  	$push12=, $3, $5
	br_if   	2, $pop12       # 2: down to label3
.LBB1_11:                               # %for.cond
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label8:
	i32.const	$push56=, 1
	i32.add 	$2=, $2, $pop56
	i32.const	$push55=, 2
	i32.add 	$push0=, $1, $pop55
	i32.store	12($6), $pop0
	i32.const	$push54=, 2
	i32.add 	$0=, $0, $pop54
	i32.const	$push53=, 1
	i32.add 	$push52=, $1, $pop53
	tee_local	$push51=, $1=, $pop52
	i32.const	$push50=, 15
	i32.le_u	$push13=, $pop51, $pop50
	br_if   	0, $pop13       # 0: up to label4
# BB#12:                                # %for.end
	end_loop
	i32.const	$push23=, 0
	i32.const	$push21=, 16
	i32.add 	$push22=, $6, $pop21
	i32.store	__stack_pointer($pop23), $pop22
	i32.const	$push14=, 0
	return  	$pop14
.LBB1_13:                               # %if.then17
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
