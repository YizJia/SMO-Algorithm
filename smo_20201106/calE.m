function resultE = calE( i1 )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明

% 全局变量
global train;
global target;
global alph;
global b;
global kernelPara;

y1 = target(i1);

u1 = (alph .* target)' * (KerFunc(train, train(i1, :), kernelPara) ) - b;
resultE = u1 - y1;
end

