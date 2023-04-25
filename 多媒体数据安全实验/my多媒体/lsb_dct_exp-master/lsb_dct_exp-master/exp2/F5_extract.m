function message=F5_extract(STEGO,messageLen)

try
	jobj=jpeg_read(STEGO);	%��ȡstegoͼƬ
	DCT=jobj.coef_arrays{1};%��ȡDCTϵ��
catch
	error('ERROR (problem with the cover image)');
end

AC_Location=DCT; % ����DCT
AC_Location(1:8:end,1:8:end)=false; % ��DCϵ����0
AC_Location=find(AC_Location);	%�ҳ�DCT�в�ΪDCϵ������Ϊ0��λ��

i_DCT=1;

for i_MSG=1:2:messageLen
	DCTInfo=DCT(AC_Location(i_DCT:i_DCT+2));
    DCTInfo(DCTInfo<0)=DCTInfo(DCTInfo<0)+1; % �����и���+1�󣬸ı����λ
    message(1,i_MSG)=bitxor(mod(DCTInfo(1),2),mod(DCTInfo(2),2)); % a1��λ���a2
    message(1,i_MSG+1)=bitxor(mod(DCTInfo(2),2),mod(DCTInfo(3),2)); % a2��λ���a3
    i_DCT=i_DCT+3;
end
