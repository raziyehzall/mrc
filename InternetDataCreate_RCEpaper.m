function [ traindata,testdata ] = InternetDataCreate_RCEpaper( data,randomnum1,randomnum2,randnum1,randnum2,numoflabeldata1,numoflabeldata2,numtraindata1,numtraindata2,numofun1,numofun2,numoftest1,numoftest2)


%kar = load(filename);

kar_train=zeros(numtraindata1+numtraindata2,size(data,2));
kar_test=zeros(numoftest1+numoftest2,size(data,2));



    kar_train(1:numtraindata1,:)=data(randomnum1(1:numtraindata1),:);
    kar_train(numtraindata1+1:numtraindata1+numtraindata2,:)=data(randomnum2(1:numtraindata2),:);
     
    kar_test(1:numoftest1,:)=data(randomnum1(numtraindata1+1:numtraindata1+numoftest1),:);
    kar_test(numoftest1+1:numoftest2+numoftest1,:)=data(randomnum2(numtraindata2+1:numtraindata2+numoftest2),:);

%-----------------------------------label matricx

%kar________tozi label ha baraye train data ha dorost mishavad__________________________________________________


%randnum=randperm(100);%for trian data and test data


TrainData=zeros(numoflabeldata1+numoflabeldata2,size(data,2));%labeled train data
UnlabelData=zeros(numofun1+numofun2,size(data,2));




TrainData(1:numoflabeldata1,:)= kar_train(randnum1(1:numoflabeldata1),:);
TrainData(numoflabeldata1+1:numoflabeldata1+numoflabeldata2,:)= kar_train(randnum2(1:numoflabeldata2),:);

UnlabelData(1:numofun1,:)= kar_train(randnum1(numoflabeldata1+1:numoflabeldata1+numofun1),:);
UnlabelData(numofun1+1:numofun1+numofun2,:)= kar_train(randnum2(numoflabeldata2+1:numoflabeldata2+numofun2),:);




traindata{1}=TrainData;
traindata{2}=UnlabelData;
testdata=kar_test;
clear kar_train;
clear kar_test;
clear TrainData;
clear UnlabelData;
end

