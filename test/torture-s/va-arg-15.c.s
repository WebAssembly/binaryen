	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-15.c"
	.section	.text.vafunction,"ax",@progbits
	.hidden	vafunction
	.globl	vafunction
	.type	vafunction,@function
vafunction:                             # @vafunction
	.param  	i32, i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 16
	i32.sub 	$6=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$6=, 0($4), $6
	i32.store	$discard=, 12($6), $1
	i32.const	$1=, 1
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block
	block
	loop                            # label2:
	block
	block
	i32.const	$push15=, -1
	i32.add 	$push0=, $1, $pop15
	i32.const	$push14=, 1
	i32.and 	$push1=, $pop0, $pop14
	br_if   	0, $pop1        # 0: down to label5
# BB#2:                                 # %if.else
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.load	$push8=, 12($6)
	i32.const	$push25=, 3
	i32.add 	$push9=, $pop8, $pop25
	i32.const	$push24=, -4
	i32.and 	$push23=, $pop9, $pop24
	tee_local	$push22=, $2=, $pop23
	i32.const	$push21=, 4
	i32.add 	$push10=, $pop22, $pop21
	i32.store	$discard=, 12($6), $pop10
	i32.load	$push11=, 0($2)
	i32.eq  	$push12=, $1, $pop11
	br_if   	1, $pop12       # 1: down to label4
	br      	4               # 4: down to label1
.LBB0_3:                                # %if.then
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label5:
	i32.load	$push2=, 12($6)
	i32.const	$push20=, 7
	i32.add 	$push3=, $pop2, $pop20
	i32.const	$push19=, -8
	i32.and 	$push18=, $pop3, $pop19
	tee_local	$push17=, $2=, $pop18
	i32.const	$push16=, 8
	i32.add 	$push4=, $pop17, $pop16
	i32.store	$discard=, 12($6), $pop4
	f64.load	$push5=, 0($2)
	f64.convert_s/i32	$push6=, $1
	f64.ne  	$push7=, $pop5, $pop6
	br_if   	4, $pop7        # 4: down to label0
.LBB0_4:                                # %for.inc
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label4:
	i32.const	$push27=, 1
	i32.add 	$1=, $1, $pop27
	i32.const	$push26=, 19
	i32.lt_s	$push13=, $1, $pop26
	br_if   	0, $pop13       # 0: up to label2
# BB#5:                                 # %for.end
	end_loop                        # label3:
	i32.const	$5=, 16
	i32.add 	$6=, $6, $5
	i32.const	$5=, __stack_pointer
	i32.store	$6=, 0($5), $6
	return
.LBB0_6:                                # %if.then7
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
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 144
	i32.sub 	$3=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$3=, 0($2), $3
	i32.const	$push0=, 136
	i32.add 	$push1=, $3, $pop0
	i64.const	$push2=, 4625759767262920704
	i64.store	$discard=, 0($pop1), $pop2
	i32.const	$push3=, 128
	i32.add 	$push4=, $3, $pop3
	i32.const	$push5=, 17
	i32.store	$discard=, 0($pop4):p2align=4, $pop5
	i32.const	$push6=, 120
	i32.add 	$push7=, $3, $pop6
	i64.const	$push8=, 4625196817309499392
	i64.store	$discard=, 0($pop7), $pop8
	i32.const	$push9=, 112
	i32.add 	$push10=, $3, $pop9
	i32.const	$push11=, 15
	i32.store	$discard=, 0($pop10):p2align=4, $pop11
	i32.const	$push12=, 104
	i32.add 	$push13=, $3, $pop12
	i64.const	$push14=, 4624070917402656768
	i64.store	$discard=, 0($pop13), $pop14
	i32.const	$push15=, 96
	i32.add 	$push16=, $3, $pop15
	i32.const	$push17=, 13
	i32.store	$discard=, 0($pop16):p2align=4, $pop17
	i32.const	$push18=, 88
	i32.add 	$push19=, $3, $pop18
	i64.const	$push20=, 4622945017495814144
	i64.store	$discard=, 0($pop19), $pop20
	i32.const	$push21=, 80
	i32.add 	$push22=, $3, $pop21
	i32.const	$push23=, 11
	i32.store	$discard=, 0($pop22):p2align=4, $pop23
	i32.const	$push24=, 72
	i32.add 	$push25=, $3, $pop24
	i64.const	$push26=, 4621819117588971520
	i64.store	$discard=, 0($pop25), $pop26
	i32.const	$push27=, 64
	i32.add 	$push28=, $3, $pop27
	i32.const	$push29=, 9
	i32.store	$discard=, 0($pop28):p2align=4, $pop29
	i32.const	$push30=, 56
	i32.add 	$push31=, $3, $pop30
	i64.const	$push32=, 4620693217682128896
	i64.store	$discard=, 0($pop31), $pop32
	i32.const	$push33=, 48
	i32.add 	$push34=, $3, $pop33
	i32.const	$push35=, 7
	i32.store	$discard=, 0($pop34):p2align=4, $pop35
	i32.const	$push36=, 40
	i32.add 	$push37=, $3, $pop36
	i64.const	$push38=, 4618441417868443648
	i64.store	$discard=, 0($pop37), $pop38
	i32.const	$push39=, 32
	i32.add 	$push40=, $3, $pop39
	i32.const	$push41=, 5
	i32.store	$discard=, 0($pop40):p2align=4, $pop41
	i32.const	$push42=, 24
	i32.add 	$push43=, $3, $pop42
	i64.const	$push44=, 4616189618054758400
	i64.store	$discard=, 0($pop43), $pop44
	i32.const	$push45=, 16
	i32.add 	$push46=, $3, $pop45
	i32.const	$push47=, 3
	i32.store	$discard=, 0($pop46):p2align=4, $pop47
	i32.const	$push48=, 8
	i32.or  	$push49=, $3, $pop48
	i64.const	$push50=, 4611686018427387904
	i64.store	$discard=, 0($pop49), $pop50
	i32.const	$push51=, 1
	i32.store	$discard=, 0($3):p2align=4, $pop51
	call    	vafunction@FUNCTION, $0, $3
	i32.const	$push52=, 0
	call    	exit@FUNCTION, $pop52
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
