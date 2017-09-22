function [] = naive_bayes( data, test, type, number )

    delimiterIn = ' ';
    training_data = importdata(data, delimiterIn);
    
    [height, width] = size(training_data);
    
%     sorted_data = sortrows (training_data, width);
    
    classes = unique (training_data(:,end));
    
%     sorted_data(sorted_data(:,width) == 1,:)
%     size(classes)
    
    data_split_by_class = cell(size(classes));
    
    for i = 1:size(classes,1)   
        data_split_by_class{i} = training_data(training_data(:,width) == classes(i), 1:width-1)
    end
    
%     data_split_by_class
%     gaussians( data_split_by_class, height, width);
%    histograms( data_split_by_class, height, width, 5 );
    
%     if nargin == 3 && type == 'gaussians'
%         gaussians( sorted_data, height, width);
%     elseif nargin == 4 && type == 'histograms'
%         histograms( sorted_data, height, width, number );
%     else
%         fprintf("You entered something wrong. Try again.");
%    end

end

function [] = gaussians( training_data, height, width )
    avgs = zeros (width-1, size(training_data, 1));
    std_devs = zeros (width-1, size(training_data, 1));
      
    for i = 1:size(training_data, 1)
        avgs(:,i) = mean(training_data{i});
        std_devs(:,i) = std(training_data{i});
                  
    end
    
    for i = 1:size(std_devs,2)
        for j = 1:size(std_devs,1)
            if std_devs(j,i) < 0.01
                std_devs(j,i) = 0.01;
            end
            fprintf("Class %d, attribute %d, mean = %.2f, std = %.2f\n", i, j, avgs(j,i), std_devs(j,i));
        end
   end
%     
%     classes = classes / height;
%     for i = 1:size(classes,2)
%         for
%         
%     end

            
end

function [] = histograms( training_data, height, width, number )

    prob_bin_given_class = zeros(size(training_data,1),width-1,number);    
    bins = zeros(size(training_data,1),width-1,number);

    for i = 1:size(training_data, 1)
        for j = 1:(width-1)
            bin_data = sortrows (training_data{i}, j);
            G = (bin_data(end,j) - bin_data(1,j)) / (number - 3);
            
            if G < 0.0001
                G = 0.0001;
            end
%             
%             (bin_data(1,j) - (G/2))
%             G
%             (bin_data(1,j) + (number - 3) - (G/2))

            bins(i, j, 1) = -inf;
            bins(i, j, 2:end-1) = ((bin_data(1,j) - (G/2)) : G : (bin_data(1,j) + (number - 3)*G - (G/2)));
            bins(i, j, end) = inf;
            
            prob_bin_given_class(i, j, 1) = 0;
            prob_bin_given_class (i, j, end) = 0;
            
            size(training_data{i}(training_data{i}(j,:) < bins(i,j,(2))),2)
            training_data{i}(training_data{i}(j,:) < bins(i,j,(2)))
            (size(training_data{i}(:,j),1))
            for k = 1:(number-2)
                prob_bin_given_class(i, j, k+1) = size(training_data{i}(training_data{i}(:,j) < bins(i,j,(k+1))),2) / (size(training_data{i}(:,j),2) * G);
            end
            
            %b = bin_data(end,j);
            
        end 

    end
%       prob_bin_given_class
%      bins
    
end