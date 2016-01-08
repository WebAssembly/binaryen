	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/bswap-1.c"
	.section	.text.g,"ax",@progbits
	.hidden	g
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i64
	.result 	i64
	.local  	i64, i64, i64, i64
# BB#0:                                 # %entry
	i64.const	$2=, 40
	i64.const	$1=, 56
	i64.const	$3=, 24
	i64.const	$4=, 8
	i64.shl 	$push20=, $0, $1
	i64.shl 	$push21=, $0, $2
	i64.const	$push22=, 71776119061217280
	i64.and 	$push23=, $pop21, $pop22
	i64.or  	$push24=, $pop20, $pop23
	i64.shl 	$push16=, $0, $3
	i64.const	$push17=, 280375465082880
	i64.and 	$push18=, $pop16, $pop17
	i64.shl 	$push13=, $0, $4
	i64.const	$push14=, 1095216660480
	i64.and 	$push15=, $pop13, $pop14
	i64.or  	$push19=, $pop18, $pop15
	i64.or  	$push25=, $pop24, $pop19
	i64.shr_u	$push8=, $0, $4
	i64.const	$push9=, 4278190080
	i64.and 	$push10=, $pop8, $pop9
	i64.shr_u	$push5=, $0, $3
	i64.const	$push6=, 16711680
	i64.and 	$push7=, $pop5, $pop6
	i64.or  	$push11=, $pop10, $pop7
	i64.shr_u	$push1=, $0, $2
	i64.const	$push2=, 65280
	i64.and 	$push3=, $pop1, $pop2
	i64.shr_u	$push0=, $0, $1
	i64.or  	$push4=, $pop3, $pop0
	i64.or  	$push12=, $pop11, $pop4
	i64.or  	$push26=, $pop25, $pop12
	return  	$pop26
.Lfunc_end0:
	.size	g, .Lfunc_end0-g

	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i64
	.result 	i64
	.local  	i64, i64, i64, i64
# BB#0:                                 # %entry
	i64.const	$2=, 40
	i64.const	$1=, 56
	i64.const	$3=, 24
	i64.const	$4=, 8
	i64.shl 	$push20=, $0, $1
	i64.shl 	$push21=, $0, $2
	i64.const	$push22=, 71776119061217280
	i64.and 	$push23=, $pop21, $pop22
	i64.or  	$push24=, $pop20, $pop23
	i64.shl 	$push16=, $0, $3
	i64.const	$push17=, 280375465082880
	i64.and 	$push18=, $pop16, $pop17
	i64.shl 	$push13=, $0, $4
	i64.const	$push14=, 1095216660480
	i64.and 	$push15=, $pop13, $pop14
	i64.or  	$push19=, $pop18, $pop15
	i64.or  	$push25=, $pop24, $pop19
	i64.shr_u	$push8=, $0, $4
	i64.const	$push9=, 4278190080
	i64.and 	$push10=, $pop8, $pop9
	i64.shr_u	$push5=, $0, $3
	i64.const	$push6=, 16711680
	i64.and 	$push7=, $pop5, $pop6
	i64.or  	$push11=, $pop10, $pop7
	i64.shr_u	$push1=, $0, $2
	i64.const	$push2=, 65280
	i64.and 	$push3=, $pop1, $pop2
	i64.shr_u	$push0=, $0, $1
	i64.or  	$push4=, $pop3, $pop0
	i64.or  	$push12=, $pop11, $pop4
	i64.or  	$push26=, $pop25, $pop12
	return  	$pop26
.Lfunc_end1:
	.size	f, .Lfunc_end1-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block   	.LBB2_16
	i64.const	$push0=, 18
	i64.call	$push1=, g, $pop0
	i64.const	$push2=, 1297036692682702848
	i64.ne  	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB2_16
# BB#1:                                 # %if.end
	block   	.LBB2_15
	i64.const	$push4=, 4660
	i64.call	$push5=, g, $pop4
	i64.const	$push6=, 3752061439553044480
	i64.ne  	$push7=, $pop5, $pop6
	br_if   	$pop7, .LBB2_15
# BB#2:                                 # %if.end6
	block   	.LBB2_14
	i64.const	$push8=, 1193046
	i64.call	$push9=, g, $pop8
	i64.const	$push10=, 6211609577260056576
	i64.ne  	$push11=, $pop9, $pop10
	br_if   	$pop11, .LBB2_14
# BB#3:                                 # %if.end11
	block   	.LBB2_13
	i64.const	$push12=, 305419896
	i64.call	$push13=, g, $pop12
	i64.const	$push14=, 8671175384462524416
	i64.ne  	$push15=, $pop13, $pop14
	br_if   	$pop15, .LBB2_13
# BB#4:                                 # %if.end16
	block   	.LBB2_12
	i64.const	$push16=, 78187493520
	i64.call	$push17=, g, $pop16
	i64.const	$push18=, -8036578753402372096
	i64.ne  	$push19=, $pop17, $pop18
	br_if   	$pop19, .LBB2_12
# BB#5:                                 # %if.end21
	block   	.LBB2_11
	i64.const	$push20=, 20015998341138
	i64.call	$push21=, g, $pop20
	i64.const	$push22=, 1337701400965152768
	i64.ne  	$push23=, $pop21, $pop22
	br_if   	$pop23, .LBB2_11
# BB#6:                                 # %if.end26
	block   	.LBB2_10
	i64.const	$push24=, 5124095575331380
	i64.call	$push25=, g, $pop24
	i64.const	$push26=, 3752220286069772800
	i64.ne  	$push27=, $pop25, $pop26
	br_if   	$pop27, .LBB2_10
# BB#7:                                 # %if.end31
	block   	.LBB2_9
	i64.const	$push28=, 1311768467284833366
	i64.call	$push29=, g, $pop28
	i64.const	$push30=, 6211610197754262546
	i64.ne  	$push31=, $pop29, $pop30
	br_if   	$pop31, .LBB2_9
# BB#8:                                 # %if.end36
	i32.const	$push32=, 0
	return  	$pop32
.LBB2_9:                                # %if.then35
	call    	abort
	unreachable
.LBB2_10:                               # %if.then30
	call    	abort
	unreachable
.LBB2_11:                               # %if.then25
	call    	abort
	unreachable
.LBB2_12:                               # %if.then20
	call    	abort
	unreachable
.LBB2_13:                               # %if.then15
	call    	abort
	unreachable
.LBB2_14:                               # %if.then10
	call    	abort
	unreachable
.LBB2_15:                               # %if.then5
	call    	abort
	unreachable
.LBB2_16:                               # %if.then
	call    	abort
	unreachable
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
