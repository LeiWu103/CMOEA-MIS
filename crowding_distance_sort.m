function combine_chromo = crowding_distance_sort(F,combine_chromo)
%ӵ���ȼ���
[m,n] = size(combine_chromo);
%����pareto�ȼ�����Ⱥ�еĸ����������
[~,index]=sort(combine_chromo(:,end));
%[~,mm1]=size(chromo);
temp=zeros(m,n);
for i=1:m
    temp(i,:)=combine_chromo(index(i),:);%����pareto�ȼ��������Ⱥ
end

%����ÿ���ȼ��ĸ��忪ʼ����ӵ����
current_index = 0;
for pareto_rank=1:(length(F)-1)%����F��ѭ��ʱ����һ�οգ����Լ���
    %%ӵ���ȳ�ʼ��Ϊ0
    nd=[];
    nd(:,1)=zeros(length(F(pareto_rank).ss),1);
    %y=[];%���浱ǰ����ĵȼ��ĸ���
    [~,mm2]=size(temp);
    y=zeros(length(F(pareto_rank).ss),mm2);%���浱ǰ����ĵȼ��ĸ���
    previous_index=current_index + 1;
    for i=1:length(F(pareto_rank).ss)
        y(i,:)=temp(current_index + i,:);
    end
    current_index=current_index + i;
    %%����ÿһ��Ŀ�꺯��fm
    for i=1 : 2
        %%���ݸ�Ŀ�꺯��ֵ�Ըõȼ��ĸ����������
        [~,index_objective]=sort(y(:,n-4+i));
        %objective_sort=[];%ͨ��Ŀ�꺯�������ĸ���
        [~,mm3]=size(y);
        objective_sort=zeros(length(index_objective),mm3);%ͨ��Ŀ�꺯�������ĸ���
        for j=1:length(index_objective)
            objective_sort(j,:)=y(index_objective(j),:);
        end
        %%��fmaxΪ���ֵ��fminΪ��Сֵ
        fmin=objective_sort(1,n-4+i);
        fmax=objective_sort(length(index_objective),n-4+i);
        %%�������������߽�ӵ������Ϊ1d��nd��Ϊ����
        y(index_objective(1),n+i)=Inf;
        y(index_objective(length(index_objective)),n+i)=Inf;
        %%����nd=nd+(fm(i+1)-fm(i-1))/(fmax-fmin)
        for j=2:(length(index_objective)-1)
            pre_f=objective_sort(j-1,n-4+i);
            next_f=objective_sort(j+1,n-4+i);
            if (fmax-fmin==0)
                y(index_objective(j),n+i)=Inf;
            else
                y(index_objective(j),n+i)=(next_f-pre_f)/(fmax-fmin);
            end
        end
    end
    %���Ŀ�꺯��ӵ�������
    for i=1:2
        nd(:,1)=nd(:,1)+y(:,n+i);
    end
    %��2�б���ӵ���ȣ������ĸ��ǵ�
    y(:,n+1)=nd;
    y=y(:,1:(n+1));
    temp_two(previous_index:current_index,:) = y;
end
combine_chromo=temp_two;
end
