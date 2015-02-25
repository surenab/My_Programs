set module HS1P
set deslib sa10n_pg4_ssl_tc_a01_p1
set env(PIPE_RERUN_ABORTED)  0
set env(PIPE_ARRAYJOBS) 0

set vlmake(max_parallel_instances) 20

set test {STV2_WRAPPER}
set verification($test) calibre
#set fdrc(CALIBRE_DRC::queryccs_metal_stack) "11M_3Mx_6Dx_1Gx_1Iz_LB"
#set fdrc(CALIBRE_DRC::queryccs_foundry_process) "c123-ss10lpe-1.8v/rel1.1"
#set fdrc(CALIBRE_DRC::options) "-hier -v_2014.3-27.21"

set fdrc(CALIBRE_DRC::ruledeck) "/slowfs/am04dwt2p018/scratch/ss10/hd1p/drc/new_deck/deck_540/DRC/cmos10lpe.drc.cal"
set fdrc(CALIBRE_DRC::options) "-hier -calex2  -v_2014.3-27.21 -bashrc_/slowfs/am04dwt2p018/scratch/ss10/hd1p/drc/new_deck/deck_540/DRC/sourceme.10lpe"

#set fdrc(CALIBRE_DRC::ruledeck)  "/remote/cad-rep/fab/f108-Samsung/10nm/logic/LPE/rules/calibre/drc/verS00-V0.5.3.0/DRC/cmos10lpe.drc.cal"
#set fdrc(CALIBRE_DRC::options) "-hier -v_2014.3-27.21 -calex2 -bashrc_/remote/cad-rep/proj/c123-ss10lpe-1.8v/rel1.0/cad/11M_3Mx_6Dx_1Gx_1Iz_LB/calibre/DRC/DRCV0530_sourceme"
#set fdrc(CALIBRE_DRC::options) "-hier -v_2014.3-27.21 -bashrc_/slowfs/am04dwt2p018/aaa/DRC/sourceme.10lpe"
set coverParams($test) {
header {memory_name		NW	NB	CM	BK	SW	center_decode	pg_enable	redundancy_enable	bist_enable	vdda_enable	periphery_Vt	write_assist wrapper_name raw_timing_data delay_equations}
	Freq  {200}
	pvt_enable {1 2 3 4 5 6 }
	viewselect  "\{ \"coord\" \}"
} 
add_inst $test  cmos10lpe_rf1apr_hs_256x32m4 256 32 4 1 0 1 1 1 1 0 LOW 0 cmos28lpp_rf1apr_hd_256x32m4 stv2_raw_del/cmos10lpe_rf1apr_hs_256x32m4.raw stv2_raw_del/cmos10lpe_rf1apr_hs_256x32m4.del
add_inst $test  cmos10lpe_rf1apr_hs_256x32m4 256 32 16 1 0 1 1 1 1 0 LOW 0 cmos28lpp_rf1apr_hd_256x32m4 stv2_raw_del/cmos10lpe_rf1apr_hs_256x32m4.raw stv2_raw_del/cmos10lpe_rf1apr_hs_256x32m4.del
add_inst $test  cmos10lpe_rf1ar_hs_3840x12m16 3840 12 4 4 0 1 0 1 1 0 LOW 0 cmos28lpp_rf1ar_hd_3840x12m16 stv2_raw_del/cmos10lpe_rf1ar_hs_3840x12m16.raw stv2_raw_del/cmos10lpe_rf1ar_hs_3840x12m16.del

add_inst       $test   cmos10lpe_rf1a_hs_128x24m4	   128     24	   4	   1	   0	   1	   0	   0	   1	   1	   LOW     0	   cmos28lpp_rf1a_hd_128x24m4	   stv2_raw_del/cmos10lpe_rf1a_hs_128x24m4.raw     stv2_raw_del/cmos10lpe_rf1a_hs_128x24m4.del
add_inst       $test   cmos10lpe_rf1a_hs_128x64m2	  128	  64	  4	  1	  0	  1	  0	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1a_hd_128x64m2	  stv2_raw_del/cmos10lpe_rf1a_hs_128x64m2.raw	  stv2_raw_del/cmos10lpe_rf1a_hs_128x64m2.del
add_inst       $test   cmos10lpe_rf1a_hs_224x48m2	  224	  48	  4	  1	  0	  1	  0	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1a_hd_224x48m2	  stv2_raw_del/cmos10lpe_rf1a_hs_224x48m2.raw	  stv2_raw_del/cmos10lpe_rf1a_hs_224x48m2.del
add_inst       $test   cmos10lpe_rf1a_hs_224x64m2	  224	  64	  4	  1	  0	  1	  0	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1a_hd_224x64m2	  stv2_raw_del/cmos10lpe_rf1a_hs_224x64m2.raw	  stv2_raw_del/cmos10lpe_rf1a_hs_224x64m2.del
add_inst       $test   cmos10lpe_rf1a_hs_256x57m4	  256	  57	  4	  1	  0	  1	  0	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1a_hd_256x57m4	  stv2_raw_del/cmos10lpe_rf1a_hs_256x57m4.raw	  stv2_raw_del/cmos10lpe_rf1a_hs_256x57m4.del
add_inst       $test   cmos10lpe_rf1a_hs_256x64m2	  256	  64	  4	  1	  0	  1	  0	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1a_hd_256x64m2	  stv2_raw_del/cmos10lpe_rf1a_hs_256x64m2.raw	  stv2_raw_del/cmos10lpe_rf1a_hs_256x64m2.del
add_inst       $test   cmos10lpe_rf1a_hs_32x32m2	  32	  32	  4	  1	  0	  1	  0	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1a_hd_32x32m2	  stv2_raw_del/cmos10lpe_rf1a_hs_32x32m2.raw	  stv2_raw_del/cmos10lpe_rf1a_hs_32x32m2.del
add_inst       $test   cmos10lpe_rf1a_hs_32x36m2	   32	   36	   4	   1	   0	   1	   0	   0	   1	   1	   LOW     0	   cmos28lpp_rf1a_hd_32x36m2	   stv2_raw_del/cmos10lpe_rf1a_hs_32x36m2.raw	   stv2_raw_del/cmos10lpe_rf1a_hs_32x36m2.del
add_inst       $test   cmos10lpe_rf1a_hs_32x64m2	  32	  64	  4	  1	  0	  1	  0	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1a_hd_32x64m2	  stv2_raw_del/cmos10lpe_rf1a_hs_32x64m2.raw	  stv2_raw_del/cmos10lpe_rf1a_hs_32x64m2.del
add_inst       $test   cmos10lpe_rf1a_hs_40x32m2	  48	  32	  4	  1	  0	  1	  0	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1a_hd_40x32m2	  stv2_raw_del/cmos10lpe_rf1a_hs_40x32m2.raw	  stv2_raw_del/cmos10lpe_rf1a_hs_40x32m2.del
add_inst       $test   cmos10lpe_rf1a_hs_52x40m2	  64	  40	  4	  1	  0	  1	  0	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1a_hd_52x40m2	  stv2_raw_del/cmos10lpe_rf1a_hs_52x40m2.raw	  stv2_raw_del/cmos10lpe_rf1a_hs_52x40m2.del
add_inst       $test   cmos10lpe_rf1a_hs_52x64m2	  64	  64	  4	  1	  0	  1	  0	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1a_hd_52x64m2	  stv2_raw_del/cmos10lpe_rf1a_hs_52x64m2.raw	  stv2_raw_del/cmos10lpe_rf1a_hs_52x64m2.del
add_inst       $test   cmos10lpe_rf1a_hs_56x32m2	  64	  32	  4	  1	  0	  1	  0	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1a_hd_56x32m2	  stv2_raw_del/cmos10lpe_rf1a_hs_56x32m2.raw	  stv2_raw_del/cmos10lpe_rf1a_hs_56x32m2.del
add_inst       $test   cmos10lpe_rf1a_hs_576x32m8	  576	  32	  4	  1	  0	  1	  0	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1a_hd_576x32m8	  stv2_raw_del/cmos10lpe_rf1a_hs_576x32m8.raw	  stv2_raw_del/cmos10lpe_rf1a_hs_576x32m8.del
add_inst       $test   cmos10lpe_rf1a_hs_64x40m2	  64	  40	  4	  1	  0	  1	  0	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1a_hd_64x40m2	  stv2_raw_del/cmos10lpe_rf1a_hs_64x40m2.raw	  stv2_raw_del/cmos10lpe_rf1a_hs_64x40m2.del
add_inst       $test   cmos10lpe_rf1a_hs_80x64m2	  80	  64	  4	  1	  0	  1	  0	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1a_hd_80x64m2	  stv2_raw_del/cmos10lpe_rf1a_hs_80x64m2.raw	  stv2_raw_del/cmos10lpe_rf1a_hs_80x64m2.del
add_inst       $test   cmos10lpe_rf1a_hs_96x32m2	  96	  32	  4	  1	  0	  1	  0	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1a_hd_96x32m2	  stv2_raw_del/cmos10lpe_rf1a_hs_96x32m2.raw	  stv2_raw_del/cmos10lpe_rf1a_hs_96x32m2.del
add_inst       $test   cmos10lpe_rf1a_hs_96x36m2	  96	  36	  4	  1	  0	  1	  0	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1a_hd_96x36m2	  stv2_raw_del/cmos10lpe_rf1a_hs_96x36m2.raw	  stv2_raw_del/cmos10lpe_rf1a_hs_96x36m2.del
add_inst       $test   cmos10lpe_rf1a_hs_96x48m2	  96	  48	  4	  1	  0	  1	  0	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1a_hd_96x48m2	  stv2_raw_del/cmos10lpe_rf1a_hs_96x48m2.raw	  stv2_raw_del/cmos10lpe_rf1a_hs_96x48m2.del
add_inst       $test   cmos10lpe_rf1a_hs_96x64m2	  96	  64	  4	  1	  0	  1	  0	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1a_hd_96x64m2	  stv2_raw_del/cmos10lpe_rf1a_hs_96x64m2.raw	  stv2_raw_del/cmos10lpe_rf1a_hs_96x64m2.del
add_inst       $test   cmos10lpe_rf1apr_hs_256x32m4	  256	  32	  4	  1	  0	  1	  1	  1	  1	  1	  LOW	  0	  cmos28lpp_rf1apr_hd_256x32m4    stv2_raw_del/cmos10lpe_rf1apr_hs_256x32m4.raw   stv2_raw_del/cmos10lpe_rf1apr_hs_256x32m4.del
add_inst       $test   cmos10lpe_rf1apr_hs_688x32m4	  688	  32	  4	  1	  0	  1	  1	  1	  1	  1	  LOW	  0	  cmos28lpp_rf1apr_hd_688x32m4    stv2_raw_del/cmos10lpe_rf1apr_hs_688x32m4.raw   stv2_raw_del/cmos10lpe_rf1apr_hs_688x32m4.del
add_inst       $test   cmos10lpe_rf1ar_hs_256x128m2	  256	  128	  4	  1	  0	  1	  0	  1	  1	  1	  LOW	  0	  cmos28lpp_rf1ar_hd_256x128m2    stv2_raw_del/cmos10lpe_rf1ar_hs_256x128m2.raw   stv2_raw_del/cmos10lpe_rf1ar_hs_256x128m2.del
add_inst       $test   cmos10lpe_rf1ar_hs_256x16m4	  256	  16	  4	  1	  0	  1	  0	  1	  1	  1	  LOW	  0	  cmos28lpp_rf1ar_hd_256x16m4	  stv2_raw_del/cmos10lpe_rf1ar_hs_256x16m4.raw    stv2_raw_del/cmos10lpe_rf1ar_hs_256x16m4.del
add_inst       $test   cmos10lpe_rf1ar_hs_256x64m4	  256	  64	  4	  1	  0	  1	  0	  1	  1	  1	  LOW	  0	  cmos28lpp_rf1ar_hd_256x64m4	  stv2_raw_del/cmos10lpe_rf1ar_hs_256x64m4.raw    stv2_raw_del/cmos10lpe_rf1ar_hs_256x64m4.del
add_inst       $test   cmos10lpe_rf1ar_hs_512x16m4	  512	  16	  4	  1	  0	  1	  0	  1	  1	  1	  LOW	  0	  cmos28lpp_rf1ar_hd_512x16m4	  stv2_raw_del/cmos10lpe_rf1ar_hs_512x16m4.raw    stv2_raw_del/cmos10lpe_rf1ar_hs_512x16m4.del
add_inst       $test   cmos10lpe_rf1rwa_hs_1024x64m8_b32       1024    64      4       1       1       1       0       1       1       1       LOW     0       cmos28lpp_rf1rwa_hd_1024x64m8_b32       stv2_raw_del/cmos10lpe_rf1rwa_hs_1024x64m8_b32.raw      stv2_raw_del/cmos10lpe_rf1rwa_hs_1024x64m8_b32.del
add_inst       $test   cmos10lpe_rf1rwa_hs_960x16m8_b1         960     16      4       1       1       1       0       1       1       1       LOW     0       cmos28lpp_rf1rwa_hd_960x16m8_b1 stv2_raw_del/cmos10lpe_rf1rwa_hs_960x16m8_b1.raw        stv2_raw_del/cmos10lpe_rf1rwa_hs_960x16m8_b1.del
add_inst       $test   cmos10lpe_rf1rwa_hs_960x20m8_b1         960     20      4       1       1       1       0       1       1       1       LOW     0       cmos28lpp_rf1rwa_hd_960x20m8_b1 stv2_raw_del/cmos10lpe_rf1rwa_hs_960x20m8_b1.raw        stv2_raw_del/cmos10lpe_rf1rwa_hs_960x20m8_b1.del
add_inst       $test   cmos10lpe_rf1wa_hs_512x32m8_b1	  512	  32	  4	  1	  1	  1	  0	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1wa_hd_512x32m8_b1  stv2_raw_del/cmos10lpe_rf1wa_hs_512x32m8_b1.raw stv2_raw_del/cmos10lpe_rf1wa_hs_512x32m8_b1.del
add_inst       $test   cmos10lpe_rf1wa_hs_512x64m8_b1	  512	  64	  4	  1	  1	  1	  0	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1wa_hd_512x64m8_b1  stv2_raw_del/cmos10lpe_rf1wa_hs_512x64m8_b1.raw stv2_raw_del/cmos10lpe_rf1wa_hs_512x64m8_b1.del
add_inst       $test   cmos10lpe_rf1wa_hs_80x128m2_b1	  80	  128	  4	  1	  1	  1	  0	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1wa_hd_80x128m2_b1  stv2_raw_del/cmos10lpe_rf1wa_hs_80x128m2_b1.raw stv2_raw_del/cmos10lpe_rf1wa_hs_80x128m2_b1.del
add_inst       $test   cmos10lpe_rf1wa_hs_96x64m4_b1	  96	  64	  4	  1	  1	  1	  0	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1wa_hd_96x64m4_b1   stv2_raw_del/cmos10lpe_rf1wa_hs_96x64m4_b1.raw  stv2_raw_del/cmos10lpe_rf1wa_hs_96x64m4_b1.del
add_inst       $test   cmos10lpe_rf1ar_hs_1024x68m8	  1024    68	  4	  1	  0	  1	  0	  1	  1	  1	  LOW	  0	  cmos28lpp_ra1ar_hd_1024x68m8    stv2_raw_del/cmos10lpe_rf1ar_hs_1024x68m8.raw   stv2_raw_del/cmos10lpe_rf1ar_hs_1024x68m8.del
add_inst       $test   cmos10lpe_rf1war_hs_1024x72m8_b1        1024    72      4       1       1       1       0       1       1       1       LOW     0       cmos28lpp_ra1war_hd_1024x72m8_b1        stv2_raw_del/cmos10lpe_rf1war_hs_1024x72m8_b1.raw       stv2_raw_del/cmos10lpe_rf1war_hs_1024x72m8_b1.del
add_inst       $test   cmos10lpe_rf1war_hs_1024x96m8_b1        1024    96      4       1       1       1       0       1       1       1       LOW     0       cmos28lpp_ra1war_hd_1024x96m8_b1        stv2_raw_del/cmos10lpe_rf1war_hs_1024x96m8_b1.raw       stv2_raw_del/cmos10lpe_rf1war_hs_1024x96m8_b1.del
add_inst       $test   cmos10lpe_rf1_hs_256x25m4	  256	  25	  4	  1	  0	  1	  0	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1_hs_256x25m4	  stv2_raw_del/cmos10lpe_rf1_hs_256x25m4.raw	  stv2_raw_del/cmos10lpe_rf1_hs_256x25m4.del
add_inst       $test   cmos10lpe_rf1_hsl_1024x36m8	  1024    36	  4	  1	  0	  1	  0	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1_hsl_1024x36m8	  stv2_raw_del/cmos10lpe_rf1_hsl_1024x36m8.raw    stv2_raw_del/cmos10lpe_rf1_hsl_1024x36m8.del
add_inst       $test   cmos10lpe_rf1_hsl_256x25m4	  256	  25	  4	  1	  0	  1	  0	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1_hsl_256x25m4	  stv2_raw_del/cmos10lpe_rf1_hsl_256x25m4.raw	  stv2_raw_del/cmos10lpe_rf1_hsl_256x25m4.del
add_inst       $test   cmos10lpe_rf1_hsl_256x32m4	  256	  32	  4	  1	  0	  1	  0	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1_hsl_256x32m4	  stv2_raw_del/cmos10lpe_rf1_hsl_256x32m4.raw	  stv2_raw_del/cmos10lpe_rf1_hsl_256x32m4.del
add_inst       $test   cmos10lpe_rf1_hsl_256x36m4	  256	  36	  4	  1	  0	  1	  0	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1_hsl_256x36m4	  stv2_raw_del/cmos10lpe_rf1_hsl_256x36m4.raw	  stv2_raw_del/cmos10lpe_rf1_hsl_256x36m4.del
add_inst       $test   cmos10lpe_rf1_hsl_64x69m4	  64	  69	  4	  1	  0	  1	  0	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1_hsl_64x69m4	  stv2_raw_del/cmos10lpe_rf1_hsl_64x69m4.raw	  stv2_raw_del/cmos10lpe_rf1_hsl_64x69m4.del
add_inst       $test   cmos10lpe_rf1ap_hs_128x128m2	  128	  128	  4	  1	  0	  1	  1	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1ap_hd_128x128m2    stv2_raw_del/cmos10lpe_rf1ap_hs_128x128m2.raw   stv2_raw_del/cmos10lpe_rf1ap_hs_128x128m2.del
add_inst       $test   cmos10lpe_rf1ap_hs_128x130m2	  128	  130	  4	  1	  0	  1	  1	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1ap_hd_128x130m2    stv2_raw_del/cmos10lpe_rf1ap_hs_128x130m2.raw   stv2_raw_del/cmos10lpe_rf1ap_hs_128x130m2.del
add_inst       $test   cmos10lpe_rf1ap_hs_128x64m2	  128	  64	  4	  1	  0	  1	  1	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1ap_hd_128x64m2	  stv2_raw_del/cmos10lpe_rf1ap_hs_128x64m2.raw    stv2_raw_del/cmos10lpe_rf1ap_hs_128x64m2.del
add_inst       $test   cmos10lpe_rf1ap_hs_32x106m2	  32	  106	  4	  1	  0	  1	  1	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1ap_hd_32x106m2	  stv2_raw_del/cmos10lpe_rf1ap_hs_32x106m2.raw    stv2_raw_del/cmos10lpe_rf1ap_hs_32x106m2.del
add_inst       $test   cmos10lpe_rf1ap_hs_32x128m2	  32	  128	  4	  1	  0	  1	  1	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1ap_hd_32x128m2	  stv2_raw_del/cmos10lpe_rf1ap_hs_32x128m2.raw    stv2_raw_del/cmos10lpe_rf1ap_hs_32x128m2.del
add_inst       $test   cmos10lpe_rf1ap_hs_32x42m2	  32	  42	  4	  1	  0	  1	  1	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1ap_hd_32x42m2	  stv2_raw_del/cmos10lpe_rf1ap_hs_32x42m2.raw	  stv2_raw_del/cmos10lpe_rf1ap_hs_32x42m2.del
add_inst       $test   cmos10lpe_rf1ap_hs_32x64m2	  32	  64	  4	  1	  0	  1	  1	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1ap_hd_32x64m2	  stv2_raw_del/cmos10lpe_rf1ap_hs_32x64m2.raw	  stv2_raw_del/cmos10lpe_rf1ap_hs_32x64m2.del
add_inst       $test   cmos10lpe_rf1ap_hs_32x80m2	  32	  80	  4	  1	  0	  1	  1	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1ap_hd_32x80m2	  stv2_raw_del/cmos10lpe_rf1ap_hs_32x80m2.raw	  stv2_raw_del/cmos10lpe_rf1ap_hs_32x80m2.del
add_inst       $test   cmos10lpe_rf1ap_hs_32x94m2	  32	  94	  4	  1	  0	  1	  1	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1ap_hd_32x94m2	  stv2_raw_del/cmos10lpe_rf1ap_hs_32x94m2.raw	  stv2_raw_del/cmos10lpe_rf1ap_hs_32x94m2.del
add_inst       $test   cmos10lpe_rf1ap_hs_44x60m2	  48	  60	  4	  1	  0	  1	  1	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1ap_hd_44x60m2	  stv2_raw_del/cmos10lpe_rf1ap_hs_44x60m2.raw	  stv2_raw_del/cmos10lpe_rf1ap_hs_44x60m2.del
add_inst       $test   cmos10lpe_rf1ap_hs_512x128m2	  512	  128	  4	  1	  0	  1	  1	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1ap_hd_512x128m2    stv2_raw_del/cmos10lpe_rf1ap_hs_512x128m2.raw   stv2_raw_del/cmos10lpe_rf1ap_hs_512x128m2.del
add_inst       $test   cmos10lpe_rf1ap_hs_512x30m2	  512	  30	  4	  1	  0	  1	  1	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1ap_hd_512x30m2	  stv2_raw_del/cmos10lpe_rf1ap_hs_512x30m2.raw    stv2_raw_del/cmos10lpe_rf1ap_hs_512x30m2.del
add_inst       $test   cmos10lpe_rf1apw_hs_32x144m2_b9         32      144     4       1       1       1       1       0       1       1       LOW     0       cmos28lpp_rf1apw_hd_32x144m2_b9 stv2_raw_del/cmos10lpe_rf1apw_hs_32x144m2_b9.raw        stv2_raw_del/cmos10lpe_rf1apw_hs_32x144m2_b9.del
add_inst       $test   cmos10lpe_rf1apw_hs_32x40m2_b10         32      40      4       1       1       1       1       0       1       1       LOW     0       cmos28lpp_rf1apw_hd_32x40m2_b10 stv2_raw_del/cmos10lpe_rf1apw_hs_32x40m2_b10.raw        stv2_raw_del/cmos10lpe_rf1apw_hs_32x40m2_b10.del
add_inst       $test   cmos10lpe_rf1ar_hs_256x16m2	  256	  16	  4	  1	  0	  1	  0	  1	  1	  1	  LOW	  0	  cmos28lpp_rf1ar_hd_256x16m2	  stv2_raw_del/cmos10lpe_rf1ar_hs_256x16m2.raw    stv2_raw_del/cmos10lpe_rf1ar_hs_256x16m2.del
add_inst       $test   cmos10lpe_rf1ar_hs_256x21m8	  256	  21	  4	  1	  0	  1	  0	  1	  1	  1	  LOW	  0	  cmos28lpp_rf1ar_hd_256x21m8	  stv2_raw_del/cmos10lpe_rf1ar_hs_256x21m8.raw    stv2_raw_del/cmos10lpe_rf1ar_hs_256x21m8.del
add_inst       $test   cmos10lpe_rf1ar_hs_256x24m8	  256	  24	  4	  1	  0	  1	  0	  1	  1	  1	  LOW	  0	  cmos28lpp_rf1ar_hd_256x24m8	  stv2_raw_del/cmos10lpe_rf1ar_hs_256x24m8.raw    stv2_raw_del/cmos10lpe_rf1ar_hs_256x24m8.del
add_inst       $test   cmos10lpe_rf1ar_hs_256x8m8	  256	  8	  4	  1	  0	  1	  0	  1	  1	  1	  LOW	  0	  cmos28lpp_rf1ar_hd_256x8m8	  stv2_raw_del/cmos10lpe_rf1ar_hs_256x8m8.raw	  stv2_raw_del/cmos10lpe_rf1ar_hs_256x8m8.del
add_inst       $test   cmos10lpe_rf1ar_hs_32x64m2	  32	  64	  4	  1	  0	  1	  0	  1	  1	  1	  LOW	  0	  cmos28lpp_rf1ar_hd_32x64m2	  stv2_raw_del/cmos10lpe_rf1ar_hs_32x64m2.raw	  stv2_raw_del/cmos10lpe_rf1ar_hs_32x64m2.del
add_inst       $test   cmos10lpe_rf1ar_hs_480x64m4	  480	  64	  4	  1	  0	  1	  0	  1	  1	  1	  LOW	  0	  cmos28lpp_rf1ar_hd_480x64m4	  stv2_raw_del/cmos10lpe_rf1ar_hs_480x64m4.raw    stv2_raw_del/cmos10lpe_rf1ar_hs_480x64m4.del
add_inst       $test   cmos10lpe_rf1ar_hs_64x64m2	  64	  64	  4	  1	  0	  1	  0	  1	  1	  1	  LOW	  0	  cmos28lpp_rf1ar_hd_64x64m2	  stv2_raw_del/cmos10lpe_rf1ar_hs_64x64m2.raw	  stv2_raw_del/cmos10lpe_rf1ar_hs_64x64m2.del
add_inst       $test   cmos10lpe_rf1ar_hs_72x18m2	 80	 18	 4	 1	 0	 1	 0	 1	 1	 1	 LOW	 0	 cmos28lpp_rf1ar_hd_72x18m2	 stv2_raw_del/cmos10lpe_rf1ar_hs_72x18m2.raw	 stv2_raw_del/cmos10lpe_rf1ar_hs_72x18m2.del
add_inst       $test   cmos10lpe_rf1ar_hs_72x24m2	 80	 24	 4	 1	 0	 1	 0	 1	 1	 1	 LOW	 0	 cmos28lpp_rf1ar_hd_72x24m2	 stv2_raw_del/cmos10lpe_rf1ar_hs_72x24m2.raw	 stv2_raw_del/cmos10lpe_rf1ar_hs_72x24m2.del
add_inst       $test   cmos10lpe_rf1ar_hs_80x13m4	 80	 13	 4	 1	 0	 1	 0	 1	 1	 1	 LOW	 0	 cmos28lpp_rf1ar_hd_80x13m4	 stv2_raw_del/cmos10lpe_rf1ar_hs_80x13m4.raw	 stv2_raw_del/cmos10lpe_rf1ar_hs_80x13m4.del
add_inst       $test   cmos10lpe_rf1ar_hs_832x48m8	 832	 48	 4	 1	 0	 1	 0	 1	 1	 1	 LOW	 0	 cmos28lpp_rf1ar_hd_832x48m8	 stv2_raw_del/cmos10lpe_rf1ar_hs_832x48m8.raw	 stv2_raw_del/cmos10lpe_rf1ar_hs_832x48m8.del
add_inst       $test   cmos10lpe_rf1ar_hs_960x24m8	 960	 24	 4	 1	 0	 1	 0	 1	 1	 1	 LOW	 0	 cmos28lpp_rf1ar_hd_960x24m8	 stv2_raw_del/cmos10lpe_rf1ar_hs_960x24m8.raw	 stv2_raw_del/cmos10lpe_rf1ar_hs_960x24m8.del
add_inst       $test   cmos10lpe_rf1ar_hs_960x32m8	 960	 32	 4	 1	 0	 1	 0	 1	 1	 1	 LOW	 0	 cmos28lpp_rf1ar_hd_960x32m8	 stv2_raw_del/cmos10lpe_rf1ar_hs_960x32m8.raw	 stv2_raw_del/cmos10lpe_rf1ar_hs_960x32m8.del
add_inst       $test   cmos10lpe_rf1ar_hs_992x34m8	 992	 34	 4	 1	 0	 1	 0	 1	 1	 1	 LOW	 0	 cmos28lpp_rf1ar_hd_992x34m8	 stv2_raw_del/cmos10lpe_rf1ar_hs_992x34m8.raw	 stv2_raw_del/cmos10lpe_rf1ar_hs_992x34m8.del
add_inst       $test   cmos10lpe_rf1ar_hs_992x48m8	 992	 48	 4	 1	 0	 1	 0	 1	 1	 1	 LOW	 0	 cmos28lpp_rf1ar_hd_992x48m8	 stv2_raw_del/cmos10lpe_rf1ar_hs_992x48m8.raw	 stv2_raw_del/cmos10lpe_rf1ar_hs_992x48m8.del
add_inst       $test   cmos10lpe_rf1ar_hs_128x22m2	 128	 22	 4	 1	 0	 1	 0	 1	 1	 1	 LOW	 0	 cmos28lpp_rf1ar_hs_128x22m2	 stv2_raw_del/cmos10lpe_rf1ar_hs_128x22m2.raw	 stv2_raw_del/cmos10lpe_rf1ar_hs_128x22m2.del
add_inst       $test   cmos10lpe_rf1ar_hs_256x23m4	 256	 23	 4	 1	 0	 1	 0	 1	 1	 1	 LOW	 0	 cmos28lpp_rf1ar_hs_256x23m4	 stv2_raw_del/cmos10lpe_rf1ar_hs_256x23m4.raw	 stv2_raw_del/cmos10lpe_rf1ar_hs_256x23m4.del
add_inst       $test   cmos10lpe_rf1ar_hs_64x63m4	64	63	4	1	0	1	0	1	1	1	LOW	0	cmos28lpp_rf1ar_hs_64x63m4	stv2_raw_del/cmos10lpe_rf1ar_hs_64x63m4.raw	stv2_raw_del/cmos10lpe_rf1ar_hs_64x63m4.del
add_inst       $test   cmos10lpe_rf1awr_hs_1024x32m4_b8        1024    32      4       1       1       1       0       1       1       1       LOW     0       cmos28lpp_rf1awr_hs_1024x32m4_b8        stv2_raw_del/cmos10lpe_rf1awr_hs_1024x32m4_b8.raw       stv2_raw_del/cmos10lpe_rf1awr_hs_1024x32m4_b8.del
add_inst       $test   cmos10lpe_rf1awr_hs_1024x72m4_b9        1024    72      4       1       1       1       0       1       1       1       LOW     0       cmos28lpp_rf1awr_hs_1024x72m4_b9        stv2_raw_del/cmos10lpe_rf1awr_hs_1024x72m4_b9.raw       stv2_raw_del/cmos10lpe_rf1awr_hs_1024x72m4_b9.del
add_inst       $test   cmos10lpe_rf1awr_hs_128x12m2_b1         128     12      4       1       1       1       0       1       1       1       LOW     0       cmos28lpp_rf1awr_hs_128x12m2_b1 stv2_raw_del/cmos10lpe_rf1awr_hs_128x12m2_b1.raw        stv2_raw_del/cmos10lpe_rf1awr_hs_128x12m2_b1.del
add_inst       $test   cmos10lpe_rf1w_hs_256x16m4	 256	 16	 4	 1	 1	 1	 0	 0	 1	 1	 LOW	 0	 cmos28lpp_rf1w_hs_256x16m4	 stv2_raw_del/cmos10lpe_rf1w_hs_256x16m4.raw	 stv2_raw_del/cmos10lpe_rf1w_hs_256x16m4.del
add_inst       $test   cmos10lpe_rf1w_hsl_1024x36m8	 1024	 36	 4	 1	 1	 1	 0	 0	 1	 1	 LOW	 0	 cmos28lpp_rf1w_hsl_1024x36m8	 stv2_raw_del/cmos10lpe_rf1w_hsl_1024x36m8.raw   stv2_raw_del/cmos10lpe_rf1w_hsl_1024x36m8.del
add_inst       $test   cmos10lpe_rf1w_hsl_256x16m4	 256	 16	 4	 1	 1	 1	 0	 0	 1	 1	 LOW	 0	 cmos28lpp_rf1w_hsl_256x16m4	 stv2_raw_del/cmos10lpe_rf1w_hsl_256x16m4.raw	 stv2_raw_del/cmos10lpe_rf1w_hsl_256x16m4.del
add_inst       $test   cmos10lpe_rf1w_hsl_256x27m4	 256	 27	 4	 1	 1	 1	 0	 0	 1	 1	 LOW	 0	 cmos28lpp_rf1w_hsl_256x27m4	 stv2_raw_del/cmos10lpe_rf1w_hsl_256x27m4.raw	 stv2_raw_del/cmos10lpe_rf1w_hsl_256x27m4.del
add_inst       $test   cmos10lpe_rf1w_hsl_256x32m4	 256	 32	 4	 1	 1	 1	 0	 0	 1	 1	 LOW	 0	 cmos28lpp_rf1w_hsl_256x32m4	 stv2_raw_del/cmos10lpe_rf1w_hsl_256x32m4.raw	 stv2_raw_del/cmos10lpe_rf1w_hsl_256x32m4.del
add_inst       $test   cmos10lpe_rf1w_hsl_512x8m4	 512	 8	 4	 1	 1	 1	 0	 0	 1	 1	 LOW	 0	 cmos28lpp_rf1w_hsl_512x8m4	 stv2_raw_del/cmos10lpe_rf1w_hsl_512x8m4.raw	 stv2_raw_del/cmos10lpe_rf1w_hsl_512x8m4.del
add_inst       $test   cmos10lpe_rf1war_hs_192x88m4_b1         192     88      4       1       1       1       0       1       1       1       LOW     0       cmos28lpp_rf1war_hd_192x88m4_b1 stv2_raw_del/cmos10lpe_rf1war_hs_192x88m4_b1.raw        stv2_raw_del/cmos10lpe_rf1war_hs_192x88m4_b1.del
add_inst       $test   cmos10lpe_rf1war_hs_384x88m4_b1         384     88      4       1       1       1       0       1       1       1       LOW     0       cmos28lpp_rf1war_hd_384x88m4_b1 stv2_raw_del/cmos10lpe_rf1war_hs_384x88m4_b1.raw        stv2_raw_del/cmos10lpe_rf1war_hs_384x88m4_b1.del
add_inst       $test   cmos10lpe_rf1war_hs_480x96m4_b1         480     96      4       1       1       1       0       1       1       1       LOW     0       cmos28lpp_rf1war_hd_480x96m4_b1 stv2_raw_del/cmos10lpe_rf1war_hs_480x96m4_b1.raw        stv2_raw_del/cmos10lpe_rf1war_hs_480x96m4_b1.del
add_inst       $test   cmos10lpe_rf1war_hs_960x48m8_b1         960     48      4       1       1       1       0       1       1       1       LOW     0       cmos28lpp_rf1war_hd_960x48m8_b1 stv2_raw_del/cmos10lpe_rf1war_hs_960x48m8_b1.raw        stv2_raw_del/cmos10lpe_rf1war_hs_960x48m8_b1.del
add_inst       $test   cmos10lpe_rf1ar_hs_1920x24m8	 1920	 24	 4	 2	 0	 1	 0	 1	 1	 1	 LOW	 0	 cmos28lpp_rf1ar_hd_1920x24m8	 stv2_raw_del/cmos10lpe_rf1ar_hs_1920x24m8.raw   stv2_raw_del/cmos10lpe_rf1ar_hs_1920x24m8.del
add_inst       $test   cmos10lpe_rf1ar_hs_1920x64m8	 1920	 64	 4	 2	 0	 1	 0	 1	 1	 1	 LOW	 0	 cmos28lpp_rf1ar_hd_1920x64m8	 stv2_raw_del/cmos10lpe_rf1ar_hs_1920x64m8.raw   stv2_raw_del/cmos10lpe_rf1ar_hs_1920x64m8.del
add_inst       $test   cmos10lpe_rf1ra_hs_1920x64m8	 1920	 64	 4	 2	 0	 1	 0	 1	 1	 1	 LOW	 0	 cmos28lpp_rf1ra_hd_1920x64m8	 stv2_raw_del/cmos10lpe_rf1ra_hs_1920x64m8.raw   stv2_raw_del/cmos10lpe_rf1ra_hs_1920x64m8.del
add_inst       $test   cmos10lpe_rf1rpa_hs_2048x32m8	 2048	 32	 4	 2	 0	 1	 1	 1	 1	 1	 LOW	 0	 cmos28lpp_rf1rpa_hd_2048x32m8   stv2_raw_del/cmos10lpe_rf1rpa_hs_2048x32m8.raw  stv2_raw_del/cmos10lpe_rf1rpa_hs_2048x32m8.del
add_inst       $test   cmos10lpe_rf1ar_hs_1056x24m8	 1056	 24	 4	 2	 0	 1	 0	 1	 1	 1	 LOW	 0	 cmos28lpp_ra1ar_hd_1056x24m8	 stv2_raw_del/cmos10lpe_rf1ar_hs_1056x24m8.raw   stv2_raw_del/cmos10lpe_rf1ar_hs_1056x24m8.del
add_inst       $test   cmos10lpe_rf1ar_hs_1056x48m8	 1056	 48	 4	 2	 0	 1	 0	 1	 1	 1	 LOW	 0	 cmos28lpp_ra1ar_hd_1056x48m8	 stv2_raw_del/cmos10lpe_rf1ar_hs_1056x48m8.raw   stv2_raw_del/cmos10lpe_rf1ar_hs_1056x48m8.del
add_inst       $test   cmos10lpe_rf1war_hs_1056x96m8_b1        1056    96      4       2       1       1       0       1       1       1       LOW     0       cmos28lpp_ra1war_hd_1056x96m8_b1        stv2_raw_del/cmos10lpe_rf1war_hs_1056x96m8_b1.raw       stv2_raw_del/cmos10lpe_rf1war_hs_1056x96m8_b1.del
add_inst       $test   cmos10lpe_rf1war_hs_1920x72m8_b1        1920    72      4       2       1       1       0       1       1       1       LOW     0       cmos28lpp_ra1war_hd_1920x72m8_b1        stv2_raw_del/cmos10lpe_rf1war_hs_1920x72m8_b1.raw       stv2_raw_del/cmos10lpe_rf1war_hs_1920x72m8_b1.del
add_inst       $test   cmos10lpe_rf1wpa_hs_2048x20m16	 2048	 20	 4	 2	 1	 1	 1	 0	 1	 1	 LOW	 0	 cmos28lpp_ra1wpa_hd_2048x20m16  stv2_raw_del/cmos10lpe_rf1wpa_hs_2048x20m16.raw stv2_raw_del/cmos10lpe_rf1wpa_hs_2048x20m16.del
add_inst       $test   cmos10lpe_rf1wpa_hs_2048x20m8	 2048	 20	 4	 2	 1	 1	 1	 0	 1	 1	 LOW	 0	 cmos28lpp_ra1wpa_hd_2048x20m8   stv2_raw_del/cmos10lpe_rf1wpa_hs_2048x20m8.raw  stv2_raw_del/cmos10lpe_rf1wpa_hs_2048x20m8.del
add_inst       $test   cmos10lpe_rf1ar_hs_1920x12m16	 1920	 12	 4	 2	 0	 1	 0	 1	 1	 1	 LOW	 0	 cmos28lpp_rf1ar_hd_1920x12m16   stv2_raw_del/cmos10lpe_rf1ar_hs_1920x12m16.raw  stv2_raw_del/cmos10lpe_rf1ar_hs_1920x12m16.del
add_inst       $test   cmos10lpe_rf1ar_hs_1920x20m8	 1920	 20	 4	 2	 0	 1	 0	 1	 1	 1	 LOW	 0	 cmos28lpp_rf1ar_hd_1920x20m8	 stv2_raw_del/cmos10lpe_rf1ar_hs_1920x20m8.raw   stv2_raw_del/cmos10lpe_rf1ar_hs_1920x20m8.del
add_inst       $test   cmos10lpe_rf1ar_hs_1920x32m8	 1920	 32	 4	 2	 0	 1	 0	 1	 1	 1	 LOW	 0	 cmos28lpp_rf1ar_hd_1920x32m8	 stv2_raw_del/cmos10lpe_rf1ar_hs_1920x32m8.raw   stv2_raw_del/cmos10lpe_rf1ar_hs_1920x32m8.del
add_inst       $test   cmos10lpe_rf1ar_hs_1952x34m8	 1952	 34	 4	 2	 0	 1	 0	 1	 1	 1	 LOW	 0	 cmos28lpp_rf1ar_hd_1952x34m8	 stv2_raw_del/cmos10lpe_rf1ar_hs_1952x34m8.raw   stv2_raw_del/cmos10lpe_rf1ar_hs_1952x34m8.del
add_inst       $test   cmos10lpe_ra1aprw_hs_2048x128m8_b32     2048    128     4       4       1       1       1       1       1       1       LOW     0       cmos28lpp_ra1aprw_hd_2048x128m8_b32     stv2_raw_del/cmos10lpe_ra1aprw_hs_2048x128m8_b32.raw    stv2_raw_del/cmos10lpe_ra1aprw_hs_2048x128m8_b32.del
add_inst       $test   cmos10lpe_rf1ar_hs_3840x12m16	 3840	 12	 4	 4	 0	 1	 0	 1	 1	 1	 LOW	 0	 cmos28lpp_rf1ar_hd_3840x12m16   stv2_raw_del/cmos10lpe_rf1ar_hs_3840x12m16.raw  stv2_raw_del/cmos10lpe_rf1ar_hs_3840x12m16.del
add_inst       $test   cmos10lpe_rf1ar_hs_3840x8m16	 3840	 8	 4	 4	 0	 1	 0	 1	 1	 1	 LOW	 0	 cmos28lpp_rf1ar_hd_3840x8m16	 stv2_raw_del/cmos10lpe_rf1ar_hs_3840x8m16.raw   stv2_raw_del/cmos10lpe_rf1ar_hs_3840x8m16.del
add_inst       $test   cmos10lpe_rf1ar_hs_2112x20m8	 2112	 20	 4	 4	 0	 1	 0	 1	 1	 1	 LOW	 0	 cmos28lpp_rf1ar_hd_2112x20m8	 stv2_raw_del/cmos10lpe_rf1ar_hs_2112x20m8.raw   stv2_raw_del/cmos10lpe_rf1ar_hs_2112x20m8.del
add_inst       $test   cmos10lpe_rf1ar_hs_2112x32m8	 2112	 32	 4	 4	 0	 1	 0	 1	 1	 1	 LOW	 0	 cmos28lpp_rf1ar_hd_2112x32m8	 stv2_raw_del/cmos10lpe_rf1ar_hs_2112x32m8.raw   stv2_raw_del/cmos10lpe_rf1ar_hs_2112x32m8.del
add_inst       $test   cmos10lpe_rf1ar_hs_2112x12m8	 2112	 12	 4	 4	 0	 1	 0	 1	 1	 1	 LOW	 0	 cmos28lpp_ra1ar_hd_2112x12m8	 stv2_raw_del/cmos10lpe_rf1ar_hs_2112x12m8.raw   stv2_raw_del/cmos10lpe_rf1ar_hs_2112x12m8.del
add_inst       $test   cmos10lpe_rf1rwpa_hs_4096x64m8	 4096	 64	 4	 4	 1	 1	 1	 1	 1	 1	 LOW	 0	 cmos28lpp_ra1rwpa_hd_4096x64m8  stv2_raw_del/cmos10lpe_rf1rwpa_hs_4096x64m8.raw stv2_raw_del/cmos10lpe_rf1rwpa_hs_4096x64m8.del
add_inst       $test   cmos10lpe_rf1rwpa_hs_4096x64m8_w8       4096    64      4       4       1       1       1       1       1       1       LOW     0       cmos28lpp_ra1rwpa_hd_4096x64m8_w8       stv2_raw_del/cmos10lpe_rf1rwpa_hs_4096x64m8_w8.raw      stv2_raw_del/cmos10lpe_rf1rwpa_hs_4096x64m8_w8.del
add_inst       $test   cmos10lpe_ra1aprw_hs_2080x128m8_b32     2112    128     4       4       1       1       1       1       1       1       LOW     0       cmos28lpp_ra1aprw_hs_2080x128m8_b32     stv2_raw_del/cmos10lpe_ra1aprw_hs_2080x128m8_b32.raw    stv2_raw_del/cmos10lpe_ra1aprw_hs_2080x128m8_b32.del
add_inst       $test   cmos10lpe_rf1rwa_hs_2112x16m8_b1        2112    16      4       4       1       1       0       1       1       1       LOW     0       cmos28lpp_rf1rwa_hd_2112x16m8_b1        stv2_raw_del/cmos10lpe_rf1rwa_hs_2112x16m8_b1.raw       stv2_raw_del/cmos10lpe_rf1rwa_hs_2112x16m8_b1.del
add_inst       $test   cmos10lpe_rf1rwa_hs_2112x20m8_b1        2112    20      4       4       1       1       0       1       1       1       LOW     0       cmos28lpp_rf1rwa_hd_2112x20m8_b1        stv2_raw_del/cmos10lpe_rf1rwa_hs_2112x20m8_b1.raw       stv2_raw_del/cmos10lpe_rf1rwa_hs_2112x20m8_b1.del
add_inst       $test   cmos10lpe_rf1ar_hs_3840x64m8	 3840	 64	 4	 4	 0	 1	 0	 1	 1	 1	 LOW	 0	 cmos28lpp_rf1ar_hd_3840x64m8	 stv2_raw_del/cmos10lpe_rf1ar_hs_3840x64m8.raw   stv2_raw_del/cmos10lpe_rf1ar_hs_3840x64m8.del
add_inst       $test   cmos10lpe_rf1awr_hs_2112x16m8_b1        2112    16      4       4       1       1       0       1       1       1       LOW     0       cmos28lpp_rf1awr_hd_2112x16m8_b1        stv2_raw_del/cmos10lpe_rf1awr_hs_2112x16m8_b1.raw       stv2_raw_del/cmos10lpe_rf1awr_hs_2112x16m8_b1.del
add_inst       $test   cmos10lpe_rf1awr_hs_2112x20m8_b1        2112    20      4       4       1       1       0       1       1       1       LOW     0       cmos28lpp_rf1awr_hd_2112x20m8_b1        stv2_raw_del/cmos10lpe_rf1awr_hs_2112x20m8_b1.raw       stv2_raw_del/cmos10lpe_rf1awr_hs_2112x20m8_b1.del
add_inst       $test   cmos10lpe_rf1ra_hs_3840x64m8	 3840	 64	 4	 4	 0	 1	 0	 1	 1	 1	 LOW	 0	 cmos28lpp_rf1ra_hd_3840x64m8	 stv2_raw_del/cmos10lpe_rf1ra_hs_3840x64m8.raw   stv2_raw_del/cmos10lpe_rf1ra_hs_3840x64m8.del
add_inst       $test   cmos10lpe_rf1rwa_hs_8192x32m16_b8       8192    32      4       8       1       1       0       1       1       1       LOW     0       cmos28lpp_rf1rwa_hd_8192x32m16_b8       stv2_raw_del/cmos10lpe_rf1rwa_hs_8192x32m16_b8.raw      stv2_raw_del/cmos10lpe_rf1rwa_hs_8192x32m16_b8.del

add_inst       $test   cmos10lpe_rf1rpa_hs_7936x35m16	 7936	 35	 4	 8	 0	 1	 1	 1	 1	 1	 LOW	 0	 cmos28lpp_rf1rpa_hd_7936x35m16  stv2_raw_del/cmos10lpe_rf1rpa_hs_7936x35m16.raw stv2_raw_del/cmos10lpe_rf1rpa_hs_7936x35m16.del

add_inst       $test   cmos10lpe_rf1ar_hs_4224x8m16	 4224	 8	 4	 8	 0	 1	 0	 1	 1	 1	 LOW	 0	 cmos28lpp_rf1ar_hd_4224x8m16	 stv2_raw_del/cmos10lpe_rf1ar_hs_4224x8m16.raw   stv2_raw_del/cmos10lpe_rf1ar_hs_4224x8m16.del
add_inst       $test   cmos10lpe_rf1a_hs_1024x64m8	  1024     64	   4	   1	   0	   1	   0	   0	   1	   1	   LOW     0	   cmos28lpp_rf1a_hd_1024x64m8     stv2_raw_del/cmos10lpe_rf1a_hs_1024x64m8.raw    stv2_raw_del/cmos10lpe_rf1a_hs_1024x64m8.del


add_inst       $test   cmos10lpe_rf1a_hs_1088x6m16	   1088     6	    16      1	    0	    1	    0	    0	    1	    1	    LOW     0	    cmos28lpp_rf1a_hd_1088x6m16     stv2_raw_del/cmos10lpe_rf1a_hs_1088x6m16.raw    stv2_raw_del/cmos10lpe_rf1a_hs_1088x6m16.del
add_inst       $test   cmos10lpe_rf1a_hs_576x4m8	    576     4	    16      1	    0	    1	    0	    0	    1	    1	    LOW     0	    cmos28lpp_rf1a_hd_576x4m8	    stv2_raw_del/cmos10lpe_rf1a_hs_576x4m8.raw      stv2_raw_del/cmos10lpe_rf1a_hs_576x4m8.del
add_inst       $test   cmos10lpe_rf1rwpa_hs_16384x32m16_b8     16384   32      16      8       1       1       1       0       1       1       LOW     0       cmos28lpp_rf1rwpa_hd_16384x32m16_b8     stv2_raw_del/cmos10lpe_rf1rwpa_hs_16384x32m16_b8.raw    stv2_raw_del/cmos10lpe_rf1rwpa_hs_16384x32m16_b8.del
add_inst       $test   cmos10lpe_rf1a_hs_128x17m4	  128	  17	  4	  1	  0	  1	  0	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1a_hd_128x17m4	  stv2_raw_del/cmos10lpe_rf1a_hs_128x17m4.raw	  stv2_raw_del/cmos10lpe_rf1a_hs_128x17m4.del
add_inst       $test   cmos10lpe_rf1a_hs_128x7m4	  128	  7	  4	  1	  0	  1	  0	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1a_hd_128x7m4	  stv2_raw_del/cmos10lpe_rf1a_hs_128x7m4.raw	  stv2_raw_del/cmos10lpe_rf1a_hs_128x7m4.del
add_inst       $test   cmos10lpe_rf1a_hs_208x16m2	  208	  16	  4	  1	  0	  1	  0	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1a_hd_208x16m2	  stv2_raw_del/cmos10lpe_rf1a_hs_208x16m2.raw	  stv2_raw_del/cmos10lpe_rf1a_hs_208x16m2.del
add_inst       $test   cmos10lpe_rf1a_hs_224x16m2	  224	  16	  4	  1	  0	  1	  0	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1a_hd_224x16m2	  stv2_raw_del/cmos10lpe_rf1a_hs_224x16m2.raw	  stv2_raw_del/cmos10lpe_rf1a_hs_224x16m2.del
add_inst       $test   cmos10lpe_rf1a_hs_224x8m4	  224	  8	  4	  1	  0	  1	  0	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1a_hd_224x8m4	  stv2_raw_del/cmos10lpe_rf1a_hs_224x8m4.raw	  stv2_raw_del/cmos10lpe_rf1a_hs_224x8m4.del
add_inst       $test   cmos10lpe_rf1a_hs_256x8m4	  256	  8	  4	  1	  0	  1	  0	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1a_hd_256x8m4	  stv2_raw_del/cmos10lpe_rf1a_hs_256x8m4.raw	  stv2_raw_del/cmos10lpe_rf1a_hs_256x8m4.del
add_inst       $test   cmos10lpe_rf1a_hs_64x16m2	  64	  16	  4	  1	  0	  1	  0	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1a_hd_64x16m2	  stv2_raw_del/cmos10lpe_rf1a_hs_64x16m2.raw	  stv2_raw_del/cmos10lpe_rf1a_hs_64x16m2.del
add_inst       $test   cmos10lpe_rf1ap_hs_32x20m2	  32	  20	  4	  1	  0	  1	  1	  0	  1	  1	  LOW	  0	  cmos28lpp_rf1ap_hd_32x20m2	  stv2_raw_del/cmos10lpe_rf1ap_hs_32x20m2.raw	  stv2_raw_del/cmos10lpe_rf1ap_hs_32x20m2.del




#####signal enabling parameters#####
set plugin_param(LEFCHECK::enable_signal_pin_start_check) {true}
set plugin_param(LEFCHECK::enable_signal_routing_grid_check) {true}
set plugin_param(LEFCHECK::enable_signal_pin_metal_check) {true}
set plugin_param(LEFCHECK::enable_signal_pin_name_check) {true}
set plugin_param(LEFCHECK::signal_direction) {horizontal}
set plugin_param(LEFCHECK::enable_signal_pin_size_check) {true}
set plugin_param(LEFCHECK::signal_pin_size) {0.048 0.11}
#####power enabling parameters#####
set plugin_param(LEFCHECK::enable_power_pin_width_check) "true"
set plugin_param(LEFCHECK::power_pin_width) { 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.16 0.2}
set plugin_param(LEFCHECK::power_direction) {horizontal}
set plugin_param(LEFCHECK::enable_power_pin_height_check) {true}
set plugin_param(LEFCHECK::power_pin_min_height) {5}
#####instance enabling parameters#####
set plugin_param(LEFCHECK::enable_modular_grid_check) {true}
set plugin_param(LEFCHECK::instance_size_modulo) {0.048 0.336 }
set plugin_param(LEFCHECK::enable_power_pin_rectangular_check) {true}
set plugin_param(LEFCHECK::enable_signal_pin_rectangular_check) {true}
#####blockages enabling parameters#####
set plugin_param(LEFCHECK::enable_power_pin_block_overlap_check) {false}
set plugin_param(LEFCHECK::enable_signal_pin_block_overlap_check) {true}
#####previous parameters#####
set plugin_param(LEFCHECK::enable_rectangular_blockage_check) {false}
set plugin_param(LEFCHECK::enable_routing_porosity_check) {false}
set plugin_param(LEFCHECK::enable_exposed_blockage_check) {false}
set plugin_param(LEFCHECK::enable_exposed_metal_check) {true}
set plugin_param(LEFCHECK::porosity_threshold_vertical)  0.5
set plugin_param(LEFCHECK::porosity_threshold_horizontal)  0.5
