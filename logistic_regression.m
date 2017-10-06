function [] = logistic_regression( training_file, degree, test_file )

    delimiterIn = ' ';
    training_data = importdata(training_file, delimiterIn);
    testing_data = importdata(test_file, delimiterIn);
    
    [height, width] = size(training_data);
    testHeight = size(testing_data, 1);
    
    if degree == 1
    
        phi = zeros(height, width);
        phi(:, 1) = ones(1,height);
        phi(:, 2:width) = training_data(:, 1:width-1);
    
        testPhi = zeros(testHeight, width);
        testPhi(:, 1) = ones(1,testHeight);
        testPhi(:, 2:width) = testing_data(:, 1:width-1);

        weights = zeros(width, 1);
        
    else
    
        phi = zeros(height, (2*width) - 1);
        phi(:, 1) = ones(1,height);
        
        testPhi = zeros(testHeight, (2*width) - 1);
        testPhi(:, 1) = ones(1,testHeight);
        
        for i = 2:(2*width) - 1
            if mod(i,2) 
                phi(:, i) = training_data(:, fix(i / 2)).^2;
                testPhi(:, i) = testing_data(:, fix(i / 2)).^2;
            else
                phi(:, i) = training_data(:, fix(i / 2));
                testPhi(:, i) = testing_data(:, fix(i / 2));
            end
        end

        weights = zeros((2*width) - 1, 1);
        
    end
    
    t = training_data(:, width);
    t = t == 1;
    
    while (1)
    
        y = sigmf(weights.' * phi.', [1 0]).';
        oneMinusY = 1 - y;
    
        R = diag(y.*(oneMinusY));
        H = pinv(phi.' * R * phi);
        E = phi.' * (y - t);

        newWeights = weights - (H * E);
        
        yN = sigmf(newWeights.' * phi.', [1 0]).';
        
        if weightChange(newWeights, weights) || crossEntropy(y, yN, t)
            break;
        end
        
        weights = newWeights;
    end
    
    for i = 0:(size(newWeights, 1)-1)
        fprintf('w%d=%.4f\n', i, newWeights(i+1));
    end
     
    finalY = sigmf(newWeights.' * testPhi.', [1 0]).';
    
    testT = testing_data(:, width);
    testT = testT == 1;
    
    class1 = finalY > 0.5;
    class1AndTie = finalY > 0.5;
    
    tieCase = bitxor(class1, class1AndTie);
    accuracy = zeros(testHeight, 1);
    
    for i = 1:testHeight
       
       if tieCase(i) ~= 0
           accuracy(i) = 0.5;
       elseif class1(i) == testT(i)
           accuracy(i) = 1;
       end
       
       if class1(i) == 0
           finalY(i) = 1 - finalY(i);
       end
       
       fprintf('ID=%5d, predicted=%3d, probability = %.4f, true=%3d, accuracy=%4.2f\n', ...
                        i, class1(i), finalY(i), testT(i), accuracy(i)); 
    end
    
    classification_accuracy = mean(accuracy);
    
    fprintf('classification accuracy=%6.4f\n', classification_accuracy);
end

function [minWeightChange] = weightChange(newWeights, oldWeights)
    weightChange = newWeights + oldWeights;
    weightChange = abs(weightChange);
    
    sumWeightChanges = sum(weightChange);
    
    if sumWeightChanges < 0.001
        minWeightChange = true;
    else
        minWeightChange = false;
    end
end

function [minCrossEntropy] = crossEntropy(y, yN, t)
    oneMinusY = 1 - y;
    oneMinusYN = 1 - yN;
    oneMinusT = 1 - t;

    tLogY = t.*log(y);
    oneMinusLog = oneMinusT.*log(oneMinusY);
    
    tLogYN = t.*log(yN);
    oneMinusLogYN = oneMinusT.*log(oneMinusYN);
    
    entropy1 = -sum(tLogY + oneMinusLog);
    entropy2 = -sum(tLogYN + oneMinusLogYN);
    
    if abs(entropy1-entropy2) < 0.001
        minCrossEntropy = true;
    else
        minCrossEntropy = false;
    end
    
end