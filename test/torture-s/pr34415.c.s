	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr34415.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
                                        # implicit-def: %vreg68
	i32.const	$5=, 1
.LBB0_1:                                # %for.cond
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_4 Depth 2
	loop                            # label0:
	copy_local	$push27=, $0
	tee_local	$push26=, $1=, $pop27
	copy_local	$0=, $pop26
	block
	i32.load8_s	$push25=, 0($1)
	tee_local	$push24=, $2=, $pop25
	i32.const	$push23=, -32
	i32.add 	$push0=, $pop24, $pop23
	i32.const	$push22=, -97
	i32.add 	$push1=, $2, $pop22
	i32.const	$push21=, 255
	i32.and 	$push2=, $pop1, $pop21
	i32.const	$push20=, 26
	i32.lt_u	$push3=, $pop2, $pop20
	i32.select	$push19=, $pop0, $2, $pop3
	tee_local	$push18=, $3=, $pop19
	i32.const	$push17=, 66
	i32.eq  	$push4=, $pop18, $pop17
	br_if   	0, $pop4        # 0: down to label2
# BB#2:                                 # %for.cond
                                        #   in Loop: Header=BB0_1 Depth=1
	block
	i32.const	$push28=, 65
	i32.ne  	$push5=, $3, $pop28
	br_if   	0, $pop5        # 0: down to label3
# BB#3:                                 # %do.body.preheader
                                        #   in Loop: Header=BB0_1 Depth=1
	copy_local	$0=, $1
.LBB0_4:                                # %do.body
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label4:
	i32.const	$push32=, 1
	i32.add 	$push31=, $0, $pop32
	tee_local	$push30=, $0=, $pop31
	i32.load8_u	$push6=, 0($pop30)
	i32.const	$push29=, 43
	i32.eq  	$push7=, $pop6, $pop29
	br_if   	0, $pop7        # 0: up to label4
	br      	3               # 3: down to label2
.LBB0_5:                                # %for.end
	end_loop                        # label5:
	end_block                       # label3:
	block
	i32.const	$push8=, 3
	i32.lt_s	$push9=, $5, $pop8
	br_if   	0, $pop9        # 0: down to label6
# BB#6:                                 # %land.lhs.true17
	i32.const	$push10=, 255
	i32.and 	$push11=, $2, $pop10
	i32.const	$push12=, 58
	i32.eq  	$push13=, $pop11, $pop12
	i32.select	$push14=, $4, $1, $pop13
	return  	$pop14
.LBB0_7:                                # %if.end22
	end_block                       # label6:
	return  	$1
.LBB0_8:                                # %cleanup.thread
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i32.const	$push16=, 1
	i32.add 	$5=, $5, $pop16
	i32.const	$push15=, 1
	i32.add 	$0=, $0, $pop15
	copy_local	$4=, $1
	br      	0               # 0: up to label0
.LBB0_9:
	end_loop                        # label1:
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, .L.str
	i32.call	$push1=, foo@FUNCTION, $pop0
	i32.const	$push2=, .L.str+2
	i32.ne  	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"Bbb:"
	.size	.L.str, 5


	.ident	"clang version 3.9.0 "
