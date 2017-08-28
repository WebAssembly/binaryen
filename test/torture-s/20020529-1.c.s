	.text
	.file	"20020529-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push15=, 0
	i32.const	$push14=, 0
	i32.load	$push13=, f1.beenhere($pop14)
	tee_local	$push12=, $7=, $pop13
	i32.const	$push11=, 1
	i32.add 	$push10=, $pop12, $pop11
	tee_local	$push9=, $6=, $pop10
	i32.store	f1.beenhere($pop15), $pop9
	block   	
	block   	
	block   	
	i32.const	$push8=, 1
	i32.gt_s	$push0=, $7, $pop8
	br_if   	0, $pop0        # 0: down to label2
# BB#1:                                 # %f1.exit.lr.ph.lr.ph
	i32.const	$push3=, 8
	i32.add 	$5=, $0, $pop3
.LBB0_2:                                # %f1.exit
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	copy_local	$4=, $6
	i32.const	$push16=, 1
	i32.eq  	$push1=, $7, $pop16
	br_if   	2, $pop1        # 2: down to label1
# BB#3:                                 # %if.end
                                        #   in Loop: Header=BB0_2 Depth=1
	block   	
	i32.eqz 	$push29=, $1
	br_if   	0, $pop29       # 0: down to label4
# BB#4:                                 # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push21=, 0
	i32.const	$push20=, 1
	i32.add 	$push19=, $4, $pop20
	tee_local	$push18=, $6=, $pop19
	i32.store	f1.beenhere($pop21), $pop18
	copy_local	$7=, $4
	i32.const	$push17=, 2
	i32.lt_s	$push2=, $4, $pop17
	br_if   	1, $pop2        # 1: up to label3
	br      	2               # 2: down to label2
.LBB0_5:                                # %if.end3
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label4:
	i32.store16	0($5), $3
	i32.load	$push4=, 0($0)
	br_if   	3, $pop4        # 3: down to label0
# BB#6:                                 # %if.end8
                                        #   in Loop: Header=BB0_2 Depth=1
	br_if   	3, $2           # 3: down to label0
# BB#7:                                 # %sw.epilog
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push28=, 0
	i32.const	$push27=, 1
	i32.add 	$push26=, $4, $pop27
	tee_local	$push25=, $6=, $pop26
	i32.store	f1.beenhere($pop28), $pop25
	i32.const	$push24=, 16
	i32.shl 	$push5=, $3, $pop24
	i32.const	$push23=, 16
	i32.shr_s	$3=, $pop5, $pop23
	copy_local	$7=, $4
	i32.const	$push22=, 1
	i32.le_s	$push6=, $4, $pop22
	br_if   	0, $pop6        # 0: up to label3
.LBB0_8:                                # %if.then.i
	end_loop
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_9:                                # %if.then
	end_block                       # label1:
	i32.const	$push7=, 0
	return  	$pop7
.LBB0_10:                               # %if.then7
	end_block                       # label0:
	call    	f2@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.f1,"ax",@progbits
	.hidden	f1                      # -- Begin function f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push8=, 0
	i32.load	$push7=, f1.beenhere($pop8)
	tee_local	$push6=, $1=, $pop7
	i32.const	$push5=, 1
	i32.add 	$push1=, $pop6, $pop5
	i32.store	f1.beenhere($pop0), $pop1
	block   	
	i32.const	$push2=, 2
	i32.ge_s	$push3=, $1, $pop2
	br_if   	0, $pop3        # 0: down to label5
# BB#1:                                 # %if.end
	i32.const	$push9=, 1
	i32.eq  	$push4=, $1, $pop9
	return  	$pop4
.LBB1_2:                                # %if.then
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	f1, .Lfunc_end1-f1
                                        # -- End function
	.section	.text.f2,"ax",@progbits
	.hidden	f2                      # -- Begin function f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
# BB#0:                                 # %entry
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	f2, .Lfunc_end2-f2
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push13=, 0
	i32.const	$push11=, 0
	i32.load	$push10=, __stack_pointer($pop11)
	i32.const	$push12=, 16
	i32.sub 	$push22=, $pop10, $pop12
	tee_local	$push21=, $0=, $pop22
	i32.store	__stack_pointer($pop13), $pop21
	i32.const	$push0=, 0
	i32.const	$push20=, 0
	i32.load	$push19=, f1.beenhere($pop20)
	tee_local	$push18=, $1=, $pop19
	i32.const	$push17=, 1
	i32.add 	$push1=, $pop18, $pop17
	i32.store	f1.beenhere($pop0), $pop1
	i32.const	$push16=, 0
	i32.store	0($0), $pop16
	i32.const	$2=, 23
	i32.const	$push15=, 23
	i32.store16	8($0), $pop15
	i32.store	4($0), $0
	block   	
	i32.const	$push14=, 1
	i32.gt_s	$push2=, $1, $pop14
	br_if   	0, $pop2        # 0: down to label6
# BB#1:                                 # %f1.exit.lr.ph.i.preheader
	i32.const	$push5=, 8
	i32.add 	$0=, $0, $pop5
.LBB3_2:                                # %f1.exit.lr.ph.i
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label8:
	i32.const	$push23=, 1
	i32.eq  	$push3=, $1, $pop23
	br_if   	1, $pop3        # 1: down to label7
# BB#3:                                 # %if.end8.i
                                        #   in Loop: Header=BB3_2 Depth=1
	i32.const	$2=, 0
	i32.const	$push30=, 0
	i32.const	$push29=, 2
	i32.add 	$push4=, $1, $pop29
	i32.store	f1.beenhere($pop30), $pop4
	i32.const	$push28=, 0
	i32.store16	0($0), $pop28
	i32.const	$push27=, 1
	i32.add 	$push26=, $1, $pop27
	tee_local	$push25=, $1=, $pop26
	i32.const	$push24=, 1
	i32.le_s	$push6=, $pop25, $pop24
	br_if   	0, $pop6        # 0: up to label8
	br      	2               # 2: down to label6
.LBB3_4:                                # %foo.exit
	end_loop
	end_block                       # label7:
	i32.const	$push7=, 65535
	i32.and 	$push8=, $2, $pop7
	br_if   	0, $pop8        # 0: down to label6
# BB#5:                                 # %if.end
	i32.const	$push9=, 0
	call    	exit@FUNCTION, $pop9
	unreachable
.LBB3_6:                                # %if.then.i.i
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main
                                        # -- End function
	.type	f1.beenhere,@object     # @f1.beenhere
	.section	.bss.f1.beenhere,"aw",@nobits
	.p2align	2
f1.beenhere:
	.int32	0                       # 0x0
	.size	f1.beenhere, 4


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
