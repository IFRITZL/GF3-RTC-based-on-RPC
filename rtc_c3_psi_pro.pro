;基于T3数据地形辐射校正研究，基于gamma生成psi投影角，进行散射面积校正。
;输入：T3路径，路径+Psi文件，输出T3路径
;输出：校正后T3
pro RTC_c3_Psi_pro,Ipath,PsiFile,Opath
  
  start_time = systime(/second)
  COMPILE_OPT IDL2
  ENVI, /RESTORE_BASE_SAVE_FILES
  ENVI_BATCH_INIT, LOG_FILE = 'batch_log.txt', BATCH_LUN = lunit
  
  if file_test(Opath,/directory) eq 0 then file_mkdir,Opath
  IconfigFile = Ipath + 'config.txt'
  OconfigFile = Opath + 'config.txt'
  file_copy,IconfigFile,OconfigFile,/OVERWRITE
  T_dat=C3T3Name('C')
  T_hdr = T_dat + '.hdr'
  T_poc = T_dat
  P_hdr = T_poc + '.hdr'
  Read_envi_hdr,Ipath+T_hdr[0],samples,lines,bands,datatype,headeroffset,interleave

  ;打开输入文件
  openr,r11 ,Ipath + T_dat[0],/GET_LUN & openr,r12r,Ipath + T_dat[1],/GET_LUN & openr,r12i,Ipath + T_dat[2],/GET_LUN
  openr,r13r,Ipath + T_dat[3],/GET_LUN & openr,r13i,Ipath + T_dat[4],/GET_LUN & openr,r22 ,Ipath + T_dat[5],/GET_LUN
  openr,r23r,Ipath + T_dat[6],/GET_LUN & openr,r23i,Ipath + T_dat[7],/GET_LUN & openr,r33 ,Ipath + T_dat[8],/GET_LUN
  openr,psir,PsiFile,/GET_LUN;, /SWAP_ENDIAN

  ;打开输出文件
  openw,w11 ,Opath + T_poc[0],/GET_LUN & openw,w12r,Opath + T_poc[1],/GET_LUN & openw,w12i,Opath + T_poc[2],/GET_LUN
  openw,w13r,Opath + T_poc[3],/GET_LUN & openw,w13i,Opath + T_poc[4],/GET_LUN & openw,w22 ,Opath + T_poc[5],/GET_LUN
  openw,w23r,Opath + T_poc[6],/GET_LUN & openw,w23i,Opath + T_poc[7],/GET_LUN & openw,w33 ,Opath + T_poc[8],/GET_LUN
  ;openw,poli,Opath + 'PauliRGB.BIL.dat',/GET_LUN
  ;逐行处理
  T11  = fltarr(samples) & T12r = fltarr(samples) & T12i = fltarr(samples)
  T13r = fltarr(samples) & T13i = fltarr(samples) & T22  = fltarr(samples)
  T23r = fltarr(samples) & T23i = fltarr(samples) & T33  = fltarr(samples)
  Psi  = fltarr(samples);面积校正因子
  FltInc = fltarr(samples)
  LocInc = fltarr(samples)
  for l=0,lines-1 do begin
    ;读取一行数据
    readu,r11 ,T11  & readu,r12r,T12r & readu,r12i,T12i
    readu,r13r,T13r & readu,r13i,T13i & readu,r22 ,T22
    readu,r23r,T23r & readu,r23i,T23i & readu,r33 ,T33
    readu,psir,Psi
    ;校正因子
    Pix = cos(Psi*!pi/180.) 
    ;散射面积校正
    T11o  =  T11*Pix
    T12ro =  T12r*Pix
    T12io =  T12i*Pix
    T13ro =  T13r*Pix
    T13io =  T13i*Pix
    T22o  =  T22*Pix
    T23ro =  T23r*Pix
    T23io =  T23i*Pix
    T33o  =  T33*Pix
    ;Pauli RGB三个波段
    ;T11db = 10*alog10(T11o);
    ;T22db = 10*alog10(T22o);
    ;T33db = 10*alog10(T33o);
    ;写出T3一行结果
    writeu,w11 ,T11o  & writeu,w12r,T12ro & writeu,w12i,T12io
    writeu,w13r,T13ro & writeu,w13i,T13io & writeu,w22 ,T22o
    writeu,w23r,T23ro & writeu,w23i,T23io & writeu,w33 ,T33o
    ;写出PauliRGB文件
    ;writeu,poli,T22db & writeu,poli,T33db & writeu,poli,T11db
    ;if l mod 100 eq 0 then print,'Processing:'+ strcompress(string(float(l)/lines*100))+'%'
  endfor
  ;print,'Processing: Begin Create HDR File'
  ;释放文件标记
  free_lun,r11,r12r,r12i,r13r,r13i,r22,r23r,r23i,r33, $
    w11,w12r,w12i,w13r,w13i,w22,w23r,w23i,w33, $
    psir;,fltr,locr;,poli
    
  close,/all
  ;T3头文件
  for h = 0,8 do begin
    envi_setup_head, fname=OPath+P_hdr[h],ns=samples, nl=lines,nb=bands,interleave=0,$
      data_type=datatype,offset=headeroffset,bnames=T_poc[h],/write
    ;print,'Processing: Create'+P_hdr[h]
  endfor
  ;PauliRGB头文件
  ;envi_setup_head, fname=OPath+'PauliRGB.BIL.dat.hdr',ns=samples, nl=lines,nb= 3,interleave=1,$
  ;  data_type=datatype,offset=headeroffset,bnames='PauliRGB.BIL.dat',/write
  ;print,'Processing: end'
  openr,lun,Opath+'\config.txt',/get_lun
  line=strarr(11)
  readf,lun,line
  free_lun,lun
  nrow=line[1]
  ncol=line[4]
  codedir = file_dirname(routine_filepath('RTC_c3_Psi_pro'))
  T3mult_pauliRGB=['create_pauli_rgb_file_C3',Opath,Opath+'\PauliRGB.bmp',ncol,'0','0',nrow,ncol]
  cd,codedir
  spawn,T3mult_pauliRGB,/hide

  end_time = systime(/second)
  print,'RTC_T3_Psi_pro cost_time: ' + strcompress(string(end_time-start_time),/remove) + ' s'
  
end