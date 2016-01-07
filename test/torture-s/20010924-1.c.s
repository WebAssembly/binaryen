	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20010924-1.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	block   	.LBB0_26
	i32.load8_u	$push0=, a1($1)
	i32.const	$push1=, 52
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	$pop2, .LBB0_26
# BB#1:                                 # %if.end
	i32.load	$0=, a1+4($1)
	block   	.LBB0_25
	i32.load8_u	$push3=, 0($0)
	i32.const	$push4=, 54
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	$pop5, .LBB0_25
# BB#2:                                 # %if.end6
	block   	.LBB0_24
	i32.load8_u	$push6=, 1($0)
	i32.const	$push7=, 50
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	$pop8, .LBB0_24
# BB#3:                                 # %if.end12
	block   	.LBB0_23
	i32.load8_u	$push9=, 2($0)
	br_if   	$pop9, .LBB0_23
# BB#4:                                 # %if.end18
	block   	.LBB0_22
	i32.load8_u	$push10=, a2($1)
	i32.const	$push11=, 118
	i32.ne  	$push12=, $pop10, $pop11
	br_if   	$pop12, .LBB0_22
# BB#5:                                 # %if.end23
	block   	.LBB0_21
	i32.load8_u	$push13=, a2+1($1)
	i32.const	$push14=, 99
	i32.ne  	$push15=, $pop13, $pop14
	br_if   	$pop15, .LBB0_21
# BB#6:                                 # %if.end28
	block   	.LBB0_20
	i32.load8_u	$push16=, a2+2($1)
	i32.const	$push17=, 113
	i32.ne  	$push18=, $pop16, $pop17
	br_if   	$pop18, .LBB0_20
# BB#7:                                 # %if.end33
	block   	.LBB0_19
	i32.load8_u	$push19=, a3($1)
	i32.const	$push20=, 111
	i32.ne  	$push21=, $pop19, $pop20
	br_if   	$pop21, .LBB0_19
# BB#8:                                 # %if.end38
	block   	.LBB0_18
	i32.load8_u	$push22=, a3+1($1)
	i32.const	$push23=, 119
	i32.ne  	$push24=, $pop22, $pop23
	br_if   	$pop24, .LBB0_18
# BB#9:                                 # %if.end43
	block   	.LBB0_17
	i32.load8_u	$push25=, a3+2($1)
	i32.const	$push26=, 120
	i32.ne  	$push27=, $pop25, $pop26
	br_if   	$pop27, .LBB0_17
# BB#10:                                # %if.end48
	block   	.LBB0_16
	i32.load8_u	$push28=, a4($1)
	i32.const	$push29=, 57
	i32.ne  	$push30=, $pop28, $pop29
	br_if   	$pop30, .LBB0_16
# BB#11:                                # %if.end53
	block   	.LBB0_15
	i32.load8_u	$push31=, a4+1($1)
	i32.const	$push32=, 101
	i32.ne  	$push33=, $pop31, $pop32
	br_if   	$pop33, .LBB0_15
# BB#12:                                # %if.end58
	block   	.LBB0_14
	i32.load8_u	$push34=, a4+2($1)
	i32.const	$push35=, 98
	i32.ne  	$push36=, $pop34, $pop35
	br_if   	$pop36, .LBB0_14
# BB#13:                                # %if.end63
	return  	$1
.LBB0_14:                                 # %if.then62
	call    	abort
	unreachable
.LBB0_15:                                 # %if.then57
	call    	abort
	unreachable
.LBB0_16:                                 # %if.then52
	call    	abort
	unreachable
.LBB0_17:                                 # %if.then47
	call    	abort
	unreachable
.LBB0_18:                                 # %if.then42
	call    	abort
	unreachable
.LBB0_19:                                 # %if.then37
	call    	abort
	unreachable
.LBB0_20:                                 # %if.then32
	call    	abort
	unreachable
.LBB0_21:                                 # %if.then27
	call    	abort
	unreachable
.LBB0_22:                                 # %if.then22
	call    	abort
	unreachable
.LBB0_23:                                 # %if.then17
	call    	abort
	unreachable
.LBB0_24:                                 # %if.then11
	call    	abort
	unreachable
.LBB0_25:                                 # %if.then5
	call    	abort
	unreachable
.LBB0_26:                                 # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	.str,@object            # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.str:
	.asciz	"62"
	.size	.str, 3

	.type	a1,@object              # @a1
	.data
	.globl	a1
	.align	2
a1:
	.int8	52                      # 0x34
	.zero	3
	.int32	.str
	.size	a1, 8

	.type	a2,@object              # @a2
	.globl	a2
a2:
	.int8	118                     # 0x76
	.ascii	"cq"
	.size	a2, 3

	.type	a3,@object              # @a3
	.globl	a3
a3:
	.int8	111                     # 0x6f
	.asciz	"wx"
	.size	a3, 4

	.type	a4,@object              # @a4
	.globl	a4
a4:
	.int8	57                      # 0x39
	.ascii	"eb"
	.size	a4, 3


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
