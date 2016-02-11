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
	i32.const	$push55=, 3
	i32.add 	$push1=, $2, $pop55
	i32.const	$push54=, -4
	i32.and 	$push2=, $pop1, $pop54
	tee_local	$push53=, $0=, $pop2
	i32.const	$push52=, 4
	i32.add 	$push3=, $pop53, $pop52
	i32.store	$discard=, 8($6), $pop3
	i32.const	$push51=, 0
	i32.store	$push0=, global($pop51), $1
	i32.store	$2=, 12($6), $pop0
	block
	i32.load	$push4=, 0($0)
	i32.const	$push50=, 1
	i32.ne  	$push5=, $pop4, $pop50
	br_if   	0, $pop5        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push62=, 0
	i32.const	$push61=, 0
	i32.load	$push6=, global($pop61)
	i32.const	$push60=, 3
	i32.add 	$push7=, $pop6, $pop60
	i32.const	$push59=, -4
	i32.and 	$push8=, $pop7, $pop59
	tee_local	$push58=, $1=, $pop8
	i32.const	$push57=, 4
	i32.add 	$push9=, $pop58, $pop57
	i32.store	$discard=, global($pop62), $pop9
	block
	i32.load	$push10=, 0($1)
	i32.const	$push56=, 1
	i32.ne  	$push11=, $pop10, $pop56
	br_if   	0, $pop11       # 0: down to label1
# BB#2:                                 # %if.end5
	i32.load	$push12=, 12($6)
	i32.const	$push67=, 3
	i32.add 	$push13=, $pop12, $pop67
	i32.const	$push66=, -4
	i32.and 	$push14=, $pop13, $pop66
	tee_local	$push65=, $1=, $pop14
	i32.const	$push64=, 4
	i32.add 	$push15=, $pop65, $pop64
	i32.store	$discard=, 12($6), $pop15
	block
	i32.load	$push16=, 0($1)
	i32.const	$push63=, 1
	i32.ne  	$push17=, $pop16, $pop63
	br_if   	0, $pop17       # 0: down to label2
# BB#3:                                 # %if.end8
	i32.const	$push73=, 0
	i32.store	$push18=, 12($6), $2
	i32.store	$push19=, global($pop73), $pop18
	i32.store	$push20=, 8($6), $pop19
	i32.const	$push72=, 3
	i32.add 	$push21=, $pop20, $pop72
	i32.const	$push71=, -4
	i32.and 	$push22=, $pop21, $pop71
	tee_local	$push70=, $1=, $pop22
	i32.const	$push69=, 4
	i32.add 	$push23=, $pop70, $pop69
	i32.store	$discard=, 8($6), $pop23
	block
	i32.load	$push24=, 0($1)
	i32.const	$push68=, 1
	i32.ne  	$push25=, $pop24, $pop68
	br_if   	0, $pop25       # 0: down to label3
# BB#4:                                 # %if.end13
	i32.const	$push79=, 0
	i32.load	$push26=, global($pop79)
	i32.store	$push27=, 8($6), $pop26
	i32.const	$push78=, 3
	i32.add 	$push28=, $pop27, $pop78
	i32.const	$push77=, -4
	i32.and 	$push29=, $pop28, $pop77
	tee_local	$push76=, $1=, $pop29
	i32.const	$push75=, 4
	i32.add 	$push30=, $pop76, $pop75
	i32.store	$discard=, 8($6), $pop30
	block
	i32.load	$push31=, 0($1)
	i32.const	$push74=, 1
	i32.ne  	$push32=, $pop31, $pop74
	br_if   	0, $pop32       # 0: down to label4
# BB#5:                                 # %if.end17
	i32.const	$push33=, 0
	i32.const	$push85=, 0
	i32.load	$push34=, global($pop85)
	i32.const	$push84=, 3
	i32.add 	$push35=, $pop34, $pop84
	i32.const	$push83=, -4
	i32.and 	$push36=, $pop35, $pop83
	tee_local	$push82=, $1=, $pop36
	i32.const	$push81=, 4
	i32.add 	$push37=, $pop82, $pop81
	i32.store	$discard=, global($pop33), $pop37
	block
	i32.load	$push38=, 0($1)
	i32.const	$push80=, 1
	i32.ne  	$push39=, $pop38, $pop80
	br_if   	0, $pop39       # 0: down to label5
# BB#6:                                 # %if.end21
	i32.load	$push40=, 12($6)
	i32.const	$push41=, 3
	i32.add 	$push42=, $pop40, $pop41
	i32.const	$push43=, -4
	i32.and 	$push44=, $pop42, $pop43
	tee_local	$push86=, $1=, $pop44
	i32.const	$push45=, 4
	i32.add 	$push46=, $pop86, $pop45
	i32.store	$discard=, 12($6), $pop46
	block
	i32.load	$push47=, 0($1)
	i32.const	$push48=, 1
	i32.ne  	$push49=, $pop47, $pop48
	br_if   	0, $pop49       # 0: down to label6
# BB#7:                                 # %if.end24
	i32.const	$5=, 16
	i32.add 	$6=, $6, $5
	i32.const	$5=, __stack_pointer
	i32.store	$6=, 0($5), $6
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
