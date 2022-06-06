%%%
%%% createRunName.m
%%%
%%% Standardizes generation of simulation names based on model parameters
%%%

function run_name = createRunName (Ua,Va,atide,Hi,Ai,Ws,Hbed,Htr,Zn,Zsb,dZs,is_hires,is_ContinuedRun)

  if (is_hires)
    resstr = 'hires_';
  else
    resstr = 'lores_';
  end

run_name=['Ua',num2str(Ua),'Va',num2str(Va),'_Atide',num2str(atide),...
  '_Hi',num2str(Hi),'Ai',num2str(Ai),'_Ws',num2str(Ws/1000) ...
  '_Hbed',num2str(Hbed) 'Htr',num2str(Htr) '_Zn',num2str(Zn) 'Zsb',num2str(Zsb) 'dZs',num2str(dZs) ];

%   if (is_ContinuedRun)
%     run_name = [run_name,'_prod'];
%   end
end