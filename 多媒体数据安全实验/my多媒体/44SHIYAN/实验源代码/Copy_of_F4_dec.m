cover='cover.jpg';
stego='stegoF4.jpg';
frr=fopen('F4_dec.txt','a');
try 
    jobj=jpeg_read(stego);
    dct=jobj.coef_arrays{1};
    dct1=jobj.coef_arrays{1};
catch
    error('Error(problem with the cover image)');
end
AC=numel(dct)-numel(dct(1:8:end,1:8:end));
len=80;
p=1;
[m,n]=size(dct);
for f2 =1:n
    for f1 =1:m
        if(dct(f1,f2)==0)
            continue;
        end
        if dct(f1,f2)>0
            odd=mod(dct(f1,f2),2);
            fwrite(frr,odd,'ubit1');
        else
            odd=mod(dct(f1,f2),2);
            fwrite(frr,mod(odd+1,2),'ubit1');
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