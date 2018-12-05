clc;
clear all;
clear;
clear functions;

WEKA_HOME = 'E:\Arshad\Impelemention\weka-3-7-7\weka-3-7-7';
javaaddpath([WEKA_HOME '\weka.jar']);


label=zeros(1000,1);
k=80;
t1=100-k;

%{
labeltest(1:230)=0;
labeltest(231:1640)=1;

    
labeltrain(1:45)=0;
labeltrain(46:327)=1;

unlabeltrain(1:184)=0;
unlabeltrain(185:1312)=1;


            
label{1,1}=labeltrain(:,:);
 
label{1,2}=unlabeltrain(:,:);
label{1,3}=labeltest(:,:);
%}

filename='E:/Arshad/Thesis-1/dataset/Dataset/Dataset/ad.mat';
datahandwritten=load(filename);


%label=datahandwritten(1).ad_label;


numoflabeldata1=45 
%labeled
numoflabeldata2=45


numtraindata1=229
numtraindata2=1410

numofun1=numtraindata1-numoflabeldata1
numofun2=numtraindata2-numoflabeldata2

numoftest1=230
numoftest2=1410


labeltrain(1:numoflabeldata1,1)=0;
labeltrain(numoflabeldata1+1:numoflabeldata1+numoflabeldata2,1)=1;

unlabeltrain(1:numofun1,1)=0;
unlabeltrain(numofun1+1:numofun1+numofun2,1)=1;

labeltest(1:numoftest1,1)=0;
labeltest(numoftest1+1:numoftest1+numoftest2,1)=1;

            
label1{1,1}=labeltrain(:,1);
 
label1{1,2}=unlabeltrain(:,1);
label1{1,3}=labeltest(:,1);

clear labeltrain;
clear unlabeltrain;
clear labeltest;

sizedata1=numtraindata1+numoftest1;
sizedata2=numtraindata2+numoftest2;

randomnum1=randperm(numtraindata1+numoftest1);%for trian data and test data
randomnum2=randperm(numtraindata2+numoftest2);%for trian data and test data

randomnum2=randomnum2+sizedata1;

randnum1=randperm(numtraindata1);%for trian data and unlabel data
randnum2=randperm(numtraindata2);%for trian data and unlabel data

randnum2=randnum2+numtraindata1;

%save ('E:/Randomnum1internet.txt','randomnum1','-ASCII');
randomnum1=load('E:/Randomnum1internet.txt');

%save ('E:/Randomnum2internet.txt','randomnum2','-ASCII');
randomnum2=load('E:/Randomnum2internet.txt');

%save ('E:/Randnum1internet.txt','randnum1','-ASCII');
%randnum1=load('E:/Randnum1internet.txt');

%save ('E:/Randnum2internet.txt','randnum2','-ASCII');
%randnum2=load('E:/Randnum2internet.txt');

 %++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 numdata=1;
 Alt=datahandwritten(1).ad_alt;
[Alt_train,Alt_test]=InternetDataCreate_RCEpaper(Alt,randomnum1,randomnum2,randnum1,randnum2,numoflabeldata1,numoflabeldata2,numtraindata1,numtraindata2,numofun1,numofun2,numoftest1,numoftest2);

data{numdata,1}=Alt_train{1};
data{numdata,2}=Alt_train{2};
data{numdata,3}=Alt_test;
disp('-------------------------------------');
disp('Alt:');
size(Alt_train{1})
size(Alt_train{2})
size(Alt_test)

clear Alt;
clear Alt_train;
clear Alt_test;

numdata=numdata+1;



%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

 Cap=datahandwritten(1).ad_cap;
[Cap_train,Cap_test]=InternetDataCreate_RCEpaper(Cap,randomnum1,randomnum2,randnum1,randnum2,numoflabeldata1,numoflabeldata2,numtraindata1,numtraindata2,numofun1,numofun2,numoftest1,numoftest2);

data{numdata,1}=Cap_train{1};
data{numdata,2}=Cap_train{2};
data{numdata,3}=Cap_test;

disp('-------------------------------------');
disp('Cap:');
size(Cap_train{1})
size(Cap_train{2})
size(Cap_test)

clear Cap;
clear Cap_train;
clear Cap_test;

numdata=numdata+1;

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

 Url=datahandwritten(1).ad_url;
[Url_train,Url_test]=InternetDataCreate_RCEpaper(Url,randomnum1,randomnum2,randnum1,randnum2,numoflabeldata1,numoflabeldata2,numtraindata1,numtraindata2,numofun1,numofun2,numoftest1,numoftest2);

data{numdata,1}=Url_train{1};
data{numdata,2}=Url_train{2};
data{numdata,3}=Url_test;
disp('-------------------------------------');
disp('Url:');
size(Url_train{1})
size(Url_train{2})
size(Url_test)

clear Url;
clear Url_train;
clear Url_test;

numdata=numdata+1;

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

 orig=datahandwritten(1).ad_orig;
[orig_train,orig_test]=InternetDataCreate_RCEpaper(orig,randomnum1,randomnum2,randnum1,randnum2,numoflabeldata1,numoflabeldata2,numtraindata1,numtraindata2,numofun1,numofun2,numoftest1,numoftest2);

data{numdata,1}=orig_train{1};
data{numdata,2}=orig_train{2};
data{numdata,3}=orig_test;
disp('-------------------------------------');
disp('orig:');
size(orig_train{1})
size(orig_train{2})
size(orig_test)

clear orig;
clear orig_train;
clear orig_test;

numdata=numdata+1;


%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

 ancurl=datahandwritten(1).ad_ancurl;
[ancurl_train,ancurl_test]=InternetDataCreate_RCEpaper(ancurl,randomnum1,randomnum2,randnum1,randnum2,numoflabeldata1,numoflabeldata2,numtraindata1,numtraindata2,numofun1,numofun2,numoftest1,numoftest2);

data{numdata,1}=ancurl_train{1};
data{numdata,2}=ancurl_train{2};
data{numdata,3}=ancurl_test;

disp('-------------------------------------');
disp('ancurl:');
size(ancurl_train{1})
size(ancurl_train{2})
size(ancurl_test)

clear ancurl;
clear ancurl_train;
clear ancurl_test;

numdata=numdata+1;




%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

clear randomnum1;
clear randomnum2;
clear randnum1;
clear randnum2;

index=2;

data1{1,1}=data{index,1};
data1{1,2}=data{index,2};
data1{1,3}=data{index,3};

c1=[];
c2=[];
c3=[];
for i=1:5
   if i~=index
    c1=cat(2,c1,data{i,1});
    c2=cat(2,c2,data{i,2});
    c3=cat(2,c3,data{i,3});
   end
   
end

data1{2,1}=c1;
data1{2,2}=c2;
data1{2,3}=c3;

clear data;
clear label;
clear c1;
clear c2;
clear c3;
clear datahandwritten;

%{
c=cat(2,data{2,1},data{3,1});
c=cat(2,c,data{4,1});
c=cat(2,c,data{5,1});
data1{2,1}=c;

c2=cat(2,data{2,2},data{3,2});
c2=cat(2,c2,data{4,2});
c2=cat(2,c2,data{5,2});

data1{2,2}=c2;

c3=cat(2,data{2,3},data{3,3});
c3=cat(2,c3,data{4,3});
c3=cat(2,c3,data{5,3});
data1{2,3}=c3;

%}
Setoflabel=zeros(15,15);
flagsim=1;
%{
%traindata1=cat(1,data1{1,1},data1{1,2});
%traindata2=cat(1,data1{2,1},data1{2,2});

traindata1=data1{1,1};
traindata2=data1{2,1};

%testdata1=data1{1,3};
%testdata2=data1{2,3};
testdata1=cat(1,data1{1,3},data1{1,2});
testdata2=cat(1,data1{2,3},data1{2,2});


%labeltrain=cat(1,label1{1,1},label1{1,2});
labeltrain=label1{1,1};


%labeltest=label1{1,3};
labeltest=cat(1,label1{1,3},label1{1,2});

%labeltrain=cat(1,label1{1,1},label1{1,2});
labeltrain=label1{1,1};
%}
Similarity=[];
h=15;


ensemblesize=15;
fss=1;
t=7;
dim=12;

% correct = RCE_Ensemble(traindata1,traindata2,labeltrain, testdata1,testdata2,labeltest,Similarity,h,fss,t,dim )
for i=1:2
   
 [acc ,h,k]= Ensemble_Evaluation( data1,label1,dim,ensemblesize,fss,t );
%[acc ,h,k]= MultiSemi_RCE( data1,label1,Setoflabel,dim,ensemblesize,flagsim,fss,t);
Acc1(i,1)=acc;
end



