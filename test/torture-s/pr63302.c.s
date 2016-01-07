	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr63302.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i64, i64
	.result 	i32
	.local  	i64
# BB#0:                                 # %entry
	i64.const	$push0=, -9223372036854773761
	i64.and 	$0=, $0, $pop0
	i64.const	$2=, 0
	i64.or  	$push1=, $0, $1
	i64.eq  	$push2=, $pop1, $2
	i64.const	$push5=, -9223372036854775808
	i64.xor 	$push6=, $0, $pop5
	i64.const	$push3=, -1
	i64.xor 	$push4=, $1, $pop3
	i64.or  	$push7=, $pop6, $pop4
	i64.eq  	$push8=, $pop7, $2
	i32.or  	$push9=, $pop2, $pop8
	return  	$pop9
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i64
	.result 	i32
# BB#0:                                 # %entry
	i64.const	$push0=, -2147481601
	i64.and 	$0=, $0, $pop0
	i64.const	$push1=, 0
	i64.eq  	$push2=, $0, $pop1
	i64.const	$push3=, -2147483648
	i64.eq  	$push4=, $0, $pop3
	i32.or  	$push5=, $pop2, $pop4
	return  	$pop5
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i32, i32, i64, i64, i64, i64, i64
# BB#0:                                 # %entry
	i64.const	$0=, 0
	i32.call	$1=, foo, $0, $0
	i32.const	$2=, 1
	block   	.LBB2_20
	i32.ne  	$push0=, $1, $2
	br_if   	$pop0, .LBB2_20
# BB#1:                                 # %lor.lhs.false
	i64.const	$3=, 1
	i32.call	$push1=, foo, $3, $0
	br_if   	$pop1, .LBB2_20
# BB#2:                                 # %lor.lhs.false3
	i64.const	$4=, 2048
	i32.call	$push2=, foo, $4, $0
	i32.ne  	$push3=, $pop2, $2
	br_if   	$pop3, .LBB2_20
# BB#3:                                 # %lor.lhs.false6
	i64.const	$5=, 2049
	i32.call	$push4=, foo, $5, $0
	br_if   	$pop4, .LBB2_20
# BB#4:                                 # %lor.lhs.false9
	i64.const	$6=, -9223372036854775808
	i32.call	$push5=, foo, $6, $0
	br_if   	$pop5, .LBB2_20
# BB#5:                                 # %lor.lhs.false12
	i64.const	$7=, -1
	i32.call	$push6=, foo, $6, $7
	i32.ne  	$push7=, $pop6, $2
	br_if   	$pop7, .LBB2_20
# BB#6:                                 # %lor.lhs.false15
	i64.const	$push8=, -9223372036854775807
	i32.call	$push9=, foo, $pop8, $7
	br_if   	$pop9, .LBB2_20
# BB#7:                                 # %lor.lhs.false18
	i64.const	$push10=, -9223372036854773760
	i32.call	$push11=, foo, $pop10, $7
	i32.ne  	$push12=, $pop11, $2
	br_if   	$pop12, .LBB2_20
# BB#8:                                 # %lor.lhs.false21
	i64.const	$push13=, -9223372036854773759
	i32.call	$push14=, foo, $pop13, $7
	br_if   	$pop14, .LBB2_20
# BB#9:                                 # %if.end
	block   	.LBB2_19
	i32.call	$push15=, bar, $0
	i32.ne  	$push16=, $pop15, $2
	br_if   	$pop16, .LBB2_19
# BB#10:                                # %lor.lhs.false26
	i32.call	$push17=, bar, $3
	br_if   	$pop17, .LBB2_19
# BB#11:                                # %lor.lhs.false29
	i32.call	$push18=, bar, $4
	i32.ne  	$push19=, $pop18, $2
	br_if   	$pop19, .LBB2_19
# BB#12:                                # %lor.lhs.false32
	i32.call	$push20=, bar, $5
	br_if   	$pop20, .LBB2_19
# BB#13:                                # %lor.lhs.false35
	i64.const	$push21=, 2147483648
	i32.call	$push22=, bar, $pop21
	br_if   	$pop22, .LBB2_19
# BB#14:                                # %lor.lhs.false38
	i64.const	$push23=, -2147483648
	i32.call	$push24=, bar, $pop23
	i32.ne  	$push25=, $pop24, $2
	br_if   	$pop25, .LBB2_19
# BB#15:                                # %lor.lhs.false41
	i64.const	$push26=, -2147483647
	i32.call	$push27=, bar, $pop26
	br_if   	$pop27, .LBB2_19
# BB#16:                                # %lor.lhs.false44
	i64.const	$push28=, -2147481600
	i32.call	$push29=, bar, $pop28
	i32.ne  	$push30=, $pop29, $2
	br_if   	$pop30, .LBB2_19
# BB#17:                                # %lor.lhs.false47
	i64.const	$push31=, -2147481599
	i32.call	$push32=, bar, $pop31
	br_if   	$pop32, .LBB2_19
# BB#18:                                # %if.end51
	i32.const	$push33=, 0
	return  	$pop33
.LBB2_19:                                 # %if.then50
	call    	abort
	unreachable
.LBB2_20:                                 # %if.then
	call    	abort
	unreachable
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
