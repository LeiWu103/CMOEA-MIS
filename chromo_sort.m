function [F,combine_chromo] = chromo_sort(combine_chromo)
%����GM��Red����
[m,n] = size(combine_chromo);
n = n-3;
pareto_rank=1;
F(pareto_rank).ss=[];%pareto�ȼ�Ϊpareto_rank�ļ���
p=[];%ÿ������p�ļ���
for i=1:m
    %�������Ⱥ��ÿ������p�ı�֧�����n�͸ø���֧��Ľ�ļ���s
    p(i).n=0;%֧���ŵ�i����Ľ����Ŀ
    p(i).s=[];%��i������֧���ļ���s
    for j=1:m
        less=0;%y'��Ŀ�꺯��ֵС�ڸø����Ŀ�꺯��ֵ��Ŀ
        equal=0;%y'��Ŀ�꺯��ֵ���ڸø����Ŀ�꺯��ֵ��Ŀ
        greater=0;%y'��Ŀ�꺯��ֵ���ڸø����Ŀ�꺯��ֵ��Ŀ
        for k=2:3
            if(combine_chromo(i,n+k) < combine_chromo(j,n+k))
                less=less+1;
            elseif(combine_chromo(i,n+k) == combine_chromo(j,n+k))
                equal=equal+1;
            else
                greater=greater+1;
            end
        end
        if(less==0 && equal ~= 2)
            p(i).n=p(i).n+1;
        elseif(greater==0 && equal ~= 2)
            p(i).s=[p(i).s j];
        end
    end
    %����Ⱥ��û�б�֧��ĸ�����뵽F1��
    if(p(i).n==0)
        combine_chromo(i,n+4)=1;%�����һ�У������������ĵȼ�Ϊ1�Ľ�
        F(pareto_rank).ss=[F(pareto_rank).ss i];%������F1�ȼ��ĸ��嶼���뵽����F��pareto_rank��.ss��
    end
end
%��pareto�ȼ�Ϊpareto_rank+1�ĸ���
while ~isempty(F(pareto_rank).ss)
    temp=[];
    for i=1:length(F(pareto_rank).ss)
        if ~isempty(p(F(pareto_rank).ss(i)).s)
            for j=1:length(p(F(pareto_rank).ss(i)).s)
                p(p(F(pareto_rank).ss(i)).s(j)).n=p(p(F(pareto_rank).ss(i)).s(j)).n - 1;%nl=nl-1
                if p(p(F(pareto_rank).ss(i)).s(j)).n==0
                    combine_chromo(p(F(pareto_rank).ss(i)).s(j),n+4)=pareto_rank+1;%�������ĵȼ���Ϣ
                    temp=[temp p(F(pareto_rank).ss(i)).s(j)];
                end
            end
        end
    end
    pareto_rank=pareto_rank+1;
    F(pareto_rank).ss=temp;
end
end
