	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-14.c"
	.section	.text.vat,"ax",@progbits
	.hidden	vat
	.globl	vat
	.type	vat,@function
vat:                                    # @vat
	.param  	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 16
	i32.sub 	$4=, $1, $2
	copy_local	$5=, $4
	i32.const	$2=, __stack_pointer
	i32.store	$4=, 0($2), $4
	i32.store	$discard=, 12($4), $0
	i32.load	$0=, 8($4)
	i32.const	$push56=, 0
	i32.store	$push0=, 8($4), $5
	i32.store	$push1=, global($pop56), $pop0
	i32.store	$discard=, 12($4), $pop1
	i32.const	$push55=, 3
	i32.add 	$push2=, $0, $pop55
	i32.const	$push54=, -4
	i32.and 	$push3=, $pop2, $pop54
	tee_local	$push53=, $0=, $pop3
	i32.const	$push52=, 4
	i32.add 	$push4=, $pop53, $pop52
	i32.store	$discard=, 8($4), $pop4
	block
	i32.load	$push5=, 0($0)
	i32.const	$push51=, 1
	i32.ne  	$push6=, $pop5, $pop51
	br_if   	$pop6, 0        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push63=, 0
	i32.const	$push62=, 0
	i32.load	$push7=, global($pop62)
	i32.const	$push61=, 3
	i32.add 	$push8=, $pop7, $pop61
	i32.const	$push60=, -4
	i32.and 	$push9=, $pop8, $pop60
	tee_local	$push59=, $0=, $pop9
	i32.const	$push58=, 4
	i32.add 	$push10=, $pop59, $pop58
	i32.store	$discard=, global($pop63), $pop10
	block
	i32.load	$push11=, 0($0)
	i32.const	$push57=, 1
	i32.ne  	$push12=, $pop11, $pop57
	br_if   	$pop12, 0       # 0: down to label1
# BB#2:                                 # %if.end5
	i32.load	$push13=, 12($4)
	i32.const	$push68=, 3
	i32.add 	$push14=, $pop13, $pop68
	i32.const	$push67=, -4
	i32.and 	$push15=, $pop14, $pop67
	tee_local	$push66=, $0=, $pop15
	i32.const	$push65=, 4
	i32.add 	$push16=, $pop66, $pop65
	i32.store	$discard=, 12($4), $pop16
	block
	i32.load	$push17=, 0($0)
	i32.const	$push64=, 1
	i32.ne  	$push18=, $pop17, $pop64
	br_if   	$pop18, 0       # 0: down to label2
# BB#3:                                 # %if.end8
	i32.const	$push74=, 0
	i32.store	$push19=, 12($4), $5
	i32.store	$push20=, global($pop74), $pop19
	i32.store	$push21=, 8($4), $pop20
	i32.const	$push73=, 3
	i32.add 	$push22=, $pop21, $pop73
	i32.const	$push72=, -4
	i32.and 	$push23=, $pop22, $pop72
	tee_local	$push71=, $0=, $pop23
	i32.const	$push70=, 4
	i32.add 	$push24=, $pop71, $pop70
	i32.store	$discard=, 8($4), $pop24
	block
	i32.load	$push25=, 0($0)
	i32.const	$push69=, 1
	i32.ne  	$push26=, $pop25, $pop69
	br_if   	$pop26, 0       # 0: down to label3
# BB#4:                                 # %if.end13
	i32.const	$push80=, 0
	i32.load	$push27=, global($pop80)
	i32.store	$push28=, 8($4), $pop27
	i32.const	$push79=, 3
	i32.add 	$push29=, $pop28, $pop79
	i32.const	$push78=, -4
	i32.and 	$push30=, $pop29, $pop78
	tee_local	$push77=, $0=, $pop30
	i32.const	$push76=, 4
	i32.add 	$push31=, $pop77, $pop76
	i32.store	$discard=, 8($4), $pop31
	block
	i32.load	$push32=, 0($0)
	i32.const	$push75=, 1
	i32.ne  	$push33=, $pop32, $pop75
	br_if   	$pop33, 0       # 0: down to label4
# BB#5:                                 # %if.end17
	i32.const	$push34=, 0
	i32.const	$push86=, 0
	i32.load	$push35=, global($pop86)
	i32.const	$push85=, 3
	i32.add 	$push36=, $pop35, $pop85
	i32.const	$push84=, -4
	i32.and 	$push37=, $pop36, $pop84
	tee_local	$push83=, $0=, $pop37
	i32.const	$push82=, 4
	i32.add 	$push38=, $pop83, $pop82
	i32.store	$discard=, global($pop34), $pop38
	block
	i32.load	$push39=, 0($0)
	i32.const	$push81=, 1
	i32.ne  	$push40=, $pop39, $pop81
	br_if   	$pop40, 0       # 0: down to label5
# BB#6:                                 # %if.end21
	i32.load	$push41=, 12($4)
	i32.const	$push42=, 3
	i32.add 	$push43=, $pop41, $pop42
	i32.const	$push44=, -4
	i32.and 	$push45=, $pop43, $pop44
	tee_local	$push87=, $0=, $pop45
	i32.const	$push46=, 4
	i32.add 	$push47=, $pop87, $pop46
	i32.store	$discard=, 12($4), $pop47
	block
	i32.load	$push48=, 0($0)
	i32.const	$push49=, 1
	i32.ne  	$push50=, $pop48, $pop49
	br_if   	$pop50, 0       # 0: down to label6
# BB#7:                                 # %if.end24
	i32.const	$3=, 16
	i32.add 	$4=, $5, $3
	i32.const	$3=, __stack_pointer
	i32.store	$4=, 0($3), $4
	return
.LBB0_8:                                # %if.then23
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB0_9:                                # %if.then20
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB0_10:                               # %if.then16
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB0_11:                               # %if.then12
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_12:                               # %if.then7
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_13:                               # %if.then4
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_14:                               # %if.then
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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 16
	i32.sub 	$7=, $5, $6
	i32.const	$6=, __stack_pointer
	i32.store	$7=, 0($6), $7
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 4
	i32.sub 	$7=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$7=, 0($2), $7
	i32.const	$push0=, 1
	i32.store	$discard=, 0($7), $pop0
	call    	vat@FUNCTION, $0
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 4
	i32.add 	$7=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$7=, 0($4), $7
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
