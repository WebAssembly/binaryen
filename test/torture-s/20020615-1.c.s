	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020615-1.c"
	.section	.text.line_hints,"ax",@progbits
	.hidden	line_hints
	.globl	line_hints
	.type	line_hints,@function
line_hints:                             # @line_hints
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push53=, 0
	i32.load	$push6=, 4($2)
	i32.load	$push5=, 4($1)
	i32.sub 	$push52=, $pop6, $pop5
	tee_local	$push51=, $5=, $pop52
	i32.sub 	$push7=, $pop53, $pop51
	i32.load	$push50=, 8($0)
	tee_local	$push49=, $4=, $pop50
	i32.select	$push48=, $pop7, $5, $pop49
	tee_local	$push47=, $6=, $pop48
	i32.const	$push46=, 0
	i32.load	$push3=, 0($2)
	i32.load	$push2=, 0($1)
	i32.sub 	$push45=, $pop3, $pop2
	tee_local	$push44=, $2=, $pop45
	i32.sub 	$push4=, $pop46, $pop44
	i32.load	$push43=, 4($0)
	tee_local	$push42=, $3=, $pop43
	i32.select	$push41=, $pop4, $2, $pop42
	tee_local	$push40=, $7=, $pop41
	i32.load	$push39=, 0($0)
	tee_local	$push38=, $1=, $pop39
	i32.select	$push37=, $pop47, $pop40, $pop38
	tee_local	$push36=, $2=, $pop37
	i32.const	$push8=, 31
	i32.shr_s	$push35=, $2, $pop8
	tee_local	$push34=, $0=, $pop35
	i32.add 	$push9=, $pop36, $pop34
	i32.xor 	$5=, $pop9, $0
	i32.select	$push33=, $7, $6, $1
	tee_local	$push32=, $0=, $pop33
	i32.const	$push31=, 31
	i32.shr_s	$push30=, $0, $pop31
	tee_local	$push29=, $6=, $pop30
	i32.add 	$push10=, $pop32, $pop29
	i32.xor 	$6=, $pop10, $6
	block   	
	i32.eqz 	$push62=, $0
	br_if   	0, $pop62       # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$push54=, 4
	i32.shr_s	$push1=, $6, $pop54
	i32.gt_s	$push11=, $5, $pop1
	br_if   	0, $pop11       # 0: down to label0
# BB#2:                                 # %if.then21
	i32.const	$push16=, 2
	i32.const	$push15=, 1
	i32.const	$push13=, 0
	i32.gt_s	$push14=, $0, $pop13
	i32.select	$push56=, $pop16, $pop15, $pop14
	tee_local	$push55=, $0=, $pop56
	i32.const	$push17=, 3
	i32.xor 	$push18=, $pop55, $pop17
	i32.select	$push12=, $4, $3, $1
	i32.select	$push28=, $pop18, $0, $pop12
	return  	$pop28
.LBB0_3:                                # %if.else
	end_block                       # label0:
	block   	
	i32.eqz 	$push63=, $2
	br_if   	0, $pop63       # 0: down to label1
# BB#4:                                 # %if.else
	i32.const	$push57=, 4
	i32.shr_s	$push19=, $5, $pop57
	i32.gt_s	$push20=, $6, $pop19
	br_if   	0, $pop20       # 0: down to label1
# BB#5:                                 # %if.then31
	i32.const	$push21=, 29
	i32.shr_u	$push22=, $2, $pop21
	i32.const	$push23=, 4
	i32.and 	$push24=, $pop22, $pop23
	i32.const	$push60=, 4
	i32.add 	$push59=, $pop24, $pop60
	tee_local	$push58=, $0=, $pop59
	i32.const	$push25=, 12
	i32.xor 	$push26=, $pop58, $pop25
	i32.select	$push0=, $3, $4, $1
	i32.select	$push27=, $pop26, $0, $pop0
	return  	$pop27
.LBB0_6:                                # %if.end40
	end_block                       # label1:
	i32.const	$push61=, 0
                                        # fallthrough-return: $pop61
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
	i32.const	$push2=, main.fh
	i32.const	$push1=, main.gsf
	i32.const	$push0=, main.gsf+8
	i32.call	$push3=, line_hints@FUNCTION, $pop2, $pop1, $pop0
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


	.ident	"clang version 4.0.0 "
	.functype	abort, void
	.functype	exit, void, i32
