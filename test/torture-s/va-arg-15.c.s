	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-15.c"
	.section	.text.vafunction,"ax",@progbits
	.hidden	vafunction
	.globl	vafunction
	.type	vafunction,@function
vafunction:                             # @vafunction
	.param  	i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push12=, 0
	i32.const	$push9=, 0
	i32.load	$push10=, __stack_pointer($pop9)
	i32.const	$push11=, 16
	i32.sub 	$push16=, $pop10, $pop11
	i32.store	$push18=, __stack_pointer($pop12), $pop16
	tee_local	$push17=, $3=, $pop18
	i32.store	$drop=, 12($pop17), $1
	i32.const	$4=, 1
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block
	block
	loop                            # label2:
	block
	block
	i32.const	$push20=, -1
	i32.add 	$push1=, $4, $pop20
	i32.const	$push19=, 1
	i32.and 	$push2=, $pop1, $pop19
	br_if   	0, $pop2        # 0: down to label5
# BB#2:                                 # %if.else
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push21=, 4
	i32.add 	$push0=, $1, $pop21
	i32.store	$2=, 12($3), $pop0
	i32.load	$5=, 0($1)
	copy_local	$1=, $2
	i32.eq  	$push7=, $4, $5
	br_if   	1, $pop7        # 1: down to label4
	br      	4               # 4: down to label1
.LBB0_3:                                # %if.then
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label5:
	i32.const	$push28=, 7
	i32.add 	$push3=, $1, $pop28
	i32.const	$push27=, -8
	i32.and 	$push26=, $pop3, $pop27
	tee_local	$push25=, $2=, $pop26
	i32.const	$push24=, 8
	i32.add 	$push23=, $pop25, $pop24
	tee_local	$push22=, $1=, $pop23
	i32.store	$drop=, 12($3), $pop22
	f64.load	$push4=, 0($2)
	f64.convert_s/i32	$push5=, $4
	f64.ne  	$push6=, $pop4, $pop5
	br_if   	4, $pop6        # 4: down to label0
.LBB0_4:                                # %for.inc
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label4:
	i32.const	$push32=, 1
	i32.add 	$push31=, $4, $pop32
	tee_local	$push30=, $4=, $pop31
	i32.const	$push29=, 19
	i32.lt_s	$push8=, $pop30, $pop29
	br_if   	0, $pop8        # 0: up to label2
# BB#5:                                 # %for.end
	end_loop                        # label3:
	i32.const	$push15=, 0
	i32.const	$push13=, 16
	i32.add 	$push14=, $3, $pop13
	i32.store	$drop=, __stack_pointer($pop15), $pop14
	return
.LBB0_6:                                # %if.then9
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_7:                                # %if.then4
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
	i32.const	$push54=, 0
	i32.const	$push51=, 0
	i32.load	$push52=, __stack_pointer($pop51)
	i32.const	$push53=, 144
	i32.sub 	$push55=, $pop52, $pop53
	i32.store	$push57=, __stack_pointer($pop54), $pop55
	tee_local	$push56=, $0=, $pop57
	i32.const	$push0=, 136
	i32.add 	$push1=, $pop56, $pop0
	i64.const	$push2=, 4625759767262920704
	i64.store	$drop=, 0($pop1), $pop2
	i32.const	$push3=, 128
	i32.add 	$push4=, $0, $pop3
	i32.const	$push5=, 17
	i32.store	$drop=, 0($pop4), $pop5
	i32.const	$push6=, 120
	i32.add 	$push7=, $0, $pop6
	i64.const	$push8=, 4625196817309499392
	i64.store	$drop=, 0($pop7), $pop8
	i32.const	$push9=, 112
	i32.add 	$push10=, $0, $pop9
	i32.const	$push11=, 15
	i32.store	$drop=, 0($pop10), $pop11
	i32.const	$push12=, 104
	i32.add 	$push13=, $0, $pop12
	i64.const	$push14=, 4624070917402656768
	i64.store	$drop=, 0($pop13), $pop14
	i32.const	$push15=, 96
	i32.add 	$push16=, $0, $pop15
	i32.const	$push17=, 13
	i32.store	$drop=, 0($pop16), $pop17
	i32.const	$push18=, 88
	i32.add 	$push19=, $0, $pop18
	i64.const	$push20=, 4622945017495814144
	i64.store	$drop=, 0($pop19), $pop20
	i32.const	$push21=, 80
	i32.add 	$push22=, $0, $pop21
	i32.const	$push23=, 11
	i32.store	$drop=, 0($pop22), $pop23
	i32.const	$push24=, 72
	i32.add 	$push25=, $0, $pop24
	i64.const	$push26=, 4621819117588971520
	i64.store	$drop=, 0($pop25), $pop26
	i32.const	$push27=, 64
	i32.add 	$push28=, $0, $pop27
	i32.const	$push29=, 9
	i32.store	$drop=, 0($pop28), $pop29
	i32.const	$push30=, 56
	i32.add 	$push31=, $0, $pop30
	i64.const	$push32=, 4620693217682128896
	i64.store	$drop=, 0($pop31), $pop32
	i32.const	$push33=, 48
	i32.add 	$push34=, $0, $pop33
	i32.const	$push35=, 7
	i32.store	$drop=, 0($pop34), $pop35
	i32.const	$push36=, 40
	i32.add 	$push37=, $0, $pop36
	i64.const	$push38=, 4618441417868443648
	i64.store	$drop=, 0($pop37), $pop38
	i32.const	$push39=, 32
	i32.add 	$push40=, $0, $pop39
	i32.const	$push41=, 5
	i32.store	$drop=, 0($pop40), $pop41
	i32.const	$push42=, 24
	i32.add 	$push43=, $0, $pop42
	i64.const	$push44=, 4616189618054758400
	i64.store	$drop=, 0($pop43), $pop44
	i32.const	$push45=, 16
	i32.add 	$push46=, $0, $pop45
	i32.const	$push47=, 3
	i32.store	$drop=, 0($pop46), $pop47
	i64.const	$push48=, 4611686018427387904
	i64.store	$drop=, 8($0), $pop48
	i32.const	$push49=, 1
	i32.store	$drop=, 0($0), $pop49
	call    	vafunction@FUNCTION, $0, $0
	i32.const	$push50=, 0
	call    	exit@FUNCTION, $pop50
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
