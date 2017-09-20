function [] = naive_bayes( data, test, type, number )

    delimiterIn = ' ';
    training_data = importdata(data, delimiterIn);
    
    [height, width] = size(training_data);
    
    sorted_data = sortrows (training_data, width);
    
    gaussians( sorted_data, height, width );
    
%     if nargin == 3 && type == 'gaussians'
%         gaussians( sorted_data, height, width);
%     elseif nargin == 4 && type == 'histograms'
%         histograms( sorted_data, height, width, number );
%     else
%         fprintf("You entered something wrong. Try again.");
%    end

end

function [] = gaussians( training_data, height, width )
    avg = mean(training_data(:,1:end-1));
    std_dev = std(training_data(:,1:end-1));
    for i = 1:size(std_dev,2)
        if std_dev(i) < 0.01
            std_dev(i) = 0.01;
        end
    end
    
    classes = zeros (2 * (width-1), unique (training_data(end)));
    avgs = zeros (width-1, size(classes));
    std_devs = zeros (width-1, size(classes));
    
    j = 1;
    k = 1;
    
    for i = 1:size(training_data, 1)
        
        if training_data(i,end) ~= j
            classes(,j) = mean(training_data(k:i-1,1:end-1));
%             training_data(k:i-1,1:end);
            j = j + 1;
            k = i;
        end
        classes(1,j) = classes(1,j) + 1;
        
    end
    
    classes(1,:) = classes(1,:) / height;
            
end

function [] = histograms( training_data, height, width, number )

end