	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020201-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, 0
	i32.load8_u	$push43=, cx($pop0)
	tee_local	$push42=, $0=, $pop43
	i32.const	$push1=, -6
	i32.add 	$push2=, $pop42, $pop1
	i32.const	$push41=, 255
	i32.and 	$push3=, $pop2, $pop41
	i32.const	$push40=, 6
	i32.ge_u	$push4=, $pop3, $pop40
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push45=, 255
	i32.and 	$push5=, $0, $pop45
	i32.const	$push44=, 6
	i32.rem_u	$push6=, $pop5, $pop44
	i32.const	$push7=, 1
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label0
# BB#2:                                 # %if.end10
	i32.const	$push9=, 0
	i32.load16_u	$push49=, sx($pop9)
	tee_local	$push48=, $0=, $pop49
	i32.const	$push10=, -12
	i32.add 	$push11=, $pop48, $pop10
	i32.const	$push47=, 65535
	i32.and 	$push12=, $pop11, $pop47
	i32.const	$push46=, 6
	i32.ge_u	$push13=, $pop12, $pop46
	br_if   	0, $pop13       # 0: down to label0
# BB#3:                                 # %if.end18
	i32.const	$push51=, 65535
	i32.and 	$push14=, $0, $pop51
	i32.const	$push50=, 6
	i32.rem_u	$push15=, $pop14, $pop50
	i32.const	$push16=, 2
	i32.ne  	$push17=, $pop15, $pop16
	br_if   	0, $pop17       # 0: down to label0
# BB#4:                                 # %if.end26
	i32.const	$push18=, 0
	i32.load	$push54=, ix($pop18)
	tee_local	$push53=, $0=, $pop54
	i32.const	$push19=, -18
	i32.add 	$push20=, $pop53, $pop19
	i32.const	$push52=, 6
	i32.ge_u	$push21=, $pop20, $pop52
	br_if   	0, $pop21       # 0: down to label0
# BB#5:                                 # %if.end31
	i32.const	$push55=, 6
	i32.rem_u	$push22=, $0, $pop55
	i32.const	$push23=, 3
	i32.ne  	$push24=, $pop22, $pop23
	br_if   	0, $pop24       # 0: down to label0
# BB#6:                                 # %if.end36
	i32.const	$push25=, 0
	i32.load	$push58=, lx($pop25)
	tee_local	$push57=, $0=, $pop58
	i32.const	$push26=, -24
	i32.add 	$push27=, $pop57, $pop26
	i32.const	$push56=, 6
	i32.ge_u	$push28=, $pop27, $pop56
	br_if   	0, $pop28       # 0: down to label0
# BB#7:                                 # %if.end41
	i32.const	$push59=, 6
	i32.rem_u	$push29=, $0, $pop59
	i32.const	$push30=, 4
	i32.ne  	$push31=, $pop29, $pop30
	br_if   	0, $pop31       # 0: down to label0
# BB#8:                                 # %if.end46
	i32.const	$push32=, 0
	i64.load	$push62=, Lx($pop32)
	tee_local	$push61=, $1=, $pop62
	i64.const	$push33=, -30
	i64.add 	$push34=, $pop61, $pop33
	i64.const	$push60=, 6
	i64.ge_u	$push35=, $pop34, $pop60
	br_if   	0, $pop35       # 0: down to label0
# BB#9:                                 # %if.end51
	i64.const	$push63=, 6
	i64.rem_u	$push36=, $1, $pop63
	i64.const	$push37=, 5
	i64.ne  	$push38=, $pop36, $pop37
	br_if   	0, $pop38       # 0: down to label0
# BB#10:                                # %if.end56
	i32.const	$push39=, 0
	call    	exit@FUNCTION, $pop39
	unreachable
.LBB0_11:                               # %if.then55
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	cx                      # @cx
	.type	cx,@object
	.section	.data.cx,"aw",@progbits
	.globl	cx
cx:
	.int8	7                       # 0x7
	.size	cx, 1

	.hidden	sx                      # @sx
	.type	sx,@object
	.section	.data.sx,"aw",@progbits
	.globl	sx
	.p2align	1
sx:
	.int16	14                      # 0xe
	.size	sx, 2

	.hidden	ix                      # @ix
	.type	ix,@object
	.section	.data.ix,"aw",@progbits
	.globl	ix
	.p2align	2
ix:
	.int32	21                      # 0x15
	.size	ix, 4

	.hidden	lx                      # @lx
	.type	lx,@object
	.section	.data.lx,"aw",@progbits
	.globl	lx
	.p2align	2
lx:
	.int32	28                      # 0x1c
	.size	lx, 4

	.hidden	Lx                      # @Lx
	.type	Lx,@object
	.section	.data.Lx,"aw",@progbits
	.globl	Lx
	.p2align	3
Lx:
	.int64	35                      # 0x23
	.size	Lx, 8


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
