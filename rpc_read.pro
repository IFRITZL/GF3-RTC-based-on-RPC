FUNCTION RPC_READ,rpcFile

  openr,r,rpcFile,/get_lun
  para = strarr(file_lines(rpcFile))
  readf,r,para
  free_lun,r

  lineN = n_elements(para)
  rpc = {r1,errBias:2.0,errRand:1.0,lineOffset:39.0,sampOffset:3906.0,latOffset:51.01529661,longOffset:121.36583202,$
    heightOffset:1005.33251953,lineScale:6479.0,sampScale:7813.0,latScale:0.35386620,longScale:0.54402648,heightScale:1000.0,$
    a1 :-2.1E-04,a2 :-1.6E-01, a3:-1.6E-01,a4 :-1.6E-01,a5: -1.6E-01,a6 :-1.6E-01,a7 :-1.6E-01,a8 :-1.6E-01,a9 :-1.6E-01,a10:-1.6E-01,$
    a11:-2.1E-04,a12:-1.6E-01,a13:-1.6E-01,a14:-1.6E-01,a15:-1.6E-01,a16:-1.6E-01,a17:-1.6E-01,a18:-1.6E-01,a19:-1.6E-01,a20:-1.6E-01,$
    b1 :-2.1E-04,b2 :-1.6E-01, b3:-1.6E-01,b4 :-1.6E-01,b5: -1.6E-01,b6 :-1.6E-01,b7 :-1.6E-01,b8 :-1.6E-01,b9 :-1.6E-01,b10:-1.6E-01,$
    b11:-2.1E-04,b12:-1.6E-01,b13:-1.6E-01,b14:-1.6E-01,b15:-1.6E-01,b16:-1.6E-01,b17:-1.6E-01,b18:-1.6E-01,b19:-1.6E-01,b20:-1.6E-01,$
    c1 :-2.1E-04,c2 :-1.6E-01, c3:-1.6E-01,c4 :-1.6E-01,c5: -1.6E-01,c6 :-1.6E-01,c7 :-1.6E-01,c8 :-1.6E-01,c9 :-1.6E-01,c10:-1.6E-01,$
    c11:-2.1E-04,c12:-1.6E-01,c13:-1.6E-01,c14:-1.6E-01,c15:-1.6E-01,c16:-1.6E-01,c17:-1.6E-01,c18:-1.6E-01,c19:-1.6E-01,c20:-1.6E-01,$
    d1 :-2.1E-04,d2 :-1.6E-01, d3:-1.6E-01,d4 :-1.6E-01,d5: -1.6E-01,d6 :-1.6E-01,d7 :-1.6E-01,d8 :-1.6E-01,d9 :-1.6E-01,d10:-1.6E-01,$
    d11:-2.1E-04,d12:-1.6E-01,d13:-1.6E-01,d14:-1.6E-01,d15:-1.6E-01,d16:-1.6E-01,d17:-1.6E-01,d18:-1.6E-01,d19:-1.6E-01,d20:-1.6E-01}
  ;print,rpc

  for ii = 0, lineN-1 do begin
    tmp = para[ii]
    par = strsplit(tmp,'=',/EXTRACT)
    linName = STRCOMPRESS(par[0], /REMOVE_ALL)

    if linName eq 'errBias'      then begin
      par_1 = strsplit(par[1],';',/EXTRACT) & rpc.errBias      = double(par_1[0])
    endif
    if linName eq 'errRand'      then begin
      par_1 = strsplit(par[1],';',/EXTRACT) & rpc.errRand      = double(par_1[0])
    endif
    if linName eq 'lineOffset'   then begin
      par_1 = strsplit(par[1],';',/EXTRACT) & rpc.lineOffset   = double(par_1[0])
    endif
    if linName eq 'sampOffset'   then begin
      par_1 = strsplit(par[1],';',/EXTRACT) & rpc.sampOffset   = double(par_1[0])
    endif
    if linName eq 'latOffset'    then begin
      par_1 = strsplit(par[1],';',/EXTRACT) & rpc.latOffset    = double(par_1[0])
    endif
    if linName eq 'longOffset'   then begin
      par_1 = strsplit(par[1],';',/EXTRACT) & rpc.longOffset   = double(par_1[0])
    endif
    if linName eq 'heightOffset' then begin
      par_1 = strsplit(par[1],';',/EXTRACT) & rpc.heightOffset = double(par_1[0])
    endif
    if linName eq 'lineScale'    then begin
      par_1 = strsplit(par[1],';',/EXTRACT) & rpc.lineScale    = double(par_1[0])
    endif
    if linName eq 'sampScale'    then begin
      par_1 = strsplit(par[1],';',/EXTRACT) & rpc.sampScale    = double(par_1[0])
    endif
    if linName eq 'latScale'     then begin
      par_1 = strsplit(par[1],';',/EXTRACT) & rpc.latScale     = double(par_1[0])
    endif
    if linName eq 'longScale'    then begin
      par_1 = strsplit(par[1],';',/EXTRACT) & rpc.longScale    = double(par_1[0])
    endif
    if linName eq 'heightScale'  then begin
      par_1 = strsplit(par[1],';',/EXTRACT) & rpc.heightScale  = double(par_1[0])
    endif
    if linName eq 'lineNumCoef'  then begin
      par = strsplit(para[ii+1] ,',',/EXTRACT) & rpc.a1  = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+2] ,',',/EXTRACT) & rpc.a2  = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+3] ,',',/EXTRACT) & rpc.a3  = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+4] ,',',/EXTRACT) & rpc.a4  = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+5] ,',',/EXTRACT) & rpc.a5  = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+6] ,',',/EXTRACT) & rpc.a6  = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+7] ,',',/EXTRACT) & rpc.a7  = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+8] ,',',/EXTRACT) & rpc.a8  = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+9] ,',',/EXTRACT) & rpc.a9  = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+10],',',/EXTRACT) & rpc.a10 = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+11],',',/EXTRACT) & rpc.a11 = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+12],',',/EXTRACT) & rpc.a12 = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+13],',',/EXTRACT) & rpc.a13 = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+14],',',/EXTRACT) & rpc.a14 = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+15],',',/EXTRACT) & rpc.a15 = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+16],',',/EXTRACT) & rpc.a16 = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+17],',',/EXTRACT) & rpc.a17 = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+18],',',/EXTRACT) & rpc.a18 = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+19],',',/EXTRACT) & rpc.a19 = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+20],')',/EXTRACT) & rpc.a20 = double(STRCOMPRESS(par[0], /REMOVE_ALL))
    endif
    if linName eq 'lineDenCoef'  then begin
      par = strsplit(para[ii+1] ,',',/EXTRACT) & rpc.b1  = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+2] ,',',/EXTRACT) & rpc.b2  = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+3] ,',',/EXTRACT) & rpc.b3  = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+4] ,',',/EXTRACT) & rpc.b4  = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+5] ,',',/EXTRACT) & rpc.b5  = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+6] ,',',/EXTRACT) & rpc.b6  = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+7] ,',',/EXTRACT) & rpc.b7  = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+8] ,',',/EXTRACT) & rpc.b8  = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+9] ,',',/EXTRACT) & rpc.b9  = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+10],',',/EXTRACT) & rpc.b10 = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+11],',',/EXTRACT) & rpc.b11 = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+12],',',/EXTRACT) & rpc.b12 = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+13],',',/EXTRACT) & rpc.b13 = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+14],',',/EXTRACT) & rpc.b14 = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+15],',',/EXTRACT) & rpc.b15 = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+16],',',/EXTRACT) & rpc.b16 = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+17],',',/EXTRACT) & rpc.b17 = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+18],',',/EXTRACT) & rpc.b18 = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+19],',',/EXTRACT) & rpc.b19 = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+20],')',/EXTRACT) & rpc.b20 = double(STRCOMPRESS(par[0], /REMOVE_ALL))
    endif
    if linName eq 'sampNumCoef'  then begin
      par = strsplit(para[ii+1] ,',',/EXTRACT) & rpc.c1  = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+2] ,',',/EXTRACT) & rpc.c2  = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+3] ,',',/EXTRACT) & rpc.c3  = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+4] ,',',/EXTRACT) & rpc.c4  = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+5] ,',',/EXTRACT) & rpc.c5  = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+6] ,',',/EXTRACT) & rpc.c6  = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+7] ,',',/EXTRACT) & rpc.c7  = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+8] ,',',/EXTRACT) & rpc.c8  = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+9] ,',',/EXTRACT) & rpc.c9  = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+10],',',/EXTRACT) & rpc.c10 = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+11],',',/EXTRACT) & rpc.c11 = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+12],',',/EXTRACT) & rpc.c12 = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+13],',',/EXTRACT) & rpc.c13 = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+14],',',/EXTRACT) & rpc.c14 = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+15],',',/EXTRACT) & rpc.c15 = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+16],',',/EXTRACT) & rpc.c16 = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+17],',',/EXTRACT) & rpc.c17 = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+18],',',/EXTRACT) & rpc.c18 = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+19],',',/EXTRACT) & rpc.c19 = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+20],')',/EXTRACT) & rpc.c20 = double(STRCOMPRESS(par[0], /REMOVE_ALL))
    endif
    if linName eq 'sampDenCoef'  then begin
      par = strsplit(para[ii+1] ,',',/EXTRACT) & rpc.d1  = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+2] ,',',/EXTRACT) & rpc.d2  = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+3] ,',',/EXTRACT) & rpc.d3  = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+4] ,',',/EXTRACT) & rpc.d4  = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+5] ,',',/EXTRACT) & rpc.d5  = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+6] ,',',/EXTRACT) & rpc.d6  = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+7] ,',',/EXTRACT) & rpc.d7  = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+8] ,',',/EXTRACT) & rpc.d8  = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+9] ,',',/EXTRACT) & rpc.d9  = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+10],',',/EXTRACT) & rpc.d10 = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+11],',',/EXTRACT) & rpc.d11 = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+12],',',/EXTRACT) & rpc.d12 = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+13],',',/EXTRACT) & rpc.d13 = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+14],',',/EXTRACT) & rpc.d14 = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+15],',',/EXTRACT) & rpc.d15 = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+16],',',/EXTRACT) & rpc.d16 = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+17],',',/EXTRACT) & rpc.d17 = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+18],',',/EXTRACT) & rpc.d18 = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+19],',',/EXTRACT) & rpc.d19 = double(STRCOMPRESS(par[0], /REMOVE_ALL))
      par = strsplit(para[ii+20],')',/EXTRACT) & rpc.d20 = double(STRCOMPRESS(par[0], /REMOVE_ALL))
    endif
  endfor
  return,rpc
end