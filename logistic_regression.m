function [] = logistic_regression( training_file, degree, test_file )

    delimiterIn = ' ';
    training_data = importdata(training_file, delimiterIn);
    
    [height, width] = size(training_data);
    data_split_by_class = cell(2);

    data_split_by_class{1} = training_data(training_data(:,width) == 1, 1:width-1).';
    data_split_by_class{2} = training_data(training_data(:,width) ~= 1, 1:width-1).';
    
    
    
end

