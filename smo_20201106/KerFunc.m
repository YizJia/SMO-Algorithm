function result = KerFunc( data1, data2, para )
%核函数计算

global gamma;
global coef0;

% para=1 : 线性核
if para == 1
    result = data1 * data2';
elseif para < 4
%   para == 2, 3 代表多项式核函数，并且作为幂次
    result = gamma * data1 * data2';
    result = ( result + coef0) .^para;
elseif para == 4
    % para=4 : 高斯核        
    % 传过来的data1， data2，可能是向量也可能是矩阵,利用完全平方和公式来进行计算
%   直接利用norm函数计算有问题
    L1 = size(data1, 1);
    L2 = size(data2, 1);    
    result = data1 * data2'; 
    result = result *2;
    result = result - sum(data1.^2, 2) * ones(1, L2);
    result = result -ones(L1, 1) *sum(data2.^2, 2);
    result = exp( result * gamma);
elseif para == 5
%   para == 5 : s型核函数 (使用双曲正切函数）
    result = gamma * data1 * data2' + coef0;
    result = tanh(result);
end

end

