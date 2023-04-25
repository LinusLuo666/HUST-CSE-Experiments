function [ncAC]=JSteg_simulation(COVER,STEGO,message)

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

ncAC=numel(AC_Location);	% 得到非0的AC系数个数

messageLen=length(message);

%信息过长
if(messageLen>ncAC)
	error('ERROR (too long message)');
end

i_DCT=1;
i_MSG=1;
while i_MSG<=messageLen
    if(i_DCT>ncAC) % 没有更多可供注入密文的AC系数
        fprintf('Max messageLength is %d.\n', i_MSG-1);
        error('ERROR (too long message)');
    end
    DCTInfo=DCT(AC_Location(i_DCT));
    if(DCTInfo>0)
        if(mod(DCTInfo,2)) % 正奇数
            DCT(AC_Location(i_DCT))=DCTInfo+message(i_MSG)-1;
        else % 正偶数
            DCT(AC_Location(i_DCT))=DCTInfo-message(i_MSG);
        end
    else
        if(mod(DCTInfo,2)) % 负奇数
            DCT(AC_Location(i_DCT))=DCTInfo+message(i_MSG);
        else % 负偶数
            DCT(AC_Location(i_DCT))=DCTInfo-message(i_MSG)+1;
        end
    end
    if(DCT(AC_Location(i_DCT))==0) % 如果嵌入后是0，该密文重新嵌入
        i_MSG=i_MSG-1; 
    end
    i_DCT=i_DCT+1;
    i_MSG=i_MSG+1;
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
