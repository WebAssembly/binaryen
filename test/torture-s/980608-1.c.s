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
	i32.const	$push45=, 3
	i32.add 	$push1=, $pop0, $pop45
	i32.const	$push44=, -4
	i32.and 	$push2=, $pop1, $pop44
	tee_local	$push43=, $1=, $pop2
	i32.const	$push42=, 4
	i32.add 	$push3=, $pop43, $pop42
	i32.store	$discard=, 12($5), $pop3
	block
	i32.load	$push4=, 0($1)
	i32.const	$push5=, 101
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label0
# BB#1:                                 # %if.end
	i32.load	$push7=, 12($5)
	i32.const	$push49=, 3
	i32.add 	$push8=, $pop7, $pop49
	i32.const	$push48=, -4
	i32.and 	$push9=, $pop8, $pop48
	tee_local	$push47=, $1=, $pop9
	i32.const	$push46=, 4
	i32.add 	$push10=, $pop47, $pop46
	i32.store	$discard=, 12($5), $pop10
	block
	i32.load	$push11=, 0($1)
	i32.const	$push12=, 102
	i32.ne  	$push13=, $pop11, $pop12
	br_if   	0, $pop13       # 0: down to label1
# BB#2:                                 # %if.end4
	i32.load	$push14=, 12($5)
	i32.const	$push53=, 3
	i32.add 	$push15=, $pop14, $pop53
	i32.const	$push52=, -4
	i32.and 	$push16=, $pop15, $pop52
	tee_local	$push51=, $1=, $pop16
	i32.const	$push50=, 4
	i32.add 	$push17=, $pop51, $pop50
	i32.store	$discard=, 12($5), $pop17
	block
	i32.load	$push18=, 0($1)
	i32.const	$push19=, 103
	i32.ne  	$push20=, $pop18, $pop19
	br_if   	0, $pop20       # 0: down to label2
# BB#3:                                 # %if.end7
	i32.load	$push21=, 12($5)
	i32.const	$push57=, 3
	i32.add 	$push22=, $pop21, $pop57
	i32.const	$push56=, -4
	i32.and 	$push23=, $pop22, $pop56
	tee_local	$push55=, $1=, $pop23
	i32.const	$push54=, 4
	i32.add 	$push24=, $pop55, $pop54
	i32.store	$discard=, 12($5), $pop24
	block
	i32.load	$push25=, 0($1)
	i32.const	$push26=, 104
	i32.ne  	$push27=, $pop25, $pop26
	br_if   	0, $pop27       # 0: down to label3
# BB#4:                                 # %if.end10
	i32.load	$push28=, 12($5)
	i32.const	$push61=, 3
	i32.add 	$push29=, $pop28, $pop61
	i32.const	$push60=, -4
	i32.and 	$push30=, $pop29, $pop60
	tee_local	$push59=, $1=, $pop30
	i32.const	$push58=, 4
	i32.add 	$push31=, $pop59, $pop58
	i32.store	$discard=, 12($5), $pop31
	block
	i32.load	$push32=, 0($1)
	i32.const	$push33=, 105
	i32.ne  	$push34=, $pop32, $pop33
	br_if   	0, $pop34       # 0: down to label4
# BB#5:                                 # %if.end13
	i32.load	$push35=, 12($5)
	i32.const	$push65=, 3
	i32.add 	$push36=, $pop35, $pop65
	i32.const	$push64=, -4
	i32.and 	$push37=, $pop36, $pop64
	tee_local	$push63=, $1=, $pop37
	i32.const	$push62=, 4
	i32.add 	$push38=, $pop63, $pop62
	i32.store	$discard=, 12($5), $pop38
	block
	i32.load	$push39=, 0($1)
	i32.const	$push40=, 106
	i32.ne  	$push41=, $pop39, $pop40
	br_if   	0, $pop41       # 0: down to label5
# BB#6:                                 # %if.end16
	i32.const	$4=, 16
	i32.add 	$5=, $5, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
	return
.LBB1_7:                                # %if.then15
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB1_8:                                # %if.then12
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_9:                                # %if.then9
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB1_10:                               # %if.then6
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB1_11:                               # %if.then3
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB1_12:                               # %if.then
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
