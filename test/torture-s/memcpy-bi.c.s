	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/memcpy-bi.c"
	.section	.text.check,"ax",@progbits
	.hidden	check
	.globl	check
	.type	check,@function
check:                                  # @check
	.param  	i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.call	$push0=, memcmp@FUNCTION, $0, $1, $2
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	check, .Lfunc_end0-check

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64, i64, i64, i32
# BB#0:                                 # %entry
	i32.const	$4=, 0
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push251=, 26
	i32.rem_s	$push0=, $4, $pop251
	i32.const	$push250=, 97
	i32.add 	$push1=, $pop0, $pop250
	i32.store8	$discard=, src($4), $pop1
	i32.const	$push249=, 1
	i32.add 	$4=, $4, $pop249
	i32.const	$push248=, 80
	i32.ne  	$push2=, $4, $pop248
	br_if   	0, $pop2        # 0: up to label1
# BB#2:                                 # %check.exit
	end_loop                        # label2:
	i32.const	$push253=, 0
	i32.const	$push252=, 0
	i32.load16_u	$push3=, src($pop252):p2align=4
	i32.store16	$discard=, dst($pop253):p2align=4, $pop3
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	i32.const	$push4=, 1
	i32.const	$push676=, 0
	i32.eq  	$push677=, $pop4, $pop676
	br_if   	0, $pop677      # 0: down to label78
# BB#3:                                 # %check.exit13
	i32.const	$push259=, 0
	i32.const	$push258=, 0
	i32.load8_u	$push5=, src+2($pop258):p2align=1
	i32.store8	$discard=, dst+2($pop259):p2align=1, $pop5
	i32.const	$push257=, 0
	i32.const	$push256=, 0
	i32.load16_u	$push6=, src($pop256):p2align=4
	i32.store16	$discard=, dst($pop257):p2align=4, $pop6
	i32.const	$push255=, dst
	i32.const	$push254=, src
	i32.const	$push7=, 3
	i32.call	$push8=, memcmp@FUNCTION, $pop255, $pop254, $pop7
	br_if   	1, $pop8        # 1: down to label77
# BB#4:                                 # %check.exit17
	i32.const	$push265=, 0
	i32.load	$4=, src($pop265):p2align=4
	i32.const	$push264=, 0
	i32.const	$push263=, 0
	i32.load8_u	$push9=, src+4($pop263):p2align=2
	i32.store8	$discard=, dst+4($pop264):p2align=2, $pop9
	i32.const	$push262=, 0
	i32.store	$discard=, dst($pop262):p2align=4, $4
	i32.const	$push261=, dst
	i32.const	$push260=, src
	i32.const	$push10=, 5
	i32.call	$push11=, memcmp@FUNCTION, $pop261, $pop260, $pop10
	br_if   	2, $pop11       # 2: down to label76
# BB#5:                                 # %check.exit25
	i32.const	$push271=, 0
	i32.const	$push270=, 0
	i32.load16_u	$push12=, src+4($pop270):p2align=2
	i32.store16	$discard=, dst+4($pop271):p2align=2, $pop12
	i32.const	$push269=, 0
	i32.const	$push268=, 0
	i32.load	$push13=, src($pop268):p2align=4
	i32.store	$discard=, dst($pop269):p2align=4, $pop13
	i32.const	$push267=, dst
	i32.const	$push266=, src
	i32.const	$push14=, 6
	i32.call	$push15=, memcmp@FUNCTION, $pop267, $pop266, $pop14
	br_if   	3, $pop15       # 3: down to label75
# BB#6:                                 # %check.exit29
	i32.const	$push279=, 0
	i32.load16_u	$4=, src+4($pop279):p2align=2
	i32.const	$push278=, 0
	i32.load	$0=, src($pop278):p2align=4
	i32.const	$push277=, 0
	i32.const	$push276=, 0
	i32.load8_u	$push16=, src+6($pop276):p2align=1
	i32.store8	$discard=, dst+6($pop277):p2align=1, $pop16
	i32.const	$push275=, 0
	i32.store16	$discard=, dst+4($pop275):p2align=2, $4
	i32.const	$push274=, 0
	i32.store	$discard=, dst($pop274):p2align=4, $0
	i32.const	$push273=, dst
	i32.const	$push272=, src
	i32.const	$push17=, 7
	i32.call	$push18=, memcmp@FUNCTION, $pop273, $pop272, $pop17
	br_if   	4, $pop18       # 4: down to label74
# BB#7:                                 # %check.exit33
	i32.const	$push285=, 0
	i32.const	$push284=, 0
	i32.load8_u	$push19=, src+8($pop284):p2align=3
	i32.store8	$discard=, dst+8($pop285):p2align=3, $pop19
	i32.const	$push283=, 0
	i32.const	$push282=, 0
	i64.load	$push20=, src($pop282):p2align=4
	i64.store	$discard=, dst($pop283):p2align=4, $pop20
	i32.const	$push281=, dst
	i32.const	$push280=, src
	i32.const	$push21=, 9
	i32.call	$push22=, memcmp@FUNCTION, $pop281, $pop280, $pop21
	br_if   	5, $pop22       # 5: down to label73
# BB#8:                                 # %check.exit41
	i32.const	$push291=, 0
	i64.load	$1=, src($pop291):p2align=4
	i32.const	$push290=, 0
	i32.const	$push289=, 0
	i32.load16_u	$push23=, src+8($pop289):p2align=3
	i32.store16	$discard=, dst+8($pop290):p2align=3, $pop23
	i32.const	$push288=, 0
	i64.store	$discard=, dst($pop288):p2align=4, $1
	i32.const	$push287=, dst
	i32.const	$push286=, src
	i32.const	$push24=, 10
	i32.call	$push25=, memcmp@FUNCTION, $pop287, $pop286, $pop24
	br_if   	6, $pop25       # 6: down to label72
# BB#9:                                 # %check.exit45
	i32.const	$push299=, 0
	i32.load16_u	$4=, src+8($pop299):p2align=3
	i32.const	$push298=, 0
	i32.const	$push297=, 0
	i32.load8_u	$push26=, src+10($pop297):p2align=1
	i32.store8	$discard=, dst+10($pop298):p2align=1, $pop26
	i32.const	$push296=, 0
	i32.store16	$discard=, dst+8($pop296):p2align=3, $4
	i32.const	$push295=, 0
	i32.const	$push294=, 0
	i64.load	$push27=, src($pop294):p2align=4
	i64.store	$discard=, dst($pop295):p2align=4, $pop27
	i32.const	$push293=, dst
	i32.const	$push292=, src
	i32.const	$push28=, 11
	i32.call	$push29=, memcmp@FUNCTION, $pop293, $pop292, $pop28
	br_if   	7, $pop29       # 7: down to label71
# BB#10:                                # %check.exit49
	i32.const	$push305=, 0
	i64.load	$1=, src($pop305):p2align=4
	i32.const	$push304=, 0
	i32.const	$push303=, 0
	i32.load	$push30=, src+8($pop303):p2align=3
	i32.store	$discard=, dst+8($pop304):p2align=3, $pop30
	i32.const	$push302=, 0
	i64.store	$discard=, dst($pop302):p2align=4, $1
	i32.const	$push301=, dst
	i32.const	$push300=, src
	i32.const	$push31=, 12
	i32.call	$push32=, memcmp@FUNCTION, $pop301, $pop300, $pop31
	br_if   	8, $pop32       # 8: down to label70
# BB#11:                                # %check.exit53
	i32.const	$push313=, 0
	i32.load	$4=, src+8($pop313):p2align=3
	i32.const	$push312=, 0
	i32.const	$push311=, 0
	i32.load8_u	$push33=, src+12($pop311):p2align=2
	i32.store8	$discard=, dst+12($pop312):p2align=2, $pop33
	i32.const	$push310=, 0
	i32.store	$discard=, dst+8($pop310):p2align=3, $4
	i32.const	$push309=, 0
	i32.const	$push308=, 0
	i64.load	$push34=, src($pop308):p2align=4
	i64.store	$discard=, dst($pop309):p2align=4, $pop34
	i32.const	$push307=, dst
	i32.const	$push306=, src
	i32.const	$push35=, 13
	i32.call	$push36=, memcmp@FUNCTION, $pop307, $pop306, $pop35
	br_if   	9, $pop36       # 9: down to label69
# BB#12:                                # %check.exit57
	i32.const	$push321=, 0
	i32.load	$4=, src+8($pop321):p2align=3
	i32.const	$push320=, 0
	i64.load	$1=, src($pop320):p2align=4
	i32.const	$push319=, 0
	i32.const	$push318=, 0
	i32.load16_u	$push37=, src+12($pop318):p2align=2
	i32.store16	$discard=, dst+12($pop319):p2align=2, $pop37
	i32.const	$push317=, 0
	i32.store	$discard=, dst+8($pop317):p2align=3, $4
	i32.const	$push316=, 0
	i64.store	$discard=, dst($pop316):p2align=4, $1
	i32.const	$push315=, dst
	i32.const	$push314=, src
	i32.const	$push38=, 14
	i32.call	$push39=, memcmp@FUNCTION, $pop315, $pop314, $pop38
	br_if   	10, $pop39      # 10: down to label68
# BB#13:                                # %check.exit61
	i32.const	$push331=, 0
	i32.load16_u	$4=, src+12($pop331):p2align=2
	i32.const	$push330=, 0
	i32.load	$0=, src+8($pop330):p2align=3
	i32.const	$push329=, 0
	i32.const	$push328=, 0
	i32.load8_u	$push40=, src+14($pop328):p2align=1
	i32.store8	$discard=, dst+14($pop329):p2align=1, $pop40
	i32.const	$push327=, 0
	i32.store16	$discard=, dst+12($pop327):p2align=2, $4
	i32.const	$push326=, 0
	i32.store	$discard=, dst+8($pop326):p2align=3, $0
	i32.const	$push325=, 0
	i32.const	$push324=, 0
	i64.load	$push41=, src($pop324):p2align=4
	i64.store	$discard=, dst($pop325):p2align=4, $pop41
	i32.const	$push323=, dst
	i32.const	$push322=, src
	i32.const	$push42=, 15
	i32.call	$push43=, memcmp@FUNCTION, $pop323, $pop322, $pop42
	br_if   	11, $pop43      # 11: down to label67
# BB#14:                                # %check.exit65
	i32.const	$push337=, 0
	i64.load	$1=, src($pop337):p2align=4
	i32.const	$push336=, 0
	i32.const	$push335=, 0
	i64.load	$push44=, src+8($pop335)
	i64.store	$discard=, dst+8($pop336), $pop44
	i32.const	$push334=, 0
	i64.store	$discard=, dst($pop334):p2align=4, $1
	i32.const	$push333=, dst
	i32.const	$push332=, src
	i32.const	$push45=, 16
	i32.call	$push46=, memcmp@FUNCTION, $pop333, $pop332, $pop45
	br_if   	12, $pop46      # 12: down to label66
# BB#15:                                # %check.exit69
	i32.const	$push345=, 0
	i64.load	$1=, src+8($pop345)
	i32.const	$push344=, 0
	i32.const	$push343=, 0
	i32.load8_u	$push47=, src+16($pop343):p2align=4
	i32.store8	$discard=, dst+16($pop344):p2align=4, $pop47
	i32.const	$push342=, 0
	i64.store	$discard=, dst+8($pop342), $1
	i32.const	$push341=, 0
	i32.const	$push340=, 0
	i64.load	$push48=, src($pop340):p2align=4
	i64.store	$discard=, dst($pop341):p2align=4, $pop48
	i32.const	$push339=, dst
	i32.const	$push338=, src
	i32.const	$push49=, 17
	i32.call	$push50=, memcmp@FUNCTION, $pop339, $pop338, $pop49
	br_if   	13, $pop50      # 13: down to label65
# BB#16:                                # %check.exit73
	i32.const	$push353=, 0
	i64.load	$1=, src+8($pop353)
	i32.const	$push352=, 0
	i64.load	$2=, src($pop352):p2align=4
	i32.const	$push351=, 0
	i32.const	$push350=, 0
	i32.load16_u	$push51=, src+16($pop350):p2align=4
	i32.store16	$discard=, dst+16($pop351):p2align=4, $pop51
	i32.const	$push349=, 0
	i64.store	$discard=, dst+8($pop349), $1
	i32.const	$push348=, 0
	i64.store	$discard=, dst($pop348):p2align=4, $2
	i32.const	$push347=, dst
	i32.const	$push346=, src
	i32.const	$push52=, 18
	i32.call	$push53=, memcmp@FUNCTION, $pop347, $pop346, $pop52
	br_if   	14, $pop53      # 14: down to label64
# BB#17:                                # %check.exit77
	i32.const	$push363=, 0
	i32.load16_u	$4=, src+16($pop363):p2align=4
	i32.const	$push362=, 0
	i64.load	$1=, src+8($pop362)
	i32.const	$push361=, 0
	i32.const	$push360=, 0
	i32.load8_u	$push54=, src+18($pop360):p2align=1
	i32.store8	$discard=, dst+18($pop361):p2align=1, $pop54
	i32.const	$push359=, 0
	i32.store16	$discard=, dst+16($pop359):p2align=4, $4
	i32.const	$push358=, 0
	i64.store	$discard=, dst+8($pop358), $1
	i32.const	$push357=, 0
	i32.const	$push356=, 0
	i64.load	$push55=, src($pop356):p2align=4
	i64.store	$discard=, dst($pop357):p2align=4, $pop55
	i32.const	$push355=, dst
	i32.const	$push354=, src
	i32.const	$push56=, 19
	i32.call	$push57=, memcmp@FUNCTION, $pop355, $pop354, $pop56
	br_if   	15, $pop57      # 15: down to label63
# BB#18:                                # %check.exit81
	i32.const	$push371=, 0
	i64.load	$1=, src+8($pop371)
	i32.const	$push370=, 0
	i64.load	$2=, src($pop370):p2align=4
	i32.const	$push369=, 0
	i32.const	$push368=, 0
	i32.load	$push58=, src+16($pop368):p2align=4
	i32.store	$discard=, dst+16($pop369):p2align=4, $pop58
	i32.const	$push367=, 0
	i64.store	$discard=, dst+8($pop367), $1
	i32.const	$push366=, 0
	i64.store	$discard=, dst($pop366):p2align=4, $2
	i32.const	$push365=, dst
	i32.const	$push364=, src
	i32.const	$push59=, 20
	i32.call	$push60=, memcmp@FUNCTION, $pop365, $pop364, $pop59
	br_if   	16, $pop60      # 16: down to label62
# BB#19:                                # %check.exit85
	i32.const	$push381=, 0
	i32.load	$4=, src+16($pop381):p2align=4
	i32.const	$push380=, 0
	i64.load	$1=, src+8($pop380)
	i32.const	$push379=, 0
	i32.const	$push378=, 0
	i32.load8_u	$push61=, src+20($pop378):p2align=2
	i32.store8	$discard=, dst+20($pop379):p2align=2, $pop61
	i32.const	$push377=, 0
	i32.store	$discard=, dst+16($pop377):p2align=4, $4
	i32.const	$push376=, 0
	i64.store	$discard=, dst+8($pop376), $1
	i32.const	$push375=, 0
	i32.const	$push374=, 0
	i64.load	$push62=, src($pop374):p2align=4
	i64.store	$discard=, dst($pop375):p2align=4, $pop62
	i32.const	$push373=, dst
	i32.const	$push372=, src
	i32.const	$push63=, 21
	i32.call	$push64=, memcmp@FUNCTION, $pop373, $pop372, $pop63
	br_if   	17, $pop64      # 17: down to label61
# BB#20:                                # %check.exit89
	i32.const	$push391=, 0
	i32.load	$4=, src+16($pop391):p2align=4
	i32.const	$push390=, 0
	i64.load	$1=, src+8($pop390)
	i32.const	$push389=, 0
	i32.const	$push388=, 0
	i32.load16_u	$push65=, src+20($pop388):p2align=2
	i32.store16	$discard=, dst+20($pop389):p2align=2, $pop65
	i32.const	$push387=, 0
	i64.load	$2=, src($pop387):p2align=4
	i32.const	$push386=, 0
	i32.store	$discard=, dst+16($pop386):p2align=4, $4
	i32.const	$push385=, 0
	i64.store	$discard=, dst+8($pop385), $1
	i32.const	$push384=, 0
	i64.store	$discard=, dst($pop384):p2align=4, $2
	i32.const	$push383=, dst
	i32.const	$push382=, src
	i32.const	$push66=, 22
	i32.call	$push67=, memcmp@FUNCTION, $pop383, $pop382, $pop66
	br_if   	18, $pop67      # 18: down to label60
# BB#21:                                # %check.exit93
	i32.const	$push403=, 0
	i32.load16_u	$4=, src+20($pop403):p2align=2
	i32.const	$push402=, 0
	i32.load	$0=, src+16($pop402):p2align=4
	i32.const	$push401=, 0
	i64.load	$1=, src+8($pop401)
	i32.const	$push400=, 0
	i32.const	$push399=, 0
	i32.load8_u	$push68=, src+22($pop399):p2align=1
	i32.store8	$discard=, dst+22($pop400):p2align=1, $pop68
	i32.const	$push398=, 0
	i32.store16	$discard=, dst+20($pop398):p2align=2, $4
	i32.const	$push397=, 0
	i32.store	$discard=, dst+16($pop397):p2align=4, $0
	i32.const	$push396=, 0
	i64.store	$discard=, dst+8($pop396), $1
	i32.const	$push395=, 0
	i32.const	$push394=, 0
	i64.load	$push69=, src($pop394):p2align=4
	i64.store	$discard=, dst($pop395):p2align=4, $pop69
	i32.const	$push393=, dst
	i32.const	$push392=, src
	i32.const	$push70=, 23
	i32.call	$push71=, memcmp@FUNCTION, $pop393, $pop392, $pop70
	br_if   	19, $pop71      # 19: down to label59
# BB#22:                                # %check.exit97
	i32.const	$push411=, 0
	i64.load	$1=, src+8($pop411)
	i32.const	$push410=, 0
	i64.load	$2=, src($pop410):p2align=4
	i32.const	$push409=, 0
	i32.const	$push408=, 0
	i64.load	$push72=, src+16($pop408):p2align=4
	i64.store	$discard=, dst+16($pop409):p2align=4, $pop72
	i32.const	$push407=, 0
	i64.store	$discard=, dst+8($pop407), $1
	i32.const	$push406=, 0
	i64.store	$discard=, dst($pop406):p2align=4, $2
	i32.const	$push405=, dst
	i32.const	$push404=, src
	i32.const	$push73=, 24
	i32.call	$push74=, memcmp@FUNCTION, $pop405, $pop404, $pop73
	br_if   	20, $pop74      # 20: down to label58
# BB#23:                                # %check.exit101
	i32.const	$push421=, 0
	i64.load	$1=, src+16($pop421):p2align=4
	i32.const	$push420=, 0
	i64.load	$2=, src+8($pop420)
	i32.const	$push419=, 0
	i32.const	$push418=, 0
	i32.load8_u	$push75=, src+24($pop418):p2align=3
	i32.store8	$discard=, dst+24($pop419):p2align=3, $pop75
	i32.const	$push417=, 0
	i64.store	$discard=, dst+16($pop417):p2align=4, $1
	i32.const	$push416=, 0
	i64.store	$discard=, dst+8($pop416), $2
	i32.const	$push415=, 0
	i32.const	$push414=, 0
	i64.load	$push76=, src($pop414):p2align=4
	i64.store	$discard=, dst($pop415):p2align=4, $pop76
	i32.const	$push413=, dst
	i32.const	$push412=, src
	i32.const	$push77=, 25
	i32.call	$push78=, memcmp@FUNCTION, $pop413, $pop412, $pop77
	br_if   	21, $pop78      # 21: down to label57
# BB#24:                                # %check.exit105
	i32.const	$push431=, 0
	i64.load	$1=, src+16($pop431):p2align=4
	i32.const	$push430=, 0
	i64.load	$2=, src+8($pop430)
	i32.const	$push429=, 0
	i32.const	$push428=, 0
	i32.load16_u	$push79=, src+24($pop428):p2align=3
	i32.store16	$discard=, dst+24($pop429):p2align=3, $pop79
	i32.const	$push427=, 0
	i64.load	$3=, src($pop427):p2align=4
	i32.const	$push426=, 0
	i64.store	$discard=, dst+16($pop426):p2align=4, $1
	i32.const	$push425=, 0
	i64.store	$discard=, dst+8($pop425), $2
	i32.const	$push424=, 0
	i64.store	$discard=, dst($pop424):p2align=4, $3
	i32.const	$push423=, dst
	i32.const	$push422=, src
	i32.const	$push80=, 26
	i32.call	$push81=, memcmp@FUNCTION, $pop423, $pop422, $pop80
	br_if   	22, $pop81      # 22: down to label56
# BB#25:                                # %check.exit109
	i32.const	$push443=, 0
	i32.load16_u	$4=, src+24($pop443):p2align=3
	i32.const	$push442=, 0
	i64.load	$1=, src+16($pop442):p2align=4
	i32.const	$push441=, 0
	i64.load	$2=, src+8($pop441)
	i32.const	$push440=, 0
	i32.const	$push439=, 0
	i32.load8_u	$push82=, src+26($pop439):p2align=1
	i32.store8	$discard=, dst+26($pop440):p2align=1, $pop82
	i32.const	$push438=, 0
	i32.store16	$discard=, dst+24($pop438):p2align=3, $4
	i32.const	$push437=, 0
	i64.store	$discard=, dst+16($pop437):p2align=4, $1
	i32.const	$push436=, 0
	i64.store	$discard=, dst+8($pop436), $2
	i32.const	$push435=, 0
	i32.const	$push434=, 0
	i64.load	$push83=, src($pop434):p2align=4
	i64.store	$discard=, dst($pop435):p2align=4, $pop83
	i32.const	$push433=, dst
	i32.const	$push432=, src
	i32.const	$push84=, 27
	i32.call	$push85=, memcmp@FUNCTION, $pop433, $pop432, $pop84
	br_if   	23, $pop85      # 23: down to label55
# BB#26:                                # %check.exit113
	i32.const	$push453=, 0
	i64.load	$1=, src+16($pop453):p2align=4
	i32.const	$push452=, 0
	i64.load	$2=, src+8($pop452)
	i32.const	$push451=, 0
	i32.const	$push450=, 0
	i32.load	$push86=, src+24($pop450):p2align=3
	i32.store	$discard=, dst+24($pop451):p2align=3, $pop86
	i32.const	$push449=, 0
	i64.load	$3=, src($pop449):p2align=4
	i32.const	$push448=, 0
	i64.store	$discard=, dst+16($pop448):p2align=4, $1
	i32.const	$push447=, 0
	i64.store	$discard=, dst+8($pop447), $2
	i32.const	$push446=, 0
	i64.store	$discard=, dst($pop446):p2align=4, $3
	i32.const	$push445=, dst
	i32.const	$push444=, src
	i32.const	$push87=, 28
	i32.call	$push88=, memcmp@FUNCTION, $pop445, $pop444, $pop87
	br_if   	24, $pop88      # 24: down to label54
# BB#27:                                # %check.exit117
	i32.const	$push465=, 0
	i32.load	$4=, src+24($pop465):p2align=3
	i32.const	$push464=, 0
	i64.load	$1=, src+16($pop464):p2align=4
	i32.const	$push463=, 0
	i64.load	$2=, src+8($pop463)
	i32.const	$push462=, 0
	i32.const	$push461=, 0
	i32.load8_u	$push89=, src+28($pop461):p2align=2
	i32.store8	$discard=, dst+28($pop462):p2align=2, $pop89
	i32.const	$push460=, 0
	i32.store	$discard=, dst+24($pop460):p2align=3, $4
	i32.const	$push459=, 0
	i64.store	$discard=, dst+16($pop459):p2align=4, $1
	i32.const	$push458=, 0
	i64.store	$discard=, dst+8($pop458), $2
	i32.const	$push457=, 0
	i32.const	$push456=, 0
	i64.load	$push90=, src($pop456):p2align=4
	i64.store	$discard=, dst($pop457):p2align=4, $pop90
	i32.const	$push455=, dst
	i32.const	$push454=, src
	i32.const	$push91=, 29
	i32.call	$push92=, memcmp@FUNCTION, $pop455, $pop454, $pop91
	br_if   	25, $pop92      # 25: down to label53
# BB#28:                                # %check.exit121
	i32.const	$push93=, 0
	i32.load	$4=, src+24($pop93):p2align=3
	i32.const	$push476=, 0
	i32.const	$push475=, 0
	i32.load16_u	$push94=, src+28($pop475):p2align=2
	i32.store16	$discard=, dst+28($pop476):p2align=2, $pop94
	i32.const	$push474=, 0
	i64.load	$1=, src+16($pop474):p2align=4
	i32.const	$push473=, 0
	i64.load	$2=, src+8($pop473)
	i32.const	$push472=, 0
	i32.store	$discard=, dst+24($pop472):p2align=3, $4
	i32.const	$push471=, 0
	i64.load	$3=, src($pop471):p2align=4
	i32.const	$push470=, 0
	i64.store	$discard=, dst+16($pop470):p2align=4, $1
	i32.const	$push469=, 0
	i64.store	$discard=, dst+8($pop469), $2
	i32.const	$push468=, 0
	i64.store	$discard=, dst($pop468):p2align=4, $3
	i32.const	$push467=, dst
	i32.const	$push466=, src
	i32.const	$push95=, 30
	i32.call	$push96=, memcmp@FUNCTION, $pop467, $pop466, $pop95
	br_if   	26, $pop96      # 26: down to label52
# BB#29:                                # %check.exit125
	i32.const	$push97=, dst
	i32.const	$push481=, src
	i32.const	$push98=, 31
	i32.call	$push480=, memcpy@FUNCTION, $pop97, $pop481, $pop98
	tee_local	$push479=, $4=, $pop480
	i32.const	$push478=, src
	i32.const	$push477=, 31
	i32.call	$push99=, memcmp@FUNCTION, $pop479, $pop478, $pop477
	br_if   	27, $pop99      # 27: down to label51
# BB#30:                                # %check.exit129
	i32.const	$push100=, 0
	i64.load	$1=, src+16($pop100):p2align=4
	i32.const	$push489=, 0
	i64.load	$2=, src+8($pop489)
	i32.const	$push488=, 0
	i32.const	$push487=, 0
	i64.load	$push101=, src+24($pop487)
	i64.store	$discard=, dst+24($pop488), $pop101
	i32.const	$push486=, 0
	i64.load	$3=, src($pop486):p2align=4
	i32.const	$push485=, 0
	i64.store	$discard=, dst+16($pop485):p2align=4, $1
	i32.const	$push484=, 0
	i64.store	$discard=, dst+8($pop484), $2
	i32.const	$push483=, 0
	i64.store	$discard=, dst($pop483):p2align=4, $3
	i32.const	$push482=, src
	i32.const	$push102=, 32
	i32.call	$push103=, memcmp@FUNCTION, $4, $pop482, $pop102
	br_if   	28, $pop103     # 28: down to label50
# BB#31:                                # %check.exit133
	i32.const	$push104=, dst
	i32.const	$push494=, src
	i32.const	$push105=, 33
	i32.call	$push493=, memcpy@FUNCTION, $pop104, $pop494, $pop105
	tee_local	$push492=, $4=, $pop493
	i32.const	$push491=, src
	i32.const	$push490=, 33
	i32.call	$push106=, memcmp@FUNCTION, $pop492, $pop491, $pop490
	br_if   	29, $pop106     # 29: down to label49
# BB#32:                                # %check.exit137
	i32.const	$push497=, src
	i32.const	$push107=, 34
	i32.call	$push108=, memcpy@FUNCTION, $4, $pop497, $pop107
	i32.const	$push496=, src
	i32.const	$push495=, 34
	i32.call	$push109=, memcmp@FUNCTION, $pop108, $pop496, $pop495
	br_if   	30, $pop109     # 30: down to label48
# BB#33:                                # %check.exit141
	i32.const	$push110=, dst
	i32.const	$push502=, src
	i32.const	$push111=, 35
	i32.call	$push501=, memcpy@FUNCTION, $pop110, $pop502, $pop111
	tee_local	$push500=, $4=, $pop501
	i32.const	$push499=, src
	i32.const	$push498=, 35
	i32.call	$push112=, memcmp@FUNCTION, $pop500, $pop499, $pop498
	br_if   	31, $pop112     # 31: down to label47
# BB#34:                                # %check.exit145
	i32.const	$push505=, src
	i32.const	$push113=, 36
	i32.call	$push114=, memcpy@FUNCTION, $4, $pop505, $pop113
	i32.const	$push504=, src
	i32.const	$push503=, 36
	i32.call	$push115=, memcmp@FUNCTION, $pop114, $pop504, $pop503
	br_if   	32, $pop115     # 32: down to label46
# BB#35:                                # %check.exit149
	i32.const	$push116=, dst
	i32.const	$push510=, src
	i32.const	$push117=, 37
	i32.call	$push509=, memcpy@FUNCTION, $pop116, $pop510, $pop117
	tee_local	$push508=, $4=, $pop509
	i32.const	$push507=, src
	i32.const	$push506=, 37
	i32.call	$push118=, memcmp@FUNCTION, $pop508, $pop507, $pop506
	br_if   	33, $pop118     # 33: down to label45
# BB#36:                                # %check.exit153
	i32.const	$push513=, src
	i32.const	$push119=, 38
	i32.call	$push120=, memcpy@FUNCTION, $4, $pop513, $pop119
	i32.const	$push512=, src
	i32.const	$push511=, 38
	i32.call	$push121=, memcmp@FUNCTION, $pop120, $pop512, $pop511
	br_if   	34, $pop121     # 34: down to label44
# BB#37:                                # %check.exit157
	i32.const	$push122=, dst
	i32.const	$push518=, src
	i32.const	$push123=, 39
	i32.call	$push517=, memcpy@FUNCTION, $pop122, $pop518, $pop123
	tee_local	$push516=, $4=, $pop517
	i32.const	$push515=, src
	i32.const	$push514=, 39
	i32.call	$push124=, memcmp@FUNCTION, $pop516, $pop515, $pop514
	br_if   	35, $pop124     # 35: down to label43
# BB#38:                                # %check.exit161
	i32.const	$push521=, src
	i32.const	$push125=, 40
	i32.call	$push126=, memcpy@FUNCTION, $4, $pop521, $pop125
	i32.const	$push520=, src
	i32.const	$push519=, 40
	i32.call	$push127=, memcmp@FUNCTION, $pop126, $pop520, $pop519
	br_if   	36, $pop127     # 36: down to label42
# BB#39:                                # %check.exit165
	i32.const	$push128=, dst
	i32.const	$push526=, src
	i32.const	$push129=, 41
	i32.call	$push525=, memcpy@FUNCTION, $pop128, $pop526, $pop129
	tee_local	$push524=, $4=, $pop525
	i32.const	$push523=, src
	i32.const	$push522=, 41
	i32.call	$push130=, memcmp@FUNCTION, $pop524, $pop523, $pop522
	br_if   	37, $pop130     # 37: down to label41
# BB#40:                                # %check.exit169
	i32.const	$push529=, src
	i32.const	$push131=, 42
	i32.call	$push132=, memcpy@FUNCTION, $4, $pop529, $pop131
	i32.const	$push528=, src
	i32.const	$push527=, 42
	i32.call	$push133=, memcmp@FUNCTION, $pop132, $pop528, $pop527
	br_if   	38, $pop133     # 38: down to label40
# BB#41:                                # %check.exit173
	i32.const	$push134=, dst
	i32.const	$push534=, src
	i32.const	$push135=, 43
	i32.call	$push533=, memcpy@FUNCTION, $pop134, $pop534, $pop135
	tee_local	$push532=, $4=, $pop533
	i32.const	$push531=, src
	i32.const	$push530=, 43
	i32.call	$push136=, memcmp@FUNCTION, $pop532, $pop531, $pop530
	br_if   	39, $pop136     # 39: down to label39
# BB#42:                                # %check.exit177
	i32.const	$push537=, src
	i32.const	$push137=, 44
	i32.call	$push138=, memcpy@FUNCTION, $4, $pop537, $pop137
	i32.const	$push536=, src
	i32.const	$push535=, 44
	i32.call	$push139=, memcmp@FUNCTION, $pop138, $pop536, $pop535
	br_if   	40, $pop139     # 40: down to label38
# BB#43:                                # %check.exit181
	i32.const	$push140=, dst
	i32.const	$push542=, src
	i32.const	$push141=, 45
	i32.call	$push541=, memcpy@FUNCTION, $pop140, $pop542, $pop141
	tee_local	$push540=, $4=, $pop541
	i32.const	$push539=, src
	i32.const	$push538=, 45
	i32.call	$push142=, memcmp@FUNCTION, $pop540, $pop539, $pop538
	br_if   	41, $pop142     # 41: down to label37
# BB#44:                                # %check.exit185
	i32.const	$push545=, src
	i32.const	$push143=, 46
	i32.call	$push144=, memcpy@FUNCTION, $4, $pop545, $pop143
	i32.const	$push544=, src
	i32.const	$push543=, 46
	i32.call	$push145=, memcmp@FUNCTION, $pop144, $pop544, $pop543
	br_if   	42, $pop145     # 42: down to label36
# BB#45:                                # %check.exit189
	i32.const	$push146=, dst
	i32.const	$push550=, src
	i32.const	$push147=, 47
	i32.call	$push549=, memcpy@FUNCTION, $pop146, $pop550, $pop147
	tee_local	$push548=, $4=, $pop549
	i32.const	$push547=, src
	i32.const	$push546=, 47
	i32.call	$push148=, memcmp@FUNCTION, $pop548, $pop547, $pop546
	br_if   	43, $pop148     # 43: down to label35
# BB#46:                                # %check.exit193
	i32.const	$push553=, src
	i32.const	$push149=, 48
	i32.call	$push150=, memcpy@FUNCTION, $4, $pop553, $pop149
	i32.const	$push552=, src
	i32.const	$push551=, 48
	i32.call	$push151=, memcmp@FUNCTION, $pop150, $pop552, $pop551
	br_if   	44, $pop151     # 44: down to label34
# BB#47:                                # %check.exit197
	i32.const	$push152=, dst
	i32.const	$push558=, src
	i32.const	$push153=, 49
	i32.call	$push557=, memcpy@FUNCTION, $pop152, $pop558, $pop153
	tee_local	$push556=, $4=, $pop557
	i32.const	$push555=, src
	i32.const	$push554=, 49
	i32.call	$push154=, memcmp@FUNCTION, $pop556, $pop555, $pop554
	br_if   	45, $pop154     # 45: down to label33
# BB#48:                                # %check.exit201
	i32.const	$push561=, src
	i32.const	$push155=, 50
	i32.call	$push156=, memcpy@FUNCTION, $4, $pop561, $pop155
	i32.const	$push560=, src
	i32.const	$push559=, 50
	i32.call	$push157=, memcmp@FUNCTION, $pop156, $pop560, $pop559
	br_if   	46, $pop157     # 46: down to label32
# BB#49:                                # %check.exit205
	i32.const	$push158=, dst
	i32.const	$push566=, src
	i32.const	$push159=, 51
	i32.call	$push565=, memcpy@FUNCTION, $pop158, $pop566, $pop159
	tee_local	$push564=, $4=, $pop565
	i32.const	$push563=, src
	i32.const	$push562=, 51
	i32.call	$push160=, memcmp@FUNCTION, $pop564, $pop563, $pop562
	br_if   	47, $pop160     # 47: down to label31
# BB#50:                                # %check.exit209
	i32.const	$push569=, src
	i32.const	$push161=, 52
	i32.call	$push162=, memcpy@FUNCTION, $4, $pop569, $pop161
	i32.const	$push568=, src
	i32.const	$push567=, 52
	i32.call	$push163=, memcmp@FUNCTION, $pop162, $pop568, $pop567
	br_if   	48, $pop163     # 48: down to label30
# BB#51:                                # %check.exit213
	i32.const	$push164=, dst
	i32.const	$push574=, src
	i32.const	$push165=, 53
	i32.call	$push573=, memcpy@FUNCTION, $pop164, $pop574, $pop165
	tee_local	$push572=, $4=, $pop573
	i32.const	$push571=, src
	i32.const	$push570=, 53
	i32.call	$push166=, memcmp@FUNCTION, $pop572, $pop571, $pop570
	br_if   	49, $pop166     # 49: down to label29
# BB#52:                                # %check.exit217
	i32.const	$push577=, src
	i32.const	$push167=, 54
	i32.call	$push168=, memcpy@FUNCTION, $4, $pop577, $pop167
	i32.const	$push576=, src
	i32.const	$push575=, 54
	i32.call	$push169=, memcmp@FUNCTION, $pop168, $pop576, $pop575
	br_if   	50, $pop169     # 50: down to label28
# BB#53:                                # %check.exit221
	i32.const	$push170=, dst
	i32.const	$push582=, src
	i32.const	$push171=, 55
	i32.call	$push581=, memcpy@FUNCTION, $pop170, $pop582, $pop171
	tee_local	$push580=, $4=, $pop581
	i32.const	$push579=, src
	i32.const	$push578=, 55
	i32.call	$push172=, memcmp@FUNCTION, $pop580, $pop579, $pop578
	br_if   	51, $pop172     # 51: down to label27
# BB#54:                                # %check.exit225
	i32.const	$push585=, src
	i32.const	$push173=, 56
	i32.call	$push174=, memcpy@FUNCTION, $4, $pop585, $pop173
	i32.const	$push584=, src
	i32.const	$push583=, 56
	i32.call	$push175=, memcmp@FUNCTION, $pop174, $pop584, $pop583
	br_if   	52, $pop175     # 52: down to label26
# BB#55:                                # %check.exit229
	i32.const	$push176=, dst
	i32.const	$push590=, src
	i32.const	$push177=, 57
	i32.call	$push589=, memcpy@FUNCTION, $pop176, $pop590, $pop177
	tee_local	$push588=, $4=, $pop589
	i32.const	$push587=, src
	i32.const	$push586=, 57
	i32.call	$push178=, memcmp@FUNCTION, $pop588, $pop587, $pop586
	br_if   	53, $pop178     # 53: down to label25
# BB#56:                                # %check.exit233
	i32.const	$push593=, src
	i32.const	$push179=, 58
	i32.call	$push180=, memcpy@FUNCTION, $4, $pop593, $pop179
	i32.const	$push592=, src
	i32.const	$push591=, 58
	i32.call	$push181=, memcmp@FUNCTION, $pop180, $pop592, $pop591
	br_if   	54, $pop181     # 54: down to label24
# BB#57:                                # %check.exit237
	i32.const	$push182=, dst
	i32.const	$push598=, src
	i32.const	$push183=, 59
	i32.call	$push597=, memcpy@FUNCTION, $pop182, $pop598, $pop183
	tee_local	$push596=, $4=, $pop597
	i32.const	$push595=, src
	i32.const	$push594=, 59
	i32.call	$push184=, memcmp@FUNCTION, $pop596, $pop595, $pop594
	br_if   	55, $pop184     # 55: down to label23
# BB#58:                                # %check.exit241
	i32.const	$push601=, src
	i32.const	$push185=, 60
	i32.call	$push186=, memcpy@FUNCTION, $4, $pop601, $pop185
	i32.const	$push600=, src
	i32.const	$push599=, 60
	i32.call	$push187=, memcmp@FUNCTION, $pop186, $pop600, $pop599
	br_if   	56, $pop187     # 56: down to label22
# BB#59:                                # %check.exit245
	i32.const	$push188=, dst
	i32.const	$push606=, src
	i32.const	$push189=, 61
	i32.call	$push605=, memcpy@FUNCTION, $pop188, $pop606, $pop189
	tee_local	$push604=, $4=, $pop605
	i32.const	$push603=, src
	i32.const	$push602=, 61
	i32.call	$push190=, memcmp@FUNCTION, $pop604, $pop603, $pop602
	br_if   	57, $pop190     # 57: down to label21
# BB#60:                                # %check.exit249
	i32.const	$push609=, src
	i32.const	$push191=, 62
	i32.call	$push192=, memcpy@FUNCTION, $4, $pop609, $pop191
	i32.const	$push608=, src
	i32.const	$push607=, 62
	i32.call	$push193=, memcmp@FUNCTION, $pop192, $pop608, $pop607
	br_if   	58, $pop193     # 58: down to label20
# BB#61:                                # %check.exit253
	i32.const	$push194=, dst
	i32.const	$push614=, src
	i32.const	$push195=, 63
	i32.call	$push613=, memcpy@FUNCTION, $pop194, $pop614, $pop195
	tee_local	$push612=, $4=, $pop613
	i32.const	$push611=, src
	i32.const	$push610=, 63
	i32.call	$push196=, memcmp@FUNCTION, $pop612, $pop611, $pop610
	br_if   	59, $pop196     # 59: down to label19
# BB#62:                                # %check.exit257
	i32.const	$push617=, src
	i32.const	$push197=, 64
	i32.call	$push198=, memcpy@FUNCTION, $4, $pop617, $pop197
	i32.const	$push616=, src
	i32.const	$push615=, 64
	i32.call	$push199=, memcmp@FUNCTION, $pop198, $pop616, $pop615
	br_if   	60, $pop199     # 60: down to label18
# BB#63:                                # %check.exit261
	i32.const	$push200=, dst
	i32.const	$push622=, src
	i32.const	$push201=, 65
	i32.call	$push621=, memcpy@FUNCTION, $pop200, $pop622, $pop201
	tee_local	$push620=, $4=, $pop621
	i32.const	$push619=, src
	i32.const	$push618=, 65
	i32.call	$push202=, memcmp@FUNCTION, $pop620, $pop619, $pop618
	br_if   	61, $pop202     # 61: down to label17
# BB#64:                                # %check.exit265
	i32.const	$push625=, src
	i32.const	$push203=, 66
	i32.call	$push204=, memcpy@FUNCTION, $4, $pop625, $pop203
	i32.const	$push624=, src
	i32.const	$push623=, 66
	i32.call	$push205=, memcmp@FUNCTION, $pop204, $pop624, $pop623
	br_if   	62, $pop205     # 62: down to label16
# BB#65:                                # %check.exit269
	i32.const	$push206=, dst
	i32.const	$push630=, src
	i32.const	$push207=, 67
	i32.call	$push629=, memcpy@FUNCTION, $pop206, $pop630, $pop207
	tee_local	$push628=, $4=, $pop629
	i32.const	$push627=, src
	i32.const	$push626=, 67
	i32.call	$push208=, memcmp@FUNCTION, $pop628, $pop627, $pop626
	br_if   	63, $pop208     # 63: down to label15
# BB#66:                                # %check.exit273
	i32.const	$push633=, src
	i32.const	$push209=, 68
	i32.call	$push210=, memcpy@FUNCTION, $4, $pop633, $pop209
	i32.const	$push632=, src
	i32.const	$push631=, 68
	i32.call	$push211=, memcmp@FUNCTION, $pop210, $pop632, $pop631
	br_if   	64, $pop211     # 64: down to label14
# BB#67:                                # %check.exit277
	i32.const	$push212=, dst
	i32.const	$push638=, src
	i32.const	$push213=, 69
	i32.call	$push637=, memcpy@FUNCTION, $pop212, $pop638, $pop213
	tee_local	$push636=, $4=, $pop637
	i32.const	$push635=, src
	i32.const	$push634=, 69
	i32.call	$push214=, memcmp@FUNCTION, $pop636, $pop635, $pop634
	br_if   	65, $pop214     # 65: down to label13
# BB#68:                                # %check.exit281
	i32.const	$push641=, src
	i32.const	$push215=, 70
	i32.call	$push216=, memcpy@FUNCTION, $4, $pop641, $pop215
	i32.const	$push640=, src
	i32.const	$push639=, 70
	i32.call	$push217=, memcmp@FUNCTION, $pop216, $pop640, $pop639
	br_if   	66, $pop217     # 66: down to label12
# BB#69:                                # %check.exit285
	i32.const	$push218=, dst
	i32.const	$push646=, src
	i32.const	$push219=, 71
	i32.call	$push645=, memcpy@FUNCTION, $pop218, $pop646, $pop219
	tee_local	$push644=, $4=, $pop645
	i32.const	$push643=, src
	i32.const	$push642=, 71
	i32.call	$push220=, memcmp@FUNCTION, $pop644, $pop643, $pop642
	br_if   	67, $pop220     # 67: down to label11
# BB#70:                                # %check.exit289
	i32.const	$push649=, src
	i32.const	$push221=, 72
	i32.call	$push222=, memcpy@FUNCTION, $4, $pop649, $pop221
	i32.const	$push648=, src
	i32.const	$push647=, 72
	i32.call	$push223=, memcmp@FUNCTION, $pop222, $pop648, $pop647
	br_if   	68, $pop223     # 68: down to label10
# BB#71:                                # %check.exit293
	i32.const	$push224=, dst
	i32.const	$push654=, src
	i32.const	$push225=, 73
	i32.call	$push653=, memcpy@FUNCTION, $pop224, $pop654, $pop225
	tee_local	$push652=, $4=, $pop653
	i32.const	$push651=, src
	i32.const	$push650=, 73
	i32.call	$push226=, memcmp@FUNCTION, $pop652, $pop651, $pop650
	br_if   	69, $pop226     # 69: down to label9
# BB#72:                                # %check.exit297
	i32.const	$push657=, src
	i32.const	$push227=, 74
	i32.call	$push228=, memcpy@FUNCTION, $4, $pop657, $pop227
	i32.const	$push656=, src
	i32.const	$push655=, 74
	i32.call	$push229=, memcmp@FUNCTION, $pop228, $pop656, $pop655
	br_if   	70, $pop229     # 70: down to label8
# BB#73:                                # %check.exit301
	i32.const	$push230=, dst
	i32.const	$push662=, src
	i32.const	$push231=, 75
	i32.call	$push661=, memcpy@FUNCTION, $pop230, $pop662, $pop231
	tee_local	$push660=, $4=, $pop661
	i32.const	$push659=, src
	i32.const	$push658=, 75
	i32.call	$push232=, memcmp@FUNCTION, $pop660, $pop659, $pop658
	br_if   	71, $pop232     # 71: down to label7
# BB#74:                                # %check.exit305
	i32.const	$push665=, src
	i32.const	$push233=, 76
	i32.call	$push234=, memcpy@FUNCTION, $4, $pop665, $pop233
	i32.const	$push664=, src
	i32.const	$push663=, 76
	i32.call	$push235=, memcmp@FUNCTION, $pop234, $pop664, $pop663
	br_if   	72, $pop235     # 72: down to label6
# BB#75:                                # %check.exit309
	i32.const	$push236=, dst
	i32.const	$push670=, src
	i32.const	$push237=, 77
	i32.call	$push669=, memcpy@FUNCTION, $pop236, $pop670, $pop237
	tee_local	$push668=, $4=, $pop669
	i32.const	$push667=, src
	i32.const	$push666=, 77
	i32.call	$push238=, memcmp@FUNCTION, $pop668, $pop667, $pop666
	br_if   	73, $pop238     # 73: down to label5
# BB#76:                                # %check.exit313
	i32.const	$push673=, src
	i32.const	$push239=, 78
	i32.call	$push240=, memcpy@FUNCTION, $4, $pop673, $pop239
	i32.const	$push672=, src
	i32.const	$push671=, 78
	i32.call	$push241=, memcmp@FUNCTION, $pop240, $pop672, $pop671
	br_if   	74, $pop241     # 74: down to label4
# BB#77:                                # %check.exit317
	i32.const	$push243=, dst
	i32.const	$push242=, src
	i32.const	$push244=, 79
	i32.call	$push245=, memcpy@FUNCTION, $pop243, $pop242, $pop244
	i32.const	$push675=, src
	i32.const	$push674=, 79
	i32.call	$push246=, memcmp@FUNCTION, $pop245, $pop675, $pop674
	br_if   	75, $pop246     # 75: down to label3
# BB#78:                                # %check.exit321
	i32.const	$push247=, 0
	return  	$pop247
.LBB1_79:                               # %if.then.i12
	end_block                       # label78:
	call    	abort@FUNCTION
	unreachable
.LBB1_80:                               # %if.then.i16
	end_block                       # label77:
	call    	abort@FUNCTION
	unreachable
.LBB1_81:                               # %if.then.i24
	end_block                       # label76:
	call    	abort@FUNCTION
	unreachable
.LBB1_82:                               # %if.then.i28
	end_block                       # label75:
	call    	abort@FUNCTION
	unreachable
.LBB1_83:                               # %if.then.i32
	end_block                       # label74:
	call    	abort@FUNCTION
	unreachable
.LBB1_84:                               # %if.then.i40
	end_block                       # label73:
	call    	abort@FUNCTION
	unreachable
.LBB1_85:                               # %if.then.i44
	end_block                       # label72:
	call    	abort@FUNCTION
	unreachable
.LBB1_86:                               # %if.then.i48
	end_block                       # label71:
	call    	abort@FUNCTION
	unreachable
.LBB1_87:                               # %if.then.i52
	end_block                       # label70:
	call    	abort@FUNCTION
	unreachable
.LBB1_88:                               # %if.then.i56
	end_block                       # label69:
	call    	abort@FUNCTION
	unreachable
.LBB1_89:                               # %if.then.i60
	end_block                       # label68:
	call    	abort@FUNCTION
	unreachable
.LBB1_90:                               # %if.then.i64
	end_block                       # label67:
	call    	abort@FUNCTION
	unreachable
.LBB1_91:                               # %if.then.i68
	end_block                       # label66:
	call    	abort@FUNCTION
	unreachable
.LBB1_92:                               # %if.then.i72
	end_block                       # label65:
	call    	abort@FUNCTION
	unreachable
.LBB1_93:                               # %if.then.i76
	end_block                       # label64:
	call    	abort@FUNCTION
	unreachable
.LBB1_94:                               # %if.then.i80
	end_block                       # label63:
	call    	abort@FUNCTION
	unreachable
.LBB1_95:                               # %if.then.i84
	end_block                       # label62:
	call    	abort@FUNCTION
	unreachable
.LBB1_96:                               # %if.then.i88
	end_block                       # label61:
	call    	abort@FUNCTION
	unreachable
.LBB1_97:                               # %if.then.i92
	end_block                       # label60:
	call    	abort@FUNCTION
	unreachable
.LBB1_98:                               # %if.then.i96
	end_block                       # label59:
	call    	abort@FUNCTION
	unreachable
.LBB1_99:                               # %if.then.i100
	end_block                       # label58:
	call    	abort@FUNCTION
	unreachable
.LBB1_100:                              # %if.then.i104
	end_block                       # label57:
	call    	abort@FUNCTION
	unreachable
.LBB1_101:                              # %if.then.i108
	end_block                       # label56:
	call    	abort@FUNCTION
	unreachable
.LBB1_102:                              # %if.then.i112
	end_block                       # label55:
	call    	abort@FUNCTION
	unreachable
.LBB1_103:                              # %if.then.i116
	end_block                       # label54:
	call    	abort@FUNCTION
	unreachable
.LBB1_104:                              # %if.then.i120
	end_block                       # label53:
	call    	abort@FUNCTION
	unreachable
.LBB1_105:                              # %if.then.i124
	end_block                       # label52:
	call    	abort@FUNCTION
	unreachable
.LBB1_106:                              # %if.then.i128
	end_block                       # label51:
	call    	abort@FUNCTION
	unreachable
.LBB1_107:                              # %if.then.i132
	end_block                       # label50:
	call    	abort@FUNCTION
	unreachable
.LBB1_108:                              # %if.then.i136
	end_block                       # label49:
	call    	abort@FUNCTION
	unreachable
.LBB1_109:                              # %if.then.i140
	end_block                       # label48:
	call    	abort@FUNCTION
	unreachable
.LBB1_110:                              # %if.then.i144
	end_block                       # label47:
	call    	abort@FUNCTION
	unreachable
.LBB1_111:                              # %if.then.i148
	end_block                       # label46:
	call    	abort@FUNCTION
	unreachable
.LBB1_112:                              # %if.then.i152
	end_block                       # label45:
	call    	abort@FUNCTION
	unreachable
.LBB1_113:                              # %if.then.i156
	end_block                       # label44:
	call    	abort@FUNCTION
	unreachable
.LBB1_114:                              # %if.then.i160
	end_block                       # label43:
	call    	abort@FUNCTION
	unreachable
.LBB1_115:                              # %if.then.i164
	end_block                       # label42:
	call    	abort@FUNCTION
	unreachable
.LBB1_116:                              # %if.then.i168
	end_block                       # label41:
	call    	abort@FUNCTION
	unreachable
.LBB1_117:                              # %if.then.i172
	end_block                       # label40:
	call    	abort@FUNCTION
	unreachable
.LBB1_118:                              # %if.then.i176
	end_block                       # label39:
	call    	abort@FUNCTION
	unreachable
.LBB1_119:                              # %if.then.i180
	end_block                       # label38:
	call    	abort@FUNCTION
	unreachable
.LBB1_120:                              # %if.then.i184
	end_block                       # label37:
	call    	abort@FUNCTION
	unreachable
.LBB1_121:                              # %if.then.i188
	end_block                       # label36:
	call    	abort@FUNCTION
	unreachable
.LBB1_122:                              # %if.then.i192
	end_block                       # label35:
	call    	abort@FUNCTION
	unreachable
.LBB1_123:                              # %if.then.i196
	end_block                       # label34:
	call    	abort@FUNCTION
	unreachable
.LBB1_124:                              # %if.then.i200
	end_block                       # label33:
	call    	abort@FUNCTION
	unreachable
.LBB1_125:                              # %if.then.i204
	end_block                       # label32:
	call    	abort@FUNCTION
	unreachable
.LBB1_126:                              # %if.then.i208
	end_block                       # label31:
	call    	abort@FUNCTION
	unreachable
.LBB1_127:                              # %if.then.i212
	end_block                       # label30:
	call    	abort@FUNCTION
	unreachable
.LBB1_128:                              # %if.then.i216
	end_block                       # label29:
	call    	abort@FUNCTION
	unreachable
.LBB1_129:                              # %if.then.i220
	end_block                       # label28:
	call    	abort@FUNCTION
	unreachable
.LBB1_130:                              # %if.then.i224
	end_block                       # label27:
	call    	abort@FUNCTION
	unreachable
.LBB1_131:                              # %if.then.i228
	end_block                       # label26:
	call    	abort@FUNCTION
	unreachable
.LBB1_132:                              # %if.then.i232
	end_block                       # label25:
	call    	abort@FUNCTION
	unreachable
.LBB1_133:                              # %if.then.i236
	end_block                       # label24:
	call    	abort@FUNCTION
	unreachable
.LBB1_134:                              # %if.then.i240
	end_block                       # label23:
	call    	abort@FUNCTION
	unreachable
.LBB1_135:                              # %if.then.i244
	end_block                       # label22:
	call    	abort@FUNCTION
	unreachable
.LBB1_136:                              # %if.then.i248
	end_block                       # label21:
	call    	abort@FUNCTION
	unreachable
.LBB1_137:                              # %if.then.i252
	end_block                       # label20:
	call    	abort@FUNCTION
	unreachable
.LBB1_138:                              # %if.then.i256
	end_block                       # label19:
	call    	abort@FUNCTION
	unreachable
.LBB1_139:                              # %if.then.i260
	end_block                       # label18:
	call    	abort@FUNCTION
	unreachable
.LBB1_140:                              # %if.then.i264
	end_block                       # label17:
	call    	abort@FUNCTION
	unreachable
.LBB1_141:                              # %if.then.i268
	end_block                       # label16:
	call    	abort@FUNCTION
	unreachable
.LBB1_142:                              # %if.then.i272
	end_block                       # label15:
	call    	abort@FUNCTION
	unreachable
.LBB1_143:                              # %if.then.i276
	end_block                       # label14:
	call    	abort@FUNCTION
	unreachable
.LBB1_144:                              # %if.then.i280
	end_block                       # label13:
	call    	abort@FUNCTION
	unreachable
.LBB1_145:                              # %if.then.i284
	end_block                       # label12:
	call    	abort@FUNCTION
	unreachable
.LBB1_146:                              # %if.then.i288
	end_block                       # label11:
	call    	abort@FUNCTION
	unreachable
.LBB1_147:                              # %if.then.i292
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
.LBB1_148:                              # %if.then.i296
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB1_149:                              # %if.then.i300
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB1_150:                              # %if.then.i304
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB1_151:                              # %if.then.i308
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB1_152:                              # %if.then.i312
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB1_153:                              # %if.then.i316
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_154:                              # %if.then.i320
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	src                     # @src
	.type	src,@object
	.section	.bss.src,"aw",@nobits
	.globl	src
	.p2align	4
src:
	.skip	80
	.size	src, 80

	.hidden	dst                     # @dst
	.type	dst,@object
	.section	.bss.dst,"aw",@nobits
	.globl	dst
	.p2align	4
dst:
	.skip	80
	.size	dst, 80


	.ident	"clang version 3.9.0 "
