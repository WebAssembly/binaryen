	.text
	.file	"va-arg-14.c"
	.section	.text.vat,"ax",@progbits
	.hidden	vat                     # -- Begin function vat
	.globl	vat
	.type	vat,@function
vat:                                    # @vat
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push27=, 0
	i32.const	$push25=, 0
	i32.load	$push24=, __stack_pointer($pop25)
	i32.const	$push26=, 16
	i32.sub 	$push35=, $pop24, $pop26
	tee_local	$push34=, $2=, $pop35
	i32.store	__stack_pointer($pop27), $pop34
	i32.store	12($2), $0
	i32.const	$push33=, 0
	i32.store	global($pop33), $1
	i32.store	12($2), $1
	i32.const	$push32=, 4
	i32.add 	$push0=, $1, $pop32
	i32.store	8($2), $pop0
	block   	
	i32.load	$push1=, 0($1)
	i32.const	$push31=, 1
	i32.ne  	$push2=, $pop1, $pop31
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push41=, 0
	i32.const	$push40=, 0
	i32.load	$push39=, global($pop40)
	tee_local	$push38=, $0=, $pop39
	i32.const	$push37=, 4
	i32.add 	$push3=, $pop38, $pop37
	i32.store	global($pop41), $pop3
	i32.load	$push4=, 0($0)
	i32.const	$push36=, 1
	i32.ne  	$push5=, $pop4, $pop36
	br_if   	0, $pop5        # 0: down to label0
# BB#2:                                 # %if.end7
	i32.load	$push45=, 12($2)
	tee_local	$push44=, $0=, $pop45
	i32.const	$push43=, 4
	i32.add 	$push6=, $pop44, $pop43
	i32.store	12($2), $pop6
	i32.load	$push7=, 0($0)
	i32.const	$push42=, 1
	i32.ne  	$push8=, $pop7, $pop42
	br_if   	0, $pop8        # 0: down to label0
# BB#3:                                 # %if.end12
	i32.const	$push48=, 0
	i32.store	global($pop48), $1
	i32.store	12($2), $1
	i32.const	$push47=, 4
	i32.add 	$push9=, $1, $pop47
	i32.store	8($2), $pop9
	i32.load	$push10=, 0($1)
	i32.const	$push46=, 1
	i32.ne  	$push11=, $pop10, $pop46
	br_if   	0, $pop11       # 0: down to label0
# BB#4:                                 # %if.end19
	i32.const	$push53=, 0
	i32.load	$push52=, global($pop53)
	tee_local	$push51=, $1=, $pop52
	i32.const	$push50=, 4
	i32.add 	$push12=, $pop51, $pop50
	i32.store	8($2), $pop12
	i32.load	$push13=, 0($1)
	i32.const	$push49=, 1
	i32.ne  	$push14=, $pop13, $pop49
	br_if   	0, $pop14       # 0: down to label0
# BB#5:                                 # %if.end25
	i32.const	$push15=, 0
	i32.const	$push58=, 0
	i32.load	$push57=, global($pop58)
	tee_local	$push56=, $1=, $pop57
	i32.const	$push55=, 4
	i32.add 	$push16=, $pop56, $pop55
	i32.store	global($pop15), $pop16
	i32.load	$push17=, 0($1)
	i32.const	$push54=, 1
	i32.ne  	$push18=, $pop17, $pop54
	br_if   	0, $pop18       # 0: down to label0
# BB#6:                                 # %if.end31
	i32.load	$push60=, 12($2)
	tee_local	$push59=, $1=, $pop60
	i32.const	$push19=, 4
	i32.add 	$push20=, $pop59, $pop19
	i32.store	12($2), $pop20
	i32.load	$push21=, 0($1)
	i32.const	$push22=, 1
	i32.ne  	$push23=, $pop21, $pop22
	br_if   	0, $pop23       # 0: down to label0
# BB#7:                                 # %if.end36
	i32.const	$push30=, 0
	i32.const	$push28=, 16
	i32.add 	$push29=, $2, $pop28
	i32.store	__stack_pointer($pop30), $pop29
	return
.LBB0_8:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	vat, .Lfunc_end0-vat
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push5=, 0
	i32.const	$push3=, 0
	i32.load	$push2=, __stack_pointer($pop3)
	i32.const	$push4=, 16
	i32.sub 	$push7=, $pop2, $pop4
	tee_local	$push6=, $0=, $pop7
	i32.store	__stack_pointer($pop5), $pop6
	i32.const	$push0=, 1
	i32.store	0($0), $pop0
	call    	vat@FUNCTION, $0, $0
	i32.const	$push1=, 0
	call    	exit@FUNCTION, $pop1
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	global                  # @global
	.type	global,@object
	.section	.bss.global,"aw",@nobits
	.globl	global
	.p2align	2
global:
	.int32	0
	.size	global, 4


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
