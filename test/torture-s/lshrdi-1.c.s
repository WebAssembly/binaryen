	.text
	.file	"lshrdi-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i64
# %bb.0:                                # %entry
	i64.const	$2=, 0
	i32.const	$1=, .Lswitch.table.main
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label1:
	i64.const	$push8=, -8690466092652643696
	i64.shr_u	$push0=, $pop8, $2
	i64.load	$push1=, 0($1)
	i64.ne  	$push2=, $pop0, $pop1
	br_if   	1, $pop2        # 1: down to label0
# %bb.2:                                # %for.cond
                                        #   in Loop: Header=BB0_1 Depth=1
	i64.const	$push11=, 1
	i64.add 	$2=, $2, $pop11
	i32.const	$push10=, 8
	i32.add 	$1=, $1, $pop10
	i64.const	$push9=, 64
	i64.lt_u	$push3=, $2, $pop9
	br_if   	0, $pop3        # 0: up to label1
# %bb.3:                                # %for.body4.preheader
	end_loop
	i32.const	$1=, 0
	i32.const	$0=, .Lswitch.table.main
.LBB0_4:                                # %for.body4
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.const	$push13=, 2147483647
	i32.and 	$push4=, $1, $pop13
	i32.const	$push12=, 64
	i32.ge_u	$push5=, $pop4, $pop12
	br_if   	1, $pop5        # 1: down to label0
# %bb.5:                                # %switch.lookup
                                        #   in Loop: Header=BB0_4 Depth=1
	i32.const	$push14=, 1
	i32.eqz 	$push18=, $pop14
	br_if   	1, $pop18       # 1: down to label0
# %bb.6:                                # %for.cond2
                                        #   in Loop: Header=BB0_4 Depth=1
	i32.const	$push17=, 1
	i32.add 	$1=, $1, $pop17
	i32.const	$push16=, 8
	i32.add 	$0=, $0, $pop16
	i32.const	$push15=, 63
	i32.le_u	$push6=, $1, $pop15
	br_if   	0, $pop6        # 0: up to label2
# %bb.7:                                # %for.end13
	end_loop
	i32.const	$push7=, 0
	call    	exit@FUNCTION, $pop7
	unreachable
.LBB0_8:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.type	.Lswitch.table.main,@object # @switch.table.main
	.section	.rodata..Lswitch.table.main,"a",@progbits
	.p2align	4
.Lswitch.table.main:
	.int64	-8690466092652643696    # 0x87654321fedcba90
	.int64	4878138990528453960     # 0x43b2a190ff6e5d48
	.int64	2439069495264226980     # 0x21d950c87fb72ea4
	.int64	1219534747632113490     # 0x10eca8643fdb9752
	.int64	609767373816056745      # 0x87654321fedcba9
	.int64	304883686908028372      # 0x43b2a190ff6e5d4
	.int64	152441843454014186      # 0x21d950c87fb72ea
	.int64	76220921727007093       # 0x10eca8643fdb975
	.int64	38110460863503546       # 0x87654321fedcba
	.int64	19055230431751773       # 0x43b2a190ff6e5d
	.int64	9527615215875886        # 0x21d950c87fb72e
	.int64	4763807607937943        # 0x10eca8643fdb97
	.int64	2381903803968971        # 0x87654321fedcb
	.int64	1190951901984485        # 0x43b2a190ff6e5
	.int64	595475950992242         # 0x21d950c87fb72
	.int64	297737975496121         # 0x10eca8643fdb9
	.int64	148868987748060         # 0x87654321fedc
	.int64	74434493874030          # 0x43b2a190ff6e
	.int64	37217246937015          # 0x21d950c87fb7
	.int64	18608623468507          # 0x10eca8643fdb
	.int64	9304311734253           # 0x87654321fed
	.int64	4652155867126           # 0x43b2a190ff6
	.int64	2326077933563           # 0x21d950c87fb
	.int64	1163038966781           # 0x10eca8643fd
	.int64	581519483390            # 0x87654321fe
	.int64	290759741695            # 0x43b2a190ff
	.int64	145379870847            # 0x21d950c87f
	.int64	72689935423             # 0x10eca8643f
	.int64	36344967711             # 0x87654321f
	.int64	18172483855             # 0x43b2a190f
	.int64	9086241927              # 0x21d950c87
	.int64	4543120963              # 0x10eca8643
	.int64	2271560481              # 0x87654321
	.int64	1135780240              # 0x43b2a190
	.int64	567890120               # 0x21d950c8
	.int64	283945060               # 0x10eca864
	.int64	141972530               # 0x8765432
	.int64	70986265                # 0x43b2a19
	.int64	35493132                # 0x21d950c
	.int64	17746566                # 0x10eca86
	.int64	8873283                 # 0x876543
	.int64	4436641                 # 0x43b2a1
	.int64	2218320                 # 0x21d950
	.int64	1109160                 # 0x10eca8
	.int64	554580                  # 0x87654
	.int64	277290                  # 0x43b2a
	.int64	138645                  # 0x21d95
	.int64	69322                   # 0x10eca
	.int64	34661                   # 0x8765
	.int64	17330                   # 0x43b2
	.int64	8665                    # 0x21d9
	.int64	4332                    # 0x10ec
	.int64	2166                    # 0x876
	.int64	1083                    # 0x43b
	.int64	541                     # 0x21d
	.int64	270                     # 0x10e
	.int64	135                     # 0x87
	.int64	67                      # 0x43
	.int64	33                      # 0x21
	.int64	16                      # 0x10
	.int64	8                       # 0x8
	.int64	4                       # 0x4
	.int64	2                       # 0x2
	.int64	1                       # 0x1
	.size	.Lswitch.table.main, 512


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
