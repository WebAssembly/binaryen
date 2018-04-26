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
# %bb.0:                                # %entry
	i32.const	$push11=, 0
	i32.load	$7=, f1.beenhere($pop11)
	i32.const	$push10=, 1
	i32.add 	$6=, $7, $pop10
	i32.const	$push9=, 0
	i32.store	f1.beenhere($pop9), $6
	block   	
	block   	
	block   	
	i32.const	$push8=, 1
	i32.gt_s	$push0=, $7, $pop8
	br_if   	0, $pop0        # 0: down to label2
# %bb.1:                                # %f1.exit.lr.ph.lr.ph
	i32.const	$push3=, 8
	i32.add 	$5=, $0, $pop3
.LBB0_2:                                # %f1.exit
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	copy_local	$4=, $6
	i32.const	$push12=, 1
	i32.eq  	$push1=, $7, $pop12
	br_if   	2, $pop1        # 2: down to label1
# %bb.3:                                # %if.end
                                        #   in Loop: Header=BB0_2 Depth=1
	block   	
	i32.eqz 	$push21=, $1
	br_if   	0, $pop21       # 0: down to label4
# %bb.4:                                # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push15=, 1
	i32.add 	$6=, $4, $pop15
	i32.const	$push14=, 0
	i32.store	f1.beenhere($pop14), $6
	copy_local	$7=, $4
	i32.const	$push13=, 2
	i32.lt_s	$push2=, $4, $pop13
	br_if   	1, $pop2        # 1: up to label3
	br      	2               # 2: down to label2
.LBB0_5:                                # %if.end3
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label4:
	i32.store16	0($5), $3
	i32.load	$push4=, 0($0)
	br_if   	3, $pop4        # 3: down to label0
# %bb.6:                                # %if.end8
                                        #   in Loop: Header=BB0_2 Depth=1
	br_if   	3, $2           # 3: down to label0
# %bb.7:                                # %sw.epilog
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push20=, 1
	i32.add 	$6=, $4, $pop20
	i32.const	$push19=, 0
	i32.store	f1.beenhere($pop19), $6
	i32.const	$push18=, 16
	i32.shl 	$push5=, $3, $pop18
	i32.const	$push17=, 16
	i32.shr_s	$3=, $pop5, $pop17
	copy_local	$7=, $4
	i32.const	$push16=, 1
	i32.le_s	$push6=, $4, $pop16
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
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load	$1=, f1.beenhere($pop0)
	i32.const	$push6=, 0
	i32.const	$push5=, 1
	i32.add 	$push1=, $1, $pop5
	i32.store	f1.beenhere($pop6), $pop1
	block   	
	i32.const	$push2=, 2
	i32.ge_s	$push3=, $1, $pop2
	br_if   	0, $pop3        # 0: down to label5
# %bb.1:                                # %if.end
	i32.const	$push7=, 1
	i32.eq  	$push4=, $1, $pop7
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
# %bb.0:                                # %entry
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
# %bb.0:                                # %entry
	i32.const	$push11=, 0
	i32.load	$push10=, __stack_pointer($pop11)
	i32.const	$push12=, 16
	i32.sub 	$0=, $pop10, $pop12
	i32.const	$push13=, 0
	i32.store	__stack_pointer($pop13), $0
	i32.const	$push0=, 0
	i32.load	$1=, f1.beenhere($pop0)
	i32.const	$push18=, 0
	i32.const	$push17=, 1
	i32.add 	$push1=, $1, $pop17
	i32.store	f1.beenhere($pop18), $pop1
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
# %bb.1:                                # %f1.exit.lr.ph.i.preheader
	i32.const	$push5=, 8
	i32.add 	$0=, $0, $pop5
.LBB3_2:                                # %f1.exit.lr.ph.i
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label8:
	i32.const	$push19=, 1
	i32.eq  	$push3=, $1, $pop19
	br_if   	1, $pop3        # 1: down to label7
# %bb.3:                                # %if.end8.i
                                        #   in Loop: Header=BB3_2 Depth=1
	i32.const	$2=, 0
	i32.const	$push24=, 0
	i32.const	$push23=, 2
	i32.add 	$push4=, $1, $pop23
	i32.store	f1.beenhere($pop24), $pop4
	i32.const	$push22=, 0
	i32.store16	0($0), $pop22
	i32.const	$push21=, 1
	i32.add 	$1=, $1, $pop21
	i32.const	$push20=, 1
	i32.le_s	$push6=, $1, $pop20
	br_if   	0, $pop6        # 0: up to label8
	br      	2               # 2: down to label6
.LBB3_4:                                # %foo.exit
	end_loop
	end_block                       # label7:
	i32.const	$push7=, 65535
	i32.and 	$push8=, $2, $pop7
	br_if   	0, $pop8        # 0: down to label6
# %bb.5:                                # %if.end
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
