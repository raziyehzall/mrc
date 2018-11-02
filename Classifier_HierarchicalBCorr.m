classdef Classifier_HierarchicalBCorr
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    %Hierarchical classification based on Correlation
    
    properties
       train_data; 
       test_data;
       test_data_test %for each view cell array contain train(label data) test and unlabel data
    end
    
    methods
           function c= Classifier_HierarchicalBCorr(view,SRG)

               sizeview=size(view,2);
               
               flag=1;% continue when unlabel data finish or can not add unlabel data to train data
               level=0;%level in SRG for while
               numiter=1;
               stop=1;
               backindexKeep=zeros(size(view,2),1);
               backindexKeep(:,1)=1;
               %backindexKeep(2,1)=3;
               %backindexKeep(3,1)=2;
               backindexkeepflag=0;%in first iteration that is calculate and flag is set to false
               
                labeltrueTraindata=view{1,1}{1,4};
      while stop %iteration general
            disp('-------------------------------------------------num of iteration');
            disp(numiter);
            numofUnlabel=size(view{1,1}{1,5},1)
            split=1;
            numUnlabelSelect=floor(numofUnlabel/split)
            
            if numofUnlabel<10
                numUnlabelSelect=numofUnlabel;
            end
            % select random unlabel data and run voting on
            % them and if confident label add to train data!!!!
                        
            %  randomnum=randi(numofUnlabel,numUnlabelSelect,1);   %-1 chon size instances weka array based az 0 ta size-1
              randomnum=randperm(numofUnlabel);
              randomnum=randomnum(1:numUnlabelSelect);
              randomnum=randomnum';
              %   random number is not randommmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
              for i=1:numofUnlabel
                 
                  randomnum(i,1)=i;
              end
             
              while flag   %iteration-#
                                    
               %level one(classifier on each view)
              
               if(level==0)% level zero 
                for NumView=1:sizeview %based on code of each view
                   disp('___________________________________________________');
                   disp(view{1,NumView}{1,1});
                    disp(view{1,NumView}{1,8});
                         
                   train_mat=cat(2,view{1,NumView}{1,2},view{1,NumView}{1,4});   
                   
                                              
                   test_mat=cat(2,view{1,NumView}{1,3},view{1,NumView}{1,5})   ;
                   labelunlabel=view{1,NumView}{1,5};
        
                   test_mat_test=cat(2,view{1,NumView}{1,6},view{1,NumView}{1,7})   ;              
                   labeltestdata=view{1,NumView}{1,7};
                   
                %--------------------------------covert to instances array
                   R1=train_mat;
                   save ('E:/train.txt','R1','-ASCII');

                   R2=test_mat;
                   save ('E:/test.txt','R2','-ASCII');

                   R3=test_mat_test;
                   save ('E:/testdata.txt','R3','-ASCII');
                  
                   tablename1 = 'E:/train.txt';
                   tablename2 = 'E:/test.txt';
                   tablename3 = 'E:/testdata.txt';

                   loader = weka.core.converters.MatlabLoader();
                   loader.setFile( java.io.File(tablename1) );
                   train_data{1,NumView} = loader.getDataSet();            
                   train_data{1,NumView}.setClassIndex( train_data{1,NumView}.numAttributes()-1 );


                   loader = weka.core.converters.MatlabLoader();
                   loader.setFile( java.io.File(tablename2) );
                   test_data{1,NumView} = loader.getDataSet();
                   test_data{1,NumView}.setClassIndex( test_data{1,NumView}.numAttributes()-1 );


                   loader = weka.core.converters.MatlabLoader();
                   loader.setFile( java.io.File(tablename3) );
                   test_data_test{1,NumView} = loader.getDataSet();            
                   test_data_test{1,NumView}.setClassIndex( test_data_test{1,NumView}.numAttributes()-1 );
                   %--------------------------------------------------------------------
                   [Classifiers{1,NumView},pred1,pred2] = Ensemble_Classifier(train_data{1,NumView},test_data{1,NumView},test_data_test{1,NumView});
                   WofClassifier{1,NumView}=1;
                   predictionUnlabel{1,NumView}(:,1)=pred1; %unlabel data
                  
                   prediction{1,NumView}(:,1)=pred2; %test data
                
                    %_________________________________________________________________________accuracy
                    %in each view individual
                    %of classifier in level one(each classfier run on each
                    %view without extraction
                    
                     s=size(predictionUnlabel{1,NumView},1);
        
                   
                     
                     correct=0;
                     for k=1:s
                         if predictionUnlabel{1,NumView}(k,1)==labelunlabel(k,1)
                             correct=correct+1;
                         end
                     end
                     correct1=correct/s;
                    fprintf('\n corrcet classify Unlabel data in  view . size(accuracy)(numCorrect): %f(%f)(%f)\n',s,correct1,correct);
                    
                     s=size(prediction{1,NumView},1);
        
                     correct=0;
                     for k=1:s
                         if prediction{1,NumView}(k,1)==labeltestdata(k,1)
                             correct=correct+1;
                         end
                     end
                     correct1=correct/s;
                    fprintf('\n corrcet classify test  data in view. size(accuracy)(numCorrect): %f(%f)(%f)\n',s,correct1,correct);
                    %{
                    %------------------unlabeled data accuracy
                    nCls = length(unique(labeltest));
                 s=size(predictionUnlabel,1);
                 predvoting=zeros(s,1);
                 vote=zeros(nCls,s);
                 h=1;
                  for k =1:s
                      for j=1:h
                      vote(predictionUnlabel(k,j)+1,k)=vote(predictionUnlabel(k,j)+1,k)+1;
                      end
                      maxvalue=predictionUnlabel(k,1);%find max voting
                      maxindex=1;

                      for j=1:nCls 
                          if vote(j,i)>maxvalue
                              maxvalue=vote(j,k);
                              maxindex=j;
                          end
                      end
                      predvoting(k,1)=maxindex-1;%label begin 0

                  end
                 correct=0;
                 for k=1:s
                     if predvoting(k,1)==labeltest(k,1)
                         correct=correct+1;
                     end
                 end
                 correctun=correct/s;
                    fprintf('\n corrcet classify unlabeled data in Semi RCE(proposed approach). size(accuracy)(numCorrect): %f(%f)(%f)\n',s,correctun,correct);
                %}
                 %________________________________________________________________________________label
                

                end
               end 
               if(level>0)% using SRG and based on level traveles SRG graph and extract correlation based on semi RCE
                 
                   
                   %detecte level of each view according to target table
                   dist=allshortestpaths(SRG)
                   
                   %calculate index back in first iteration for all view
                   if backindexkeepflag==1
                       for j=2:size(view,2)  %j=1 =target table and do not need back index
                           
                           disp('-------------------view back---------------');
                           j
                           
                           indexback=0;
                           % set index back to
                          dist(dist(:,:)==Inf)=0
                          backindexarr=find(dist(:,j)>0)'
                          
                          maxarray=zeros(1,size(backindexarr,1));
                          for i=1 : size(backindexarr,2)% evaluate that good back point
                             if backindexarr(1,i)<j
                                view{1,backindexarr(1,i)}{1,1}
                                view{1,j}{1,1}
                                
                                backindexarr(1,i)
                                j
                                SimVotes=zeros(2,10);               
                                dim=13;
                                ensembelsize=15;
                                
                               [accuracy,classifiers,prevotingUnlabel]=SemiRCE_Ensemble( view{1,backindexarr(1,i)}{1,2},view{1,backindexarr(1,i)}{1,3},view{1,backindexarr(1,i)}{1,4},view{1,j}{1,2},view{1,j}{1,3},view{1,backindexarr(1,i)}{1,5},view{1,backindexarr(1,i)}{1,6},view{1,j}{1,6},view{1,backindexarr(1,i)}{1,7},Sim,dim,ensembelsize);
                                maxarray(1,i)=accuracy; %accuracy in train data
                               
                             end
                          end
                          maxarray
                          m=max(maxarray)
                          indexmax=find(maxarray(1,:)==m)
                          if m>0
                            indexback=backindexarr(indexmax(1,1),1)                         
                            backindexKeep(j,1)=indexback;
                          end
                       end 
                        backindexkeepflag=0;
                  end
                   
                   backindexKeep
                   indexoflevel=find(dist(1,:)==level)   %level based on target table calculate
                   
                   for indexinlevel=1: size(indexoflevel,2)
                      
                       
                       
                        disp('------views that correlated---');
                        backindexKeep(indexoflevel,1);
                        backindexKeep
                        
                        view{1,indexoflevel(1,indexinlevel)}{1,8}
                        view{1,indexoflevel(1,indexinlevel)}{1,1}
                        %view{1,backindexKeep(indexinlevel,1)}{1,1}
                        view{1,backindexKeep(indexoflevel(1,indexinlevel),1)}{1,1}
                        
                        SimVotes=zeros(2,10);               
                        dim=0;
                        ensembelsize=15;
                        
                        code=view{1,indexoflevel(1,indexinlevel)}{1,8};
                        
                          % create sim matrix based on predication on
                                % the view in level 1
                         numalldata=size(view{1,1}{1,5},1)+size(view{1,1}{1,4},1);
                         numalldata
                        numun= size(view{1,1}{1,5},1)%unalbel in working state
                        numlabel=size(view{1,1}{1,4},1)%label data in train data
                        Setoflabel=zeros(5,size(numalldata,1));
                        
                        Setoflabel(1,1:numlabel)=view{1,1}{1,4}(:,1)';
                        Setoflabel(2,1:numlabel)=1;
                        Setoflabel(1,numlabel+1:numalldata)=predvoting(:,1);
                        Setoflabel(2,numlabel+1:numalldata)=1;
                         %{
                         %for unlabel data
                         for i1=numlabel+1:numun
                             for j1=numlabel+1:numun
                                 
                                 if predvoting(i1,1)==predvoting(j1,1)
                                     Sim(i1,j1)=1;
                                                                          
                                 end
                             end
                         end
                         %for label data
                          for i1=1: numlabel
                             for j1=1: numlabel
                                 
                                 if view{1,1}{1,4}(i1,1)==view{1,1}{1,4}(j1,1)
                                     Sim(i1,j1)=1;
                                                                          
                                 end
                             end
                          end
                          %}
                        Set=Setoflabel';
                         save ('E:/sheb.txt','Set','-ASCII');
                        
                        flagsim=0;%if calculate sim in function
                        
                       [accuracy,classifiers,prevotingUnlabel,predicationTest]=SemiRCE_Ensemble( view{1,backindexKeep(indexoflevel(1,indexinlevel),1)}{1,2},view{1,backindexKeep(indexoflevel(1,indexinlevel),1)}{1,3},view{1,backindexKeep(indexoflevel(1,indexinlevel),1)}{1,4},view{1,indexoflevel(1,indexinlevel)}{1,2},view{1,indexoflevel(1,indexinlevel)}{1,3},view{1,backindexKeep(indexoflevel(1,indexinlevel),1)}{1,5},view{1,backindexKeep(indexoflevel(1,indexinlevel),1)}{1,6},view{1,indexoflevel(1,indexinlevel)}{1,6},view{1,backindexKeep(indexoflevel(1,indexinlevel),1)}{1,7},Setoflabel,dim,ensembelsize,flagsim);

                        WofClassifier{1,code}=1;
  %{
                      data1{1,1}=view{1,backindexKeep(indexinlevel,1)}{1,2};%train data view1
                      data1{1,2}=view{1,backindexKeep(indexinlevel,1)}{1,3};%unlabel data view2
                      data1{1,3}=view{1,backindexKeep(indexinlevel,1)}{1,6};
                      
                      data1{2,1}=view{1,indexoflevel(1,indexinlevel)}{1,2};
                      data1{2,2}=view{1,indexoflevel(1,indexinlevel)}{1,3};
                      data1{2,3}=view{1,indexoflevel(1,indexinlevel)}{1,6};
                      
                      labelforrce{1,1}=view{1,backindexKeep(indexinlevel,1)}{1,4};
                      labelforrce{1,2}=view{1,backindexKeep(indexinlevel,1)}{1,5};
                      labelforrce{1,3}=view{1,backindexKeep(indexinlevel,1)}{1,7};
                      %}
                     % [acc ,prevotingUnlabel,predicationTest]= MultiSemi_RCE( data1,labelforrce,Setoflabel,dim,ensembelsize,flagsim);
                       predictionUnlabel{1,code}(:,1)=prevotingUnlabel(:,1);
                       prediction{1,code}(:,1)=predicationTest(:,1);
                       
                       
                       if(level==3)% level =3 in loan database that final
                           flag=0;
                       end
                   end
                 
                   
               end
                 %of percent of unlabel data 
                 predictionUnlabel;
                   numofUnlabel=size(labelunlabel,1);
                   numClassifier=size(Classifiers,2);
                   nCls = length(unique(labelunlabel));
                   con=50/100;
              
                   %   [ predictionUnlabel{1}(:,1),predictionUnlabel{2}(:,1),predictionUnlabel{3}(:,1),predictionUnlabel{4}(:,1),predictionUnlabel{5}(:,1),predictionUnlabel{6}(:,1),predictionUnlabel{7}(:,1),labelunlabel(:,1)]
                 
                   [index,index2,predvoting] = Voting_multipleClassifer( numofUnlabel, numClassifier,nCls,predictionUnlabel,randomnum,con, WofClassifier);
                  size(index)
                  size(predictionUnlabel)
                  size(predvoting)
                  [predvoting(:,1),labelunlabel(:,1)];
                  accaddinunlabeladd=sum(predvoting(:,1)-labelunlabel(:,1)==0)/size(index,2);
                  accaddinunlabeladd
                  
                  %{
                  randomnum1=randperm(size( predictionUnlabel{1,1},1));
                  randomnum1=randomnum1(1:size( predictionUnlabel{1,1},1));
                  randomnum1=randomnum1';
                  %}
                  con=0;
                  [index6,index5,predvoting1] = Voting_multipleClassifer(size( predictionUnlabel{1,1},1) , numClassifier,nCls,prediction,randomnum,con,WofClassifier);
                   size(prediction)
                  size(predvoting1)
                  accatestadd=sum(predvoting1(:,1)-labeltestdata(:,1)==0)/size(index6,2);
                  size(index6)
                  accatestadd
                  
                  accinlabeladd=sum(view{1,1}{1,4}-labeltrueTraindata==0)/size(labeltrueTraindata,1);
                  accinlabeladd
                  
                  
                 % if size(index2<30 ) % condition not accurate and this if for go to greater levels
                      level=level+1;
                     
                 % end
                  
                  
                  %idea: add unlabel data that we give them label to train
                  %data of view that we extract correlated but do not
                  %delete from unlabel data and 
                 
              end
              
              labeltrueTraindata=[labeltrueTraindata;view{1,1}{1,5}(index,1)];%label true of traindata
              %ADD unlabel data that we give them label
              for numview=1:sizeview
                  disp('add unlabel data to train data');
                view{1,numview}{1,2} =[view{1,numview}{1,2};view{1,numview}{1,3}(index,:)];%train data add
                
                
                 view{1,numview}{1,4}=[view{1,numview}{1,4};predvoting(index2,1)];%label of train data

                 view{1,numview}{1,3}(index,:)=[];                
                 view{1,numview}{1,5}(index,:)=[];%label of unlabeldata

                    size(view{1,numview}{1,2})
                    size(view{1,numview}{1,3})

                    size(view{1,numview}{1,4}) 
                    size(labeltrueTraindata)
                    size(view{1,numview}{1,5})
              end
               
              numiter=numiter+1;
              flag=1;
              level=0;
              
              %condition of stop add shavad!!!
              %train data and unlabel data in each view update based
              %on--------------------------------------------------------
              %label
              
              
            
              
              clear predictionUnlabel;
              clear prediction;
              %if(numiter==10)
              if    size(view{1,numview}{1,5},1)<50
                  size(view{1,numview}{1,4},1)
                   flag=0;
                   stop=0;
              end
             end 
         end
    end
    
end

