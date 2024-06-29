
function GM = getTestGM(data_test,predict_label)
%获取分类的GM值
class = unique(data_test(:,end)); 
m = size(data_test,1);
class_count = size(class,1);
every_class_count = zeros(class_count,1);%用来统计每一类的实例数量
every_class_correct = zeros(class_count,1);%用来统计每一类分类正确的实例数量
predict_count = zeros(class_count,1);%统计分类器识别标签的每一类的数量
%% 统计每一类的实例数量
for i = 1 : m 
    for j = 1 : class_count
        if data_test(i,end) == class(j)
            every_class_count(j,1) = every_class_count(j,1) + 1;
        end
        if predict_label(i,1) == class(j)
            predict_count(j,1) = predict_count(j,1) + 1;
        end
    end
end

%% 统计每一类分类正确的实例数量
for i = 1 : m
    for j = 1 : class_count
        if data_test(i,end) == class(j) && predict_label(i,1) == class(j)
            every_class_correct(j,1) = every_class_correct(j,1) + 1;
        end
    end
end

%% 计算分类的GM
geometry = 1;
for i = 1 : class_count
    geometry = (every_class_correct(i,1)/every_class_count(i,1))*geometry;
end
GM = power(geometry,1/class_count);
% disp("------------------------------------------------------------------------------------------------");
