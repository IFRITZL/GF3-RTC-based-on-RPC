; GTC and RTC processing Based on RPC model.
; v 1.0; 20230325;
; email: zhaolei@ifrit.ac.cn

pro Main_Program

  COMPILE_OPT IDL2
  ENVI, /RESTORE_BASE_SAVE_FILES
  ENVI_BATCH_INIT, LOG_FILE = 'batch_log.txt', BATCH_LUN = lunit

  SARdir = 'D:\RPC_Code2Data\GF3SAR\'

  print,'%%%%%%%%%%%%%%%%%%-step-1: Raw to S2%%%%%%%%%%%%%%%%%'
  s2Dir = SARdir + 'SLC\'
  gf3_data_reader_for_polsarpro,SARdir,s2Dir

  print,'%%%%%%%%%%%%%%%%%%-step-2: S2 to C3%%%%%%%%%%%%%%%%%%'
  s2Dir = SARdir + 'SLC\'
  C3Dir = SARdir + 'mlC3\C3\'
  mlrow = 3
  mlcol = 2
  polsarpro_S2_TO_C3,s2Dir,C3Dir,mlrow,mlcol

  print,'%%%%%%%%%%%%%%%%%%-step-3: RPC %%%%%%%%%%%%%%%%%%'
  ;input
  xmlfile = SARdir + 'GF3_SAY_QPSI_016460_E118.3_N41.7_20190925_L1A_AHV_L10004266581.meta.xml'
  rpcfile = SARdir + 'GF3_SAY_QPSI_016460_E118.3_N41.7_20190925_L1A_HH_L10004266581.rpc'
  demfile = SARdir + 'dem.tif'
  ;output
  slcpar = SARdir + 'slc.par'
  gtc_lktable = SARdir + 'rpc_look_table.dat'
  locinc_ange = SARdir + 'local_inc.dat'
  psi_angle = SARdir + 'psi.dat'
  inc_angle = SARdir + 'look_angle.dat'
  rpc_gtc_angle,xmlfile,rpcfile,demfile,slcpar,gtc_lktable, psi_angle, locinc_ange, inc_angle

  print,'%%%%%%%%%%%%%%%%%%-step-4: GTC C3 %%%%%%%%%%%%%%%%%%'
  C3inpath = SARdir + 'mlC3\C3\'
  C3oupath = SARdir + 'gtcC3\C3\'
  lktable = SARdir + 'rpc_look_table.dat'
  mlrow = 3
  mlcol = 2
  C3T3_GTC_RPC,C3inpath,C3oupath,lktable,mlcol,mlrow,'C'

  print,'%%%%%%%%%%%%%%%%%%-step-5: RTC C3 %%%%%%%%%%%%%%%%%%'
  print,'%%%%%%%%%%%%%%%%%%-step-5.1 : RTC ESA %%%%%%%%%%%%%%'
  Ipath = SARdir + 'gtcC3\C3\'
  PsiFile = SARdir + 'psi.dat'
  Opath = SARdir + 'rtc_esa_C3\C3\'
  RTC_c3_Psi_pro,Ipath,PsiFile,Opath

  print,'%%%%%%%%%%%%%%%%%%-step-5.2 : RTC AVE %%%%%%%%%%%%%%'
  Ipath = SARdir + 'rtc_esa_C3\C3\'
  LocIncFile = SARdir + 'local_inc.dat'
  FltIncFile = SARdir + 'look_angle.dat'
  Opath = SARdir + 'rtc_esa_ave_C3\C3\'
  nhh = 1.0 ;C11
  nhv = 1.0 ;C22
  nvv = 1.0 ;C33
  RTC_c3_avea_pro,Ipath,LocIncFile,FltIncFile,Opath,nhh,nhv,nvv
  
end