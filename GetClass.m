data1=importdata('urban.txt');
m = size(data1,1);
class = unique(data1(:,end)); %ѵ���������ļ������
class_count = size(class,1);
every_class_count = zeros(class_count,1);%����ͳ��ÿһ���ʵ������

%% ͳ��ÿһ���ʵ������
for i = 1 : m 
    for j = 1 : class_count
        if data1(i,end) == class(j)
            every_class_count(j,1) = every_class_count(j,1) + 1;
        end
    end
end



