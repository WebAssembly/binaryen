	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-14.c"
	.section	.text.vat,"ax",@progbits
	.hidden	vat
	.globl	vat
	.type	vat,@function
vat:                                    # @vat
	.param  	i32, i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 16
	i32.sub 	$6=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$6=, 0($4), $6
	i32.store	$discard=, 8($6), $1
	i32.load	$2=, 8($6)
	i32.store	$discard=, 12($6), $0
	i32.const	$push49=, 3
	i32.add 	$push1=, $2, $pop49
	i32.const	$push48=, -4
	i32.and 	$push47=, $pop1, $pop48
	tee_local	$push46=, $0=, $pop47
	i32.const	$push45=, 4
	i32.add 	$push2=, $pop46, $pop45
	i32.store	$discard=, 8($6), $pop2
	i32.const	$push44=, 0
	i32.store	$push0=, global($pop44), $1
	i32.store	$2=, 12($6), $pop0
	block
	block
	block
	block
	block
	block
	block
	i32.load	$push3=, 0($0)
	i32.const	$push43=, 1
	i32.ne  	$push4=, $pop3, $pop43
	br_if   	0, $pop4        # 0: down to label6
# BB#1:                                 # %if.end
	i32.const	$push57=, 0
	i32.const	$push56=, 0
	i32.load	$push5=, global($pop56)
	i32.const	$push55=, 3
	i32.add 	$push6=, $pop5, $pop55
	i32.const	$push54=, -4
	i32.and 	$push53=, $pop6, $pop54
	tee_local	$push52=, $1=, $pop53
	i32.const	$push51=, 4
	i32.add 	$push7=, $pop52, $pop51
	i32.store	$discard=, global($pop57), $pop7
	i32.load	$push8=, 0($1)
	i32.const	$push50=, 1
	i32.ne  	$push9=, $pop8, $pop50
	br_if   	1, $pop9        # 1: down to label5
# BB#2:                                 # %if.end5
	i32.load	$push10=, 12($6)
	i32.const	$push63=, 3
	i32.add 	$push11=, $pop10, $pop63
	i32.const	$push62=, -4
	i32.and 	$push61=, $pop11, $pop62
	tee_local	$push60=, $1=, $pop61
	i32.const	$push59=, 4
	i32.add 	$push12=, $pop60, $pop59
	i32.store	$discard=, 12($6), $pop12
	i32.load	$push13=, 0($1)
	i32.const	$push58=, 1
	i32.ne  	$push14=, $pop13, $pop58
	br_if   	2, $pop14       # 2: down to label4
# BB#3:                                 # %if.end8
	i32.const	$push70=, 0
	i32.store	$push15=, 12($6), $2
	i32.store	$push16=, global($pop70), $pop15
	i32.store	$push17=, 8($6), $pop16
	i32.const	$push69=, 3
	i32.add 	$push18=, $pop17, $pop69
	i32.const	$push68=, -4
	i32.and 	$push67=, $pop18, $pop68
	tee_local	$push66=, $1=, $pop67
	i32.const	$push65=, 4
	i32.add 	$push19=, $pop66, $pop65
	i32.store	$discard=, 8($6), $pop19
	i32.load	$push20=, 0($1)
	i32.const	$push64=, 1
	i32.ne  	$push21=, $pop20, $pop64
	br_if   	3, $pop21       # 3: down to label3
# BB#4:                                 # %if.end13
	i32.const	$push77=, 0
	i32.load	$push22=, global($pop77)
	i32.store	$push23=, 8($6), $pop22
	i32.const	$push76=, 3
	i32.add 	$push24=, $pop23, $pop76
	i32.const	$push75=, -4
	i32.and 	$push74=, $pop24, $pop75
	tee_local	$push73=, $1=, $pop74
	i32.const	$push72=, 4
	i32.add 	$push25=, $pop73, $pop72
	i32.store	$discard=, 8($6), $pop25
	i32.load	$push26=, 0($1)
	i32.const	$push71=, 1
	i32.ne  	$push27=, $pop26, $pop71
	br_if   	4, $pop27       # 4: down to label2
# BB#5:                                 # %if.end17
	i32.const	$push28=, 0
	i32.const	$push84=, 0
	i32.load	$push29=, global($pop84)
	i32.const	$push83=, 3
	i32.add 	$push30=, $pop29, $pop83
	i32.const	$push82=, -4
	i32.and 	$push81=, $pop30, $pop82
	tee_local	$push80=, $1=, $pop81
	i32.const	$push79=, 4
	i32.add 	$push31=, $pop80, $pop79
	i32.store	$discard=, global($pop28), $pop31
	i32.load	$push32=, 0($1)
	i32.const	$push78=, 1
	i32.ne  	$push33=, $pop32, $pop78
	br_if   	5, $pop33       # 5: down to label1
# BB#6:                                 # %if.end21
	i32.load	$push34=, 12($6)
	i32.const	$push35=, 3
	i32.add 	$push36=, $pop34, $pop35
	i32.const	$push37=, -4
	i32.and 	$push86=, $pop36, $pop37
	tee_local	$push85=, $1=, $pop86
	i32.const	$push38=, 4
	i32.add 	$push39=, $pop85, $pop38
	i32.store	$discard=, 12($6), $pop39
	i32.load	$push40=, 0($1)
	i32.const	$push41=, 1
	i32.ne  	$push42=, $pop40, $pop41
	br_if   	6, $pop42       # 6: down to label0
# BB#7:                                 # %if.end24
	i32.const	$5=, 16
	i32.add 	$6=, $6, $5
	i32.const	$5=, __stack_pointer
	i32.store	$6=, 0($5), $6
	return
.LBB0_8:                                # %if.then
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB0_9:                                # %if.then4
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB0_10:                               # %if.then7
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB0_11:                               # %if.then12
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_12:                               # %if.then16
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_13:                               # %if.then20
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_14:                               # %if.then23
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
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 16
	i32.sub 	$3=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$3=, 0($2), $3
	i32.const	$push0=, 1
	i32.store	$discard=, 0($3):p2align=4, $pop0
	call    	vat@FUNCTION, $0, $3
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
