function [chromo,temp] = elitism(combine_chromo)
%��Ӣ��������
[pop2,temp]=size(combine_chromo);
pop = 100;
chromo_rank=zeros(pop2,temp);
chromo=zeros(pop,temp);
%����pareto�ȼ��Ӹߵ��ͽ�������
[~,index_rank]=sort(combine_chromo(:,temp-1));
for i=1:pop2
    chromo_rank(i,:)=combine_chromo(index_rank(i),:);
end
%�����ߵ�pareto�ȼ�
max_rank=max(combine_chromo(:,temp-1));
%����������˳�򣬽��ȼ���ͬ����Ⱥ�������븸����Ⱥ�У�ֱ��ĳһ�㲻��ȫ������Ϊֹ
prev_index=0;
for i=1:max_rank
    %Ѱ�ҵ�ǰ�ȼ�i��������������
    current_index=max(find(chromo_rank(:,(temp-1))==i));
    %���ܷ���Ϊֹ
    if(current_index>pop)
        %ʣ��Ⱥ����
        remain_pop=pop-prev_index;%����remain_pop�����壬�ﵽpop������
        %�ȼ�Ϊi�ĸ���
        t=chromo_rank(((prev_index+1):current_index),:);
        %����ӵ���ȴӴ�С����
        [~,index_crowd]=sort(t(:,temp),'descend');
        %��������
        for j=1:remain_pop
            chromo(prev_index+j,:)=t(index_crowd(j),:);
        end
        return;
    elseif(current_index<pop)
        % �����еȼ�Ϊi�ĸ���ֱ�ӷ��븸����Ⱥ
        chromo(((prev_index+1):current_index),:)=chromo_rank(((prev_index+1):current_index),:);
    else
        % �����еȼ�Ϊi�ĸ���ֱ�ӷ��븸����Ⱥ
        chromo(((prev_index+1):current_index),:)=chromo_rank(((prev_index+1):current_index),:);
        return;
    end
    prev_index = current_index;
end
end