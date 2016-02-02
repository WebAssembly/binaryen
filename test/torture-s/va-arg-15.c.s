	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-15.c"
	.section	.text.vafunction,"ax",@progbits
	.hidden	vafunction
	.globl	vafunction
	.type	vafunction,@function
vafunction:                             # @vafunction
	.param  	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 16
	i32.sub 	$6=, $3, $4
	copy_local	$7=, $6
	i32.const	$4=, __stack_pointer
	i32.store	$6=, 0($4), $6
	i32.store	$discard=, 12($6), $7
	i32.const	$1=, 1
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label1:
	block
	block
	i32.const	$push17=, -1
	i32.add 	$push0=, $1, $pop17
	i32.const	$push16=, 1
	i32.and 	$push1=, $pop0, $pop16
	br_if   	$pop1, 0        # 0: down to label4
# BB#2:                                 # %if.else
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.load	$push9=, 12($6)
	i32.const	$push25=, 3
	i32.add 	$push10=, $pop9, $pop25
	i32.const	$push24=, -4
	i32.and 	$push11=, $pop10, $pop24
	tee_local	$push23=, $2=, $pop11
	i32.const	$push22=, 4
	i32.add 	$push12=, $pop23, $pop22
	i32.store	$discard=, 12($6), $pop12
	i32.load	$push13=, 0($2)
	i32.eq  	$push14=, $1, $pop13
	br_if   	$pop14, 1       # 1: down to label3
# BB#3:                                 # %if.then7
	call    	abort@FUNCTION
	unreachable
.LBB0_4:                                # %if.then
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label4:
	i32.load	$push2=, 12($6)
	i32.const	$push21=, 7
	i32.add 	$push3=, $pop2, $pop21
	i32.const	$push20=, -8
	i32.and 	$push4=, $pop3, $pop20
	tee_local	$push19=, $2=, $pop4
	i32.const	$push18=, 8
	i32.add 	$push5=, $pop19, $pop18
	i32.store	$discard=, 12($6), $pop5
	f64.load	$push6=, 0($2)
	f64.convert_s/i32	$push7=, $1
	f64.ne  	$push8=, $pop6, $pop7
	br_if   	$pop8, 3        # 3: down to label0
.LBB0_5:                                # %for.inc
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label3:
	i32.const	$push27=, 1
	i32.add 	$1=, $1, $pop27
	i32.const	$push26=, 19
	i32.lt_s	$push15=, $1, $pop26
	br_if   	$pop15, 0       # 0: up to label1
# BB#6:                                 # %for.end
	end_loop                        # label2:
	i32.const	$5=, 16
	i32.add 	$6=, $7, $5
	i32.const	$5=, __stack_pointer
	i32.store	$6=, 0($5), $6
	return
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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 144
	i32.sub 	$7=, $5, $6
	i32.const	$6=, __stack_pointer
	i32.store	$7=, 0($6), $7
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 144
	i32.sub 	$7=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$7=, 0($2), $7
	i32.const	$push0=, 1
	i32.store	$discard=, 0($7), $pop0
	i32.const	$push1=, 136
	i32.add 	$0=, $7, $pop1
	i64.const	$push2=, 4625759767262920704
	i64.store	$discard=, 0($0), $pop2
	i32.const	$push3=, 128
	i32.add 	$0=, $7, $pop3
	i32.const	$push4=, 17
	i32.store	$discard=, 0($0), $pop4
	i32.const	$push5=, 120
	i32.add 	$0=, $7, $pop5
	i64.const	$push6=, 4625196817309499392
	i64.store	$discard=, 0($0), $pop6
	i32.const	$push7=, 112
	i32.add 	$0=, $7, $pop7
	i32.const	$push8=, 15
	i32.store	$discard=, 0($0), $pop8
	i32.const	$push9=, 104
	i32.add 	$0=, $7, $pop9
	i64.const	$push10=, 4624070917402656768
	i64.store	$discard=, 0($0), $pop10
	i32.const	$push11=, 96
	i32.add 	$0=, $7, $pop11
	i32.const	$push12=, 13
	i32.store	$discard=, 0($0), $pop12
	i32.const	$push13=, 88
	i32.add 	$0=, $7, $pop13
	i64.const	$push14=, 4622945017495814144
	i64.store	$discard=, 0($0), $pop14
	i32.const	$push15=, 80
	i32.add 	$0=, $7, $pop15
	i32.const	$push16=, 11
	i32.store	$discard=, 0($0), $pop16
	i32.const	$push17=, 72
	i32.add 	$0=, $7, $pop17
	i64.const	$push18=, 4621819117588971520
	i64.store	$discard=, 0($0), $pop18
	i32.const	$push19=, 64
	i32.add 	$0=, $7, $pop19
	i32.const	$push20=, 9
	i32.store	$discard=, 0($0), $pop20
	i32.const	$push21=, 56
	i32.add 	$0=, $7, $pop21
	i64.const	$push22=, 4620693217682128896
	i64.store	$discard=, 0($0), $pop22
	i32.const	$push23=, 48
	i32.add 	$0=, $7, $pop23
	i32.const	$push24=, 7
	i32.store	$discard=, 0($0), $pop24
	i32.const	$push25=, 40
	i32.add 	$0=, $7, $pop25
	i64.const	$push26=, 4618441417868443648
	i64.store	$discard=, 0($0), $pop26
	i32.const	$push27=, 32
	i32.add 	$0=, $7, $pop27
	i32.const	$push28=, 5
	i32.store	$discard=, 0($0), $pop28
	i32.const	$push29=, 24
	i32.add 	$0=, $7, $pop29
	i64.const	$push30=, 4616189618054758400
	i64.store	$discard=, 0($0), $pop30
	i32.const	$push31=, 16
	i32.add 	$0=, $7, $pop31
	i32.const	$push32=, 3
	i32.store	$discard=, 0($0), $pop32
	i32.const	$push33=, 8
	i32.add 	$0=, $7, $pop33
	i64.const	$push34=, 4611686018427387904
	i64.store	$discard=, 0($0), $pop34
	call    	vafunction@FUNCTION, $0
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 144
	i32.add 	$7=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$7=, 0($4), $7
	i32.const	$push35=, 0
	call    	exit@FUNCTION, $pop35
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
