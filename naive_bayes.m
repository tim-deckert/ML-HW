function [] = naive_bayes( data, test, type, number )

    delimiterIn = ' ';
    training_data = importdata(data, delimiterIn);
%     test_data = importdata(test, delimiterIn);
    
    [height, width] = size(training_data);    
    classes = unique (training_data(:,end));    
    data_split_by_class = cell(size(classes));
%     test_split_by_class = cell(size(classes));

    for i = 1:size(classes,1)   
        data_split_by_class{i} = training_data(training_data(:,width) == classes(i), 1:width);
%         test_split_by_class{i} = test_data(test_data(:,width) == classes(i), 1:width);
    end

    if (nargin == 3) && strcmp(type, 'gaussians')
        gaussians( data_split_by_class, test,  height, width);
    elseif nargin == 4 && strcmp(type, 'histograms')
        histograms( data_split_by_class, test_split_by_class, height, width, number );
    else
        fprintf("You entered something wrong. Try again.");
   end

end

function [] = gaussians( training_data, test, height, width )
    avgs = zeros (width, size(training_data, 1));
    std_devs = zeros (width, size(training_data, 1));
      
    for i = 1:size(training_data, 1)
        avgs(:,i) = mean(training_data{i});
        std_devs(:,i) = std(training_data{i});
    end
    
    for i = 1:size(std_devs,2)
        for j = 1:(size(std_devs,1)-1)
            if std_devs(j,i) < 0.01
                std_devs(j,i) = 0.01;
            end
%             fprintf("Class %d, attribute %d, mean = %.2f, std = %.2f\n", training_data{i}(1,width), j, avgs(j,i), std_devs(j,i));
        end
    end
    
    classProb = cellfun('size',transpose(training_data), 1) / height;
    
    test_data = load(test);
%      columns = size(test_data, 2)
%     vectors = test_data(:, 1:(columns-1));
    labels = test_data(:, columns);

    
%     gauss = cell(size(test_data));
%     %p_class_given_data = cell(size(test_data))
    
    for i = 1:size(test_data, 1)
         gauss(i,:) = normpdf(test_data(i,:), transpose(avgs(1:end-1,test_data(i)(end))), transpose(std_devs(1:end-1,i)));
        gauss{i} = classProb(i) * gauss{i};
    end

% %         numer(i,:) = classProb(i) * gauss{i};
% %         gauss{i};
%     end 
%     
%     for i = 1:size(gauss, 1)
%         for j = 1:size(gauss{i}, 1)
%             for k = 1:size(gauss{i}, 2)
%                 p_class_given_data(i,j,k) = gauss{i}(j,k) / sum(gauss{i}(j,:)); 
%             end
%         end
%     end
%     
%     for i = 1:size(gauss, 1)
%         for j = 1:size(gauss{i}, 1)
%             p_class(i,j) = prod(p_class_given_data(i,j,:));
%         end
%     end
%     
%     
%         
%     ID = 1;
%     
%     for i = 1:size(p_class, 1)
%         for j = 1:size(p_class, 2)
% %             for k = 1:size(p_class_given_data, 3)
%                 fprintf("ID=%5d, predicted=%3d, probability = %.4f, true=%3d, accuracy=%4.2f\n", ID, max(p_class(:,j)), p_class(i,j), training_data{i}(1,width), 1);
%                 ID = ID + 1;
% %             end
%         end
%     end
  
end

function [] = histograms( training_data, test_data, height, width, number )

    prob_bin_given_class = zeros(size(training_data,1),width-1,number);    
    bins = zeros(size(training_data,1),width-1,number);

    for i = 1:size(training_data, 1)
        for j = 1:(width-1)
            bin_data = sortrows (training_data{i}, j);
            G = (bin_data(end,j) - bin_data(1,j)) / (number - 3);
            
            if G < 0.0001
                G = 0.0001;
            end
           
            bins(i, j, 1) = -inf;
            bins(i, j, 2:end) = ((bin_data(1,j) - (G/2)) : G : (bin_data(1,j) + (number - 2)*G - (G/2)));
            
            prob_bin_given_class(i, j, 1) = 0;
            prob_bin_given_class (i, j, end) = 0;

            for k = 1:(number-2)
                
                m = 0;
                for l = 1:(size(bin_data, 1))

                    
                    if(bin_data(l,j) >= bins(i,j,(k+1)) && bin_data(l,j) < bins(i,j,(k+2)))
                        m = m + 1;
                    end
                end 
                
                prob_bin_given_class(i, j, k+1) = (m / (size(bin_data, 1) * G));
            end   
        end       
    end

    for i = 1:size(training_data, 1)
        for j = 1:(width-1)
            for k = 1:(number)
                fprintf("Class %d, attribute %d, bin %d, P(bin | class) = %.2f\n", training_data{i}(1,width), j, k, prob_bin_given_class(i, j, k));
            end   
        end       
    end
    
    
end