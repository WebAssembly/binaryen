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
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, 0
	i32.const	$3=, arg1
	i32.const	$2=, arg2
	i32.const	$1=, arg3
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.const	$push31=, 255
	i32.and 	$push3=, $4, $pop31
	i32.store16	$push1=, 0($3), $pop3
	i32.store	$discard=, 0($2), $pop1
	i64.extend_u/i32	$push2=, $4
	i64.const	$push30=, 255
	i64.and 	$push4=, $pop2, $pop30
	i64.store	$discard=, 0($1), $pop4
	i32.const	$push29=, 2
	i32.add 	$3=, $3, $pop29
	i32.const	$push28=, 4
	i32.add 	$2=, $2, $pop28
	i32.const	$push27=, 8
	i32.add 	$1=, $1, $pop27
	i32.store8	$push0=, arg4($4), $4
	i32.const	$push26=, 1
	i32.add 	$push25=, $pop0, $pop26
	tee_local	$push24=, $4=, $pop25
	i32.const	$push23=, 96
	i32.ne  	$push5=, $pop24, $pop23
	br_if   	0, $pop5        # 0: up to label2
# BB#2:                                 # %for.body.i.preheader
	end_loop                        # label3:
	i32.const	$3=, result
	i32.const	$2=, arg3
	i32.const	$1=, arg2
	i32.const	$4=, -192
.LBB1_3:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.load16_s	$0=, arg1+192($4)
	i32.const	$push42=, 1
	i32.const	$push41=, 1
	i32.lt_s	$push6=, $0, $pop41
	i32.select	$push7=, $0, $pop42, $pop6
	i32.load	$push8=, 0($1)
	i32.const	$push40=, 31
	i32.and 	$push9=, $pop8, $pop40
	i32.shr_s	$push10=, $pop7, $pop9
	i32.const	$push39=, 1
	i32.xor 	$push11=, $pop10, $pop39
	i32.const	$push38=, 32
	i32.add 	$push12=, $pop11, $pop38
	i32.const	$push37=, 7
	i32.shr_u	$push13=, $pop12, $pop37
	i32.const	$push36=, 251
	i32.or  	$push14=, $pop13, $pop36
	i64.extend_u/i32	$push15=, $pop14
	i64.load	$push16=, 0($2)
	i64.and 	$push17=, $pop15, $pop16
	i64.store8	$discard=, 0($3), $pop17
	i32.const	$push35=, 1
	i32.add 	$3=, $3, $pop35
	i32.const	$push34=, 8
	i32.add 	$2=, $2, $pop34
	i32.const	$push33=, 4
	i32.add 	$1=, $1, $pop33
	i32.const	$push32=, 2
	i32.add 	$4=, $4, $pop32
	br_if   	0, $4           # 0: up to label4
# BB#4:                                 # %for.body10.preheader
	end_loop                        # label5:
	i32.const	$4=, 0
	i32.const	$3=, .Lmain.correct
.LBB1_5:                                # %for.body10
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label7:
	i32.load8_s	$push18=, result($4)
	i32.load	$push19=, 0($3)
	i32.ne  	$push20=, $pop18, $pop19
	br_if   	2, $pop20       # 2: down to label6
# BB#6:                                 # %for.cond7
                                        #   in Loop: Header=BB1_5 Depth=1
	i32.const	$push45=, 1
	i32.add 	$4=, $4, $pop45
	i32.const	$push44=, 4
	i32.add 	$3=, $3, $pop44
	i32.const	$push43=, 95
	i32.le_s	$push21=, $4, $pop43
	br_if   	0, $pop21       # 0: up to label7
# BB#7:                                 # %for.end18
	end_loop                        # label8:
	i32.const	$push22=, 0
	return  	$pop22
.LBB1_8:                                # %if.then
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
