function chromo_parent = common_selection(aim,P)
[m,n] = size(P);
touranment=2;
chromo_candidate=zeros(touranment,1);
chromo_parent=zeros(m,n+3);
chromo_gm = zeros(2,1);
chromo_acc = zeros(2,1);
chromo_red = zeros(2,1);
for i=1:m
    %随机筛选出两个个体
    for j=1:touranment
        chromo_candidate(j)=round(m*rand(1));%随机产生候选者
        if(chromo_candidate(j)==0)
            chromo_candidate(j)=1;
        end
        if(j>1)
            while (~isempty(find(chromo_candidate(1:j-1)==chromo_candidate(j))))
                chromo_candidate(j)=round(m*rand(1));
                if(chromo_candidate(j)==0)
                    chromo_candidate(j)=1;
                end
            end
        end
    end  
    for j=1:touranment
        chromo_gm(j) = aim(chromo_candidate(j),1);
        chromo_red(j)= aim(chromo_candidate(j),2); 
        chromo_acc(j)= aim(chromo_candidate(j),3);
    end
        if chromo_acc(1,1) < chromo_acc(2,1) && chromo_red(1,1) < chromo_red(2,1)
            chromo_parent(i,1:n) = P(chromo_candidate(1),:);
            chromo_parent(i,n+1) = chromo_gm(1);
            chromo_parent(i,n+2) = chromo_red(1);
            chromo_parent(i,n+3) = chromo_acc(1);
        else 
            chromo_parent(i,1:n) = P(chromo_candidate(2),:);
            chromo_parent(i,n+1) = chromo_gm(2);
            chromo_parent(i,n+2) = chromo_red(2);
            chromo_parent(i,n+3) = chromo_acc(2);
        end
end
end