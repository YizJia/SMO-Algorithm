
testData = zx(301:end, :);
testLabel = y(301:end, :);
dataNum = size(testData, 1);

rightNum = 0;

for i = 1 : dataNum
    ui = finalW * testData(i, :)' - b;
    if ui < 0 && ( testLabel(i) == -1)
        rightNum = rightNum + 1;
    elseif ui >0 && ( testLabel(i) == 1)
        rightNum =  rightNum + 1;
    end
end

rate = rightNum / dataNum;