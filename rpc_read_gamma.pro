function rpc_read_gamma,parFile
  openr,r,parFile,/get_lun
  para = strarr(file_lines(parFile))
  readf,r,para
  free_lun,r
  lineN = n_elements(para)  
  pars = {pa1,start_time:2.0,center_time:1.0,end_time:3906.0,range_samples:51,azimuth_lines:121,$
            prf:12.1,number_of_state_vectors:11,time_of_first_state_vector:52.01,state_vector_interval:1.0,$
            position:dblarr(20,3)}
  pos = dblarr(20,3)  
  for ii = 0, lineN-1 do begin   
    tmp = para[ii]
    par = strsplit(tmp,':',/EXTRACT)
    linName = STRCOMPRESS(par[0], /REMOVE_ALL)
    ;print,linName
    if linName eq 'start_time' then begin
     par_1 = strsplit(par[1],'s',/EXTRACT) & pars.start_time   = double(par_1[0])
    endif
    if linName eq 'center_time' then begin
      par_1 = strsplit(par[1],'s',/EXTRACT) & pars.center_time   = double(par_1[0])
    endif
    if linName eq 'end_time' then begin
      par_1 = strsplit(par[1],'s',/EXTRACT) & pars.end_time   = double(par_1[0])
    endif
    if linName eq 'range_samples' then pars.range_samples   = uint(par[1])
    if linName eq 'azimuth_lines' then pars.azimuth_lines   = uint(par[1])
    if linName eq 'prf' then begin
      par_1 = strsplit(par[1],'Hz',/EXTRACT) & pars.prf   = double(par_1[0])
    endif
    if linName eq 'number_of_state_vectors' then pars.number_of_state_vectors   = uint(par[1])
    if linName eq 'time_of_first_state_vector' then begin
      par_1 = strsplit(par[1],'s',/EXTRACT) & pars.time_of_first_state_vector   = double(par_1[0])
    endif
    if linName eq 'state_vector_interval' then begin
      par_1 = strsplit(par[1],'s',/EXTRACT) & pars.state_vector_interval   = double(par_1[0])
    endif
    if linName eq 'state_vector_position_1' then begin
      for jj = 0, pars.number_of_state_vectors -1 do begin
        part = strsplit(para[ii+2*jj],':',/EXTRACT)
        par_1 = strsplit(part[1],' ',/EXTRACT)
        pos[jj,0] = double(par_1[0]) & pos[jj,1] = double(par_1[1])  & pos[jj,2] = double(par_1[2]) 
      endfor 
      pars.position = pos
    endif     
  endfor
  return,pars
end