%这段代码的主要功能是将一个文本文件（'hide.txt'）的内容以二进制形式隐藏在
%一张图像（'cover.bmp'）中，然后将处理后的图像保存为'stego.bmp'。

% 读取原始图像文件'cover.bmp'并将其赋值给变量Picture
Picture = imread('cover.bmp');

% 创建一个新变量Double_Picture，将原始图像数据赋值给它
Double_Picture = Picture;

% 将Double_Picture中的数据类型转换为双精度(double)类型
Double_Picture = double(Double_Picture);    
% 加载原始图像

% 以只读方式打开'hide.txt'文件，并将文件标识符存储在wen.txt_id变量中
wen.txt_id = fopen('hide.txt','r');  

% 从'hide.txt'文件中读取文本信息，并将其转换为二进制序列
[msg,len] = fread(wen.txt_id,'ubit1');  % 秘密信息转换为二进制序列

% 获取Double_Picture的大小，其中m为行数，n为列数
[m,n]=size(Double_Picture); % m=512, n=512

% 初始化变量p
p=1;
%% 

% 使用两层循环遍历Double_Picture的每个像素
for f2=1:n
    for f1=1:m
        % 主要算法，对每个像素点的灰度值的最低比特位替换为私密信息序列的每一比特信息
        % p = p - p mod 2 + msg
        Double_Picture(f1,f2)=Double_Picture(f1,f2)-mod(Double_Picture(f1,f2),2)+msg(p,1);

        % 如果p达到了私密信息长度，跳出循环
        if p==len
            break;
        end
        p=p+1;
    end
    % 如果p达到了私密信息长度，跳出循环
    if p==len
        break;
    end
end

% 将Double_Picture的数据类型转换回无符号整数(uint8)
Double_Picture=uint8(Double_Picture);   

% 将含有私密信息的图像Double_Picture保存为'stego.bmp'
imwrite(Double_Picture,'stego.bmp');

% 使用subplot函数分别显示原始图像和含有私密信息的图像
subplot(121);imshow(Picture);title('initial image');
subplot(122);imshow(Double_Picture);title('After image');   % 显示图像和文字

% 关闭文件标识符wen.txt_id
fclose(wen.txt_id);
