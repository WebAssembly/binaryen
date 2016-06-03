	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-19.c"
	.section	.text.vafunction,"ax",@progbits
	.hidden	vafunction
	.globl	vafunction
	.type	vafunction,@function
vafunction:                             # @vafunction
	.param  	i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push48=, 0
	i32.const	$push45=, 0
	i32.load	$push46=, __stack_pointer($pop45)
	i32.const	$push47=, 16
	i32.sub 	$push52=, $pop46, $pop47
	i32.store	$push56=, __stack_pointer($pop48), $pop52
	tee_local	$push55=, $4=, $pop56
	i32.store	$push54=, 12($4), $1
	tee_local	$push53=, $1=, $pop54
	i32.const	$push0=, 4
	i32.add 	$push1=, $pop53, $pop0
	i32.store	$2=, 12($pop55), $pop1
	block
	i32.load	$push2=, 0($1)
	i32.const	$push3=, 1
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push5=, 8
	i32.add 	$push6=, $1, $pop5
	i32.store	$3=, 12($4), $pop6
	i32.load	$push7=, 0($2)
	i32.const	$push8=, 2
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	0, $pop9        # 0: down to label0
# BB#2:                                 # %if.end6
	i32.const	$push10=, 12
	i32.add 	$push11=, $1, $pop10
	i32.store	$2=, 12($4), $pop11
	i32.load	$push12=, 0($3)
	i32.const	$push13=, 3
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	0, $pop14       # 0: down to label0
# BB#3:                                 # %if.end11
	i32.const	$push15=, 16
	i32.add 	$push16=, $1, $pop15
	i32.store	$3=, 12($4), $pop16
	i32.load	$push17=, 0($2)
	i32.const	$push18=, 4
	i32.ne  	$push19=, $pop17, $pop18
	br_if   	0, $pop19       # 0: down to label0
# BB#4:                                 # %if.end16
	i32.const	$push20=, 20
	i32.add 	$push21=, $1, $pop20
	i32.store	$2=, 12($4), $pop21
	i32.load	$push22=, 0($3)
	i32.const	$push23=, 5
	i32.ne  	$push24=, $pop22, $pop23
	br_if   	0, $pop24       # 0: down to label0
# BB#5:                                 # %if.end21
	i32.const	$push25=, 24
	i32.add 	$push26=, $1, $pop25
	i32.store	$3=, 12($4), $pop26
	i32.load	$push27=, 0($2)
	i32.const	$push28=, 6
	i32.ne  	$push29=, $pop27, $pop28
	br_if   	0, $pop29       # 0: down to label0
# BB#6:                                 # %if.end26
	i32.const	$push30=, 28
	i32.add 	$push31=, $1, $pop30
	i32.store	$2=, 12($4), $pop31
	i32.load	$push32=, 0($3)
	i32.const	$push33=, 7
	i32.ne  	$push34=, $pop32, $pop33
	br_if   	0, $pop34       # 0: down to label0
# BB#7:                                 # %if.end31
	i32.const	$push35=, 32
	i32.add 	$push36=, $1, $pop35
	i32.store	$3=, 12($4), $pop36
	i32.load	$push37=, 0($2)
	i32.const	$push38=, 8
	i32.ne  	$push39=, $pop37, $pop38
	br_if   	0, $pop39       # 0: down to label0
# BB#8:                                 # %if.end36
	i32.const	$push40=, 36
	i32.add 	$push41=, $1, $pop40
	i32.store	$drop=, 12($4), $pop41
	i32.load	$push42=, 0($3)
	i32.const	$push43=, 9
	i32.ne  	$push44=, $pop42, $pop43
	br_if   	0, $pop44       # 0: down to label0
# BB#9:                                 # %if.end41
	i32.const	$push51=, 0
	i32.const	$push49=, 16
	i32.add 	$push50=, $4, $pop49
	i32.store	$drop=, __stack_pointer($pop51), $pop50
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
	i32.sub 	$push16=, $pop13, $pop14
	i32.store	$push18=, __stack_pointer($pop15), $pop16
	tee_local	$push17=, $0=, $pop18
	i32.const	$push0=, 32
	i32.add 	$push1=, $pop17, $pop0
	i32.const	$push2=, 9
	i32.store	$drop=, 0($pop1), $pop2
	i32.const	$push3=, 24
	i32.add 	$push4=, $0, $pop3
	i64.const	$push5=, 34359738375
	i64.store	$drop=, 0($pop4), $pop5
	i32.const	$push6=, 16
	i32.add 	$push7=, $0, $pop6
	i64.const	$push8=, 25769803781
	i64.store	$drop=, 0($pop7), $pop8
	i64.const	$push9=, 17179869187
	i64.store	$drop=, 8($0), $pop9
	i64.const	$push10=, 8589934593
	i64.store	$drop=, 0($0), $pop10
	call    	vafunction@FUNCTION, $0, $0
	i32.const	$push11=, 0
	call    	exit@FUNCTION, $pop11
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
