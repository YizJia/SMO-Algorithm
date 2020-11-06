load breast;

% Data dictionary
% -train  训练数据集（300行，10列）
% -test   测试数据集
% -target     标记（300行，1列）
% -alph   要求的参数
% -N  训练数据集的个数
% -error_cache    存放non-bound的样本误差（300行，1列）
% -b      超平面方程中的常数项
% -W      超平面方程中的系数
% -C   惩罚系数
% kernelPara      指定使用核函数方法的参数
% -tolerence      ui与边界之间的公差范围
% -numChanged     每次优化更新的乘子数量
% -examineAll     控制是否全局检查更新的开关
% -gamma     核函数的参数
% -coef0      多项式核 sigmod核中的常量


%initialization
% 全局变量
global train;
global target;
global alph;
global N;
global error_cache;
global b;
global C;
global tolerence;
global kernelPara;
global gamma;
global coef0;

% 采用zscore函数进行数据的标准化，使数据集满足正态分布
% 避免样本维度之间量纲差距太大，造成收敛缓慢的情况
zx = zscore(x);
train = zx(1:300, :);
target = y(1:300, :);
alph = zeros(size(train,1), 1);
N = size(train, 1);
error_cache = zeros(size(train,1), 1);
b = 0;
C = 10;
tolerence = 0.001; %error tolent
kernelPara = 2;
gamma = 0.5;
coef0 = 1;

numChanged = 0;
examineAll = 1;
jishu = 0;

% 计时
tic

%训练样本，通过选择遍历全部样本点或者non-bound点来执行下一步
while numChanged>0 || examineAll
    numChanged = 0;
    if examineAll
        for i = 1:N
            numChanged = numChanged + examineExample(i);
        end        
    else
        for i = 1 : N
            if alph(i)>0 && alph(i)<C
                numChanged = numChanged + examineExample(i);
            end            
        end
    end  
    
    jishu = jishu + 1;
    
    if examineAll == 1
        examineAll = 0;
    elseif numChanged == 0
        examineAll = 1;
    end    
end

% 计时
toc

% 输出迭代的次数
disp(['num of itera : ' num2str(jishu)]);

% finalW = zeros(1,size(train, 2));
finalW = (alph .* target)' * train;

