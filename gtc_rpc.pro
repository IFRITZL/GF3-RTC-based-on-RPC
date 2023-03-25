;lktable:RPC查找表;
;SARin:输入数据;
;SARout:输出数据
;Mcol,Mrow：多视化参数
Pro gtc_rpc,lktable,SARin,SARout,Mcol,Mrow

  ENVI_OPEN_FILE, SARin, r_fid = sarfid
  ENVI_FILE_QUERY, sarfid, dims = sardims
  SARdat0  = ENVI_GET_DATA(fid=sarfid, dims=sardims, pos=0)
  sarsamples = sardims[2] + 1
  sarlines  = sardims[4] + 1
  print,'MLC数据的行列号：'
  print,'samples: ',sarsamples,' lines: ',sarlines

  ENVI_OPEN_FILE, lktable, r_fid = rpcfid
  ENVI_FILE_QUERY, rpcfid, dims = rpcdims
  RPCdat  = ENVI_GET_DATA(fid=rpcfid, dims=rpcdims, pos=0,/complex)
  rpcsamples = rpcdims[2] + 1
  rpclines  = rpcdims[4] + 1
  print,'RPC查找表数据的行列号：'
  print,'samples: ',rpcsamples,' lines: ',rpclines

  ;创建输出结果影像
  outDat = fltarr(rpcsamples,rpclines)
  for ss = 0, rpcsamples -1 do begin
    for ll = 0 , rpclines - 1 do begin
      slcx = real_part(RPCdat[ss,ll])
      slcy = imaginary(RPCdat[ss,ll])
      if slcx le sarsamples*Mcol and slcx gt 0. and slcy le sarlines*Mrow and slcy gt 0. then begin
        mlcx = (slcx-1)/(Mcol*1.0)
        mlcy = (slcy-1)/(Mrow*1.0)
        outDat[ss,ll]=BILINEAR(SARdat0,mlcx,mlcy)
      endif
    endfor
    if ss mod 300 eq 0 then print,ss
  endfor
  ENVI_WRITE_ENVI_FILE, outDat, out_name = SARout
  SARout1 = strsplit(SARout,'.',/extract)
  SARouthdr = SARout+'.hdr'
  File_move,SARout1[0]+'.hdr',SARouthdr
  
end