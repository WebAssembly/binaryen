	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/mode-dependent-address.c"
	.section	.text.f883b,"ax",@progbits
	.hidden	f883b
	.globl	f883b
	.type	f883b,@function
f883b:                                  # @f883b
	.param  	i32, i32, i32, i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, 0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.load16_s	$5=, 0($1)
	i32.add 	$push12=, $0, $6
	i32.const	$push25=, 1
	i32.const	$push24=, 1
	i32.lt_s	$push0=, $5, $pop24
	i32.select	$push1=, $5, $pop25, $pop0
	i32.load	$push2=, 0($2)
	i32.const	$push23=, 31
	i32.and 	$push3=, $pop2, $pop23
	i32.shr_s	$push4=, $pop1, $pop3
	i32.const	$push22=, 1
	i32.xor 	$push5=, $pop4, $pop22
	i32.const	$push21=, 32
	i32.add 	$push6=, $pop5, $pop21
	i32.const	$push20=, 7
	i32.shr_u	$push7=, $pop6, $pop20
	i32.const	$push19=, 251
	i32.or  	$push8=, $pop7, $pop19
	i64.extend_u/i32	$push9=, $pop8
	i64.load	$push10=, 0($3)
	i64.and 	$push11=, $pop9, $pop10
	i64.store8	$discard=, 0($pop12), $pop11
	i32.const	$push18=, 1
	i32.add 	$6=, $6, $pop18
	i32.const	$push17=, 2
	i32.add 	$1=, $1, $pop17
	i32.const	$push16=, 4
	i32.add 	$2=, $2, $pop16
	i32.const	$push15=, 8
	i32.add 	$3=, $3, $pop15
	i32.const	$push14=, 96
	i32.ne  	$push13=, $6, $pop14
	br_if   	0, $pop13       # 0: up to label0
# BB#2:                                 # %for.end
	end_loop                        # label1:
	return
	.endfunc
.Lfunc_end0:
	.size	f883b, .Lfunc_end0-f883b

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 0
	i32.const	$8=, arg1
	i32.const	$5=, arg2
	i32.const	$6=, arg3
	i32.const	$1=, arg3
	i32.const	$2=, arg2
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.store8	$push37=, arg4($3), $3
	tee_local	$push36=, $4=, $pop37
	i32.const	$push35=, 255
	i32.and 	$push1=, $pop36, $pop35
	i32.store16	$push2=, 0($8), $pop1
	i32.store	$discard=, 0($2), $pop2
	i64.extend_u/i32	$push0=, $3
	i64.const	$push34=, 255
	i64.and 	$push3=, $pop0, $pop34
	i64.store	$discard=, 0($1), $pop3
	i32.const	$push33=, 1
	i32.add 	$3=, $4, $pop33
	i32.const	$push32=, 2
	i32.add 	$8=, $8, $pop32
	i32.const	$push31=, 4
	i32.add 	$2=, $2, $pop31
	i32.const	$push30=, 8
	i32.add 	$1=, $1, $pop30
	i32.const	$7=, result
	i32.const	$4=, -192
	i32.const	$push29=, 96
	i32.ne  	$push4=, $3, $pop29
	br_if   	0, $pop4        # 0: up to label2
.LBB1_2:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label3:
	loop                            # label4:
	i32.load16_s	$3=, arg1+192($4)
	i32.load	$8=, 0($5)
	i64.load	$0=, 0($6)
	i32.const	$push19=, 8
	i32.add 	$6=, $6, $pop19
	i32.const	$push20=, 4
	i32.add 	$5=, $5, $pop20
	i32.const	$push21=, 2
	i32.add 	$4=, $4, $pop21
	i32.const	$push41=, 1
	i32.const	$push40=, 1
	i32.lt_s	$push5=, $3, $pop40
	i32.select	$push6=, $3, $pop41, $pop5
	i32.const	$push7=, 31
	i32.and 	$push8=, $8, $pop7
	i32.shr_s	$push9=, $pop6, $pop8
	i32.const	$push39=, 1
	i32.xor 	$push10=, $pop9, $pop39
	i32.const	$push11=, 32
	i32.add 	$push12=, $pop10, $pop11
	i32.const	$push13=, 7
	i32.shr_u	$push14=, $pop12, $pop13
	i32.const	$push15=, 251
	i32.or  	$push16=, $pop14, $pop15
	i64.extend_u/i32	$push17=, $pop16
	i64.and 	$push18=, $0, $pop17
	i64.store8	$discard=, 0($7), $pop18
	i32.const	$push38=, 1
	i32.add 	$7=, $7, $pop38
	i32.const	$3=, 0
	i32.const	$8=, .Lmain.correct
	br_if   	0, $4           # 0: up to label4
.LBB1_3:                                # %for.body10
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label5:
	block
	loop                            # label7:
	i32.load8_s	$push22=, result($3)
	i32.load	$push23=, 0($8)
	i32.ne  	$push24=, $pop22, $pop23
	br_if   	2, $pop24       # 2: down to label6
# BB#4:                                 # %for.cond7
                                        #   in Loop: Header=BB1_3 Depth=1
	i32.const	$push25=, 4
	i32.add 	$8=, $8, $pop25
	i32.const	$push42=, 1
	i32.add 	$3=, $3, $pop42
	i32.const	$push26=, 95
	i32.le_s	$push27=, $3, $pop26
	br_if   	0, $pop27       # 0: up to label7
# BB#5:                                 # %for.end18
	end_loop                        # label8:
	i32.const	$push28=, 0
	return  	$pop28
.LBB1_6:                                # %if.then
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.Lmain.correct,@object  # @main.correct
	.section	.rodata..Lmain.correct,"a",@progbits
	.p2align	4
.Lmain.correct:
	.int32	0                       # 0x0
	.int32	1                       # 0x1
	.int32	2                       # 0x2
	.int32	3                       # 0x3
	.int32	0                       # 0x0
	.int32	1                       # 0x1
	.int32	2                       # 0x2
	.int32	3                       # 0x3
	.int32	8                       # 0x8
	.int32	9                       # 0x9
	.int32	10                      # 0xa
	.int32	11                      # 0xb
	.int32	8                       # 0x8
	.int32	9                       # 0x9
	.int32	10                      # 0xa
	.int32	11                      # 0xb
	.int32	16                      # 0x10
	.int32	17                      # 0x11
	.int32	18                      # 0x12
	.int32	19                      # 0x13
	.int32	16                      # 0x10
	.int32	17                      # 0x11
	.int32	18                      # 0x12
	.int32	19                      # 0x13
	.int32	24                      # 0x18
	.int32	25                      # 0x19
	.int32	26                      # 0x1a
	.int32	27                      # 0x1b
	.int32	24                      # 0x18
	.int32	25                      # 0x19
	.int32	26                      # 0x1a
	.int32	27                      # 0x1b
	.int32	32                      # 0x20
	.int32	33                      # 0x21
	.int32	34                      # 0x22
	.int32	35                      # 0x23
	.int32	32                      # 0x20
	.int32	33                      # 0x21
	.int32	34                      # 0x22
	.int32	35                      # 0x23
	.int32	40                      # 0x28
	.int32	41                      # 0x29
	.int32	42                      # 0x2a
	.int32	43                      # 0x2b
	.int32	40                      # 0x28
	.int32	41                      # 0x29
	.int32	42                      # 0x2a
	.int32	43                      # 0x2b
	.int32	48                      # 0x30
	.int32	49                      # 0x31
	.int32	50                      # 0x32
	.int32	51                      # 0x33
	.int32	48                      # 0x30
	.int32	49                      # 0x31
	.int32	50                      # 0x32
	.int32	51                      # 0x33
	.int32	56                      # 0x38
	.int32	57                      # 0x39
	.int32	58                      # 0x3a
	.int32	59                      # 0x3b
	.int32	56                      # 0x38
	.int32	57                      # 0x39
	.int32	58                      # 0x3a
	.int32	59                      # 0x3b
	.int32	64                      # 0x40
	.int32	65                      # 0x41
	.int32	66                      # 0x42
	.int32	67                      # 0x43
	.int32	64                      # 0x40
	.int32	65                      # 0x41
	.int32	66                      # 0x42
	.int32	67                      # 0x43
	.int32	72                      # 0x48
	.int32	73                      # 0x49
	.int32	74                      # 0x4a
	.int32	75                      # 0x4b
	.int32	72                      # 0x48
	.int32	73                      # 0x49
	.int32	74                      # 0x4a
	.int32	75                      # 0x4b
	.int32	80                      # 0x50
	.int32	81                      # 0x51
	.int32	82                      # 0x52
	.int32	83                      # 0x53
	.int32	80                      # 0x50
	.int32	81                      # 0x51
	.int32	82                      # 0x52
	.int32	83                      # 0x53
	.int32	88                      # 0x58
	.int32	89                      # 0x59
	.int32	90                      # 0x5a
	.int32	91                      # 0x5b
	.int32	88                      # 0x58
	.int32	89                      # 0x59
	.int32	90                      # 0x5a
	.int32	91                      # 0x5b
	.size	.Lmain.correct, 384

	.hidden	arg4                    # @arg4
	.type	arg4,@object
	.section	.bss.arg4,"aw",@nobits
	.globl	arg4
	.p2align	4
arg4:
	.skip	96
	.size	arg4, 96

	.hidden	arg1                    # @arg1
	.type	arg1,@object
	.section	.bss.arg1,"aw",@nobits
	.globl	arg1
	.p2align	4
arg1:
	.skip	192
	.size	arg1, 192

	.hidden	arg2                    # @arg2
	.type	arg2,@object
	.section	.bss.arg2,"aw",@nobits
	.globl	arg2
	.p2align	4
arg2:
	.skip	384
	.size	arg2, 384

	.hidden	arg3                    # @arg3
	.type	arg3,@object
	.section	.bss.arg3,"aw",@nobits
	.globl	arg3
	.p2align	4
arg3:
	.skip	768
	.size	arg3, 768

	.hidden	result                  # @result
	.type	result,@object
	.section	.bss.result,"aw",@nobits
	.globl	result
	.p2align	4
result:
	.skip	96
	.size	result, 96


	.ident	"clang version 3.9.0 "
