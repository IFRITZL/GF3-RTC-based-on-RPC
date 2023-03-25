
function config,ODir,nrow,ncol
  rowstr = strcompress(string(nrow),/remove)
  colstr = strcompress(string(ncol),/remove)
;  rowstr = nrow
;  colstr = ncol
  openw,lun,ODir+'config.txt',/Get_lun  ;/append
  printf,lun,'Nrow'
  printf,lun,rowstr
  printf,lun,'---------'
  printf,lun,'Ncol'
  printf,lun,colstr
  printf,lun,'---------'
  printf,lun,'PolarCase'
  ;printf,lun,'monostatic'
  printf,lun,'bistatic'
  printf,lun,'---------'
  printf,lun,'PolarType'
  printf,lun,'full'
  free_lun,lun
  close,/all
  return,'config.txt ready'
end
