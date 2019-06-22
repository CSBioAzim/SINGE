function [metric] = run_iLasso_row(m,outs,params,rownum)
dT=params.dT;
lambda=params.lambda;
p1=params.p1;
std_dev=params.kernel_width;
[LX,WX] = size(m,'X');
if ismember('regix',who(m))
    regix = m.regix;
    if iscolumn(regix)
        regix = regix';
    elseif ~isrow(regix)
        display('Error: Regulator indices must be a vector');
    end
    numregs = length(regix);
else
    regix = 1:LX;
    numregs = LX;
end

for p = rownum
    params.p = rownum;
    pa = [p setdiff([regix],p)];
    m.pa = pa;
    [pi,indf] = sort(pa);
    params.pa = pa;
    [metric] = iLasso_for_SCINGE(m, outs, lambda,'Gaussian',p1,dT,std_dev,params);
end
%Moved this code to iLasso_for_SINGE to enable saving multiple outputs
%from glmnet