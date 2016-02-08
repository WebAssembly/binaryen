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
                                        # implicit-def: %vreg38
	i32.const	$2=, 1
.LBB0_1:                                # %for.cond
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_3 Depth 2
	loop                            # label0:
	copy_local	$push0=, $0
	tee_local	$push25=, $5=, $pop0
	copy_local	$0=, $pop25
	block
	i32.load8_s	$push1=, 0($5)
	tee_local	$push24=, $4=, $pop1
	i32.const	$push23=, -32
	i32.add 	$push6=, $pop24, $pop23
	i32.const	$push22=, -97
	i32.add 	$push3=, $4, $pop22
	i32.const	$push21=, 255
	i32.and 	$push4=, $pop3, $pop21
	i32.const	$push20=, 26
	i32.lt_u	$push5=, $pop4, $pop20
	i32.select	$push2=, $pop6, $4, $pop5
	tee_local	$push19=, $3=, $pop2
	i32.const	$push18=, 66
	i32.eq  	$push7=, $pop19, $pop18
	br_if   	0, $pop7        # 0: down to label2
# BB#2:                                 # %for.cond
                                        #   in Loop: Header=BB0_1 Depth=1
	copy_local	$0=, $5
	block
	i32.const	$push26=, 65
	i32.ne  	$push8=, $3, $pop26
	br_if   	0, $pop8        # 0: down to label3
.LBB0_3:                                # %do.body
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label4:
	i32.const	$push28=, 1
	i32.add 	$0=, $0, $pop28
	i32.load8_u	$push9=, 0($0)
	i32.const	$push27=, 43
	i32.eq  	$push10=, $pop9, $pop27
	br_if   	0, $pop10       # 0: up to label4
	br      	3               # 3: down to label2
.LBB0_4:                                # %for.end
	end_loop                        # label5:
	end_block                       # label3:
	block
	i32.const	$push11=, 3
	i32.lt_s	$push12=, $2, $pop11
	br_if   	0, $pop12       # 0: down to label6
# BB#5:                                 # %land.lhs.true17
	i32.const	$push13=, 255
	i32.and 	$push14=, $4, $pop13
	i32.const	$push15=, 58
	i32.eq  	$push16=, $pop14, $pop15
	i32.select	$push17=, $1, $5, $pop16
	return  	$pop17
.LBB0_6:                                # %if.end22
	end_block                       # label6:
	return  	$5
.LBB0_7:                                # %cleanup.thread
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i32.const	$push30=, 1
	i32.add 	$0=, $0, $pop30
	i32.const	$push29=, 1
	i32.add 	$2=, $2, $pop29
	copy_local	$1=, $5
	br      	0               # 0: up to label0
.LBB0_8:
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
	return  	$pop3
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"Bbb:"
	.size	.L.str, 5


	.ident	"clang version 3.9.0 "
