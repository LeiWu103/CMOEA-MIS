
function GM = getTestGM(data_test,predict_label)
%��ȡ�����GMֵ
class = unique(data_test(:,end)); 
m = size(data_test,1);
class_count = size(class,1);
every_class_count = zeros(class_count,1);%����ͳ��ÿһ���ʵ������
every_class_correct = zeros(class_count,1);%����ͳ��ÿһ�������ȷ��ʵ������
predict_count = zeros(class_count,1);%ͳ�Ʒ�����ʶ���ǩ��ÿһ�������
%% ͳ��ÿһ���ʵ������
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

%% ͳ��ÿһ�������ȷ��ʵ������
for i = 1 : m
    for j = 1 : class_count
        if data_test(i,end) == class(j) && predict_label(i,1) == class(j)
            every_class_correct(j,1) = every_class_correct(j,1) + 1;
        end
    end
end

%% ��������GM
geometry = 1;
for i = 1 : class_count
    geometry = (every_class_correct(i,1)/every_class_count(i,1))*geometry;
end
GM = power(geometry,1/class_count);
% disp("------------------------------------------------------------------------------------------------");
