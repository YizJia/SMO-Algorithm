function count = examineExample( i2 )
% 对传过来下标对应的元素进行判断，是否违反KKT条件，并进一步执行第二个乘子的选择
%   计算相关的变量，根据数值来判断是否违反KKT条件，并进行第二个乘子的选择

% 全局变量
global target;
global alph;
global error_cache;
global C;
global tolerence;


y2 = target(i2);
alph2 = alph(i2);

%获取 Ei的值
if alph2>0 && alph2<C
    E2 = error_cache(i2);
else
    E2 = calE(i2);
end

r2 = E2 * y2;   %等价于yi * ui - 1
count = 0;

%判断i1对应的点是否违反KKT条件，可以作为第一个乘子
if (r2 > tolerence && alph2 > 0) || (r2 < -tolerence && alph2 < C)
%   当i1违反KKT条件时，继续寻找第二个乘子
%   第二个乘子首先在non-bound中寻找，可以满足max|E1 - E2|，若找到，进行优化
    if examineFirstChoice(i2, E2)
        count = 1;
    elseif examineNonBound(i2)
        count = 1;
    elseif examineBound(i2)
        count = 1;
    end        
end

end

function examine1 = examineFirstChoice (i2, E2)
% 从non-bound中找出达到max的样本点，若找到进行优化，否则，返回 0 
%   遍历non-bound点，进行|E1 - E2|的判断

% 全局变量
global alph;
global N;
global error_cache;
global C;

tmax = 0;
i1 = -1;

%外层循环是针对所有样本点，但会进行一次是否是non-bound 的判断
for i = 1 : N
    if alph(i) >0 && alph(i) < C
%       判断是否是non-bound
        E1 = error_cache(i);
%         E1 = calE(i);
        
%       找max
        if abs(E1 - E2) > tmax
            tmax = abs(E1 - E2);
            i1 = i;
        end
    end
end

examine1 = 0;
% 判断是否能找到max，若找到执行优化函数，若未找到，返回0
if i1 > 0 
    if takeStep(i1, i2)
        examine1 = 1;
    end
end

end

function examine2 = examineNonBound (i2)
% 从non-bound中未找出达到max的样本点，或优化被判定为无作用
%   定义一个随机数，采用遍历non-bound一遍的思想（但不是从头遍历，避免最终结果受下标靠前的点影响太大），每找到一个点就进行优化， 若优化成功，则函数返回

% 全局变量
global alph;
global C;
global N;

% 生成一个随机数，实现既可以遍历non-bound，也可以从随机位置开始
i0 = randi(N);

examine2 = 0;
for i = 1 : N
%   此处应当注意，取余的结果是0~N-1，但是matlab中下标是从1开始的，0是无效的
    i1 = mod(i+i0, N);
    if i1 == 0
        i1 = N;
    end
    if alph(i1)>0 && alph(i1) < C        
        if takeStep(i1, i2)
            examine2 = 1;
            break;
        end
    end        
end

end

function examine3 = examineBound (i2)
% 从non-bound中随机找出的样本点，优化被判定为无作用
%   定义一个随机数，采用遍历样本点一遍的思想（但不是从头遍历，避免最终结果受下标靠前的点影响太大），每找到一个点就进行优化， 若优化成功，则函数返回
% 全局变量
global N;

% 生成一个随机数，实现既可以遍历岩本点，也可以从随机位置开始
i0 = randi(N);

examine3 = 0;
for i = 1 : N
    i1 = mod(i + i0, N) ;
    if i1 == 0
        i1 = N;
    end
    if takeStep(i1, i2)
        examine3 = 1;
        break;
    end
end

end