function C3T3Name,Mtype

  if Mtype eq 'T' then $
    T=["T11", "T12_real", "T12_imag",$;0 1 2
    "T13_real", "T13_imag", "T22",$;3 4 5
    "T23_real", "T23_imag", "T33"] ;6 7 8
  if Mtype eq 'C' then $
    T=["C11", "C12_real", "C12_imag",$;0 1 2
    "C13_real", "C13_imag", "C22",$;3 4 5
    "C23_real", "C23_imag", "C33"] ;6 7 8
  if Mtype eq 'C2' then $
    T=["C11", "C12_real", "C12_imag","C22"]
    
  T_dat = T + '.bin'

  return, T_dat

end