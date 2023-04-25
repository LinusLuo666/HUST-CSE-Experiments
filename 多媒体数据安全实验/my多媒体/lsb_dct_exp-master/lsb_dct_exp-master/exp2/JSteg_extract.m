function message=JSteg_extract(STEGO,messageLen)

try
	jobj=jpeg_read(STEGO);	%��ȡstegoͼƬ
	DCT=jobj.coef_arrays{1};%��ȡDCTϵ��
catch
	error('ERROR (problem with the cover image)');
end

AC_Location=DCT; % ����DCT
AC_Location(1:8:end,1:8:end)=false; % ��DCϵ����0
AC_Location(abs(AC_Location)<=1)=0; % ������ֵС�ڵ���1��λ����Ϊ0
AC_Location=find(AC_Location);	%�ҳ�DCT�в�ΪDCϵ��������ֵ����1��λ��

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
