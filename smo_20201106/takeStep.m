function resule_step = takeStep( i1, i2 )
% i1代表第一个乘子（违反KKT条件），i2代表第二个乘子，选定两个乘子之后进行优化
%  若有改进，返回1， 反之返回0

% 全局变量
global train;
global target;
global alph;
global N;
global error_cache;
global b;
global W;
global C;
global kernelPara;

resule_step  =0;
% i1 和 i2 是同一点，不进行优化
if i1 == i2
    return;
end

% old alph1 and alph2， new alph ueing a1 and a2
alph1 = alph(i1);
alph2 = alph(i2);
% lagrange multipliers' target value
y1 = target(i1);
y2 = target(i2);

% multipliers' E
if alph1>0 && alph1<C
    E1 = error_cache(i1);
else
   E1 = calE(i1);
end

if alph2>0 && alph2<C
    E2 = error_cache(i2);
else
    E2 = calE(i2);
end

% 按照公式推导，对alph2是有范围限制的，求该范围
if y1 == y2
    gamma = alph1 + alph2;
    if gamma > C
        L = gamma-C;
        H = C;
    else
        L = 0;
        H = gamma;
    end
else
    gamma = alph2 - alph1;
    if gamma > 0
        L = gamma;
        H = C;
    else
        L = 0;
        H = C + gamma;
    end
end

% 判断L 与 H是否相等，相等则优化无意义，返回0
if abs(L-H) < eps
    resule_step = 0;
    return;
end

% 计算eta，计算出alph2_new
k11 = KerFunc(train(i1, :), train(i1,:), kernelPara);
k22 = KerFunc(train(i2, :), train(i2, :), kernelPara);
k12 = KerFunc(train(i1, :), train(i2, :), kernelPara);

% 按照该方法计算，eta>=0
eta = k11 + k22 - 2*k12;
% 对eta范围合法性判断
if eta > 0
    a2 = alph2 + y2*(E1 - E2)/eta;
    %   针对alph2_new 的范围进行限制
    if a2 < L
        a2 = L;
    elseif a2 > H
        a2 = H;
    end
else
    %   eta值为0，此时代表两个样本点相同，此时应当重新选择第二个乘子
    resule_step = 0;
    return;
end

% 判断alph2是否改进，若无则直接返回
if abs(a2-alph2) < eps*(a2+alph2+eps)
    resule_step = 0;
    return;
end

% calculate alph1
a1 = alph1 + y1*y2*(alph2 - a2);
% 对a1计算的结果也要进行限制，避免其超过[0,C]的范围
if a1 < 0
    a2 = a2 + y1*y2*a1;
    a1 = 0;
elseif a1 > C
    a2 = a2 + y1*y2*(a1-C);
    a1 = C;
end
% disp('takeStep:calculate alph1_new success \n');

% update b
if a1>0 && a1<C
    bnew = E1 + y1 * k11 * (a1-alph1) + y2 * k12 * (a2-alph2) + b;
elseif a2>0 && a2<C
    bnew = E2 + y1 * k12 * (a1-alph1) + y2 * k22 *(a2 - alph2) + b;
else
    b1 = E1 + y1 * k11 * (a1-alph1) + y2 * k12 * (a2-alph2) + b;
    b2 = E2 + y1 * k12 * (a1-alph1) + y2 * k22 *(a2 - alph2) + b;
    bnew = (b1+b2) / 2;
end
delta_b = bnew - b;
b = bnew;

% 每次优化了两个乘子之后也要对error_cacehe 进行重新计算，error_cache针对的non-bound点
% 刚优化过的两个点对应的error_cache 一定是0
t1 = y1 * (a1 - alph1);
t2 = y2 * (a2 - alph2);

for i = 1 : N
    if alph(i)>0 && alph(i)<C        
        error_cache(i) = error_cache(i) + t1*KerFunc(train(i1,:), train(i,:), kernelPara) + ...
            t2*KerFunc(train(i2,:), train(i,:), kernelPara) - delta_b;
    end
end
error_cache(i1) = 0;
error_cache(i2) = 0;

% 更新alph1 and alph2
alph(i1) = a1;
alph(i2) = a2;

resule_step = 1;
end

