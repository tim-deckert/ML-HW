function [] = naive_bayes( data, test, type, number )

    delimiterIn = ' ';
    training_data = importdata(data, delimiterIn);
    
    if nargin == 3 && type == 'gaussians'
        gaussians( training_data )
    elseif nargin == 4 && type == 'histograms'
        histograms( training_data, number )
    end

end

function [] = gaussians( training_data )

end

function [] = histgrams( training_data, number )

end