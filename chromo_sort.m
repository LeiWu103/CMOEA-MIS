function [F,combine_chromo] = chromo_sort(combine_chromo)
%基于GM，Red排序
[m,n] = size(combine_chromo);
n = n-3;
pareto_rank=1;
F(pareto_rank).ss=[];%pareto等级为pareto_rank的集合
p=[];%每个个体p的集合
for i=1:m
    %计算出种群中每个个体p的被支配个数n和该个体支配的解的集合s
    p(i).n=0;%支配着第i个解的解的数目
    p(i).s=[];%第i个解所支配解的集合s
    for j=1:m
        less=0;%y'的目标函数值小于该个体的目标函数值数目
        equal=0;%y'的目标函数值等于该个体的目标函数值数目
        greater=0;%y'的目标函数值大于该个体的目标函数值数目
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
    %将种群中没有被支配的个体加入到F1中
    if(p(i).n==0)
        combine_chromo(i,n+4)=1;%另外加一列，用来储存个体的等级为1的解
        F(pareto_rank).ss=[F(pareto_rank).ss i];%将属于F1等级的个体都加入到集合F（pareto_rank）.ss中
    end
end
%求pareto等级为pareto_rank+1的个体
while ~isempty(F(pareto_rank).ss)
    temp=[];
    for i=1:length(F(pareto_rank).ss)
        if ~isempty(p(F(pareto_rank).ss(i)).s)
            for j=1:length(p(F(pareto_rank).ss(i)).s)
                p(p(F(pareto_rank).ss(i)).s(j)).n=p(p(F(pareto_rank).ss(i)).s(j)).n - 1;%nl=nl-1
                if p(p(F(pareto_rank).ss(i)).s(j)).n==0
                    combine_chromo(p(F(pareto_rank).ss(i)).s(j),n+4)=pareto_rank+1;%储存个体的等级信息
                    temp=[temp p(F(pareto_rank).ss(i)).s(j)];
                end
            end
        end
    end
    pareto_rank=pareto_rank+1;
    F(pareto_rank).ss=temp;
end
end
