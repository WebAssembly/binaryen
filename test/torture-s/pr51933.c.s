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
	block
	i32.const	$push11=, 1
	i32.lt_s	$push2=, $0, $pop11
	br_if   	0, $pop2        # 0: down to label1
# BB#3:                                 # %for.body.preheader
	copy_local	$3=, $0
	copy_local	$4=, $2
.LBB1_4:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.load16_u	$push20=, 0($1)
	tee_local	$push19=, $5=, $pop20
	i32.const	$push18=, v2
	i32.add 	$push4=, $pop19, $pop18
	i32.const	$push17=, 255
	i32.and 	$push5=, $5, $pop17
	i32.const	$push16=, v3
	i32.add 	$push6=, $pop5, $pop16
	i32.const	$push15=, 256
	i32.lt_u	$push3=, $5, $pop15
	i32.select	$push7=, $pop4, $pop6, $pop3
	i32.load8_u	$push8=, 0($pop7)
	i32.store8	$drop=, 0($4), $pop8
	i32.const	$push14=, 2
	i32.add 	$1=, $1, $pop14
	i32.const	$push13=, 1
	i32.add 	$4=, $4, $pop13
	i32.const	$push12=, -1
	i32.add 	$3=, $3, $pop12
	br_if   	0, $3           # 0: up to label2
.LBB1_5:                                # %for.end
	end_loop                        # label3:
	end_block                       # label1:
	i32.add 	$push9=, $2, $0
	i32.const	$push10=, 0
	i32.store8	$drop=, 0($pop9), $pop10
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
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push27=, __stack_pointer
	i32.const	$push24=, __stack_pointer
	i32.load	$push25=, 0($pop24)
	i32.const	$push26=, 80
	i32.sub 	$push35=, $pop25, $pop26
	i32.store	$0=, 0($pop27), $pop35
	i32.const	$1=, 0
.LBB2_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.store8	$drop=, v2($1), $1
	i32.const	$push39=, 1
	i32.add 	$push0=, $1, $pop39
	i32.store8	$push38=, v3($1), $pop0
	tee_local	$push37=, $2=, $pop38
	copy_local	$1=, $pop37
	i32.const	$push36=, 256
	i32.ne  	$push1=, $2, $pop36
	br_if   	0, $pop1        # 0: up to label4
# BB#2:                                 # %for.body6.preheader
	end_loop                        # label5:
	i32.const	$push3=, 101
	i32.store16	$drop=, 8($0), $pop3
	i32.const	$push4=, 104
	i32.store16	$drop=, 14($0), $pop4
	i32.const	$push5=, 105
	i32.store16	$drop=, 16($0), $pop5
	i32.const	$push6=, 106
	i32.store16	$drop=, 18($0), $pop6
	i32.const	$push7=, 107
	i32.store16	$drop=, 20($0), $pop7
	i32.const	$push8=, 109
	i32.store16	$drop=, 24($0), $pop8
	i32.const	$push9=, 110
	i32.store16	$drop=, 26($0), $pop9
	i32.const	$push10=, 111
	i32.store16	$drop=, 28($0), $pop10
	i32.const	$push11=, 113
	i32.store16	$drop=, 32($0), $pop11
	i32.const	$push12=, 0
	i32.store16	$drop=, 34($0), $pop12
	i32.const	$push13=, 1638
	i32.store16	$drop=, 10($0), $pop13
	i32.const	$push14=, 1383
	i32.store16	$drop=, 12($0), $pop14
	i32.const	$push15=, 8300
	i32.store16	$drop=, 22($0), $pop15
	i32.const	$push16=, 1392
	i32.store16	$drop=, 30($0), $pop16
	i64.const	$push2=, 28147922879250529
	i64.store	$drop=, 0($0), $pop2
	call    	foo@FUNCTION
	block
	i32.const	$push17=, 17
	i32.const	$push31=, 48
	i32.add 	$push32=, $0, $pop31
	i32.call	$push18=, bar@FUNCTION, $pop17, $0, $pop32
	i32.const	$push40=, 17
	i32.ne  	$push19=, $pop18, $pop40
	br_if   	0, $pop19       # 0: down to label6
# BB#3:                                 # %lor.lhs.false
	i32.const	$push33=, 48
	i32.add 	$push34=, $0, $pop33
	i32.const	$push20=, .L.str
	i32.const	$push21=, 18
	i32.call	$push22=, memcmp@FUNCTION, $pop34, $pop20, $pop21
	br_if   	0, $pop22       # 0: down to label6
# BB#4:                                 # %if.end
	i32.const	$push30=, __stack_pointer
	i32.const	$push28=, 80
	i32.add 	$push29=, $0, $pop28
	i32.store	$drop=, 0($pop30), $pop29
	i32.const	$push23=, 0
	return  	$pop23
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
