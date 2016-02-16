	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr51933.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	#APP
	#NO_APP
	return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 0
	i32.load8_u	$push1=, v1($pop0)
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.then
	call    	foo@FUNCTION
.LBB1_2:                                # %for.cond.preheader
	end_block                       # label0:
	copy_local	$3=, $0
	copy_local	$4=, $2
	block
	i32.const	$push17=, 1
	i32.lt_s	$push2=, $0, $pop17
	br_if   	0, $pop2        # 0: down to label1
.LBB1_3:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.load16_u	$push20=, 0($1)
	tee_local	$push19=, $5=, $pop20
	i32.const	$push5=, v2
	i32.add 	$push6=, $pop19, $pop5
	i32.const	$push7=, 255
	i32.and 	$push8=, $5, $pop7
	i32.const	$push9=, v3
	i32.add 	$push10=, $pop8, $pop9
	i32.const	$push3=, 256
	i32.lt_u	$push4=, $5, $pop3
	i32.select	$push11=, $pop6, $pop10, $pop4
	i32.load8_u	$push12=, 0($pop11)
	i32.store8	$discard=, 0($4), $pop12
	i32.const	$push13=, 2
	i32.add 	$1=, $1, $pop13
	i32.const	$push14=, -1
	i32.add 	$3=, $3, $pop14
	i32.const	$push18=, 1
	i32.add 	$4=, $4, $pop18
	br_if   	0, $3           # 0: up to label2
.LBB1_4:                                # %for.end
	end_loop                        # label3:
	end_block                       # label1:
	i32.add 	$push15=, $2, $0
	i32.const	$push16=, 0
	i32.store8	$discard=, 0($pop15), $pop16
	return  	$0
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 80
	i32.sub 	$6=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$6=, 0($2), $6
	i32.const	$0=, 0
.LBB2_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.store8	$discard=, v2($0), $0
	i32.const	$push33=, 1
	i32.add 	$push0=, $0, $pop33
	i32.store8	$0=, v3($0), $pop0
	i32.const	$push32=, 256
	i32.ne  	$push1=, $0, $pop32
	br_if   	0, $pop1        # 0: up to label4
# BB#2:                                 # %for.body6.preheader
	end_loop                        # label5:
	i32.const	$push3=, 8
	i32.or  	$push4=, $6, $pop3
	i32.const	$push5=, 101
	i32.store16	$discard=, 0($pop4):p2align=3, $pop5
	i32.const	$push10=, 14
	i32.or  	$push11=, $6, $pop10
	i32.const	$push12=, 104
	i32.store16	$discard=, 0($pop11), $pop12
	i32.const	$push6=, 10
	i32.or  	$push7=, $6, $pop6
	i32.const	$push21=, 1638
	i32.store16	$discard=, 0($pop7), $pop21
	i32.const	$push8=, 12
	i32.or  	$push9=, $6, $pop8
	i32.const	$push22=, 1383
	i32.store16	$discard=, 0($pop9):p2align=2, $pop22
	i32.const	$push13=, 105
	i32.store16	$discard=, 16($6):p2align=4, $pop13
	i32.const	$push14=, 106
	i32.store16	$discard=, 18($6), $pop14
	i32.const	$push15=, 107
	i32.store16	$discard=, 20($6):p2align=2, $pop15
	i32.const	$push16=, 109
	i32.store16	$discard=, 24($6):p2align=3, $pop16
	i32.const	$push17=, 110
	i32.store16	$discard=, 26($6), $pop17
	i32.const	$push18=, 111
	i32.store16	$discard=, 28($6):p2align=2, $pop18
	i32.const	$push19=, 113
	i32.store16	$discard=, 32($6):p2align=4, $pop19
	i32.const	$push20=, 0
	i32.store16	$discard=, 34($6), $pop20
	i32.const	$push23=, 8300
	i32.store16	$discard=, 22($6), $pop23
	i32.const	$push24=, 1392
	i32.store16	$discard=, 30($6), $pop24
	i64.const	$push2=, 28147922879250529
	i64.store	$discard=, 0($6):p2align=4, $pop2
	call    	foo@FUNCTION
	i32.const	$push25=, 17
	i32.const	$4=, 48
	i32.add 	$4=, $6, $4
	block
	i32.call	$push26=, bar@FUNCTION, $pop25, $6, $4
	i32.const	$push34=, 17
	i32.ne  	$push27=, $pop26, $pop34
	br_if   	0, $pop27       # 0: down to label6
# BB#3:                                 # %lor.lhs.false
	i32.const	$push28=, .L.str
	i32.const	$push29=, 18
	i32.const	$5=, 48
	i32.add 	$5=, $6, $5
	i32.call	$push30=, memcmp@FUNCTION, $5, $pop28, $pop29
	br_if   	0, $pop30       # 0: down to label6
# BB#4:                                 # %if.end
	i32.const	$push31=, 0
	i32.const	$3=, 80
	i32.add 	$6=, $6, $3
	i32.const	$3=, __stack_pointer
	i32.store	$6=, 0($3), $6
	return  	$pop31
.LBB2_5:                                # %if.then
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	v1,@object              # @v1
	.lcomm	v1,1
	.type	v2,@object              # @v2
	.lcomm	v2,256,4
	.type	v3,@object              # @v3
	.lcomm	v3,256,4
	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"abcdeghhijkmmnoqq"
	.size	.L.str, 18


	.ident	"clang version 3.9.0 "
