function message=F5_extract(STEGO,messageLen)

try
	jobj=jpeg_read(STEGO);	%读取stego图片
	DCT=jobj.coef_arrays{1};%读取DCT系数
catch
	error('ERROR (problem with the cover image)');
end

AC_Location=DCT; % 复制DCT
AC_Location(1:8:end,1:8:end)=false; % 将DC系数置0
AC_Location=find(AC_Location);	%找出DCT中不为DC系数、不为0的位置

i_DCT=1;

for i_MSG=1:2:messageLen
	DCTInfo=DCT(AC_Location(i_DCT:i_DCT+2));
    DCTInfo(DCTInfo<0)=DCTInfo(DCTInfo<0)+1; % 将所有负数+1后，改变最低位
    message(1,i_MSG)=bitxor(mod(DCTInfo(1),2),mod(DCTInfo(2),2)); % a1按位异或a2
    message(1,i_MSG+1)=bitxor(mod(DCTInfo(2),2),mod(DCTInfo(3),2)); % a2按位异或a3
    i_DCT=i_DCT+3;
end
