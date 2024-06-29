function [hard_constraint_individual_index,soft_constraint_individual_index,feasible_individual_index] = IndexOfConstraintViolate(aim,data1,data_train1,P)
[m,n] = size(P);
% n = n - 2;
hard_constraint_individual_index = zeros(m,1);
soft_constraint_individual_index = zeros(m,1);
feasible_individual_index = zeros(m,1);
hard_cosstraint_index = 1;
soft_constraint_index = 1;
feasible_index = 1;
%寻找违反硬约束个体的下标
class = unique(data_train1(:,end));
class_count =length(class); %原始数据集中的类别数

for i = 1 : m 
    p_class = zeros(class_count, 1);
    p_class_count = 0;
    for j = 1 : n
        if P(i,j) == 1 && ~ismember(data_train1(j,end),p_class) 
            p_class_count = p_class_count + 1;
            p_class(p_class_count) = data_train1(j,end);
        end
    end
    p_class_count = length(unique(data_train1(P(i, :)==1, end)));
    
    if p_class_count < class_count
        hard_constraint_individual_index(hard_cosstraint_index,1) = i;
        
    end
    hard_cosstraint_index = hard_cosstraint_index + 1;
end
%寻找违反软约束个体的下标
for i = 1 : m
    if aim(i,1) == 1 && ~ismember(i,hard_constraint_individual_index)
       soft_constraint_individual_index(soft_constraint_index,1) = i;
       
    end
    soft_constraint_index = soft_constraint_index + 1;
end
%寻找可行个体的下标
for i = 1 : m
    if ~ismember(i,hard_constraint_individual_index) && ~ismember(i,soft_constraint_individual_index)
        feasible_individual_index(feasible_index,1) = i;
        
    end
    feasible_index = feasible_index + 1;
end
