	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/980608-1.c"
	.section	.text.f1,"ax",@progbits
	.hidden	f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	return
	.endfunc
.Lfunc_end0:
	.size	f1, .Lfunc_end0-f1

	.section	.text.debug,"ax",@progbits
	.hidden	debug
	.globl	debug
	.type	debug,@function
debug:                                  # @debug
	.param  	i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$5=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	i32.store	$push0=, 12($5), $1
	i32.const	$push40=, 3
	i32.add 	$push1=, $pop0, $pop40
	i32.const	$push39=, -4
	i32.and 	$push38=, $pop1, $pop39
	tee_local	$push37=, $1=, $pop38
	i32.const	$push36=, 4
	i32.add 	$push2=, $pop37, $pop36
	i32.store	$discard=, 12($5), $pop2
	block
	block
	block
	block
	block
	block
	i32.load	$push3=, 0($1)
	i32.const	$push4=, 101
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label5
# BB#1:                                 # %if.end
	i32.load	$push6=, 12($5)
	i32.const	$push45=, 3
	i32.add 	$push7=, $pop6, $pop45
	i32.const	$push44=, -4
	i32.and 	$push43=, $pop7, $pop44
	tee_local	$push42=, $1=, $pop43
	i32.const	$push41=, 4
	i32.add 	$push8=, $pop42, $pop41
	i32.store	$discard=, 12($5), $pop8
	i32.load	$push9=, 0($1)
	i32.const	$push10=, 102
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	1, $pop11       # 1: down to label4
# BB#2:                                 # %if.end4
	i32.load	$push12=, 12($5)
	i32.const	$push50=, 3
	i32.add 	$push13=, $pop12, $pop50
	i32.const	$push49=, -4
	i32.and 	$push48=, $pop13, $pop49
	tee_local	$push47=, $1=, $pop48
	i32.const	$push46=, 4
	i32.add 	$push14=, $pop47, $pop46
	i32.store	$discard=, 12($5), $pop14
	i32.load	$push15=, 0($1)
	i32.const	$push16=, 103
	i32.ne  	$push17=, $pop15, $pop16
	br_if   	2, $pop17       # 2: down to label3
# BB#3:                                 # %if.end7
	i32.load	$push18=, 12($5)
	i32.const	$push55=, 3
	i32.add 	$push19=, $pop18, $pop55
	i32.const	$push54=, -4
	i32.and 	$push53=, $pop19, $pop54
	tee_local	$push52=, $1=, $pop53
	i32.const	$push51=, 4
	i32.add 	$push20=, $pop52, $pop51
	i32.store	$discard=, 12($5), $pop20
	i32.load	$push21=, 0($1)
	i32.const	$push22=, 104
	i32.ne  	$push23=, $pop21, $pop22
	br_if   	3, $pop23       # 3: down to label2
# BB#4:                                 # %if.end10
	i32.load	$push24=, 12($5)
	i32.const	$push60=, 3
	i32.add 	$push25=, $pop24, $pop60
	i32.const	$push59=, -4
	i32.and 	$push58=, $pop25, $pop59
	tee_local	$push57=, $1=, $pop58
	i32.const	$push56=, 4
	i32.add 	$push26=, $pop57, $pop56
	i32.store	$discard=, 12($5), $pop26
	i32.load	$push27=, 0($1)
	i32.const	$push28=, 105
	i32.ne  	$push29=, $pop27, $pop28
	br_if   	4, $pop29       # 4: down to label1
# BB#5:                                 # %if.end13
	i32.load	$push30=, 12($5)
	i32.const	$push65=, 3
	i32.add 	$push31=, $pop30, $pop65
	i32.const	$push64=, -4
	i32.and 	$push63=, $pop31, $pop64
	tee_local	$push62=, $1=, $pop63
	i32.const	$push61=, 4
	i32.add 	$push32=, $pop62, $pop61
	i32.store	$discard=, 12($5), $pop32
	i32.load	$push33=, 0($1)
	i32.const	$push34=, 106
	i32.ne  	$push35=, $pop33, $pop34
	br_if   	5, $pop35       # 5: down to label0
# BB#6:                                 # %if.end16
	i32.const	$4=, 16
	i32.add 	$5=, $5, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
	return
.LBB1_7:                                # %if.then
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB1_8:                                # %if.then3
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_9:                                # %if.then6
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB1_10:                               # %if.then9
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB1_11:                               # %if.then12
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB1_12:                               # %if.then15
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	debug, .Lfunc_end1-debug

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
	i32.const	$2=, 32
	i32.sub 	$3=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$3=, 0($2), $3
	i32.const	$push0=, 16
	i32.add 	$push1=, $3, $pop0
	i64.const	$push2=, 455266533481
	i64.store	$discard=, 0($pop1):p2align=4, $pop2
	i32.const	$push3=, 8
	i32.or  	$push4=, $3, $pop3
	i64.const	$push5=, 446676598887
	i64.store	$discard=, 0($pop4), $pop5
	i64.const	$push6=, 438086664293
	i64.store	$discard=, 0($3):p2align=4, $pop6
	call    	debug@FUNCTION, $0, $3
	i32.const	$push7=, 0
	call    	exit@FUNCTION, $pop7
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
