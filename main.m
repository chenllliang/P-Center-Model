clear;

hos_nums = 62 % 医院的总数量
distance = 100*rand(hos_nums);
distance = distance+distance';

t_h = 5 ;% 目标医院的数量




%%
%第一步：解空间编码，使用二进制编码方案

solution_space = nchoosek(hos_nums,t_h);
binary_bits = get_binary_bits(solution_space);
solution_combinations  = nchoosek(1:hos_nums,t_h);
%%
%参数设置
population_size = 1000;      % 种群大小
chromosome_size = binary_bits;       % 染色体长度
generation_size = 200;      % 最大迭代次数
cross_rate = 0.25;           % 交叉概率
mutate_rate = 0.01;         % 变异概率


%%
%第二步：初始化种群

for i=1:population_size
    population_index(i) = round(solution_space*rand());
    population_chrome{i} = dec2base(population_index(i),2,chromosome_size);
    
end

% 所有种群个体适应度初始化为0
for i=1:population_size
    fitness_value(i) = 0.;    
end

%遗传进化开始
best_fitness=0;
best_generation=0;
best_individual=0;

for G = 1:generation_size
    for i=1:population_size
        fitness_value(i) = adaptive_score(hos_nums,t_h,distance,population_chrome{i},solution_combinations);
    end

        for i=1:population_size    
        fitness_sum(i) = 0.;
    end

    min_index = 1;
    temp = 1;

    % 遍历种群 
    % 冒泡排序
    % 最后population(i)的适应度随i递增而递增，population(1)最小，population(population_size)最大
    for i=1:population_size
        min_index = i;
        for j = i+1:population_size
            if fitness_value(j) < fitness_value(min_index);
                min_index = j;
            end
        end

        if min_index ~= i
            % 交换 fitness_value(i) 和 fitness_value(min_index) 的值
            temp = fitness_value(i);
            fitness_value(i) = fitness_value(min_index);
            fitness_value(min_index) = temp;
            % 此时 fitness_value(i) 的适应度在[i,population_size]上最小

            % 交换 population(i) 和 population(min_index) 的染色体串
            temp=population_chrome{i};
            population_chrome{i}=population_chrome{min_index};
            population_chrome{min_index}=temp;
      
        end
    end
    
    % fitness_sum(i) = 前i个个体的适应度之和
    for i=1:population_size
        if i==1
            fitness_sum(i) = fitness_sum(i) + fitness_value(i);    
        else
            fitness_sum(i) = fitness_sum(i-1) + fitness_value(i);
        end
    end

    % fitness_average(G) = 第G次迭代 个体的平均适应度
    fitness_average(G) = fitness_sum(population_size)/population_size;

    % 更新最大适应度和对应的迭代次数，保存最佳个体(最佳个体的适应度最大)
    if fitness_value(population_size) > best_fitness
        best_fitness = fitness_value(population_size);
        best_generation = G;
        best_individual=population_chrome{population_size};
    end
    
    %选择
    for i=1:population_size
        r = rand * fitness_sum(population_size);  % 生成一个随机数，在[0,总适应度]之间
        first = 1;
        last = population_size;
        mid = round((last+first)/2);
        idx = -1;
    
        % 排中法选择个体
        while (first <= last) && (idx == -1) 
            if r > fitness_sum(mid)
                first = mid;
            elseif r < fitness_sum(mid)
                last = mid;     
            else
                idx = mid;
                break;
            end
            mid = round((last+first)/2);
            if (last - first) == 1
                idx = last;
                break;
            end
        end
  
       population_new{i} = population_chrome{idx};
    end

    for i=1:population_size
       population_chrome{i} = population_new{i};
    end

    %交叉
    %步长为2 遍历种群
    for i=1:2:population_size
        % rand<交叉概率，对两个个体的染色体串进行交叉操作
        if(rand < cross_rate)
            cross_position = round(rand * chromosome_size);
            if (cross_position == 0 || cross_position == 1)
                continue;
            end
            % 对 cross_position及之后的二进制串进行交换
            raw1=population_chrome{i};
            raw2=population_chrome{i+1};
            
            for j=cross_position:chromosome_size
                temp = population_chrome{i}(j);
                population_chrome{i}(j) = population_chrome{i+1}(j);
                population_chrome{i+1}(j)= temp;
            end
            
            if bin2dec(population_chrome{i})>solution_space
            population_chrome{i}=raw;
            end
            
            if bin2dec(population_chrome{i+1})>solution_space
            population_chrome{i+1}=raw;
            end
            
            
        end
    end
    %变异
    
    for i=1:population_size
        
    if rand < mutate_rate
        mutate_position = round(rand*chromosome_size);  % 变异位置
        if mutate_position == 0 
            % 若变异位置为0，不变异
            continue;
        end
        
        raw = population_chrome{i};
        
        if population_chrome{i}(mutate_position)==1
            population_chrome{i}(mutate_position)=0
        end
        
        if population_chrome{i}(mutate_position)==0
            population_chrome{i}(mutate_position)=1
        end
        
        if bin2dec(population_chrome{i})>solution_space
            population_chrome{i}=raw;
        end
        
    end
        
    
    end
    
end





