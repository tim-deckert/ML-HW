function [ ] = k_means_cluster( data_file, k, iterations )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    dataAndClasses = importdata(data_file);
    
    data = dataAndClasses(:,1:end-1);
    [height, width] = size(data);
    
    clusters = randi(k,height,1);
    
    clusteredData = [clusters, data];
    
    clustDataCopy = clusteredData;
    
    dataByCluster = cell(k,1);
    averages = zeros(k,width);
    
    distanceToClusterAvg = zeros(k,1);
    minDistClust = 4;
    minDist = inf;
    
%     avg = mean(clusteredData)
        
    clusterError = 0;
    
    for i = 1:k
        dataByCluster{i} = clusteredData(clusteredData(:,1) == i, :);
%         size(averages(i,:))
%         size(mean(dataByCluster{i}(:,2:end)))
    
        for j = 1:size(dataByCluster{i},1)
                clusterError = clusterError + sqrt(sum((dataByCluster{i}(j,2:end)-averages(i)).^2));
        end
        averages(i,:) = mean(dataByCluster{i}(:,2:end));
    end
    
    fprintf("After initialization error = %.4f\n", clusterError);
    
    for iter = 1:iterations
        for i = 1:height
            for j = 1:k
                distanceToClusterAvg(j) = sqrt(sum((clusteredData(i,2:end)-averages(j)).^2));
            
                if distanceToClusterAvg(j) < minDist
                    minDist = distanceToClusterAvg(j);
                    minDistClust = j;
                end
            end
            clusteredData(i,1) = minDistClust;
            minDist = inf;
        end
    
        clusterError = 0;
    
        for i = 1:k
        
            dataByCluster{i} = clusteredData(clusteredData(:,1) == i, :);
        
            for j = 1:size(dataByCluster{i},1)
                clusterError = clusterError + sqrt(sum((dataByCluster{i}(j,2:end)-averages(i)).^2));
        
            end
        end
        
        fprintf("After iteration %d: error = %.4f\n", iter, clusterError);
    end

end

