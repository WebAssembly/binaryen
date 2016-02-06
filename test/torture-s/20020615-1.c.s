	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020615-1.c"
	.section	.text.line_hints,"ax",@progbits
	.hidden	line_hints
	.globl	line_hints
	.type	line_hints,@function
line_hints:                             # @line_hints
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, 0
	i32.const	$push50=, 0
	i32.load	$push5=, 0($2)
	i32.load	$push6=, 0($1)
	i32.sub 	$push7=, $pop5, $pop6
	tee_local	$push49=, $4=, $pop7
	i32.sub 	$push11=, $pop50, $pop49
	i32.load	$push0=, 4($0)
	tee_local	$push48=, $7=, $pop0
	i32.select	$push12=, $pop11, $4, $pop48
	tee_local	$push47=, $3=, $pop12
	i32.const	$push46=, 0
	i32.load	$push8=, 4($2)
	i32.load	$push9=, 4($1)
	i32.sub 	$push10=, $pop8, $pop9
	tee_local	$push45=, $1=, $pop10
	i32.sub 	$push13=, $pop46, $pop45
	i32.load	$push1=, 8($0)
	tee_local	$push44=, $6=, $pop1
	i32.select	$push14=, $pop13, $1, $pop44
	tee_local	$push43=, $1=, $pop14
	i32.load	$push2=, 0($0)
	tee_local	$push42=, $2=, $pop2
	i32.select	$0=, $pop47, $pop43, $pop42
	i32.const	$push15=, 31
	i32.shr_s	$push16=, $0, $pop15
	tee_local	$push41=, $4=, $pop16
	i32.add 	$push17=, $0, $pop41
	i32.xor 	$4=, $pop17, $4
	i32.select	$1=, $1, $3, $2
	i32.const	$push40=, 31
	i32.shr_s	$push18=, $1, $pop40
	tee_local	$push39=, $3=, $pop18
	i32.add 	$push19=, $1, $pop39
	i32.xor 	$3=, $pop19, $3
	block
	block
	i32.const	$push56=, 0
	i32.eq  	$push57=, $0, $pop56
	br_if   	$pop57, 0       # 0: down to label1
# BB#1:                                 # %entry
	i32.const	$push51=, 4
	i32.shr_s	$push4=, $4, $pop51
	i32.gt_s	$push20=, $3, $pop4
	br_if   	$pop20, 0       # 0: down to label1
# BB#2:                                 # %if.then21
	i32.const	$push25=, 2
	i32.const	$push24=, 1
	i32.const	$push22=, 0
	i32.gt_s	$push23=, $0, $pop22
	i32.select	$push26=, $pop25, $pop24, $pop23
	tee_local	$push52=, $0=, $pop26
	i32.const	$push27=, 3
	i32.xor 	$push28=, $pop52, $pop27
	i32.select	$push21=, $6, $7, $2
	i32.select	$5=, $pop28, $0, $pop21
	br      	1               # 1: down to label0
.LBB0_3:                                # %if.else
	end_block                       # label1:
	i32.const	$push58=, 0
	i32.eq  	$push59=, $1, $pop58
	br_if   	$pop59, 0       # 0: down to label0
# BB#4:                                 # %if.else
	i32.const	$push53=, 4
	i32.shr_s	$push29=, $3, $pop53
	i32.gt_s	$push30=, $4, $pop29
	br_if   	$pop30, 0       # 0: down to label0
# BB#5:                                 # %if.then31
	i32.const	$push31=, 29
	i32.shr_u	$push32=, $1, $pop31
	i32.const	$push33=, 4
	i32.and 	$push34=, $pop32, $pop33
	i32.const	$push55=, 4
	i32.add 	$push35=, $pop34, $pop55
	tee_local	$push54=, $0=, $pop35
	i32.const	$push36=, 12
	i32.xor 	$push37=, $pop54, $pop36
	i32.select	$push3=, $7, $6, $2
	i32.select	$push38=, $pop37, $0, $pop3
	return  	$pop38
.LBB0_6:                                # %if.end40
	end_block                       # label0:
	return  	$5
	.endfunc
.Lfunc_end0:
	.size	line_hints, .Lfunc_end0-line_hints

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push1=, main.fh
	i32.const	$push0=, main.gsf
	i32.const	$push2=, main.gsf+8
	i32.call	$push3=, line_hints@FUNCTION, $pop1, $pop0, $pop2
	i32.const	$push4=, 1
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	$pop5, 0        # 0: down to label2
# BB#1:                                 # %lor.lhs.false
	i32.const	$push6=, main.fh+12
	i32.const	$push16=, main.gsf+16
	i32.const	$push15=, main.gsf+24
	i32.call	$push7=, line_hints@FUNCTION, $pop6, $pop16, $pop15
	i32.const	$push8=, 8
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	$pop9, 0        # 0: down to label2
# BB#2:                                 # %lor.lhs.false3
	i32.const	$push10=, main.fh+24
	i32.const	$push18=, main.gsf+16
	i32.const	$push17=, main.gsf+24
	i32.call	$push11=, line_hints@FUNCTION, $pop10, $pop18, $pop17
	i32.const	$push12=, 4
	i32.ne  	$push13=, $pop11, $pop12
	br_if   	$pop13, 0       # 0: down to label2
# BB#3:                                 # %if.end
	i32.const	$push14=, 0
	call    	exit@FUNCTION, $pop14
	unreachable
.LBB1_4:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	main.fh,@object         # @main.fh
	.section	.data.main.fh,"aw",@progbits
	.p2align	4
main.fh:
	.int32	0                       # 0x0
	.int32	1                       # 0x1
	.int32	0                       # 0x0
	.int32	0                       # 0x0
	.int32	0                       # 0x0
	.int32	1                       # 0x1
	.skip	12
	.size	main.fh, 36

	.type	main.gsf,@object        # @main.gsf
	.section	.data.main.gsf,"aw",@progbits
	.p2align	4
main.gsf:
	.int32	196608                  # 0x30000
	.int32	80216                   # 0x13958
	.int32	196608                  # 0x30000
	.int32	98697                   # 0x18189
	.int32	80216                   # 0x13958
	.int32	196608                  # 0x30000
	.int32	98697                   # 0x18189
	.int32	196608                  # 0x30000
	.size	main.gsf, 32


	.ident	"clang version 3.9.0 "
