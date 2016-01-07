function P1 = FunctionInstanceLable(P,seq,ImgGrandtruth,options)
dataFrame = [];
instlabel =[];
    for frmunm = P(1,3):P(end,3)
        index = P((P(:,3)==frmunm),:);
        if(sum(ImgGrandtruth{seq,frmunm}(:))==1)
            for instnum =1:size(index,1)
                a = ImgGrandtruth{seq,frmunm}(index(instnum,2):index(instnum,2)+options.NumGridPixel,index(instnum,1):index(instnum,1)+options.NumGridPixel);
                if(sum(a(:))>1)
                    instancelable1(instnum,1)= 1;
                else
                    instancelable1(instnum,1)= 0;
                end
            end
            baglable1 = ones(length(instancelable1),1);
        else
%             
            instancelable1 = zeros(size(index,1),1);
             baglable1 = zeros(length(instancelable1),1);
        end

        dataFrame = [dataFrame;baglable1];
        instlabel = [instlabel;instancelable1];
        clear  instancelable1 baglable1;
    end

    P1 =[P,ones(size(P,1),1).*seq,instlabel,dataFrame];
