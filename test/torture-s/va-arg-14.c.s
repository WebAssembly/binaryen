	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-14.c"
	.section	.text.vat,"ax",@progbits
	.hidden	vat
	.globl	vat
	.type	vat,@function
vat:                                    # @vat
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push32=, 0
	i32.const	$push29=, 0
	i32.load	$push30=, __stack_pointer($pop29)
	i32.const	$push31=, 16
	i32.sub 	$push36=, $pop30, $pop31
	i32.store	$push43=, __stack_pointer($pop32), $pop36
	tee_local	$push42=, $2=, $pop43
	i32.store	$drop=, 12($pop42), $0
	i32.const	$push41=, 0
	i32.store	$push0=, global($pop41), $1
	i32.store	$push1=, 8($2), $pop0
	i32.store	$1=, 12($2), $pop1
	i32.load	$push40=, 8($2)
	tee_local	$push39=, $0=, $pop40
	i32.const	$push38=, 4
	i32.add 	$push4=, $pop39, $pop38
	i32.store	$drop=, 8($2), $pop4
	block
	i32.load	$push5=, 0($0)
	i32.const	$push37=, 1
	i32.ne  	$push6=, $pop5, $pop37
	br_if   	0, $pop6        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push49=, 0
	i32.const	$push48=, 0
	i32.load	$push47=, global($pop48)
	tee_local	$push46=, $0=, $pop47
	i32.const	$push45=, 4
	i32.add 	$push7=, $pop46, $pop45
	i32.store	$drop=, global($pop49), $pop7
	i32.load	$push8=, 0($0)
	i32.const	$push44=, 1
	i32.ne  	$push9=, $pop8, $pop44
	br_if   	0, $pop9        # 0: down to label0
# BB#2:                                 # %if.end7
	i32.load	$push53=, 12($2)
	tee_local	$push52=, $0=, $pop53
	i32.const	$push51=, 4
	i32.add 	$push10=, $pop52, $pop51
	i32.store	$drop=, 12($2), $pop10
	i32.load	$push11=, 0($0)
	i32.const	$push50=, 1
	i32.ne  	$push12=, $pop11, $pop50
	br_if   	0, $pop12       # 0: down to label0
# BB#3:                                 # %if.end12
	i32.const	$push58=, 0
	i32.store	$push2=, global($pop58), $1
	i32.store	$push3=, 12($2), $pop2
	i32.store	$push57=, 8($2), $pop3
	tee_local	$push56=, $0=, $pop57
	i32.const	$push55=, 4
	i32.add 	$push13=, $pop56, $pop55
	i32.store	$drop=, 8($2), $pop13
	i32.load	$push14=, 0($0)
	i32.const	$push54=, 1
	i32.ne  	$push15=, $pop14, $pop54
	br_if   	0, $pop15       # 0: down to label0
# BB#4:                                 # %if.end19
	i32.const	$push63=, 0
	i32.load	$push16=, global($pop63)
	i32.store	$push62=, 8($2), $pop16
	tee_local	$push61=, $0=, $pop62
	i32.const	$push60=, 4
	i32.add 	$push17=, $pop61, $pop60
	i32.store	$drop=, 8($2), $pop17
	i32.load	$push18=, 0($0)
	i32.const	$push59=, 1
	i32.ne  	$push19=, $pop18, $pop59
	br_if   	0, $pop19       # 0: down to label0
# BB#5:                                 # %if.end25
	i32.const	$push20=, 0
	i32.const	$push68=, 0
	i32.load	$push67=, global($pop68)
	tee_local	$push66=, $0=, $pop67
	i32.const	$push65=, 4
	i32.add 	$push21=, $pop66, $pop65
	i32.store	$drop=, global($pop20), $pop21
	i32.load	$push22=, 0($0)
	i32.const	$push64=, 1
	i32.ne  	$push23=, $pop22, $pop64
	br_if   	0, $pop23       # 0: down to label0
# BB#6:                                 # %if.end31
	i32.load	$push70=, 12($2)
	tee_local	$push69=, $0=, $pop70
	i32.const	$push24=, 4
	i32.add 	$push25=, $pop69, $pop24
	i32.store	$drop=, 12($2), $pop25
	i32.load	$push26=, 0($0)
	i32.const	$push27=, 1
	i32.ne  	$push28=, $pop26, $pop27
	br_if   	0, $pop28       # 0: down to label0
# BB#7:                                 # %if.end36
	i32.const	$push35=, 0
	i32.const	$push33=, 16
	i32.add 	$push34=, $2, $pop33
	i32.store	$drop=, __stack_pointer($pop35), $pop34
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
	i32.sub 	$push6=, $pop3, $pop4
	i32.store	$push8=, __stack_pointer($pop5), $pop6
	tee_local	$push7=, $0=, $pop8
	i32.const	$push0=, 1
	i32.store	$drop=, 0($pop7), $pop0
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


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
