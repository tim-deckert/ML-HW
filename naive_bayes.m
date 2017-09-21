function [] = naive_bayes( data, test, type, number )

    delimiterIn = ' ';
    training_data = importdata(data, delimiterIn);
    
    [height, width] = size(training_data);
    
    sorted_data = sortrows (training_data, width);
    
    classes = unique (training_data(:,end));
    
%     sorted_data(sorted_data(:,width) == 1,:)
%     size(classes)
    
    data_split_by_class = cell(size(classes));
    
    for i = 1:size(classes,1)   
        data_split_by_class{i} = sorted_data(sorted_data(:,width) == classes(i), 1:width-1);
    end
         
    histograms( data_split_by_class, height, width );
    
%     if nargin == 3 && type == 'gaussians'
%         gaussians( sorted_data, height, width);
%     elseif nargin == 4 && type == 'histograms'
%         histograms( sorted_data, height, width, number );
%     else
%         fprintf("You entered something wrong. Try again.");
%    end

end

function [] = gaussians( training_data, height, width )
%     avg = mean(training_data(:,1:end-1));
%     std_dev = std(training_data(:,1:end-1));
%     for i = 1:size(std_dev,2)
%         if std_dev(i) < 0.01
%             std_dev(i) = 0.01;
%         end
%     end
%     
%     classes = zeros (1, unique (training_data(end)));
    avgs = zeros (width-1, size(training_data, 1));
    std_devs = zeros (width-1, size(training_data, 1));
%     
%     j = 1;
%     k = 1;
    
%     for i = 1:size(training_data, 1)
%         
%         if training_data(i,end) ~= j
%             avgs(:,j) = mean(training_data(k:i-1,1:width-1));
%             std_devs(:,j) = std(training_data(k:i-1,1:width-1));
%             
% %             mean(training_data(k:i-1,1:end-1))
% %             training_data(k:i-1,1:end);
%             j = j + 1;
%             k = i;
%         end
%         classes(j) = classes(j) + 1;
%         
%     end
      
    for i = 1:size(training_data, 1)
        
        avgs(:,i) = mean(training_data{i});
        std_devs(:,i) = std(training_data{i});
            
%             mean(training_data(k:i-1,1:end-1))
%             training_data(k:i-1,1:end);
%         j = j + 1;
%         k = i;
%         
        
    end  
    
    
%     avgs(:,j) = mean(training_data(k:height,1:width-1));
%     std_devs(:,j) = std(training_data(k:height,1:width-1));
    
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

    for i = 1:size(training_data, 1)
        for j = 1:(width-1)
            bin_data = sortrows (training_data{i}, j);
            a = bin_data(1,j);
            b = bin_data(end,j);
            
        end

    end
end