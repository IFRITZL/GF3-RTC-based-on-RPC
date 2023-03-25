pro polsarpro_S2_TO_C3,InDir,OuDir,mlrow,mlcol
  
  codedir = file_dirname(routine_filepath('polsarpro_S2_TO_C3'))
  
  if file_test(Oudir,/directory) eq 0 then file_mkdir,Oudir
  mlrows = strcompress(string(mlrow))
  mlcols = strcompress(string(mlcol))
  openr,lun,Indir+'\config.txt',/get_lun
  line=strarr(11)
  readf,lun,line
  free_lun,lun
  nrow=line(1)
  ncol=line(4)
  comd_2tif = ['data_convert_MLK_S2.exe',Indir,Oudir,ncol,'0','0',nrow,ncol,'1','C3',mlcols,mlrows]
  cd, codedir
  spawn,comd_2tif,/hide
  
  openr,lun,OuDir+'\config.txt',/get_lun
  line=strarr(11)
  readf,lun,line
  free_lun,lun
  nrow=line(1)
  ncol=line(4)
  
  T=['C11.bin','C12_imag.bin','C12_real.bin','C22.bin','C13_imag.bin','C13_real.bin','C23_imag.bin','C23_real.bin','C33.bin']
  for n=0,8 do begin
    T3_hdr=['envi_config_file',Oudir+T[n],nrow,ncol,'4',T[n]]
    cd, codedir
    spawn,T3_hdr,/hide
  end
  
  T3mult_pauliRGB=['create_pauli_rgb_file_C3',OuDir,OuDir+'\PauliRGB.bmp',ncol,'0','0',nrow,ncol]
  cd,codedir
  spawn,T3mult_pauliRGB,/hide
  
end