gen = 100;
N = 100;
K = 5;
Coding='Binary';

result = zeros(30,8);
standard_error = zeros(30,3);
d=input("���ݼ���");
Turn = input("ִ�д�����");
HSF=[];


for turn = 1:Turn
    fprintf("��%d�Σ�", turn);
    data1=datasetImport(d);
    [y1,~] = mapminmax(data1(:,1:(end-1))');
    data=[y1',data1(:,end)];
    [m, n]=size(data);
    indices = crossvalind('Kfold',m,K);
    PBE=zeros(K,7);
    tic;
    for package=1:K
        shoulian = zeros(100, 100, 2);
        fprintf("%d ", package);
        %% �������ݼ�
        P = [];
        offspring = [];
        combine_chromo = [];
        combine_chromo2 = [];
        combine_chromo3 = [];
        chromo = [];
        test=(indices==package);
        train1=~test;
        data_train1=data(train1,:);
        data_train = data1(train1,:);
        data_test=data(test,:);
        [v] = size(data_train1,1);
        minvalue1 = zeros(1,v);
        maxvalue1 = ones(1,v);
        Boundary = [maxvalue1;minvalue1]; %%���±߽�
        class = unique(data_train1(:, end));
        %% �����µĳ�ʼ��Ⱥ
        a = initialize(N,v);
        f1 = find(a>=0.5);
        a(f1) = 1;
        f2 = find(a<0.5);
        a(f2) = 0;
        P = a;
        %% ���۳�ʼ�����ɵĸ���
        aim = zeros(N,3);
        for i = 1 : N
            %GET AIM
            Cpop = P(i,:);
            Cpop = logical(Cpop);
            CdataSet = data_train1(Cpop,:);%ѡ����ǰ��Ⱥ��ѡȡ��ʵ������Cpop==1
            Clabel = CdataSet(:,n);
            CdataSet = sparse(CdataSet(:,1:n-1));
            model1(i,1)= svmtrain(Clabel,CdataSet,'-q');
            [predict_label1, acc, ~]  = svmpredict(data_train1(:,n),sparse(data_train1(:,1:n-1)), model1(i,1),'-q');
            aim(i,1) = 1-getGM(data_train1,predict_label1);
            aim(i,2) = 1-sum(Cpop==0)/v;
            aim(i,3) = 1-acc(1,1)/100;
        end
        %% �����׶�
        distance_1 = zeros(v, v);
        for u = 1 : v
            for k = 1 : v
                c = (data_train(k,1:end-1) - data_train(u,1:end-1)).^2;
                distance_1(u,k)=sqrt(sum(c(:)));
            end
        end
        chromo_parent = zeros(100,v);
        hsf = [];
        for j = 1 : gen
            
            
            %���и���Ļ���
            [hard_constraint_individual_index,soft_constraint_individual_index,feasible_individual_index] = IndexOfConstraintViolate(aim,data1,data_train1,P);
            if mod(j, 10) == 1
                h = sum(hard_constraint_individual_index~=0);
                s = sum(soft_constraint_individual_index~=0);
                f = sum(feasible_individual_index~=0);
                hsf = [hsf h s f];
%                 if j == 100
%                     HSF=[HSF; hsf];
%                 end
            end
            %Լ��ѡ�����
            chromo_parent = constraints_based_selection(hard_constraint_individual_index,soft_constraint_individual_index,feasible_individual_index,aim,P);

            len = size(chromo_parent,2);

            %�����������Ӵ���Ⱥ
            offspring = crossover_mutation(chromo_parent,j,data_train1,data_train, distance_1, distance_1);
                    
            %���Ӵ���������
            offspring_aim = zeros(N,3);
            for i = 1 : N
                Cpop = offspring(i,:);
                Cpop = logical(Cpop);
                if sum(Cpop==1) == 0
                    offspring_aim(i, 1) = 1;
                    offspring_aim(i, 2) = 1;
                    offspring_aim(i, 3) = 1;
                else
                    CdataSet = data_train1(Cpop,:);
                    Clabel = CdataSet(:,n);
                    CdataSet = sparse(CdataSet(:,1:n-1));
                    model2(i,1)= svmtrain(Clabel,CdataSet,'-q');
                    [predict_label1, acc, ~]  = svmpredict(data_train1(:,n),sparse(data_train1(:,1:n-1)), model2(i,1),'-q');
                    offspring_aim(i,1) = 1-getGM(data_train1,predict_label1);
                    offspring_aim(i,2) = 1-sum(Cpop==0)/v;
                    offspring_aim(i,3) = 1-acc(1,1)/100;
                end
            end
            
            %���Ӵ��ϲ�
            [p,q] = size(chromo_parent);
            [pop_offspring,~] = size(offspring);
            combine_chromo(1:p,1:q-3) = P(1:100,:);
            combine_chromo(1:p,q-2:q) = aim(:,1:3);
            combine_chromo((p+1):(2*p),1:q-3) = offspring(1:100,:);
            combine_chromo((p+1):(2*p),q-2:q) = offspring_aim(:,1:3);
            %����
            [F,combine_chromo2] = chromo_sort(combine_chromo);
            %ӵ���ȼ���
            combine_chromo3 = crowding_distance_sort(F,combine_chromo2);
            %��Ӣ����ɸѡ���
            [chromo,temp] = elitism(combine_chromo3);
            P(:,1:temp-5) = chromo(:,1:temp-5);
            aim(:,1:3) = chromo(:,temp-4:temp-2);
            %          fprintf('%d gen has completed!\n',j);
            plot(1-aim(:,3),1-aim(:,2),'o');
            set(get(gca, 'XLabel'), 'String', int2str(j));
            axis([0 1 0 1]);
            drawnow;
            shoulian(j,:,:) = 1 - aim(:, 3:-1:2);
        end
        for i = 1 : N
            if aim(i, 1) == 1
                for c = 1 : length(class)
                    if isempty(find(data_train1(P(i, :) == 1, end) == class(c), 1))
                        num = 1;
                        for z = 1 : size(data_train1, 1)
                            
                            if data_train1(z, end) == class(c)
                                if rand < 1 / num
                                    P(i, z) = 1 == 1;
                                    num = num + 1;
                                end
                                
                            end
                        end
                    end
                end
            end
            
        end
        aim = zeros(N,3);
        for i = 1 : N
            Cpop = P(i,:);
            Cpop = logical(Cpop);
            if sum(Cpop==1) == 0
                aim(i, 1) = 1;
                aim(i, 2) = 1;
                aim(i, 3) = 1;
            else
                CdataSet = data_train1(Cpop,:);
                Clabel = CdataSet(:,n);
                CdataSet = sparse(CdataSet(:,1:n-1));
                model2(i,1)= svmtrain(Clabel,CdataSet,'-q');
                [predict_label1, acc, ~]  = svmpredict(data_train1(:,n),sparse(data_train1(:,1:n-1)), model2(i,1),'-q');
                aim(i,1) = 1-getGM(data_train1,predict_label1);
                aim(i,2) = 1-sum(Cpop==0)/v;
                aim(i,3) = 1-acc(1,1)/100;
            end
        end
        [hard_constraint_individual_index,soft_constraint_individual_index,feasible_individual_index] = IndexOfConstraintViolate(aim,data1,data_train1,P);
        h = sum(hard_constraint_individual_index~=0);
        s = sum(soft_constraint_individual_index~=0);
        f = sum(feasible_individual_index~=0);
        hsf = [hsf h s f];
        HSF=[HSF; hsf];

        [~,index] = sort(aim(:,3));
        [test_r,test_c] = size(data_test);
        %%���Ծ���
        Cpop1 = P(index(1,1),:);
        Cpop1 = logical(Cpop1);
        CdataSet1 = data_train1(Cpop1,:);
        Clabel = CdataSet1(:,n);
        CdataSet2 = sparse(CdataSet1(:,1:n-1));
        model3(1,1)= svmtrain(Clabel,CdataSet2,'-q');
        [predict_label3, acc, ~]  = svmpredict(data_test(:,test_c),sparse(data_test(:,1:test_c-1)), model3(1,1),'-q');
        PBE(package,1) = 1-getTestGM(data_test,predict_label3);
        PBE(package,2) = 1-sum(Cpop1==0)/v;
        PBE(package,3) = 1-acc(1,1)/100;
%         PBE(package,4) = 1-NHV(aim(:,2:3),[1,1]);
        max_acc_red = 0;
        sum_GM = 0;
        sum_hard = 0;
        %������Ⱥ��ÿ������
        Test = zeros(1, N);
        Last = zeros(N, 2);
        GM_values = zeros(N,1);
        onefoldGM = zeros(N, 1);
        for i = 1 : N
            Cpop2 = P(i,:);
            Cpop2 = logical(Cpop2);
            CdataSet1 = data_train1(Cpop2,:);
            Clabel = CdataSet1(:,n);
            CdataSet3 = sparse(CdataSet1(:,1:n-1));
            model4 = svmtrain(Clabel, CdataSet3, '-q');
            [predict_label4, acc, ~]  = svmpredict(data_test(:,test_c),sparse(data_test(:,1:test_c-1)), model4,'-q');
            sum_GM = sum_GM + getTestGM(data_test, predict_label4);
            GM_values(i) = getTestGM(data_test, predict_label4);
            Test(i) = acc(1,1)/100;
            Last(i, 2) = sum(Cpop2==0)/v;
            if max_acc_red < acc(1,1)/100 * (sum(Cpop2==0)/v)
                max_acc_red = acc(1,1) /100* (sum(Cpop2==0)/v);
            end
            num = 0;
            for c = 1 : length(class)
                if ~isempty(find(data_train1(P(i, :) == 1, end) == class(c), 1))
                    num = num + 1;
                end
            end
            sum_hard = sum_hard + num / c; 
        end
        kexing = GM_values > 0;
        Test1 = 1-Test';
        PBE(package, 4) = NHV([Test1(kexing), 1-Last(kexing,2)], [1,1]);
        PBE(package, 5) = max_acc_red;
        PBE(package, 6) = sum_GM / N;
        PBE(package, 7) = sum_hard / N;
%         mkdir(['..\PF\CMOEA-MIS\' num2str(d)]);
%    save(['..\PF\CMOEA-MIS\' num2str(d) '\' num2str(package) '.mat'], "Test", "Last", "GM_values");
%    mkdir(['..\shoulian\CMOEA-MIS\' num2str(d)]);
%    save(['..\shoulian\CMOEA-MIS\' num2str(d) '\' num2str(package) '.mat'], "shoulian");
    end
    time = toc;
    result(turn,1) = 1 - sum(PBE(:,1)) / K;
    result(turn,2) = 1 - sum(PBE(:,2)) / K;
    result(turn,3) = 1 - sum(PBE(:,3)) / K;
    result(turn,4) = sum(PBE(:,4)) / K;
    result(turn, 5) = time / K;
    result(turn, 6) = sum(PBE(:, 5)) / K;
    result(turn, 7) = sum(PBE(:, 6)) / K;
    result(turn, 8) = sum(PBE(:, 7)) / K;
    %%std��׼��
    standard_error(turn,1) = std(PBE(:,1));
    standard_error(turn,2) = std(PBE(:,2));
    standard_error(turn,3) = std(PBE(:,3));
    fprintf("\n");
end