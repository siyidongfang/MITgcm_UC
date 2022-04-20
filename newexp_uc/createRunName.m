%%%
%%% createRunName.m
%%%
%%% Standardizes generation of simulation names based on model parameters
%%%

function run_name = createRunName (Ua,Va,atide,Hi,Ai,Ws,is_hires)

  if (is_hires)
    resstr = 'hires_';
  else
    resstr = 'lores_';
  end

%   run_name = [resstr 'Ua',num2str(Ua),'Va',num2str(Va),'_Atide',num2str(atide),...
%   '_Hi',num2str(Hi),'Ai',num2str(Ai),'_Ws',num2str(Ws/1000)];

run_name=['Ua',num2str(Ua),'Va',num2str(Va),'_Atide',num2str(atide),...
  '_Hi',num2str(Hi),'Ai',num2str(Ai),'_Ws',num2str(Ws/1000)];

%   if (is_relaxSurfT)
%     run_name = [run_name,'_relaxSurfT'];
%   end
end