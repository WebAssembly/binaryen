	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/980707-1.c"
	.section	.text.buildargv,"ax",@progbits
	.hidden	buildargv
	.globl	buildargv
	.type	buildargv,@function
buildargv:                              # @buildargv
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
.LBB0_1:                                # %while.cond1
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_5 Depth 2
	block
	loop                            # label1:
	block
	i32.load8_u	$push11=, 0($0)
	tee_local	$push10=, $2=, $pop11
	i32.const	$push9=, 32
	i32.ne  	$push1=, $pop10, $pop9
	br_if   	0, $pop1        # 0: down to label3
# BB#2:                                 # %while.body3
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push8=, 1
	i32.add 	$0=, $0, $pop8
	br      	1               # 1: up to label1
.LBB0_3:                                # %while.cond1
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label3:
	i32.eqz 	$push20=, $2
	br_if   	2, $pop20       # 2: down to label0
# BB#4:                                 # %if.end
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push13=, 2
	i32.shl 	$push2=, $1, $pop13
	i32.store	$discard=, buildargv.arglist($pop2), $0
	i32.const	$push12=, 1
	i32.add 	$1=, $1, $pop12
.LBB0_5:                                # %while.cond7
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label4:
	i32.load8_u	$push16=, 0($0)
	tee_local	$push15=, $2=, $pop16
	i32.eqz 	$push21=, $pop15
	br_if   	3, $pop21       # 3: down to label2
# BB#6:                                 # %while.cond7
                                        #   in Loop: Header=BB0_5 Depth=2
	i32.const	$push17=, 32
	i32.eq  	$push3=, $2, $pop17
	br_if   	1, $pop3        # 1: down to label5
# BB#7:                                 # %while.body14
                                        #   in Loop: Header=BB0_5 Depth=2
	i32.const	$push14=, 1
	i32.add 	$0=, $0, $pop14
	br      	0               # 0: up to label4
.LBB0_8:                                # %if.end21
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop                        # label5:
	i32.const	$push19=, 0
	i32.store8	$discard=, 0($0), $pop19
	i32.const	$push18=, 1
	i32.add 	$push0=, $0, $pop18
	copy_local	$0=, $pop0
	copy_local	$1=, $1
	br      	0               # 0: up to label1
.LBB0_9:
	end_loop                        # label2:
	copy_local	$1=, $1
.LBB0_10:                               # %while.end23
	end_block                       # label0:
	i32.const	$push4=, 2
	i32.shl 	$push5=, $1, $pop4
	i32.const	$push7=, 0
	i32.store	$discard=, buildargv.arglist($pop5), $pop7
	i32.const	$push6=, buildargv.arglist
	return  	$pop6
	.endfunc
.Lfunc_end0:
	.size	buildargv, .Lfunc_end0-buildargv

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push19=, __stack_pointer
	i32.const	$push16=, __stack_pointer
	i32.load	$push17=, 0($pop16)
	i32.const	$push18=, 256
	i32.sub 	$push20=, $pop17, $pop18
	i32.store	$push24=, 0($pop19), $pop20
	tee_local	$push23=, $0=, $pop24
	i32.const	$push22=, 0
	i32.load8_u	$push1=, .L.str+4($pop22)
	i32.store8	$discard=, 4($pop23), $pop1
	i32.const	$push21=, 0
	i32.load	$push2=, .L.str($pop21):p2align=0
	i32.store	$discard=, 0($0), $pop2
	copy_local	$0=, $0
	i32.const	$1=, 0
.LBB1_1:                                # %while.cond1.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_5 Depth 2
	block
	loop                            # label7:
	block
	i32.load8_u	$push28=, 0($0)
	tee_local	$push27=, $2=, $pop28
	i32.const	$push26=, 32
	i32.ne  	$push3=, $pop27, $pop26
	br_if   	0, $pop3        # 0: down to label9
# BB#2:                                 # %while.body3.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push25=, 1
	i32.add 	$0=, $0, $pop25
	br      	1               # 1: up to label7
.LBB1_3:                                # %while.cond1.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label9:
	i32.eqz 	$push41=, $2
	br_if   	2, $pop41       # 2: down to label6
# BB#4:                                 # %if.end.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push30=, 2
	i32.shl 	$push4=, $1, $pop30
	i32.store	$discard=, buildargv.arglist($pop4), $0
	i32.const	$push29=, 1
	i32.add 	$2=, $1, $pop29
.LBB1_5:                                # %while.cond7.i
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label10:
	i32.load8_u	$push34=, 0($0)
	tee_local	$push33=, $1=, $pop34
	i32.const	$push32=, 32
	i32.eq  	$push5=, $pop33, $pop32
	br_if   	1, $pop5        # 1: down to label11
# BB#6:                                 # %while.cond7.i
                                        #   in Loop: Header=BB1_5 Depth=2
	i32.eqz 	$push42=, $1
	br_if   	3, $pop42       # 3: down to label8
# BB#7:                                 # %while.body14.i
                                        #   in Loop: Header=BB1_5 Depth=2
	i32.const	$push31=, 1
	i32.add 	$0=, $0, $pop31
	br      	0               # 0: up to label10
.LBB1_8:                                # %if.end21.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_loop                        # label11:
	i32.const	$push36=, 0
	i32.store8	$discard=, 0($0), $pop36
	i32.const	$push35=, 1
	i32.add 	$push0=, $0, $pop35
	copy_local	$0=, $pop0
	copy_local	$1=, $2
	br      	0               # 0: up to label7
.LBB1_9:
	end_loop                        # label8:
	copy_local	$1=, $2
.LBB1_10:                               # %buildargv.exit
	end_block                       # label6:
	block
	i32.const	$push6=, 2
	i32.shl 	$push7=, $1, $pop6
	i32.const	$push8=, 0
	i32.store	$push38=, buildargv.arglist($pop7), $pop8
	tee_local	$push37=, $0=, $pop38
	i32.load	$push9=, buildargv.arglist($pop37)
	i32.const	$push10=, .L.str.1
	i32.call	$push11=, strcmp@FUNCTION, $pop9, $pop10
	br_if   	0, $pop11       # 0: down to label12
# BB#11:                                # %if.end
	i32.load	$push12=, buildargv.arglist+4($0)
	i32.const	$push13=, .L.str.2
	i32.call	$push14=, strcmp@FUNCTION, $pop12, $pop13
	br_if   	0, $pop14       # 0: down to label12
# BB#12:                                # %if.end8
	i32.const	$push39=, 0
	i32.load	$push15=, buildargv.arglist+8($pop39)
	br_if   	0, $pop15       # 0: down to label12
# BB#13:                                # %if.end11
	i32.const	$push40=, 0
	call    	exit@FUNCTION, $pop40
	unreachable
.LBB1_14:                               # %if.then10
	end_block                       # label12:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	buildargv.arglist,@object # @buildargv.arglist
	.lcomm	buildargv.arglist,1024,4
	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	" a b"
	.size	.L.str, 5

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"a"
	.size	.L.str.1, 2

	.type	.L.str.2,@object        # @.str.2
.L.str.2:
	.asciz	"b"
	.size	.L.str.2, 2


	.ident	"clang version 3.9.0 "
