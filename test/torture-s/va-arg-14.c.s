	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-14.c"
	.section	.text.vat,"ax",@progbits
	.hidden	vat
	.globl	vat
	.type	vat,@function
vat:                                    # @vat
	.param  	i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push31=, __stack_pointer
	i32.const	$push28=, __stack_pointer
	i32.load	$push29=, 0($pop28)
	i32.const	$push30=, 16
	i32.sub 	$push35=, $pop29, $pop30
	i32.store	$push40=, 0($pop31), $pop35
	tee_local	$push39=, $3=, $pop40
	i32.store	$2=, 8($pop39), $1
	i32.load	$1=, 8($3)
	i32.store	$discard=, 12($3), $0
	i32.const	$push38=, 4
	i32.add 	$push3=, $1, $pop38
	i32.store	$discard=, 8($3), $pop3
	i32.const	$push37=, 0
	i32.store	$push0=, global($pop37), $2
	i32.store	$0=, 12($3), $pop0
	block
	i32.load	$push4=, 0($1)
	i32.const	$push36=, 1
	i32.ne  	$push5=, $pop4, $pop36
	br_if   	0, $pop5        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push46=, 0
	i32.const	$push45=, 0
	i32.load	$push44=, global($pop45)
	tee_local	$push43=, $1=, $pop44
	i32.const	$push42=, 4
	i32.add 	$push6=, $pop43, $pop42
	i32.store	$discard=, global($pop46), $pop6
	i32.load	$push7=, 0($1)
	i32.const	$push41=, 1
	i32.ne  	$push8=, $pop7, $pop41
	br_if   	0, $pop8        # 0: down to label0
# BB#2:                                 # %if.end7
	i32.load	$push50=, 12($3)
	tee_local	$push49=, $1=, $pop50
	i32.const	$push48=, 4
	i32.add 	$push9=, $pop49, $pop48
	i32.store	$discard=, 12($3), $pop9
	i32.load	$push10=, 0($1)
	i32.const	$push47=, 1
	i32.ne  	$push11=, $pop10, $pop47
	br_if   	0, $pop11       # 0: down to label0
# BB#3:                                 # %if.end12
	i32.store	$push55=, 8($3), $0
	tee_local	$push54=, $1=, $pop55
	i32.const	$push53=, 4
	i32.add 	$push12=, $pop54, $pop53
	i32.store	$discard=, 8($3), $pop12
	i32.const	$push52=, 0
	i32.store	$push1=, 12($3), $1
	i32.store	$push2=, global($pop52), $pop1
	i32.load	$push13=, 0($pop2)
	i32.const	$push51=, 1
	i32.ne  	$push14=, $pop13, $pop51
	br_if   	0, $pop14       # 0: down to label0
# BB#4:                                 # %if.end19
	i32.const	$push60=, 0
	i32.load	$push15=, global($pop60)
	i32.store	$push59=, 8($3), $pop15
	tee_local	$push58=, $1=, $pop59
	i32.const	$push57=, 4
	i32.add 	$push16=, $pop58, $pop57
	i32.store	$discard=, 8($3), $pop16
	i32.load	$push17=, 0($1)
	i32.const	$push56=, 1
	i32.ne  	$push18=, $pop17, $pop56
	br_if   	0, $pop18       # 0: down to label0
# BB#5:                                 # %if.end25
	i32.const	$push19=, 0
	i32.const	$push65=, 0
	i32.load	$push64=, global($pop65)
	tee_local	$push63=, $1=, $pop64
	i32.const	$push62=, 4
	i32.add 	$push20=, $pop63, $pop62
	i32.store	$discard=, global($pop19), $pop20
	i32.load	$push21=, 0($1)
	i32.const	$push61=, 1
	i32.ne  	$push22=, $pop21, $pop61
	br_if   	0, $pop22       # 0: down to label0
# BB#6:                                 # %if.end31
	i32.load	$push67=, 12($3)
	tee_local	$push66=, $1=, $pop67
	i32.const	$push23=, 4
	i32.add 	$push24=, $pop66, $pop23
	i32.store	$discard=, 12($3), $pop24
	i32.load	$push25=, 0($1)
	i32.const	$push26=, 1
	i32.ne  	$push27=, $pop25, $pop26
	br_if   	0, $pop27       # 0: down to label0
# BB#7:                                 # %if.end36
	i32.const	$push34=, __stack_pointer
	i32.const	$push32=, 16
	i32.add 	$push33=, $3, $pop32
	i32.store	$discard=, 0($pop34), $pop33
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
	i32.const	$push5=, __stack_pointer
	i32.const	$push2=, __stack_pointer
	i32.load	$push3=, 0($pop2)
	i32.const	$push4=, 16
	i32.sub 	$push6=, $pop3, $pop4
	i32.store	$push8=, 0($pop5), $pop6
	tee_local	$push7=, $0=, $pop8
	i32.const	$push0=, 1
	i32.store	$discard=, 0($pop7), $pop0
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
