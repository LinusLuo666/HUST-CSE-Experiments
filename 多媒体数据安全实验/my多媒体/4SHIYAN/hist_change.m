[fn,pn]=uigetfile({'*.jpg','JPEG files(*.jpg)';'*.bmp','BMP files(*.bmp)'},'Select file to hide');
% 弹出一个文件选择对话框，让用户选择一个 JPG 或 BMP 格式的图片文件。

name=strcat(pn,fn);
% 构造文件的完整路径。

I=rgb2gray(imread(name)); %对灰度图像进行隐藏
% 读入图片文件，将其转换为灰度图像，赋值给变量 I。

sz=size(I);
% 获取 I 的大小，生成一个包含行数和列数的数组 sz。

% generate msg
rt=1;%隐写率为 100%
% 隐写率 rt 为 1，即所有像素都用于隐写秘密信息。

row=round(sz(1)*rt);
% 计算秘密信息矩阵的行数，为 sz(1) 乘以 rt 的四舍五入整数值。
col=round(sz(2)*rt);
% 计算秘密信息矩阵的列数，为 sz(2) 乘以 rt 的四舍五入整数值。
msg=randsrc(row,col,[0 1;0.5 0.5]);
% 生成一个大小为 rowxcol 的随机矩阵 msg，矩阵中的元素值为 0 或 1，生成规则为：0 和 1 的概率均为 0.5。
% randsrc 是 MATLAB 内置函数，用于生成服从特定概率分布的随机数。

% LSB hide
stg=I;
% 将图像矩阵 I 复制给新变量 stg，后面将对 stg 进行信息隐写。
stg(1:row,1:col)=bitset(stg(1:row,1:col),1,msg);
% 对 stg 的前 row 行和前 col 列的像素值进行隐写，隐写的信息为 msg 矩阵中的元素值，隐写方式为最低有效位 (LSB) 隐写。
% bitset 是 MATLAB 内置函数，用于将指定位的值设置为指定值。

nI=sum(hist(I,[0:255]),2)';
% 统计原始图像中各个数值的出现次数，生成一个长度为 256 的数组 nI。

nS=sum(hist(stg,[0:255]),2)';
% 统计隐写后的图像中各个数值的出现次数，生成一个长度为 256 的数组 nS。

x=[80:99];
% 选择一个像素值区间，x 为该区间的取值范围。

figure;
% 创建一个新的图形窗口。

stem(x,nI(81:100));
% 用柱状图显示原始图像中在 x 区间内的像素数量。

figure;
% 创建一个新的图形窗口。

stem(x,nS(81:100));
imwrite(stg,'wow.jpg');
% 用柱状图显示隐写后的图像中在 x 区间内的像素数量。

% 循环结束。
