Picture = imread('cover.bmp');
Double_Picture = Picture;
Double_Picture = double(Double_Picture);    
% 加载原始图像

wen.txt_id = fopen('hide.txt','r');  
[msg,len] = fread(wen.txt_id,'ubit1');  % 秘密信息转换为二进制序列

[m,n]=size(Double_Picture); % m=512, n=512
p=1;
for f2=1:n
    for f1=1:m
        Double_Picture(f1,f2)=Double_Picture(f1,f2)-mod(Double_Picture(f1,f2),2)+msg(p,1);
        % 主要算法，对每个像素点的灰度值的最低比特位替换为私密信息序列的每一比特信息
        % p = p - p mod 2 + msg
        if p==len
            break;
        end
        p=p+1;
    end
    if p==len
        break;
    end
end

Double_Picture=uint8(Double_Picture);   
imwrite(Double_Picture,'stego.bmp');
subplot(121);imshow(Picture);title('initial image');
subplot(122);imshow(Double_Picture);title('After image');   % 显示图像和文字

fclose(wen.txt_id);
