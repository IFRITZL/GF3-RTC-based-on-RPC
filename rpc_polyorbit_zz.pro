function rpc_polyOrbit_zz,par,n
  
  arr = par.position
  numsta = par.number_of_state_vectors
  t1 = par.time_of_first_state_vector
  stai = par.state_vector_interval

  xx = indgen(numsta)*stai
  yy = dblarr(numsta)
  yy = arr[0:numsta-1,2]
  measure_errors = REPLICATE(0.01, 11)
  result = poly_fit(xx,yy,n,MEASURE_ERRORS=measure_errors,SIGMA=sigma);
  print,xx
  print,yy
  
  return,result
  
end