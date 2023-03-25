pro C3T3_GTC_RPC,T3inpath,T3oupath,lktable,Mcol,Mrow,Mtype

  if file_test(T3oupath,/directory) eq 0 then file_mkdir,T3oupath
  if Mtype eq 'T' then $
    T=["T11", "T12_real", "T12_imag",$;0 1 2
    "T13_real", "T13_imag", "T22",$;3 4 5
    "T23_real", "T23_imag", "T33"] ;6 7 8
  if Mtype eq 'C' then $
    T=["C11", "C12_real", "C12_imag",$;0 1 2
    "C13_real", "C13_imag", "C22",$;3 4 5
    "C23_real", "C23_imag", "C33"] ;6 7 8
    
  for h = 0,8 do begin
    SARin  = T3inpath + T[H] + '.bin'
    SARout = T3oupath + T[H] + '.bin'
    gtc_rpc,lktable,SARin,SARout,Mcol,Mrow
  endfor
  
  ENVI_OPEN_FILE, lktable, r_fid = rpcfid
  ENVI_FILE_QUERY, rpcfid, dims = rpcdims
  RPCdat  = ENVI_GET_DATA(fid=rpcfid, dims=rpcdims, pos=0,/complex)
  rpcsamples = rpcdims[2] + 1
  rpclines  = rpcdims[4] + 1
 
  print,config(T3oupath,rpclines,rpcsamples)
  
  openr,lun,T3oupath+'\config.txt',/get_lun
  line=strarr(11)
  readf,lun,line
  free_lun,lun
  nrow=line(1)
  ncol=line(4)  
  codedir = file_dirname(routine_filepath('C3T3_GTC_RPC'))
  T3mult_pauliRGB=['create_pauli_rgb_file_C3',T3oupath,T3oupath+'\PauliRGB.bmp',ncol,'0','0',nrow,ncol]
  cd,codedir
  spawn,T3mult_pauliRGB,/hide

end