@echo on
data_convert_MLK_S2.exe D:\ZLPro\RPC_Code2Data\GF3SAR\SLC\ D:\ZLPro\RPC_Code2Data\GF3SAR\SLC\C3\ 4288 0 0 5702 4288 1 C3 2 3
@rem --1. ����׼��
@rem --1.1 ͷ�ļ�׼��
::GF3_PolSAR_PAR_Reader_v3.1.exe  GF3_SAY_QPSI_016460_E118.3_N41.7_20190925_L1A_AHV_L10004266581.meta.xml slc.par
@rem --1.2 �����ļ�
::swap_bytes  s11.bin    hh.slc.dat  4

@rem --2. ���䶨�괦��(����radarsat2���Բ�����Ҫ��һ���裬���ݵ���ʱ�Ѷ��꣩
@rem ������һ�����SLC�а���һ��60db���������ӣ���ˣ���Ҫ�ڶ��ӻ�������ȥ��)
@rem ::radcal_SLC hh.slc.dat hh.slc.par hh.cslc.dat hh.cslc.par 4 - 0 0 1 60 

@rem --3. ���ӻ���������0.000001��ȥ��60db�������ӣ��õ���ȷ��ǿ�����ݣ�
::multi_look hh.slc.dat slc.par hh.mli.dat hh.mli.par 2 3
@rem --4. ����demͷ�ļ�
::create_dem_par dem.par slc.par 1300 -25 25 

@rem ----GEC-----
@rem --5. gecע���ز������ӣ�Ĭ��Ϊ2����������ı�ֱ���
::gec_map  hh.mli.par - dem.par 1300 dem.seg.par lookup_table.dat 1 1 

@rem --6. ����gec���ɵĲ��ұ����е������
::geocode_back hh.mli.dat 1072  lookup_table.dat hh.mli.gec.dat  1182  0  0  0  
::data2geotiff dem.seg.par hh.mli.gec.dat 2 hh.mli.gec.dat.tif 0.0 
@rem ----GEC end-----

@rem ----GTC-----
@rem --7. dem׼����a.�ߵ�λת����Host->Network b.���ն�
::swap_bytes dem30envi.dat dem30.dat 4
::interp_ad dem30.dat dem30.i.dat 2848 32

@rem --8. gc_map��ʼ�����ұ�����dem��ز�Ʒ
@rem ::del dem.seg.par dem.seg.dat  dem.seg.hdr (ע��ɾ���ϵ�seg����ļ�)
::del dem.seg.par
::gc_map hh.mli.par - dem30.par dem30.dat dem.seg.par dem.seg.dat lookup_table.gc.dat 2 2 sim_sar u v inc psi pix lsmap 
::sim.sar.dat u.dat v.dat inc.dat psi.dat pix.dat ls_map.dat  



::data2geotiff dem.seg.par psi 2 psi.dat.tif 0.0
::data2geotiff dem.seg.par inc 2 inc.dat.tif 0.0

::interp_ad u.dat u.i.dat 1986 16
::interp_ad v.dat v.i.dat 1986 16
::interp_ad pix.dat pix.i.dat 1986 16
::interp_ad psi.dat psi.i.dat 1986 16
::interp_ad inc.dat inc.i.dat 1986 16

::swap_bytes fltinc.angle.mli.dat fltinc.angle.mli.s.dat 4
::geocode_back fltinc.angle.mli.s.dat 2144  lookup_table.gc.fine.dat fltinc.angle.mli.s.gc.dat  2968  3171  0  0 

::geocode_back hh.mli.dat 1072  lookup_table.gc.dat hh.mli.gc.dat  1188  0  0  0  
::data2geotiff dem.seg.par hh.mli.gc.dat 2 hh.mli.gc.dat.tif 0.0 
::geocode_back PauliRGB.bmp 2144  lookup_table.gc.dat PauliRGB.gc.bmp  1978  0  0  2
::data2geotiff dem.seg.par PauliRGB.gc.bmp 0 PauliRGB.gc.bmp.tif 0.0 

@rem --9. ģ��sarӰ������ռ�ת������ͼ�ռ䵽б��ռ�
::geocode lookup_table.gc.dat sim.sar.dat 1986  sim.sar.mli.dat 2144 1900   0 0 
::geocode lookup_table.gc.fine.dat pix.i.dat 1986  pix.i.mli.dat 2144 1900   0 0 

@rem --10. �Ż����ұ�
@rem --10.1 ��ʼ������diff.par
::create_diff_par hh.mli.par - diff.par 1
@rem --10.2 ���Ƴ�ʼƫ����
::init_offsetm hh.mli.dat sim.sar.mli.dat diff.par
@rem --10.3 �������Ƶ�
::offset_pwrm hh.mli.dat sim.sar.mli.dat diff.par offs.dat snr.dat 256 256 offsets.txt 1 48 48 7.0 1
@rem --10.4 ��Ͽ��Ƶ�ƫ��
::offset_fitm offs.dat snr.dat diff.par coffs.dat coffsets.txt 7 1 0
@rem --10.5 ���ݿ��Ƶ�ƫ��Ż����ұ�
::gc_map_fine lookup_table.gc.dat 1986 diff.par lookup_table.gc.fine.dat 0 

@rem --11. �����Ż���Ĳ��ұ����е������
::geocode_back hh.mli.dat 1072  lookup_table.gc.fine.dat hh.mli.gc.fine.dat  1188  0  0  0 
::geocode_back PauliRGB.bmp 2144  lookup_table.gc.fine.dat PauliRGB.gc.fine.bmp  1986  0  0  2
::data2geotiff dem.seg.par PauliRGB.gc.fine.bmp 0 PauliRGB.gc.fine.bmp.tif 0.0 
::data2geotiff dem.seg.par ls_map.dat 2 ls_map.dat.tif 0.0 

::geocode_back PauliRGB_GTC.bmp 2144  lookup_table.gc.fine.dat PauliRGB_GTC.gc.fine.bmp  1986  0  0  2
::data2geotiff dem.seg.par PauliRGB_GTC.gc.fine.bmp 0 PauliRGB_GTC.gc.fine.bmp.tif 0.0 
::geocode_back PauliRGB_ESA.bmp 2144  lookup_table.gc.fine.dat PauliRGB_ESA.gc.fine.bmp  1986  0  0  2
::data2geotiff dem.seg.par PauliRGB_ESA.gc.fine.bmp 0 PauliRGB_ESA.gc.fine.bmp.tif 0.0 

::geocode_back hh.mli.dat 1078  lookup_table.gc01.fine.dat hh.mli.gtc01.dat  1306  0  0  0 
::geocode_back hv.mli.dat 1078  lookup_table.gc01.fine.dat hv.mli.gtc01.dat  1306  0  0  0 
::geocode_back vh.mli.dat 1078  lookup_table.gc01.fine.dat vh.mli.gtc01.dat  1306  0  0  0 
::geocode_back vv.mli.dat 1078  lookup_table.gc01.fine.dat vv.mli.gtc01.dat  1306  0  0  0 
::geocode_back PauliRGB_zl_rote.bmp 1078  lookup_table.gc01.fine.dat PauliRGB_zl_rote_gec.bmp  1306  0  0  2 
@rem ----GTC end-----
pause

@echo Programme runing finlshed...

