	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-19.c"
	.section	.text.vafunction,"ax",@progbits
	.hidden	vafunction
	.globl	vafunction
	.type	vafunction,@function
vafunction:                             # @vafunction
	.param  	i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push40=, 0
	i32.const	$push37=, 0
	i32.load	$push38=, __stack_pointer($pop37)
	i32.const	$push39=, 16
	i32.sub 	$push47=, $pop38, $pop39
	tee_local	$push46=, $4=, $pop47
	i32.store	__stack_pointer($pop40), $pop46
	i32.store	12($4), $1
	i32.const	$push0=, 4
	i32.add 	$push45=, $1, $pop0
	tee_local	$push44=, $2=, $pop45
	i32.store	12($4), $pop44
	block   	
	i32.load	$push1=, 0($1)
	i32.const	$push2=, 1
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push4=, 8
	i32.add 	$push49=, $1, $pop4
	tee_local	$push48=, $3=, $pop49
	i32.store	12($4), $pop48
	i32.load	$push5=, 0($2)
	i32.const	$push6=, 2
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#2:                                 # %if.end6
	i32.const	$push8=, 12
	i32.add 	$push51=, $1, $pop8
	tee_local	$push50=, $2=, $pop51
	i32.store	12($4), $pop50
	i32.load	$push9=, 0($3)
	i32.const	$push10=, 3
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	0, $pop11       # 0: down to label0
# BB#3:                                 # %if.end11
	i32.const	$push12=, 16
	i32.add 	$push53=, $1, $pop12
	tee_local	$push52=, $3=, $pop53
	i32.store	12($4), $pop52
	i32.load	$push13=, 0($2)
	i32.const	$push14=, 4
	i32.ne  	$push15=, $pop13, $pop14
	br_if   	0, $pop15       # 0: down to label0
# BB#4:                                 # %if.end16
	i32.const	$push16=, 20
	i32.add 	$push55=, $1, $pop16
	tee_local	$push54=, $2=, $pop55
	i32.store	12($4), $pop54
	i32.load	$push17=, 0($3)
	i32.const	$push18=, 5
	i32.ne  	$push19=, $pop17, $pop18
	br_if   	0, $pop19       # 0: down to label0
# BB#5:                                 # %if.end21
	i32.const	$push20=, 24
	i32.add 	$push57=, $1, $pop20
	tee_local	$push56=, $3=, $pop57
	i32.store	12($4), $pop56
	i32.load	$push21=, 0($2)
	i32.const	$push22=, 6
	i32.ne  	$push23=, $pop21, $pop22
	br_if   	0, $pop23       # 0: down to label0
# BB#6:                                 # %if.end26
	i32.const	$push24=, 28
	i32.add 	$push59=, $1, $pop24
	tee_local	$push58=, $2=, $pop59
	i32.store	12($4), $pop58
	i32.load	$push25=, 0($3)
	i32.const	$push26=, 7
	i32.ne  	$push27=, $pop25, $pop26
	br_if   	0, $pop27       # 0: down to label0
# BB#7:                                 # %if.end31
	i32.const	$push28=, 32
	i32.add 	$push61=, $1, $pop28
	tee_local	$push60=, $3=, $pop61
	i32.store	12($4), $pop60
	i32.load	$push29=, 0($2)
	i32.const	$push30=, 8
	i32.ne  	$push31=, $pop29, $pop30
	br_if   	0, $pop31       # 0: down to label0
# BB#8:                                 # %if.end36
	i32.const	$push32=, 36
	i32.add 	$push33=, $1, $pop32
	i32.store	12($4), $pop33
	i32.load	$push34=, 0($3)
	i32.const	$push35=, 9
	i32.ne  	$push36=, $pop34, $pop35
	br_if   	0, $pop36       # 0: down to label0
# BB#9:                                 # %if.end41
	i32.const	$push43=, 0
	i32.const	$push41=, 16
	i32.add 	$push42=, $4, $pop41
	i32.store	__stack_pointer($pop43), $pop42
	return
.LBB0_10:                               # %if.then40
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	vafunction, .Lfunc_end0-vafunction

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push15=, 0
	i32.const	$push12=, 0
	i32.load	$push13=, __stack_pointer($pop12)
	i32.const	$push14=, 48
	i32.sub 	$push17=, $pop13, $pop14
	tee_local	$push16=, $0=, $pop17
	i32.store	__stack_pointer($pop15), $pop16
	i32.const	$push0=, 32
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 9
	i32.store	0($pop1), $pop2
	i32.const	$push3=, 24
	i32.add 	$push4=, $0, $pop3
	i64.const	$push5=, 34359738375
	i64.store	0($pop4), $pop5
	i32.const	$push6=, 16
	i32.add 	$push7=, $0, $pop6
	i64.const	$push8=, 25769803781
	i64.store	0($pop7), $pop8
	i64.const	$push9=, 17179869187
	i64.store	8($0), $pop9
	i64.const	$push10=, 8589934593
	i64.store	0($0), $pop10
	call    	vafunction@FUNCTION, $0, $0
	i32.const	$push11=, 0
	call    	exit@FUNCTION, $pop11
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
