function offspring = crossover_mutation(chromo_parent,gen,data_train1,data_train, distance_1, distance_2)
%交叉变异产生子代种群
[m,~] = size(chromo_parent);
n= size(data_train1,1);
t = 1;
offspring = zeros(m,n);
%交叉操作
for i = 1 : m/2
    parent_1=round(m*rand(1));
    if (parent_1<1)
        parent_1=1;
    end
    parent_2=round(m*rand(1));
    if (parent_2<1)
        parent_2=1;
    end
    
    chromo_parent_1=chromo_parent(parent_1,1:n);
    chromo_parent_2=chromo_parent(parent_2,1:n);

    point = rand(1,n)<0.5;
    offspring_1 = chromo_parent_1(1:n);
    offspring_2 = chromo_parent_2(1:n);
    temp = offspring_1(point);
    offspring_1(point) = offspring_2(point);
    offspring_2(point) = temp;
    %两阶段的变异操作
    if gen < 50
       %基于不平衡性的变异
       class = unique(data_train1(:,end)); %训练集中有哪几种类别
%        m = size(data_train1,1);
       class_count = size(class,1);
       every_class_count_1 = zeros(class_count,1);
       every_class_count_2 = zeros(class_count,1);

       for j = 1 : n
            for k = 1 : class_count
               if offspring_1(j) == 1 && data_train1(j,end) == class(k)
                  every_class_count_1(k,1) = every_class_count_1(k,1) + 1;
               end
               if offspring_2(j) == 1 && data_train1(j,end) == class(k)
                  every_class_count_2(k,1) = every_class_count_1(k,1) + 1;
               end
            end
       end
       
       
       for j = 1 : n
           if offspring_1(j) == 0 && rand(1) < 0.05
               offspring_1(j) = 1;
           elseif offspring_1(j) == 1
               for k = 1 : class_count
                   if data_train1(j,end) == class(k) && rand(1) < (every_class_count_1(k,1)/sum(every_class_count_1))
                       offspring_1(j) = 0;
                   end
               end
           end
         
           if offspring_2(j) == 0 && rand(1) < 0.05
               offspring_2(j) = 1;
           elseif offspring_2(j) == 1 
               for k = 1 : class_count
                   if data_train1(j,end) == class(k) && rand(1) < (every_class_count_2(k,1)/sum(every_class_count_2))
                       a=(every_class_count_2(k,1)/sum(every_class_count_2));
                       offspring_2(j) = 0;
                   end
               end
           end
       end
       
    end
    if gen >= 50
        %基于实例重要度的变异
        %计算最近邻居距离矩阵
%         distance_1 = zeros(n,n);
%         distance_2 = zeros(n,n);
        for j = 1 : n
            for k = 1 : n
                if offspring_1(j) == 0
                    distance_1(j,:) = Inf;
                    break;
                elseif offspring_1(k) == 0
                    distance_1(j,k) = Inf;
                elseif j == k 
                    distance_1(j,:) = Inf;
                else
%                     c = (data_train(k,1:end-1) - data_train(j,1:end-1)).^2;
%                     distance_1(j,k)=sqrt(sum(c(:)));
                end
            end
        end
        
        for j = 1 : n
            for k = 1 : n
                if offspring_2(j) == 0
                    distance_2(j,:) = Inf;
                    break;
                elseif offspring_1(k) == 0
                    distance_2(j,k) = Inf;
                elseif j == k 
                    distance_2(j,:) = Inf;
                else
%                     d = (data_train(j,1:end-1)-data_train(k,1:end-1)).^2;
%                     distance_2(j,k)=sqrt(sum(d(:)));
                end
            end
        end
        %统计少数类和多数类
        class = unique(data_train(:,end));
        class_count = size(class,1);
        every_class_count_1 = zeros(class_count,1);
        every_class_count_2 = zeros(class_count,1);
        % 统计子集中每一类的实例数量
        for j = 1 : n 
            for k = 1 : class_count
                if offspring_1(j) == 1 && data_train(j,end) == class(k)
                    every_class_count_1(k,1) = every_class_count_1(k,1) + 1;
                end
            end
        end
        for j = 1 : n 
            for k = 1 : class_count
                if offspring_2(j) == 1 && data_train(j,end) == class(k)
                    every_class_count_2(k,1) = every_class_count_2(k,1) + 1;
                end
            end
        end
        %划分多数类和少数类
        minority_1 = zeros(class_count,1);
        minority_2 = zeros(class_count,1);
        majority_1 = zeros(class_count,1);
        majority_2 = zeros(class_count,1);
        for j = 1 : class_count
            if every_class_count_1(j,1) < sum(every_class_count_1)/class_count
                minority_1(j) = class(j);
            else
                majority_1(j) = class(j);
            end
        end
        for j = 1 : class_count
            if every_class_count_2(j,1) < sum(every_class_count_2)/class_count
                minority_2(j) = class(j);
            else
                majority_2(j) = class(j);
            end
        end
        %变异操作
        for j = 1 : n
            flag = 0;
            count = 0;
            if offspring_1(j) == 0 && rand(1) < 1/n
                offspring_1(j) = 1;
            elseif offspring_1(j) == 1
                if ismember(data_train(j,end),minority_1) && rand(1) < 1/n
                    offspring_1(j) = 0;
                elseif ismember(data_train(j,end),majority_1)
                    [~,index] = sort(distance_1(j,:));
                    for k = 1 : 5
                        if data_train(j,end) ~= data_train(index(1,k),end)
                            count = count + 1;
                            flag = 1;
                            break;
                        end
                    end
                    if flag == 0
                        offspring_1(j) = 0;
                    elseif flag == 1 &&count == 5
                        offspring_1(j) = 0;
                    else
                        offspring_1(j) = 1;
                    end
                end
            end
        end

        for j = 1 : n
            flag = 0;
            count = 0;
            if offspring_2(j) == 0 && rand(1) < 1/n
                offspring_2(j) = 1;
            elseif offspring_2(j) == 1
                if ismember(data_train(j,end),minority_2) && rand(1) < 1/n
                    offspring_2(j) = 0;
                elseif ismember(data_train(j,end),majority_2)
                    [~,index] = sort(distance_2(j,:));
                    for k = 1 : 5
                        if data_train(j,end) ~= data_train(index(1,k),end)
                            count = count + 1;
                            flag = 1;
                            break;
                        end
                    end
                    if flag == 0
                        offspring_2(j) = 0;
                    elseif flag == 1 && count == 5
                        offspring_2(j) = 0;
                    else
                        offspring_2(j) = 1;
                    end
                end
            end
        end
    end
    offspring(t,:) = offspring_1(:);
    offspring(t+1,:) = offspring_2(:);
    t = t + 2;
end
end
        
