cover='cover.jpg'; % 设置原始图像文件名
stego='stegojsteg.jpg'; % 设置隐藏信息后的图像文件名
frr=fopen('dec.txt','w'); % 打开一个文件用于写入解密后的信息

% 读取嵌入了信息的图像的DCT系数
try 
    jobj=jpeg_read(stego); % 读取JPEG图像文件
    dct=jobj.coef_arrays{1}; % 提取DCT系数
    dct1=jobj.coef_arrays{1}; % 备份DCT系数
catch
    error('Error(problem with the cover image)'); % 报错提示原始图像文件有问题
end

len=1200; % 要解密的信息长度
p=1; % 当前解密的信息位置
[m,n]=size(dct); % DCT系数的尺寸
for f2 =1:n
    for f1 =1:m
        % 判断是否为DC系数或直流系数
        if(dct(f1,f2)==1||dct(f1,f2)==0)
            continue; % 跳过
        end
        
        odd=mod(dct(f1,f2),2); % 取DCT系数的最低位
        fwrite(frr,odd,'ubit1'); % 将最低位写入文件
        
        % 判断是否解密完所有信息
        if(p==len)
            break;
        end
        p=p+1;
    end
    if p ==len
        break;
    end
end

fclose(frr); % 关闭文件流
