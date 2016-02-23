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
	i32.const	$push58=, __stack_pointer
	i32.load	$push59=, 0($pop58)
	i32.const	$push60=, 16
	i32.sub 	$3=, $pop59, $pop60
	i32.const	$push61=, __stack_pointer
	i32.store	$discard=, 0($pop61), $3
	i32.store	$2=, 8($3), $1
	i32.load	$1=, 8($3)
	i32.store	$discard=, 12($3), $0
	i32.const	$push30=, 4
	i32.add 	$push1=, $1, $pop30
	i32.store	$discard=, 8($3), $pop1
	i32.const	$push29=, 0
	i32.store	$push0=, global($pop29), $2
	i32.store	$0=, 12($3), $pop0
	block
	i32.load	$push2=, 0($1)
	i32.const	$push28=, 1
	i32.ne  	$push3=, $pop2, $pop28
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push36=, 0
	i32.const	$push35=, 0
	i32.load	$push34=, global($pop35)
	tee_local	$push33=, $1=, $pop34
	i32.const	$push32=, 4
	i32.add 	$push4=, $pop33, $pop32
	i32.store	$discard=, global($pop36), $pop4
	i32.load	$push5=, 0($1)
	i32.const	$push31=, 1
	i32.ne  	$push6=, $pop5, $pop31
	br_if   	0, $pop6        # 0: down to label0
# BB#2:                                 # %if.end7
	i32.load	$push40=, 12($3)
	tee_local	$push39=, $1=, $pop40
	i32.const	$push38=, 4
	i32.add 	$push7=, $pop39, $pop38
	i32.store	$discard=, 12($3), $pop7
	i32.load	$push8=, 0($1)
	i32.const	$push37=, 1
	i32.ne  	$push9=, $pop8, $pop37
	br_if   	0, $pop9        # 0: down to label0
# BB#3:                                 # %if.end12
	i32.const	$push45=, 0
	i32.store	$push10=, 12($3), $0
	i32.store	$push11=, global($pop45), $pop10
	i32.store	$push44=, 8($3), $pop11
	tee_local	$push43=, $1=, $pop44
	i32.const	$push42=, 4
	i32.add 	$push12=, $pop43, $pop42
	i32.store	$discard=, 8($3), $pop12
	i32.load	$push13=, 0($1)
	i32.const	$push41=, 1
	i32.ne  	$push14=, $pop13, $pop41
	br_if   	0, $pop14       # 0: down to label0
# BB#4:                                 # %if.end19
	i32.const	$push50=, 0
	i32.load	$push15=, global($pop50)
	i32.store	$push49=, 8($3), $pop15
	tee_local	$push48=, $1=, $pop49
	i32.const	$push47=, 4
	i32.add 	$push16=, $pop48, $pop47
	i32.store	$discard=, 8($3), $pop16
	i32.load	$push17=, 0($1)
	i32.const	$push46=, 1
	i32.ne  	$push18=, $pop17, $pop46
	br_if   	0, $pop18       # 0: down to label0
# BB#5:                                 # %if.end25
	i32.const	$push19=, 0
	i32.const	$push55=, 0
	i32.load	$push54=, global($pop55)
	tee_local	$push53=, $1=, $pop54
	i32.const	$push52=, 4
	i32.add 	$push20=, $pop53, $pop52
	i32.store	$discard=, global($pop19), $pop20
	i32.load	$push21=, 0($1)
	i32.const	$push51=, 1
	i32.ne  	$push22=, $pop21, $pop51
	br_if   	0, $pop22       # 0: down to label0
# BB#6:                                 # %if.end31
	i32.load	$push57=, 12($3)
	tee_local	$push56=, $1=, $pop57
	i32.const	$push23=, 4
	i32.add 	$push24=, $pop56, $pop23
	i32.store	$discard=, 12($3), $pop24
	i32.load	$push25=, 0($1)
	i32.const	$push26=, 1
	i32.ne  	$push27=, $pop25, $pop26
	br_if   	0, $pop27       # 0: down to label0
# BB#7:                                 # %if.end36
	i32.const	$push62=, 16
	i32.add 	$3=, $3, $pop62
	i32.const	$push63=, __stack_pointer
	i32.store	$discard=, 0($pop63), $3
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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push2=, __stack_pointer
	i32.load	$push3=, 0($pop2)
	i32.const	$push4=, 16
	i32.sub 	$1=, $pop3, $pop4
	i32.const	$push5=, __stack_pointer
	i32.store	$discard=, 0($pop5), $1
	i32.const	$push0=, 1
	i32.store	$discard=, 0($1):p2align=4, $pop0
	call    	vat@FUNCTION, $0, $1
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
