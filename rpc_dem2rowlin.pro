;将经纬度投影的DEM坐标转换为SAR影像坐标

function RPC_DEM2RowLin,r,lat,lon,sch
      ;RPC
      ;标准化地面坐标
      P = (lat-r.latOffset)/r.latScale 
      L = (lon-r.longOffset)/r.longScale 
      H = (sch-r.heightOffset)/r.heightScale 
      ;比值多项式
      NL = r.a1+r.a2*L+r.a3*P+r.a4*H+r.a5*L*P+r.a6*L*H+r.a7*P*H+r.a8*(L^2)+r.a9*(P^2)+r.a10*(H^2)+r.a11*P*L*H+r.a12*(L^3)+r.a13*L*(P^2)+r.a14*L*(H^2)+r.a15*(L^2)*P+r.a16*(P^3)+r.a17*P*(H^2)+r.a18*(L^2)*H+r.a19*(P^2)*H+r.a20*(H^3)
      DL = r.b1+r.b2*L+r.b3*P+r.b4*H+r.b5*L*P+r.b6*L*H+r.b7*P*H+r.b8*(L^2)+r.b9*(P^2)+r.b10*(H^2)+r.b11*P*L*H+r.b12*(L^3)+r.b13*L*(P^2)+r.b14*L*(H^2)+r.b15*(L^2)*P+r.b16*(P^3)+r.b17*P*(H^2)+r.b18*(L^2)*H+r.b19*(P^2)*H+r.b20*(H^3)
      NS = r.c1+r.c2*L+r.c3*P+r.c4*H+r.c5*L*P+r.c6*L*H+r.c7*P*H+r.c8*(L^2)+r.c9*(P^2)+r.c10*(H^2)+r.c11*P*L*H+r.c12*(L^3)+r.c13*L*(P^2)+r.c14*L*(H^2)+r.c15*(L^2)*P+r.c16*(P^3)+r.c17*P*(H^2)+r.c18*(L^2)*H+r.c19*(P^2)*H+r.c20*(H^3)
      DS = r.d1+r.d2*L+r.d3*P+r.d4*H+r.d5*L*P+r.d6*L*H+r.d7*P*H+r.d8*(L^2)+r.d9*(P^2)+r.d10*(H^2)+r.d11*P*L*H+r.d12*(L^3)+r.d13*L*(P^2)+r.d14*L*(H^2)+r.d15*(L^2)*P+r.d16*(P^3)+r.d17*P*(H^2)+r.d18*(L^2)*H+r.d19*(P^2)*H+r.d20*(H^3)
      ;标准化的影像坐标
      Y = NL/DL
      X = NS/DS
      ;影像坐标
      sap = X*r.sampScale + r.sampOffset
      lin = Y*r.lineScale + r.lineOffset    
      arr = [sap,lin]      
      return,arr

end