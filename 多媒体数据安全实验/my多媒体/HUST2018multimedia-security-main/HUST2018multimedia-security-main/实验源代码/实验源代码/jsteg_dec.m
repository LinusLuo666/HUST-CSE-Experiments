cover='cover.jpg';
stego='stegojsteg.jpg';
frr=fopen('dec.txt','a');
try 
    jobj=jpeg_read(stego);
    dct=jobj.coef_arrays{1};
    dct1=jobj.coef_arrays{1};
catch
    error('Error(problem with the cover image)');
end
AC=numel(dct)-numel(dct(1:8:end,1:8:end));
len=800;
p=1;
[m,n]=size(dct);
for f2 =1:n
    for f1 =1:m
        if(abs(dct(f1,f2))<=1)
            continue;
        end
        if(dct(f1,f2)>1)%正数
            odd=mod(dct(f1,f2),2);
            if(odd==0)%奇数
               fwrite(frr,0,'ubit1');
               %result(p,1)=0;
            end
            if( odd==1)
               fwrite(frr,1,'ubit1');
              % result(p,1)=1;
            end
        end
        if(dct(f1,f2)<-1)
            odd=abs(mod(dct(f1,f2),2));
            if(odd==1)
                fwrite(frr,1,'ubit1');
            end
            if(odd==0)
               fwrite(frr,0,'ubit1');
            end
        end
        if(p==len)
            break;
        end
        p=p+1;
        
    end
    if p ==len
        break;
    end
end
fclose(frr);
            
            
        
            
            
        
            
            
            
        
    
