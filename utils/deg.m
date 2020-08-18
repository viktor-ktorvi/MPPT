function Deg = deg(I,V,dI,dV)
    Deg = atan(dI/dV) + atan(I/V);
    Deg = Deg*180/pi;
end