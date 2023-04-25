stego='stego.jpg';
SEED=99;
mlen=80;
frr=fopen('f5dec.txt','a');
messageste=nsf5_extract(stego,SEED,frr,mlen);
function message=nsf5_extract(stego,SEED,frr,mlen)

try
    jobj = jpeg_read(stego); % JPEG image structure
    dct = jobj.coef_arrays{1}; % DCT plane
catch
    error('ERROR (problem with the cover image)');
end
AC=numel(dct)-numel(dct(1:8:end,1:8:end));
changeable=true(size(dct));
changeable(1:8:end,1:8:end)=false;
changeable=find(changeable);
rand('state',SEED);
changeable=changeable(randperm(AC));
idD=1;
for id=1:mlen
    while((dct(changeable(idD))==0))
        idD=idD+1;
    end
    if(mod(dct(changeable(idD)),2)==1)
        message(1,id)=1;
    else
        message(1,id)=0;
    end
    idD=idD+1;
end
for id=1:mlen
    fwrite(frr,message(1,id),'ubit1');
end
end

        