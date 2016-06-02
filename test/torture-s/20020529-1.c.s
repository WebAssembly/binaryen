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
	i32.const	$push7=, 0
	i32.load	$6=, f1.beenhere($pop7)
	i32.const	$push2=, 8
	i32.add 	$5=, $0, $pop2
.LBB0_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	block
	loop                            # label2:
	i32.const	$push11=, 1
	i32.add 	$4=, $6, $pop11
	i32.const	$push10=, 2
	i32.ge_s	$push0=, $6, $pop10
	br_if   	3, $pop0        # 3: down to label0
# BB#2:                                 # %f1.exit
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push12=, 1
	i32.eq  	$push1=, $6, $pop12
	br_if   	2, $pop1        # 2: down to label1
# BB#3:                                 # %if.end
                                        #   in Loop: Header=BB0_1 Depth=1
	copy_local	$6=, $4
	br_if   	0, $1           # 0: up to label2
# BB#4:                                 # %if.end3
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push13=, 0
	i32.store	$6=, f1.beenhere($pop13), $4
	i32.store16	$4=, 0($5), $3
	i32.load	$push3=, 0($0)
	br_if   	1, $pop3        # 1: down to label3
# BB#5:                                 # %if.end8
                                        #   in Loop: Header=BB0_1 Depth=1
	br_if   	1, $2           # 1: down to label3
# BB#6:                                 # %for.cond.outer.backedge
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push9=, 16
	i32.shl 	$push4=, $4, $pop9
	i32.const	$push8=, 16
	i32.shr_s	$3=, $pop4, $pop8
	copy_local	$6=, $6
	br      	0               # 0: up to label2
.LBB0_7:                                # %if.then10
	end_loop                        # label3:
	call    	f2@FUNCTION
	unreachable
.LBB0_8:                                # %if.then
	end_block                       # label1:
	i32.const	$push5=, 0
	i32.store	$drop=, f1.beenhere($pop5), $4
	i32.const	$push14=, 0
	return  	$pop14
.LBB0_9:                                # %if.then.i
	end_block                       # label0:
	i32.const	$push6=, 0
	i32.store	$drop=, f1.beenhere($pop6), $4
	call    	abort@FUNCTION
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
	i32.const	$push0=, 0
	i32.const	$push8=, 0
	i32.load	$push7=, f1.beenhere($pop8)
	tee_local	$push6=, $1=, $pop7
	i32.const	$push5=, 1
	i32.add 	$push1=, $pop6, $pop5
	i32.store	$drop=, f1.beenhere($pop0), $pop1
	block
	i32.const	$push2=, 2
	i32.ge_s	$push3=, $1, $pop2
	br_if   	0, $pop3        # 0: down to label4
# BB#1:                                 # %if.end
	i32.const	$push9=, 1
	i32.eq  	$push4=, $1, $pop9
	return  	$pop4
.LBB1_2:                                # %if.then
	end_block                       # label4:
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
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, 23
	i32.const	$push11=, 0
	i32.const	$push8=, 0
	i32.load	$push9=, __stack_pointer($pop8)
	i32.const	$push10=, 16
	i32.sub 	$push12=, $pop9, $pop10
	i32.store	$push18=, __stack_pointer($pop11), $pop12
	tee_local	$push17=, $1=, $pop18
	i32.const	$push16=, 23
	i32.store16	$drop=, 8($pop17), $pop16
	i32.const	$push0=, 0
	i32.store	$push15=, 0($1), $pop0
	tee_local	$push14=, $0=, $pop15
	i32.load	$3=, f1.beenhere($pop14)
	i32.store	$drop=, 4($1), $1
	block
	block
	i32.const	$push13=, 1
	i32.gt_s	$push1=, $3, $pop13
	br_if   	0, $pop1        # 0: down to label6
# BB#1:                                 # %f1.exit.i.preheader
	i32.const	$push3=, 8
	i32.add 	$2=, $1, $pop3
.LBB3_2:                                # %f1.exit.i
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label8:
	copy_local	$push22=, $3
	tee_local	$push21=, $1=, $pop22
	i32.const	$push20=, 1
	i32.add 	$3=, $pop21, $pop20
	i32.const	$push19=, 1
	i32.eq  	$push2=, $1, $pop19
	br_if   	2, $pop2        # 2: down to label7
# BB#3:                                 # %if.end.i
                                        #   in Loop: Header=BB3_2 Depth=1
	i32.const	$4=, 0
	i32.const	$push24=, 0
	i32.store16	$drop=, 0($2), $pop24
	i32.const	$push23=, 1
	i32.le_s	$push4=, $3, $pop23
	br_if   	0, $pop4        # 0: up to label8
# BB#4:                                 # %if.then.i.i.loopexit
	end_loop                        # label9:
	i32.const	$push25=, 2
	i32.add 	$1=, $1, $pop25
	i32.const	$push5=, 0
	i32.store	$drop=, f1.beenhere($pop5), $3
	br      	2               # 2: down to label5
.LBB3_5:                                # %foo.exit
	end_block                       # label7:
	i32.const	$push26=, 0
	i32.store	$drop=, f1.beenhere($pop26), $3
	block
	i32.const	$push6=, 65535
	i32.and 	$push7=, $4, $pop6
	br_if   	0, $pop7        # 0: down to label10
# BB#6:                                 # %if.end
	i32.const	$push27=, 0
	call    	exit@FUNCTION, $pop27
	unreachable
.LBB3_7:                                # %if.then
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
.LBB3_8:
	end_block                       # label6:
	i32.const	$push28=, 1
	i32.add 	$1=, $3, $pop28
.LBB3_9:                                # %if.then.i.i
	end_block                       # label5:
	i32.store	$drop=, f1.beenhere($0), $1
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

	.type	f1.beenhere,@object     # @f1.beenhere
	.lcomm	f1.beenhere,4,2

	.ident	"clang version 3.9.0 "
