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
	i32.const	$push48=, 0
	i32.load	$push2=, 0($2)
	i32.load	$push3=, 0($1)
	i32.sub 	$push47=, $pop2, $pop3
	tee_local	$push46=, $4=, $pop47
	i32.sub 	$push6=, $pop48, $pop46
	i32.load	$push45=, 4($0)
	tee_local	$push44=, $7=, $pop45
	i32.select	$push43=, $pop6, $4, $pop44
	tee_local	$push42=, $3=, $pop43
	i32.const	$push41=, 0
	i32.load	$push4=, 4($2)
	i32.load	$push5=, 4($1)
	i32.sub 	$push40=, $pop4, $pop5
	tee_local	$push39=, $1=, $pop40
	i32.sub 	$push7=, $pop41, $pop39
	i32.load	$push38=, 8($0)
	tee_local	$push37=, $6=, $pop38
	i32.select	$push36=, $pop7, $1, $pop37
	tee_local	$push35=, $1=, $pop36
	i32.load	$push34=, 0($0)
	tee_local	$push33=, $2=, $pop34
	i32.select	$0=, $pop42, $pop35, $pop33
	i32.const	$push8=, 31
	i32.shr_s	$push32=, $0, $pop8
	tee_local	$push31=, $4=, $pop32
	i32.add 	$push9=, $0, $pop31
	i32.xor 	$4=, $pop9, $4
	i32.select	$1=, $1, $3, $2
	i32.const	$push30=, 31
	i32.shr_s	$push29=, $1, $pop30
	tee_local	$push28=, $3=, $pop29
	i32.add 	$push10=, $1, $pop28
	i32.xor 	$3=, $pop10, $3
	block
	block
	i32.const	$push56=, 0
	i32.eq  	$push57=, $0, $pop56
	br_if   	0, $pop57       # 0: down to label1
# BB#1:                                 # %entry
	i32.const	$push49=, 4
	i32.shr_s	$push1=, $4, $pop49
	i32.gt_s	$push11=, $3, $pop1
	br_if   	0, $pop11       # 0: down to label1
# BB#2:                                 # %if.then21
	i32.const	$push16=, 2
	i32.const	$push15=, 1
	i32.const	$push13=, 0
	i32.gt_s	$push14=, $0, $pop13
	i32.select	$push51=, $pop16, $pop15, $pop14
	tee_local	$push50=, $0=, $pop51
	i32.const	$push17=, 3
	i32.xor 	$push18=, $pop50, $pop17
	i32.select	$push12=, $6, $7, $2
	i32.select	$5=, $pop18, $0, $pop12
	br      	1               # 1: down to label0
.LBB0_3:                                # %if.else
	end_block                       # label1:
	i32.const	$push58=, 0
	i32.eq  	$push59=, $1, $pop58
	br_if   	0, $pop59       # 0: down to label0
# BB#4:                                 # %if.else
	i32.const	$push52=, 4
	i32.shr_s	$push19=, $3, $pop52
	i32.gt_s	$push20=, $4, $pop19
	br_if   	0, $pop20       # 0: down to label0
# BB#5:                                 # %if.then31
	i32.const	$push21=, 29
	i32.shr_u	$push22=, $1, $pop21
	i32.const	$push23=, 4
	i32.and 	$push24=, $pop22, $pop23
	i32.const	$push55=, 4
	i32.add 	$push54=, $pop24, $pop55
	tee_local	$push53=, $0=, $pop54
	i32.const	$push25=, 12
	i32.xor 	$push26=, $pop53, $pop25
	i32.select	$push0=, $7, $6, $2
	i32.select	$push27=, $pop26, $0, $pop0
	return  	$pop27
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
	br_if   	0, $pop5        # 0: down to label2
# BB#1:                                 # %lor.lhs.false
	i32.const	$push6=, main.fh+12
	i32.const	$push16=, main.gsf+16
	i32.const	$push15=, main.gsf+24
	i32.call	$push7=, line_hints@FUNCTION, $pop6, $pop16, $pop15
	i32.const	$push8=, 8
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	0, $pop9        # 0: down to label2
# BB#2:                                 # %lor.lhs.false3
	i32.const	$push10=, main.fh+24
	i32.const	$push18=, main.gsf+16
	i32.const	$push17=, main.gsf+24
	i32.call	$push11=, line_hints@FUNCTION, $pop10, $pop18, $pop17
	i32.const	$push12=, 4
	i32.ne  	$push13=, $pop11, $pop12
	br_if   	0, $pop13       # 0: down to label2
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
