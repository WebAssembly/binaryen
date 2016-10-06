	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/ffs-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push46=, 0
	i32.load	$push45=, ffstesttab($pop46)
	tee_local	$push44=, $0=, $pop45
	i32.ctz 	$push0=, $pop44
	i32.const	$push43=, 1
	i32.add 	$push1=, $pop0, $pop43
	i32.const	$push42=, 0
	i32.select	$push2=, $pop1, $pop42, $0
	i32.const	$push41=, 0
	i32.load	$push3=, ffstesttab+4($pop41)
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %for.cond
	i32.const	$push52=, 0
	i32.load	$push51=, ffstesttab+8($pop52)
	tee_local	$push50=, $0=, $pop51
	i32.ctz 	$push5=, $pop50
	i32.const	$push49=, 1
	i32.add 	$push6=, $pop5, $pop49
	i32.const	$push48=, 0
	i32.select	$push7=, $pop6, $pop48, $0
	i32.const	$push47=, 0
	i32.load	$push8=, ffstesttab+12($pop47)
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	0, $pop9        # 0: down to label0
# BB#2:                                 # %for.cond.1
	i32.const	$push58=, 0
	i32.load	$push57=, ffstesttab+16($pop58)
	tee_local	$push56=, $0=, $pop57
	i32.ctz 	$push10=, $pop56
	i32.const	$push55=, 1
	i32.add 	$push11=, $pop10, $pop55
	i32.const	$push54=, 0
	i32.select	$push12=, $pop11, $pop54, $0
	i32.const	$push53=, 0
	i32.load	$push13=, ffstesttab+20($pop53)
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	0, $pop14       # 0: down to label0
# BB#3:                                 # %for.cond.2
	i32.const	$push64=, 0
	i32.load	$push63=, ffstesttab+24($pop64)
	tee_local	$push62=, $0=, $pop63
	i32.ctz 	$push15=, $pop62
	i32.const	$push61=, 1
	i32.add 	$push16=, $pop15, $pop61
	i32.const	$push60=, 0
	i32.select	$push17=, $pop16, $pop60, $0
	i32.const	$push59=, 0
	i32.load	$push18=, ffstesttab+28($pop59)
	i32.ne  	$push19=, $pop17, $pop18
	br_if   	0, $pop19       # 0: down to label0
# BB#4:                                 # %for.cond.3
	i32.const	$push70=, 0
	i32.load	$push69=, ffstesttab+32($pop70)
	tee_local	$push68=, $0=, $pop69
	i32.ctz 	$push20=, $pop68
	i32.const	$push67=, 1
	i32.add 	$push21=, $pop20, $pop67
	i32.const	$push66=, 0
	i32.select	$push22=, $pop21, $pop66, $0
	i32.const	$push65=, 0
	i32.load	$push23=, ffstesttab+36($pop65)
	i32.ne  	$push24=, $pop22, $pop23
	br_if   	0, $pop24       # 0: down to label0
# BB#5:                                 # %for.cond.4
	i32.const	$push76=, 0
	i32.load	$push75=, ffstesttab+40($pop76)
	tee_local	$push74=, $0=, $pop75
	i32.ctz 	$push25=, $pop74
	i32.const	$push73=, 1
	i32.add 	$push26=, $pop25, $pop73
	i32.const	$push72=, 0
	i32.select	$push27=, $pop26, $pop72, $0
	i32.const	$push71=, 0
	i32.load	$push28=, ffstesttab+44($pop71)
	i32.ne  	$push29=, $pop27, $pop28
	br_if   	0, $pop29       # 0: down to label0
# BB#6:                                 # %for.cond.5
	i32.const	$push82=, 0
	i32.load	$push81=, ffstesttab+48($pop82)
	tee_local	$push80=, $0=, $pop81
	i32.ctz 	$push30=, $pop80
	i32.const	$push79=, 1
	i32.add 	$push31=, $pop30, $pop79
	i32.const	$push78=, 0
	i32.select	$push32=, $pop31, $pop78, $0
	i32.const	$push77=, 0
	i32.load	$push33=, ffstesttab+52($pop77)
	i32.ne  	$push34=, $pop32, $pop33
	br_if   	0, $pop34       # 0: down to label0
# BB#7:                                 # %for.cond.6
	i32.const	$push88=, 0
	i32.load	$push87=, ffstesttab+56($pop88)
	tee_local	$push86=, $0=, $pop87
	i32.ctz 	$push35=, $pop86
	i32.const	$push85=, 1
	i32.add 	$push36=, $pop35, $pop85
	i32.const	$push84=, 0
	i32.select	$push37=, $pop36, $pop84, $0
	i32.const	$push83=, 0
	i32.load	$push38=, ffstesttab+60($pop83)
	i32.ne  	$push39=, $pop37, $pop38
	br_if   	0, $pop39       # 0: down to label0
# BB#8:                                 # %for.cond.7
	i32.const	$push40=, 0
	call    	exit@FUNCTION, $pop40
	unreachable
.LBB0_9:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	ffstesttab              # @ffstesttab
	.type	ffstesttab,@object
	.section	.data.ffstesttab,"aw",@progbits
	.globl	ffstesttab
	.p2align	4
ffstesttab:
	.int32	2147483648              # 0x80000000
	.int32	32                      # 0x20
	.int32	2779096485              # 0xa5a5a5a5
	.int32	1                       # 0x1
	.int32	1515870810              # 0x5a5a5a5a
	.int32	2                       # 0x2
	.int32	3405643776              # 0xcafe0000
	.int32	18                      # 0x12
	.int32	32768                   # 0x8000
	.int32	16                      # 0x10
	.int32	42405                   # 0xa5a5
	.int32	1                       # 0x1
	.int32	23130                   # 0x5a5a
	.int32	2                       # 0x2
	.int32	3232                    # 0xca0
	.int32	6                       # 0x6
	.size	ffstesttab, 64


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
