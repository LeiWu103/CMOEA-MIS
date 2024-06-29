function y=datasetImport(gg)
%�������ݼ�
a='';
switch gg
    case 1
         a='glass.txt';
    case 2
         a='vowel.dat';
    case 3
         a='balance.txt';
    case 4
        a='flare.dat';
    case 5
        a='COIL20.txt';
    case 6
        a='morphological.arff';
    case 7
        a='semeion.txt';
    case 8
        a='splice.dat';
    case 9
        a='page-blocks.txt';
    case 10
        a='optdigits.dat';
    case 11
        a='satimage.txt';
    case 12
        a='penbased.txt';
    case 13
        a="synthetic_control.arff";
    case 14
        a='shuttle_seed_2_nrows_2000.txt';
    case 15
        a='cleveland.txt';
    case 16
        a='cardiotocography.txt';
    case 17
        a='usps.mat';
end
y=importdata(a);
disp(a);