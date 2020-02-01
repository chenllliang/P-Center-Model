function x = adaptive_score(n_h,t_h,distance,sample,solution_combinations)
    index = bin2dec(sample);
    combination = solution_combinations(index,:);
    x=0;
    for i = 1:n_h
        
        if(find(combination==i))
            continue;
        end
        
        t_length = [];
        for j = 1:length(combination)
            t_length = [t_length,distance(i,j)];
        end
        
        max_length = max(t_length);
        
        x=x-max_length;
    end

end