function message=JSteg_extract(STEGO,messageLen)

try
	jobj=jpeg_read(STEGO);	%读取stego图片
	DCT=jobj.coef_arrays{1};%读取DCT系数
catch
	error('ERROR (problem with the cover image)');
end

AC_Location=DCT; % 复制DCT
AC_Location(1:8:end,1:8:end)=false; % 将DC系数置0
AC_Location(abs(AC_Location)<=1)=0; % 将绝对值小于等于1的位置置为0
AC_Location=find(AC_Location);	%找出DCT中不为DC系数、绝对值大于1的位置

i_DCT=1;

for i_MSG=1:messageLen
    DCTInfo=DCT(AC_Location(i_DCT));
    if(DCTInfo>0)
        message(1,i_MSG)=mod(DCTInfo,2);
    else
        message(1,i_MSG)=mod(DCTInfo+1,2);
    end
    i_DCT=i_DCT+1;
end
