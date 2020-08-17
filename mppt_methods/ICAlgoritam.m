function output = ICAlgoritam(V, I)

   
duty_init=0.5;
duty_min=0.0;
duty_max=1.0;

error = 0.000;

persistent Vold Iold duty_old;

if isempty(Vold)
    Vold=0;
    Iold = 0;
    duty_old=duty_init;
end
        step = 0.0025;
        
  
    
   
    DV = V - Vold;
    DI = I - Iold; 
    
    if(abs(DV) <= error)
       if(abs(DI) <= error)
           output = duty_old;
       else
           if(DI > 0)
               output = duty_old - step;
              
           else
               output = duty_old + step;
               
           end
       end
   else
       if(abs(I + V*DI/DV) <= error )
           output = duty_old;
           
       else
           if((I + V*DI/DV) > error)
               output = duty_old - step;
               
           else
               output = duty_old + step;
               
           end
       end
    end        
   
    
    
    
    if output >duty_max
     output=duty_max;
    else
        if output<duty_min
      output=duty_min;
        end
    end
 
 
 duty_old=output;
 Vold=V;
 Iold = I;
end

