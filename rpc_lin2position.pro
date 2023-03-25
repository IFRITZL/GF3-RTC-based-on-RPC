function rpc_lin2position,lin,par,polyXX,polyYY,polyZZ

  t0 = par.start_time 
  pt0 = par.time_of_first_state_vector
  prf = par.prf
  xx = t0 + (lin-1)/prf - pt0
  
  ptx = polyXX[0] + polyXX[1]*xx + polyXX[2]*xx^2 + polyXX[3]*xx^3
  pty = polyYY[0] + polyYY[1]*xx + polyYY[2]*xx^2 + polyYY[3]*xx^3
  ptz = polyZZ[0] + polyZZ[1]*xx + polyZZ[2]*xx^2 + polyZZ[3]*xx^3

  arr = [ptx,pty,ptz]
  return,arr

end