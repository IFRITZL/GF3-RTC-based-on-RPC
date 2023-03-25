function vector_product,m,n
    
;    m = [2,0,0]
;    n = [0,2,0]
    a = m(0)
    b = m(1)
    c = m(2)
    d = n(0)
    e = n(1)
    f = n(2)
    
    x = b*f - c*e
    y = c*d - a*f
    z = a*e - b*d
    
    t = [x,y,z]
    return,t

end