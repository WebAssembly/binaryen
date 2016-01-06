	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/mode-dependent-address.c"
	.globl	f883b
	.type	f883b,@function
f883b:                                  # @f883b
	.param  	i32, i32, i32, i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$7=, 0
BB0_1:                                  # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB0_2
	i32.load16_s	$5=, 0($1)
	i32.const	$6=, 1
	i32.add 	$push16=, $0, $7
	i32.lt_s	$push0=, $5, $6
	i32.select	$push1=, $pop0, $5, $6
	i32.load	$push2=, 0($2)
	i32.const	$push3=, 31
	i32.and 	$push4=, $pop2, $pop3
	i32.shr_s	$push5=, $pop1, $pop4
	i32.xor 	$push6=, $pop5, $6
	i32.const	$push7=, 32
	i32.add 	$push8=, $pop6, $pop7
	i32.const	$push9=, 7
	i32.shr_u	$push10=, $pop8, $pop9
	i32.const	$push11=, 251
	i32.or  	$push12=, $pop10, $pop11
	i64.extend_u/i32	$push13=, $pop12
	i64.load	$push14=, 0($3)
	i64.and 	$push15=, $pop13, $pop14
	i64.store8	$discard=, 0($pop16), $pop15
	i32.add 	$7=, $7, $6
	i32.const	$push17=, 2
	i32.add 	$1=, $1, $pop17
	i32.const	$push18=, 4
	i32.add 	$2=, $2, $pop18
	i32.const	$push19=, 8
	i32.add 	$3=, $3, $pop19
	i32.const	$push20=, 96
	i32.ne  	$push21=, $7, $pop20
	br_if   	$pop21, BB0_1
BB0_2:                                  # %for.end
	return
func_end0:
	.size	f883b, func_end0-f883b

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i64.const	$0=, 255
	i32.const	$7=, 0
	i32.const	$9=, arg2
	i32.const	$10=, arg3
	i32.const	$12=, arg1
	copy_local	$5=, $10
	copy_local	$6=, $9
BB1_1:                                  # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB1_2
	i32.const	$push1=, arg4
	i32.add 	$push2=, $pop1, $7
	i32.store8	$8=, 0($pop2), $7
	i32.const	$push3=, 255
	i32.and 	$push4=, $8, $pop3
	i32.store16	$push5=, 0($12), $pop4
	i32.store	$discard=, 0($6), $pop5
	i64.extend_u/i32	$push0=, $7
	i64.and 	$push6=, $pop0, $0
	i64.store	$discard=, 0($5), $pop6
	i32.const	$1=, 1
	i32.add 	$7=, $8, $1
	i32.const	$2=, 2
	i32.add 	$12=, $12, $2
	i32.const	$3=, 4
	i32.add 	$6=, $6, $3
	i32.const	$4=, 8
	i32.add 	$5=, $5, $4
	i32.const	$11=, result
	i32.const	$8=, -192
	i32.const	$push7=, 96
	i32.ne  	$push8=, $7, $pop7
	br_if   	$pop8, BB1_1
BB1_2:                                  # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB1_3
	i32.const	$push9=, arg1
	i32.add 	$push10=, $pop9, $8
	i32.const	$push11=, 192
	i32.add 	$push12=, $pop10, $pop11
	i32.load16_s	$7=, 0($pop12)
	i32.lt_s	$push13=, $7, $1
	i32.select	$push14=, $pop13, $7, $1
	i32.load	$push15=, 0($9)
	i32.const	$push16=, 31
	i32.and 	$push17=, $pop15, $pop16
	i32.shr_s	$push18=, $pop14, $pop17
	i32.xor 	$push19=, $pop18, $1
	i32.const	$push20=, 32
	i32.add 	$push21=, $pop19, $pop20
	i32.const	$push22=, 7
	i32.shr_u	$push23=, $pop21, $pop22
	i32.const	$push24=, 251
	i32.or  	$push25=, $pop23, $pop24
	i64.extend_u/i32	$push26=, $pop25
	i64.load	$push27=, 0($10)
	i64.and 	$push28=, $pop26, $pop27
	i64.store8	$discard=, 0($11), $pop28
	i32.add 	$11=, $11, $1
	i32.add 	$10=, $10, $4
	i32.add 	$9=, $9, $3
	i32.add 	$8=, $8, $2
	i32.const	$7=, 0
	i32.const	$12=, main.correct
	br_if   	$8, BB1_2
BB1_3:                                  # %for.body10
                                        # =>This Inner Loop Header: Depth=1
	block   	BB1_6
	loop    	BB1_5
	i32.const	$push29=, result
	i32.add 	$push30=, $pop29, $7
	i32.load8_s	$push31=, 0($pop30)
	i32.load	$push32=, 0($12)
	i32.ne  	$push33=, $pop31, $pop32
	br_if   	$pop33, BB1_6
# BB#4:                                 # %for.cond7
                                        #   in Loop: Header=BB1_3 Depth=1
	i32.add 	$7=, $7, $1
	i32.add 	$12=, $12, $3
	i32.const	$push34=, 95
	i32.le_s	$push35=, $7, $pop34
	br_if   	$pop35, BB1_3
BB1_5:                                  # %for.end18
	i32.const	$push36=, 0
	return  	$pop36
BB1_6:                                  # %if.then
	call    	abort
	unreachable
func_end1:
	.size	main, func_end1-main

	.type	main.correct,@object    # @main.correct
	.section	.rodata,"a",@progbits
	.align	4
main.correct:
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
	.size	main.correct, 384

	.type	arg4,@object            # @arg4
	.bss
	.globl	arg4
	.align	4
arg4:
	.zero	96
	.size	arg4, 96

	.type	arg1,@object            # @arg1
	.globl	arg1
	.align	4
arg1:
	.zero	192
	.size	arg1, 192

	.type	arg2,@object            # @arg2
	.globl	arg2
	.align	4
arg2:
	.zero	384
	.size	arg2, 384

	.type	arg3,@object            # @arg3
	.globl	arg3
	.align	4
arg3:
	.zero	768
	.size	arg3, 768

	.type	result,@object          # @result
	.globl	result
	.align	4
result:
	.zero	96
	.size	result, 96


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
