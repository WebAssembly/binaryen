	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr57344-4.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i64
# BB#0:                                 # %entry
	block   	.LBB0_2
	i64.const	$push0=, -1220975898975746
	i64.ne  	$push1=, $0, $pop0
	br_if   	$pop1, .LBB0_2
# BB#1:                                 # %if.end
	#APP
	#NO_APP
	return
.LBB0_2:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push2=, s+16
	i32.const	$push0=, .Lmain.t
	i32.const	$push1=, 16
	call    	memcpy@FUNCTION, $pop2, $pop0, $pop1
	i32.const	$0=, 0
	block   	.LBB1_3
	i32.load	$push3=, i($0)
	i32.gt_s	$push4=, $pop3, $0
	br_if   	$pop4, .LBB1_3
# BB#1:                                 # %for.body.preheader
	i64.const	$push5=, -1220975898975746
	call    	foo@FUNCTION, $pop5
	i32.load	$2=, i($0)
	i32.const	$1=, 1
	i32.add 	$push6=, $2, $1
	i32.store	$discard=, i($0), $pop6
	i32.const	$push7=, -1
	i32.gt_s	$push8=, $2, $pop7
	br_if   	$pop8, .LBB1_3
.LBB1_2:                                # %for.body.for.body_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB1_3
	i32.const	$2=, s+24
	i64.load32_u	$push20=, s+24($0)
	i32.const	$push14=, 4
	i32.add 	$push15=, $2, $pop14
	i64.load16_u	$push16=, 0($pop15)
	i32.const	$push9=, 6
	i32.add 	$push10=, $2, $pop9
	i64.load8_u	$push11=, 0($pop10)
	i64.const	$push12=, 16
	i64.shl 	$push13=, $pop11, $pop12
	i64.or  	$push17=, $pop16, $pop13
	i64.const	$push18=, 32
	i64.shl 	$push19=, $pop17, $pop18
	i64.or  	$push21=, $pop20, $pop19
	i64.const	$push23=, 7
	i64.shl 	$push24=, $pop21, $pop23
	i64.load	$push22=, s+16($0)
	i64.const	$push25=, 57
	i64.shr_u	$push26=, $pop22, $pop25
	i64.or  	$push27=, $pop24, $pop26
	i64.const	$push28=, 8
	i64.shl 	$push29=, $pop27, $pop28
	i64.const	$push30=, 10
	i64.shr_s	$push31=, $pop29, $pop30
	call    	foo@FUNCTION, $pop31
	i32.load	$2=, i($0)
	i32.add 	$push32=, $2, $1
	i32.store	$discard=, i($0), $pop32
	i32.lt_s	$push33=, $2, $0
	br_if   	$pop33, .LBB1_2
.LBB1_3:                                # %for.end
	return  	$0
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.Lmain.t,@object        # @main.t
	.section	.rodata.cst16,"aM",@progbits,16
.Lmain.t:
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	240                     # 0xf0
	.int8	15                      # 0xf
	.int8	25                      # 0x19
	.int8	42                      # 0x2a
	.int8	59                      # 0x3b
	.int8	76                      # 0x4c
	.int8	221                     # 0xdd
	.int8	1                       # 0x1
	.int8	0                       # 0x0
	.size	.Lmain.t, 16

	.hidden	s                       # @s
	.type	s,@object
	.section	.bss.s,"aw",@nobits
	.globl	s
	.align	4
s:
	.skip	32
	.size	s, 32

	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.align	2
i:
	.int32	0                       # 0x0
	.size	i, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
