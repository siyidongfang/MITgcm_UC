%             if(hFacW(i,j,k)==1)
%                 hFacWf(i,j,(k-1)*ffac+1:k*ffac) = 1;
%             elseif (hFacW(i,j,k)==0)
%                 hFacWf(i,j,(k-1)*ffac+1:k*ffac) = 0;
%             else
%                 nf1 = 
%                 nf0 = 
%                 nf_partial = 
% 
%                 hFacWf(i,j,(k-1)*ffac+1:(k-1)*ffac+1+ nf1-1 ) = 1;
%                 hFacWf(i,j,k*ffac-nf0+1:k*ffac) = 1;
%             end