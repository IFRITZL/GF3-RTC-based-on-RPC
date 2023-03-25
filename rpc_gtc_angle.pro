pro rpc_gtc_angle,xmlfile,rpcfile,demfile,slcpar,gtc_lktable, psi_angle, locinc_ange, inc_angle

  ;固定参数
  el_major = 6378137.0
  el_minor = 6356752.3141
  DTR = .0174532925199  ;/* degrees to radians */
  ;SAR 左视 1 右视-1
  lr = -1 
  
  codedir = file_dirname(routine_filepath('rpc_gtc_angle'))
  
  r = rpc_read(rpcfile)
  ;GAMMA头文件

  comd_3tif = ['GF3_PolSAR_PAR_Reader.exe',xmlfile,slcpar]
  CD,codedir
  spawn,comd_3tif
  
  par = rpc_read_gamma(slcpar)
  polyXX = rpc_polyOrbit_xx(par,3)
  polyYY = rpc_polyOrbit_yy(par,3)
  polyZZ = rpc_polyOrbit_zz(par,3)

  ;读取DEM数据并获取相关信息
  ENVI_OPEN_FILE, demfile, r_fid = demfid
  ENVI_FILE_QUERY, demfid, dims = dims
  DEMdat  = ENVI_GET_DATA(fid=demfid, dims=dims, pos=0)
  samples = dims[2] + 1
  lines  = dims[4] + 1

  ;投影信息
  iProj = ENVI_GET_PROJECTION(Fid = demfid)
  oProj = ENVI_PROJ_CREATE(/geographic)

  ECR_xx_arr = fltarr(samples,lines)
  ECR_yy_arr = fltarr(samples,lines)
  ECR_zz_arr = fltarr(samples,lines)

  spl_lin_arr = complexarr(samples,lines)
  arr = intarr(2)


  for row1=0,lines-1 do begin
    for col1 =0, samples-1 do begin
        hh = DEMdat[col1,row1]
        ;将影像坐标统一转换为经纬度坐标
        xf = col1
        yf = row1
        ENVI_CONVERT_FILE_COORDINATES, demfid, xf, yf, iXmap, iYmap, /TO_MAP
        ENVI_CONVERT_PROJECTION_COORDINATES,iXmap, iYmap, iProj, oXmap, oYmap, oProj , INPUT_Z = hh, OUTPUT_Z = sch
        inCoor = [iXmap,iYmap,hh]
        OutCoor = [oXmap,oYmap,sch]

        lat = OutCoor[1]
        lon = OutCoor[0]

        ;将经纬度坐标转换为ECR坐标
        e2=((el_major*el_major)-(el_minor*el_minor))/(el_major*el_major);
        nu = el_major/sqrt(1. - e2*(sin(lat*DTR))*(sin(lat*DTR)));
        xx=(nu+sch)*cos(lat*DTR)*cos(lon*DTR);
        yy=(nu+sch)*cos(lat*DTR)*sin(lon*DTR);
        zz=(nu*(1.-e2)+sch)*sin(lat*DTR);

        ECR_xx_arr[col1,row1] = xx
        ECR_yy_arr[col1,row1] = yy
        ECR_zz_arr[col1,row1] = zz

        ;基于RPC获得SAR斜距坐标
        if sch gt 0. then begin
          arr = RPC_DEM2RowLin(r,lat,lon,sch)
          spl_lin_arr(col1,row1) = complex(arr[0],arr[1])
        endif

        if row1 mod 10 eq 0 and col1 mod 800 eq 0 then print,row1,col1,inCoor,OutCoor;,lon,lat,arr
    endfor
  endfor
  

  openw,slu,gtc_lktable,/GET_LUN
  writeu,slu ,spl_lin_arr
  envi_setup_head, fname=gtc_lktable + '.hdr',ns=samples, nl=lines,nb=1,interleave=0,$
    data_type=6,offset=0,bnames=gtc_lktable,map_info = map_info,/write
  free_lun,slu

  print,'地面法向量计算……'
  
  ;计算地面法向量，利用[i,j][i-1,j][i,j-1]三个像元的坐标计算
  local_arr = fltarr(samples,lines);局部入射角
  psi_arr = fltarr(samples,lines);投影角
  lookagl_arr = fltarr(samples,lines);雷达视角
  u_slope_arr = fltarr(samples,lines);坡度角
  v_arr = fltarr(samples,lines);方位向坡度角 

  for row1=5,lines-5 do begin
    for col1 =5, samples-5 do begin
      sch = DEMdat[col1,row1]
      if sch gt 0 then begin
        x1 = ECR_xx_arr[col1,row1] & y1 = ECR_yy_arr[col1,row1] & z1 = ECR_zz_arr[col1,row1]
        x2 = ECR_xx_arr[col1-1,row1] & y2 = ECR_yy_arr[col1-1,row1] & z2 = ECR_zz_arr[col1-1,row1]
        x3 = ECR_xx_arr[col1,row1-1] & y3 = ECR_yy_arr[col1,row1-1] & z3 = ECR_zz_arr[col1,row1-1]
        ;计算法向量
        nxx = (y2-y1)*(z3-z1)-(y3-y1)*(z2-z1)
        nyy = (z2-z1)*(x3-x1)-(z3-z1)*(x2-x1)
        nzz = (x2-x1)*(y3-y1)-(x3-x1)*(y2-y1)
        ;计算卫星位置
        lin = imaginary(spl_lin_arr[col1,row1])
        position = rpc_lin2position(lin,par,polyXX,polyYY,polyZZ)

        OS = position;卫星位置矢量
        TN = [nxx,nyy,nzz];局部地表法向量TN
        TNu = TN/sqrt(total(TN*TN))
        
        OT = [x1+x2+x3,y1+y2+y3,z1+z2+z3]/3;地心法向量OT
        OTu = (OT/sqrt(total(OT*OT)))*(-lr) ;OT的单位矢量，并确保朝上
        
        ST = OT - OS  ;卫星位置指向局部点向量ST
        TS = - ST  ;局部点指向卫星
        
        SV = vector_product(TS,OT)*(-1);SV这样算出来无法保证方向，是个问题
        SVu = SV/sqrt(total(SV*SV))
        
        TP = vector_product(TS,SV)
        TPu = (TP/sqrt(total(TP*TP)))*(-lr) ;OT的单位矢量，并确保朝上
             
        ;计算局部入射角
        localInc = acos(total(TS*TN)/(sqrt(total(TS*TS)*total(TN*TN))))*180/!pi
        if localInc gt 90 then localInc = 180-localInc
        local_arr[col1,row1] = localInc
        ;计算投影角 
        psi = acos(total(TP*TN)/(sqrt(total(TP*TP)*total(TN*TN))))*180/!pi
        if psi gt 90 then psi = 180-psi
        psi_arr[col1,row1] = psi    
        ;雷达视角
        lka = acos(total(OT*TS)/(sqrt(total(OT*OT)*total(TS*TS))))*180/!pi
        lookagl_arr[col1,row1] = lka ;雷达视角
                 
      endif
      if row1 mod 500 eq 0 and col1 mod 500 eq 0 then print,row1,col1,localInc,psi,lka
    endfor
  endfor


  openw,wloc,locinc_ange,/GET_LUN
  writeu,wloc ,local_arr
  envi_setup_head, fname=locinc_ange + '.hdr',ns=samples, nl=lines,nb=1,interleave=0,$
    data_type=4,offset=0,bnames=locinc_ange,map_info = map_info,/write
  free_lun,wloc
  

  openw,wpsi,psi_angle,/GET_LUN
  writeu,wpsi,psi_arr
  envi_setup_head, fname=psi_angle + '.hdr',ns=samples, nl=lines,nb=1,interleave=0,$
    data_type=4,offset=0,bnames=psi_angle,map_info = map_info,/write
  free_lun,wpsi
  

  openw,wsita,inc_angle,/GET_LUN
  writeu,wsita,lookagl_arr
  envi_setup_head, fname=inc_angle + '.hdr',ns=samples, nl=lines,nb=1,interleave=0,$
    data_type=4,offset=0,bnames=inc_angle,map_info = map_info,/write
  free_lun,wsita
  
  
end