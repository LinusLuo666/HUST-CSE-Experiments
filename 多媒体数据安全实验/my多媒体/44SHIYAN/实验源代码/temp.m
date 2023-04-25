cover='cover.jpg';
stego='stegojsteg.jpg';
wen.txt_id=fopen('hide1.txt','r');
[msg,L]=fread(wen.txt_id,'ubit1');
try 
    jobj=jpeg_read(cover);
    dct=jobj.coef_arrays{1};
    dct1=jobj.coef_arrays{1};
catch
    error('Error(problem with the cover image)');
end
AC=numel(dct)-numel(dct(1:8:end,1:8:end));
if(length(msg)>AC)
    error('ERROR(too long message)');
end
len=length(msg);
id=1;
[m,n]=size(dct);
for f2 =1:n
    for f1 =1:m
        if(abs(dct(f1,f2))<=1)
            continue;
        end
        if(dct(f1,f2)>1)%正数
            odd=mod(dct(f1,f2),2);
            if(msg(id,1)==0&&odd==1)%奇数遇到0
                dct(f1,f2)=dct(f1,f2)-1;
            end
            if(msg(id,1)==1 && odd==0)
               dct(f1,f2)=dct(f1,f2)+1;
            end
        end
        if(dct(f1,f2)<-1)
            odd=abs(mod(dct(f1,f2),2));
            if(msg(id,1)==0&&odd==1)%奇数遇到0
                dct(f1,f2)=dct(f1,f2)+1;
            end
            if(msg(id,1)==1 && odd==0)
               dct(f1,f2)=dct(f1,f2)-1;
            end
        end
        if(id==len)
            break;
        end
        id=id+1;
    end
    if id ==len
        break;
    end
end
dctchange=dct-dct1;       
try 
    jobj.coef_arrays{1}=dct;
    jobj.optimize_coding=1;
    jpeg_write(jobj,stego);
catch
    error('ERROR (problem with saving the stego image)')
end
subplot(2,2,1);
imshow(cover);
title('initial image');
subplot(2,2,2);
imshow(stego);
title('after image');
subplot(2,2,3);
% i=1;
% j=1;
% for f1 =1:n
%     for f2=1:m
%         if(dct1(f1,f2)>=-8 &&dct1(f1,f2)<=8)
%             dcti(i,j)=dct1(f1,f2);
%             j=j+1;
%         end
%     end
%     i=i+1;
% end

hist(dct1,300);
axis([-8 8,0 inf]);
title('histogram of initial image');
subplot(2,2,4);
hist(dct,300);
axis([-8 8,0 inf]);
title('histogram of after image');
%bar(dct);

