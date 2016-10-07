	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-14.c"
	.section	.text.vat,"ax",@progbits
	.hidden	vat
	.globl	vat
	.type	vat,@function
vat:                                    # @vat
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push27=, 0
	i32.const	$push24=, 0
	i32.load	$push25=, __stack_pointer($pop24)
	i32.const	$push26=, 16
	i32.sub 	$push37=, $pop25, $pop26
	tee_local	$push36=, $2=, $pop37
	i32.store	__stack_pointer($pop27), $pop36
	i32.store	12($2), $0
	i32.const	$push35=, 0
	i32.store	global($pop35), $1
	i32.store	8($2), $1
	i32.store	12($2), $1
	i32.load	$push34=, 8($2)
	tee_local	$push33=, $0=, $pop34
	i32.const	$push32=, 4
	i32.add 	$push0=, $pop33, $pop32
	i32.store	8($2), $pop0
	block   	
	i32.load	$push1=, 0($0)
	i32.const	$push31=, 1
	i32.ne  	$push2=, $pop1, $pop31
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push43=, 0
	i32.const	$push42=, 0
	i32.load	$push41=, global($pop42)
	tee_local	$push40=, $0=, $pop41
	i32.const	$push39=, 4
	i32.add 	$push3=, $pop40, $pop39
	i32.store	global($pop43), $pop3
	i32.load	$push4=, 0($0)
	i32.const	$push38=, 1
	i32.ne  	$push5=, $pop4, $pop38
	br_if   	0, $pop5        # 0: down to label0
# BB#2:                                 # %if.end7
	i32.load	$push47=, 12($2)
	tee_local	$push46=, $0=, $pop47
	i32.const	$push45=, 4
	i32.add 	$push6=, $pop46, $pop45
	i32.store	12($2), $pop6
	i32.load	$push7=, 0($0)
	i32.const	$push44=, 1
	i32.ne  	$push8=, $pop7, $pop44
	br_if   	0, $pop8        # 0: down to label0
# BB#3:                                 # %if.end12
	i32.const	$push50=, 0
	i32.store	global($pop50), $1
	i32.store	12($2), $1
	i32.store	8($2), $1
	i32.const	$push49=, 4
	i32.add 	$push9=, $1, $pop49
	i32.store	8($2), $pop9
	i32.load	$push10=, 0($1)
	i32.const	$push48=, 1
	i32.ne  	$push11=, $pop10, $pop48
	br_if   	0, $pop11       # 0: down to label0
# BB#4:                                 # %if.end19
	i32.const	$push55=, 0
	i32.load	$push54=, global($pop55)
	tee_local	$push53=, $1=, $pop54
	i32.store	8($2), $pop53
	i32.const	$push52=, 4
	i32.add 	$push12=, $1, $pop52
	i32.store	8($2), $pop12
	i32.load	$push13=, 0($1)
	i32.const	$push51=, 1
	i32.ne  	$push14=, $pop13, $pop51
	br_if   	0, $pop14       # 0: down to label0
# BB#5:                                 # %if.end25
	i32.const	$push15=, 0
	i32.const	$push60=, 0
	i32.load	$push59=, global($pop60)
	tee_local	$push58=, $1=, $pop59
	i32.const	$push57=, 4
	i32.add 	$push16=, $pop58, $pop57
	i32.store	global($pop15), $pop16
	i32.load	$push17=, 0($1)
	i32.const	$push56=, 1
	i32.ne  	$push18=, $pop17, $pop56
	br_if   	0, $pop18       # 0: down to label0
# BB#6:                                 # %if.end31
	i32.load	$push62=, 12($2)
	tee_local	$push61=, $1=, $pop62
	i32.const	$push19=, 4
	i32.add 	$push20=, $pop61, $pop19
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
.LBB0_8:                                # %if.then35
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	vat, .Lfunc_end0-vat

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push5=, 0
	i32.const	$push2=, 0
	i32.load	$push3=, __stack_pointer($pop2)
	i32.const	$push4=, 16
	i32.sub 	$push7=, $pop3, $pop4
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

	.hidden	global                  # @global
	.type	global,@object
	.section	.bss.global,"aw",@nobits
	.globl	global
	.p2align	2
global:
	.int32	0
	.size	global, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
