function [] = logistic_regression( training_file, degree, test_file )

    delimiterIn = ' ';
    training_data = importdata(training_file, delimiterIn);
    
    [height, width] = size(training_data);
    %data_split_by_class = cell([1 2]);
    
    phi = zeros(height, width);
    phi(:, 1) = ones(1,height);
    phi(:, 2:width) = training_data(:, 1:width-1);
    
    t = training_data(:, width);
    
    t = t == 1;
    
    weights = zeros(1, width);
    
    while (1)
    
        y = sigmf(weights * phi.', [1 0]);
        oneMinusY = 1 - y;
    
        R = diag(y.*(oneMinusY));
        H = pinv(phi.' * R * phi);
        E = phi.' * (y - t);

        newWeights =  weights.' - (H * E);
        
        if weightChange(newWeights, weights) || crossEntropy(y, t)
            break;
        end
    end
    
end

function [minWeightChange] = weightChange(newWeights, oldWeights)
    size(newWeights)
    size(oldWeights)
    weightChange = newWeights + oldWeights;
    weightChange = abs(weightChange);
    
    sumWeightChanges = sum(weightChange);
    
    if sumWeightChanges < 0.001
        minWeightChange = true;
    else
        minWeightChange = false;
    end
end

function [minCrossEntropy] = crossEntropy(y, t)
    oneMinusY = 1 - y;
    oneMinusT = 1 - t;
    
    tLogY = t.' * log(y);
    oneMinusLog = oneMinusT.' * log(oneMinusY);
    
    entropy = -sum(tLogY + oneMinusLog);
    
    if entropy < 0.001
        minCrossEntropy = true;
    else
        minCrossEntropy = false;
    end
    
end