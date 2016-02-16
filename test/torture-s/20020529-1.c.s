	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020529-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push2=, 8
	i32.add 	$5=, $0, $pop2
	i32.const	$push6=, 0
	i32.load	$6=, f1.beenhere($pop6)
.LBB0_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	block
	block
	loop                            # label3:
	i32.const	$push8=, 1
	i32.add 	$4=, $6, $pop8
	i32.const	$push7=, 2
	i32.ge_s	$push0=, $6, $pop7
	br_if   	3, $pop0        # 3: down to label1
# BB#2:                                 # %f1.exit
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push9=, 1
	i32.ge_s	$push1=, $6, $pop9
	br_if   	2, $pop1        # 2: down to label2
# BB#3:                                 # %if.end
                                        #   in Loop: Header=BB0_1 Depth=1
	copy_local	$6=, $4
	br_if   	0, $1           # 0: up to label3
# BB#4:                                 # %if.end3
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push11=, 0
	i32.store	$6=, f1.beenhere($pop11), $4
	i32.load	$4=, 0($0)
	i32.store16	$discard=, 0($5):p2align=2, $3
	br_if   	4, $4           # 4: down to label0
# BB#5:                                 # %if.end8
                                        #   in Loop: Header=BB0_1 Depth=1
	br_if   	1, $2           # 1: down to label4
# BB#6:                                 # %for.cond.outer.backedge
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push13=, 16
	i32.shl 	$push3=, $3, $pop13
	i32.const	$push12=, 16
	i32.shr_s	$3=, $pop3, $pop12
	br      	0               # 0: up to label3
.LBB0_7:                                # %if.then10
	end_loop                        # label4:
	call    	f2@FUNCTION
	unreachable
.LBB0_8:                                # %if.then
	end_block                       # label2:
	i32.const	$push4=, 0
	i32.store	$discard=, f1.beenhere($pop4), $4
	i32.const	$push10=, 0
	return  	$pop10
.LBB0_9:                                # %if.then.i
	end_block                       # label1:
	i32.const	$push5=, 0
	i32.store	$discard=, f1.beenhere($pop5), $4
	call    	abort@FUNCTION
	unreachable
.LBB0_10:                               # %if.then7
	end_block                       # label0:
	call    	f2@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.f1,"ax",@progbits
	.hidden	f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push8=, 0
	i32.const	$push7=, 0
	i32.load	$push6=, f1.beenhere($pop7)
	tee_local	$push5=, $1=, $pop6
	i32.const	$push0=, 1
	i32.add 	$push1=, $pop5, $pop0
	i32.store	$discard=, f1.beenhere($pop8), $pop1
	block
	i32.const	$push2=, 2
	i32.ge_s	$push3=, $1, $pop2
	br_if   	0, $pop3        # 0: down to label5
# BB#1:                                 # %if.end
	i32.const	$push9=, 0
	i32.gt_s	$push4=, $1, $pop9
	return  	$pop4
.LBB1_2:                                # %if.then
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	f1, .Lfunc_end1-f1

	.section	.text.f2,"ax",@progbits
	.hidden	f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
# BB#0:                                 # %entry
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	f2, .Lfunc_end2-f2

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 16
	i32.sub 	$6=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$6=, 0($5), $6
	i32.const	$push3=, 4
	i32.or  	$push4=, $6, $pop3
	i32.store	$discard=, 0($pop4), $6
	i32.const	$push2=, 0
	i32.store	$push19=, 0($6):p2align=3, $pop2
	tee_local	$push18=, $2=, $pop19
	i32.load	$0=, f1.beenhere($pop18)
	i32.const	$push1=, 23
	i32.store16	$1=, 8($6):p2align=3, $pop1
	i32.const	$push17=, 1
	i32.add 	$3=, $0, $pop17
	block
	block
	i32.const	$push16=, 1
	i32.gt_s	$push5=, $0, $pop16
	br_if   	0, $pop5        # 0: down to label7
.LBB3_1:                                # %f1.exit.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label8:
	copy_local	$push21=, $0
	tee_local	$push20=, $3=, $pop21
	i32.gt_s	$push6=, $pop20, $2
	br_if   	3, $pop6        # 3: down to label6
# BB#2:                                 # %if.end.i
                                        #   in Loop: Header=BB3_1 Depth=1
	i32.const	$push8=, 8
	i32.add 	$push9=, $6, $pop8
	i32.const	$push7=, 0
	i32.store16	$1=, 0($pop9):p2align=3, $pop7
	i32.const	$push10=, 1
	i32.add 	$0=, $3, $pop10
	i32.const	$push22=, 1
	i32.le_s	$push11=, $0, $pop22
	br_if   	0, $pop11       # 0: up to label8
# BB#3:                                 # %if.then.i.i.loopexit
	end_loop                        # label9:
	i32.const	$push13=, 0
	i32.store	$discard=, f1.beenhere($pop13), $0
	i32.const	$push12=, 2
	i32.add 	$3=, $3, $pop12
.LBB3_4:                                # %if.then.i.i
	end_block                       # label7:
	i32.store	$discard=, f1.beenhere($2), $3
	call    	abort@FUNCTION
	unreachable
.LBB3_5:                                # %foo.exit
	end_block                       # label6:
	i32.const	$push24=, 0
	i32.const	$push23=, 1
	i32.add 	$push0=, $3, $pop23
	i32.store	$discard=, f1.beenhere($pop24), $pop0
	block
	i32.const	$push14=, 65535
	i32.and 	$push15=, $1, $pop14
	br_if   	0, $pop15       # 0: down to label10
# BB#6:                                 # %if.end
	i32.const	$push25=, 0
	call    	exit@FUNCTION, $pop25
	unreachable
.LBB3_7:                                # %if.then
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

	.type	f1.beenhere,@object     # @f1.beenhere
	.lcomm	f1.beenhere,4,2

	.ident	"clang version 3.9.0 "
