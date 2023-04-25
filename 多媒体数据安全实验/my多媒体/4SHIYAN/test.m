clear all;
% 清除工作区中所有变量。

[fn,pn]=uigetfile({'*.jpg','JPEG files(*.jpg)';'*.bmp','BMP files(*.bmp)'},'Select file to hide');
% 弹出一个文件选择对话框，让用户选择一个 JPG 或 BMP 格式的图片文件。

name=strcat(pn,fn);
% 构造文件的完整路径。

t=imread(name);
% 读入图片文件。

I=t(1:512,1:512);
% 取图片的前 512 行和前 512 列，生成一个 512x512 的图像矩阵 I。

sz=size(I);
% 获取 I 的大小，生成一个包含行数和列数的数组 sz。

for k=1:3
    % 对每个隐写率进行以下操作：
    % 据隐写率大小生成秘密信息，隐写率为 0.3 0.5 0.7三种
    rt=0.3+0.2*(k-1);
    % 根据 k 值计算隐写率 rt，rt 的取值为 0.3、0.5 和 0.7。
    row=round(sz(1)*rt);
    % 计算秘密信息矩阵的行数，为 sz(1) 乘以 rt 的四舍五入整数值。
    col=round(sz(2)*rt);
    % 计算秘密信息矩阵的列数，为 sz(2) 乘以 rt 的四舍五入整数值。
    msg=randsrc(row,col,[0 1;0.5 0.5]);
    % 生成一个大小为 rowxcol 的随机矩阵 msg，矩阵中的元素值为 0 或 1，生成规则为：0 和 1 的概率均为 0.5。
    % randsrc 是 MATLAB 内置函数，用于生成服从特定概率分布的随机数。

    % LSB信息隐写
    stg=I;
    % 将图像矩阵 I 复制给新变量 stg，后面将对 stg 进行信息隐写。
    stg(1:row,1:col)=bitset(stg(1:row,1:col),1,msg);
    % 对 stg 的前 row 行和前 col 列的像素值进行隐写，隐写的信息为 msg 矩阵中的元素值，隐写方式为最低有效位 (LSB) 隐写。
    % bitset 是 MATLAB 内置函数，用于将指定位的值设置为指定值。

    imwrite(stg,strcat(pn,strcat(sprintf('stg_%d_',floor(100*rt)),fn)),'bmp');
    % 将隐写后的图像 stg 写入到文件中，文件名为 pn 和 fn 的组合，其中 pn 为原始文件的路径，fn 为原始文件名，中间插入了一个字符串 'stg_' 和隐写率的百分数。
    i=1;
    for rto=0.1:0.01:1
        % 对每个截取比例进行以下操作：  （截取比例为从10%到100%）
        row=round(sz(1)*rto);
        % 计算截取的行数，为 sz(1) 乘以 rto 的四舍五入整数值。
        col=round(sz(2)*rto);
        % 计算截取的列数，为 sz(2) 乘以 rto 的四舍五入整数值。
        p(k,i)=StgPrb(stg(1:row,1:col));
        % 调用函数 StgPrb，计算 stg 矩阵的前 row 行和前 col 列中的隐写概率，将概率值保存到 p 数组中的第 k 行、第 i 列。
        % StgPrb 是一个 MATLAB 函数，用于计算指定矩阵中的隐写概率。
        i=i+1;
        % 将 i 的值加 1。
    end
end
% 循环结束。
