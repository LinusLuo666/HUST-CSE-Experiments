function [ncAC]=F5_simulation(COVER,STEGO,message)

try
	jobj=jpeg_read(COVER);	%读取cover图片
	PrimeDCT=jobj.coef_arrays{1};%读取DCT系数
    DCT=PrimeDCT;
catch
	error('ERROR (problem with the cover image)');
end

AC_Location=DCT; % 复制DCT
AC_Location(1:8:end,1:8:end)=false; % 将DC系数置0
AC_Location=find(AC_Location);	%找出DCT中不为DC系数、不为0的位置

ncAC=numel(AC_Location);	% 得到AC系数总数

messageLen=length(message); % 得到密文的数量

%信息过长
if(messageLen/2>ncAC/3)
	error('ERROR (too long message)');
end

i_DCT=1;
i_MSG=1;

while i_MSG+1<=messageLen
    if(i_DCT+2>ncAC) % 没有更多可供注入密文的AC系数
        fprintf('Max messageLength is %d.\n', i_MSG-2);
        error('ERROR (too long message)');
    end
    DCTInfo=DCT(AC_Location(i_DCT:i_DCT+2));
    DCTInfo(DCTInfo<0)=DCTInfo(DCTInfo<0)+1; % 将所有负数+1，改变最低位
    xor1=bitxor(mod(DCTInfo(1),2),mod(DCTInfo(2),2)); % a1按位异或a2
    xor2=bitxor(mod(DCTInfo(2),2),mod(DCTInfo(3),2)); % a2按位异或a3
    tobe_change=i_DCT;
    if(message(i_MSG)==xor1) % 判断异或值，确定修改位
        if(message(i_MSG+1)==xor2)
            tobe_change=-1;
        else
            tobe_change=tobe_change+2;
        end
    else
        if(message(i_MSG+1)~=xor2)
            tobe_change=tobe_change+1;
        end 
    end
    if(tobe_change~=-1) % 需要修改
        if(DCT(AC_Location(tobe_change))>0) % 正数减1
            DCT(AC_Location(tobe_change))=DCT(AC_Location(tobe_change))-1;
        else % 负数加1
            DCT(AC_Location(tobe_change))=DCT(AC_Location(tobe_change))+1;
        end
        if(DCT(AC_Location(tobe_change))==0) % 如果嵌入后是0，这两位密文重新嵌入
            i_MSG=i_MSG-2; 
            AC_Location(tobe_change)=[]; % 删除这一位置
            ncAC=ncAC-1;
            i_DCT=i_DCT-3; % 复用未被修改的AC系数
        end
    end
    i_DCT=i_DCT+3;
    i_MSG=i_MSG+2; % for循环内循环索引改变不生效
end

%%% save the resulting stego image
try
    jobj.coef_arrays{1} = DCT;
    jobj.optimize_coding = 1;
    jpeg_write(jobj,STEGO);
catch
    error('ERROR (problem with saving the stego image)');
end

%显示图像
subplot(2,2,1);imshow(COVER);
title('未嵌入信息的图像');

subplot(2,2,2);histogram(PrimeDCT);axis([-10,10,0,2*1e4]);
title('嵌入前的图像DCT系数直方图');

subplot(2,2,3);imshow(STEGO);
title('嵌入信息的图像');

subplot(2,2,4);histogram(DCT);axis([-10,10,0,2*1e4]);
title('嵌入后的图像DCT系数直方图');
