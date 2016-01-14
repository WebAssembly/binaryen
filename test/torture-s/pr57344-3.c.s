	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr57344-3.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i64
# BB#0:                                 # %entry
	block
	i64.const	$push0=, -3161
	i64.ne  	$push1=, $0, $pop0
	br_if   	$pop1, 0        # 0: down to label0
# BB#1:                                 # %if.end
	#APP
	#NO_APP
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i64, i64, i64, i32
# BB#0:                                 # %entry
	i32.const	$push2=, s+16
	i32.const	$push0=, .Lmain.t
	i32.const	$push1=, 16
	call    	memcpy@FUNCTION, $pop2, $pop0, $pop1
	i32.const	$0=, 0
	block
	i32.load	$push3=, i($0)
	i32.gt_s	$push4=, $pop3, $0
	br_if   	$pop4, 0        # 0: down to label1
# BB#1:                                 # %for.body.preheader
	i64.const	$push5=, -3161
	call    	foo@FUNCTION, $pop5
	i32.load	$5=, i($0)
	i32.const	$1=, 1
	i32.add 	$push6=, $5, $1
	i32.store	$discard=, i($0), $pop6
	i32.const	$push7=, -1
	i32.gt_s	$push8=, $5, $pop7
	br_if   	$pop8, 0        # 0: down to label1
.LBB1_2:                                # %for.body.for.body_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i64.load	$2=, s+16($0)
	i64.const	$3=, 7
	i64.const	$4=, 56
	i64.shl 	$push16=, $2, $3
	i64.const	$push19=, 50
	i64.shr_u	$push20=, $pop16, $pop19
	i64.load8_u	$push9=, s+24($0)
	i64.shl 	$push12=, $pop9, $3
	i64.const	$push10=, 57
	i64.shr_u	$push11=, $2, $pop10
	i64.or  	$push13=, $pop12, $pop11
	i64.shl 	$push14=, $pop13, $4
	i64.shr_s	$push15=, $pop14, $4
	i64.const	$push17=, 14
	i64.shl 	$push18=, $pop15, $pop17
	i64.or  	$push21=, $pop20, $pop18
	call    	foo@FUNCTION, $pop21
	i32.load	$5=, i($0)
	i32.add 	$push22=, $5, $1
	i32.store	$discard=, i($0), $pop22
	i32.lt_s	$push23=, $5, $0
	br_if   	$pop23, 0       # 0: up to label2
.LBB1_3:                                # %for.end
	end_loop                        # label3:
	end_block                       # label1:
	return  	$0
	.endfunc
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
	.int8	56                      # 0x38
	.int8	157                     # 0x9d
	.int8	255                     # 0xff
	.int8	1                       # 0x1
	.int8	0                       # 0x0
	.skip	6
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


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
