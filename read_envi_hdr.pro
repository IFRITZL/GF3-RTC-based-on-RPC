PRO  Read_envi_hdr,hdrfile,samples,lines,bands,datatype,headeroffset,interleave
    
  Hdr_Label='';
  data='';
  samples=0L
  lines=0L
  bands=0L
  headeroffset=0L;
  datatype=0L;
  interleave=''
  
  OPENR,hdrf,hdrfile,/GET_LUN;
  READF,hdrf,Hdr_Label ;
  Hdr_Label= STRLOWCASE(Hdr_Label);
  Hdr_Label=STRTRIM(Hdr_Label);
  IF( Hdr_Label NE 'envi') THEN BEGIN
    temp = DIALOG_MESSAGE('非envi格式头文件！',/Warning)
    RETURN;
  END
  chara=''
  
  WHILE ~EOF(hdrf) DO BEGIN
    READF,hdrf,data
    
    chara=STRMID(data,0,STRPOS(data,'='))
    chara=STRTRIM(chara);
    chara=STRLOWCASE(chara)
    
    CASE chara OF
      'description': BREAK
      
      'samples':  samples=STRMID(data,STRPOS(data,'=')+1)
      
      'lines':  lines=STRMID(data,STRPOS(data,'=')+1)
      
      'bands': bands=STRMID(data,STRPOS(data,'=')+1)
      
      'headeroffset': headroffset=STRMID(data,STRPOS(data,'=')+1)
      
      'filetype': filetype=STRMID(data,STRPOS(data,'=')+1)
      
      'data type': datatype=STRMID(data,STRPOS(data,'=')+1)
      
      'interleave': interleave=STRMID(data,STRPOS(data,'=')+1)
      
      'map info': BEGIN ;?·?°?≠?≥??–≈??
        InfoString = STRMID(data,STRPOS(data,'=')+1)
        Info = Strsplit(data,',',/extract)
        Min_lon = FLOAT(Info[3])
        Max_lon = Min_lon+ samples*FLOAT(info[5])
        
        Max_lat = FLOAT(Info[4])
        Min_lat =  Max_lat- lines*FLOAT(info[6])
      END
      ELSE:
    ENDCASE
  ENDWHILE
  
  FREE_LUN,hdrf
  
  
END