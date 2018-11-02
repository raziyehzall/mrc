clc;
clear all;

WEKA_HOME = 'E:\Arshad\Impelemention\weka-3-7-7\weka-3-7-7';
javaaddpath([WEKA_HOME '\weka.jar']);

% create SRG graph
%%
cm = [0,1,0,0,0,0,0;0,0,1,1,1,1,0;0,0,0,0,0,0,0;0,0,0,0,0,0,0;0,0,0,0,0,0,1;0,0,0,0,0,0,1;0,0,0,0,0,0,0];
%cm=cm+cm';


ids = {'loan','account','order','transaction','disp','district','client'};
SRG= biograph(cm,ids);
get(SRG.nodes,'ID')
%view(SRG1)
allshortestpaths(SRG)

%%
% load data from file

%load table loan
fName='E:/Arshad/Impelemention/DataFile-view/loan.arff';
loan_view= view_table2(fName,'loan',1);


%load table account
fName1='E:/Arshad/Impelemention/DataFile-view/account.arff';
account_view= view_table2(fName1,'account',2);

%load table client
fName1='E:/Arshad/Impelemention/DataFile-view/client.arff';
client_view= view_table2(fName1,'client',7);

%load table disp
fName1='E:/Arshad/Impelemention/DataFile-view/disp.arff';
disp_view= view_table2(fName1,'disp',5);

%load table district
fName1='E:/Arshad/Impelemention/DataFile-view/district.arff';

district_view= view_table2(fName1,'district',6);
    
%load table order
fName1='E:/Arshad/Impelemention/DataFile-view/order.arff';
order_view= view_table2(fName1,'order',3);

%load table trans
fName1='E:/Arshad/Impelemention/DataFile-view/trans.txt';
trans_view= view_table2(fName1,'trans',4);
%{
%load table card
%fName1='E:/Arshad/Impelemention/DataFile-view/card.arff';
%card_view= view_table(fName1,'card');


%}
%% Semi correlated table
% view consist data and label in data  and train data and test data in each
% view
view{1}=loan_view.View;
view{2}=account_view.View;
view{3}=order_view.View;
view{4}=trans_view.View;
view{5}=disp_view.View;
view{6}=district_view.View;
view{7}=client_view.View;



%%

 level=0;%level in SRG for while
 numiter=1;
 stop=1;
  numofUnlabel=size(view{1,1}{1,5},1)
  for i=1:numofUnlabel
                 
        randomnum(i,1)=i;
  end
  
   sizeview=size(view,2);
   
while stop
   
      if(level==0)% level zero 
                for NumView=1:sizeview %based on code of each view
                   disp('___________________________________________________');
                   disp(view{1,NumView}{1,1});
                    disp(view{1,NumView}{1,8});
                         
                   train_mat=cat(2,view{1,NumView}{1,2},view{1,NumView}{1,4});   
                   
                                              
                          
                   test_mat_test=cat(2,view{1,NumView}{1,3},view{1,NumView}{1,5})   ;              
                   labeltestdata=view{1,NumView}{1,5};
                   
                %--------------------------------covert to instances array
                   R1=train_mat;
                   save ('E:/train.txt','R1','-ASCII');

                   

                   R3=test_mat_test;
                   save ('E:/testdata.txt','R3','-ASCII');
                  
                   tablename1 = 'E:/train.txt';
                   
                   tablename3 = 'E:/testdata.txt';

                   loader = weka.core.converters.MatlabLoader();
                   loader.setFile( java.io.File(tablename1) );
                   train_data = loader.getDataSet();            
                   train_data.setClassIndex( train_data.numAttributes()-1 );


                 


                   loader = weka.core.converters.MatlabLoader();
                   loader.setFile( java.io.File(tablename3) );
                   test_data_test = loader.getDataSet();            
                   test_data_test.setClassIndex( test_data_test.numAttributes()-1 );
                   %--------------------------------------------------------------------
                   [Classifiers,pred1,pred2] = Ensemble_Classifier(train_data,test_data_test,test_data_test);
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
                         if predictionUnlabel{1,NumView}(k,1)==labeltestdata(k,1)
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
                                
                

                end
               end 
             
    
    
    if level>0
        level
 dist=allshortestpaths(SRG)  
 dist(dist(:,:)==Inf)=0
 indexoflevel=find(dist(1,:)==level)   %level based on target table calculate
 
 
 
 dim(1,1)=10;
 dim(1,2)=3;
 dim(1,3)=4;
 dim(1,4)=10;
 dim(1,5)=4;
 dim(1,6)=10;
 dim(1,7)=4;
 dim(1,8)=15;
 ensembelsize=15;
 flagsim=0;
 fss=1;
 t=5;
 
for indexinlevel=1: size(indexoflevel,2)
                      
                       
                       
                        disp('------views that correlated---');
                                               
                        view{1,indexoflevel(1,indexinlevel)}{1,8}
                        view{1,indexoflevel(1,indexinlevel)}{1,1}
                        
                        
                        SimVotes=zeros(2,10);               
                       
                        ensembelsize=15;
                        
                        code=view{1,indexoflevel(1,indexinlevel)}{1,8};
                        
                          % create sim matrix based on predication on
                                % the view in level 1
                        numalldata=size(view{1,1}{1,5},1)+size(view{1,1}{1,4},1);
                        numalldata
                        numun= size(view{1,1}{1,5},1)%unalbel in working state
                        numlabel=size(view{1,1}{1,4},1)%label data in train data
                       
                     
                        
                      WofClassifier{1,code}=1;
                        
                      dist=allshortestpaths(SRG)
                      dist(dist(:,:)==Inf)=0
                      backindexarr=find(dist(:,indexoflevel(1,indexinlevel))>0)'
                   
                       sizecon=size(backindexarr,2)
                      
                      
                        if sizecon>=4
                            
                          sizecon=sizecon-1;
                          
                          for numofcorr=1:sizecon
                            backindexarr(1,numofcorr)
                                                        
                            data1{1,numofcorr}=view{1,backindexarr(1,numofcorr)}{1,2};
                            datatest{1,numofcorr}=view{1,backindexarr(1,numofcorr)}{1,3};
                          
                         end
                      
                          indexinlevel
                          data1{1,numofcorr+1}=view{1,indexoflevel(1,indexinlevel)}{1,2};                          
                          datatest{1,numofcorr+1}=view{1,indexoflevel(1,indexinlevel)}{1,3};
                          
                          data1


                         for i1=1:size(data1{1,1},1)
                             for j1=1:size(data1{1,1},1)
                                 label1=view{1,1}{1,4};
                                 if label1(i1,1)==label1(j1,1)
                                     A1(i1,j1)=1;
                                                                          
                                 end
                             end
                         end
                         
                         for j=1:size(data1,2)
                            for i=1:size(data1,2)


                            A{i,j}=zeros(size(view{1,1}{1,4},1),size(view{1,1}{1,4},1));

                              if (i~=j)
                                  A{i,j}=A1;
                                  
                                  
                              end
                            end
                         end

                        for i1=1:size(data1,2)
                                  data{1,i1}=data1{1,i1}';
                        end
                      
                        

                         
                          
                          
                         W1 = Multi_DCCA_2( data,A,dim(1,code) )
                        
                              
                          
                          
                          for i=1:size(W1,2)
              
                    
                            W{1,i}=W1{1,i}(1:size(data1{1,i},2),:);
                          end
                      
                          
                          for numberview=1:size(data1,2);
                   
                              Wx=W{1,numberview};
                              U{numberview} = data1{1,numberview} * Wx;

                           end
                           t3 =U{1};
                           if fss==1
                               x=U{1};
                               for numview1=2:size(data1,2)
                                   x=x+U{numview1};
                               end
                                t3 =x ;
                           else
                               x=U{1};
                               for numview1=2:size(data1,2)
                                   x=[x,U{numview1}];
                               end
                                t3 =x ;
                               % Hypo{k} = [u,v];
                           end



                          train_mat=cat(2,t3,view{1,1}{1,4}); 


                           % test data---------------------------------

                           clear U;
                           for numberview=1:size(data1,2)
                              Wx=W{1,numberview};
                              U{numberview} = datatest{1,numberview} * Wx;

                           end
                           t3 =U{1};
                           if fss==1
                               x=U{1};
                               for numview1=2:size(data1,2)
                                   x=x+U{numview1};
                               end
                                t3 =x ;
                           else
                               x=U{1};
                               for numview1=2:size(data1,2)
                                   x=[x,U{numview1}];
                               end
                                t3 =x ;
                               % Hypo{k} = [u,v];
                           end



                           test_mat_test=cat(2,t3,view{1,1}{1,5})   ;

                          %--------------------------------covert to instances array
                          R1=train_mat;

                          save ('E:/train.txt','R1','-ASCII');



                          R3=test_mat_test;

                          save ('E:/testdata.txt','R3','-ASCII');
                         %...............................................

                           tablename1 = 'E:/train.txt';
                          
                           tablename3 = 'E:/testdata.txt';

                           loader = weka.core.converters.MatlabLoader();
                           loader.setFile( java.io.File(tablename1) );
                           train_data= loader.getDataSet();            
                           train_data.setClassIndex( train_data.numAttributes()-1 );




                           loader = weka.core.converters.MatlabLoader();
                           loader.setFile( java.io.File(tablename3) );
                           test_data_test = loader.getDataSet();            
                           test_data_test.setClassIndex( test_data_test.numAttributes()-1 );


                            fprintf('\n %f',i);
                           disp('traindata---------------------------------');
                           [Classifiers,pred1,pred2] = Ensemble_Classifier(train_data,train_data,test_data_test);
                           predicationlabel(:,1)=pred1;                      
                           predictiontest(:,1)=pred2; %test data


                          %%
                             clear dataRCE;
                          clear labelforce;
                          clear Setoflabel;
                          for numdata=1:size(data1,2)
                              dataRCE{numdata,1}=data1{1,numdata};
                              dataRCE{numdata,2}=data1{1,numdata}(1,:);
                              dataRCE{numdata,3}=datatest{1,numdata};
                          end
                              labelforrce{1,1}=view{1,1}{1,4};
                              labelforrce{1,2}=view{1,1}{1,4}(1,:);
                              labelforrce{1,3}=view{1,1}{1,5};

                              Setoflabel(1,:)=labelforrce{1,1}';
                              Setoflabel(1,size(Setoflabel,2)+1)=labelforrce{1,2}';
                              Setoflabel(2,:)=1;
                              size(Setoflabel)

                             
                          
                         % [acc ,prevotingUnlabel,predictiontest]= MultiSemi_RCE( dataRCE,labelforrce,Setoflabel,dim,ensembelsize,flagsim,fss,t);
                           predictionUnlabel{1,code}(:,1)=predictiontest(:,1);
                           prediction{1,code}(:,1)=predictiontest(:,1);

                           
                           s=size(predictiontest,1);
                            labeltestdata=view{1,1}{1,5};
                             correct=0;
                             for k=1:s
                                 if predictiontest(k,1)==labeltestdata(k,1)
                                     correct=correct+1;
                                 end
                             end
                             correct1=correct/s;
                            fprintf('\n corrcet classify test  data in view. size(accuracy)(numCorrect): %f(%f)(%f)\n',s,correct1,correct);
                            code
                            

                               WofClassifier{1,code}=0.5;

                              sizecon=size(backindexarr,2)
                              backindexarr(1,sizecon-1)= backindexarr(1,sizecon);
                              sizecon=sizecon-1;
                               code=code+1; 

                               WofClassifier{1,code}=0.5;

                        end
                       code
                         for numofcorr=1:sizecon
                          backindexarr(1,numofcorr)
                            data1{1,numofcorr}=view{1,backindexarr(1,numofcorr)}{1,2};
                            datatest{1,numofcorr}=view{1,backindexarr(1,numofcorr)}{1,3};
                                                   
                         end
                      
                      indexinlevel
                      indexoflevel(1,indexinlevel)
                      data1{1,numofcorr+1}=view{1,indexoflevel(1,indexinlevel)}{1,2};
                      datatest{1,numofcorr+1}=view{1,indexoflevel(1,indexinlevel)}{1,3};
                     
                      data1
                     
                      
                      for i1=1:size(data1{1,1},1)
                             for j1=1:size(data1{1,1},1)
                                 label1=view{1,1}{1,4};
                                 if label1(i1,1)==label1(j1,1)
                                     A1(i1,j1)=1;
                                                                          
                                 end
                             end
                         end
                         for j=1:size(data1,2)
                            for i=1:size(data1,2)


                            A{i,j}=zeros(size(view{1,1}{1,4},1),size(view{1,1}{1,4},1));

                              if (i~=j)
                                  A{i,j}=A1;
                                  
                                  
                              end
                            end
                         end
                         
                         
                      fss=1;
                      for i1=1:size(data1,2)
                          data{1,i1}=data1{1,i1}';
                      end
                      
                      data
                      A
                      W1 = Multi_DCCA_2( data,A,dim(1,code) )
                      
                      for i=1:size(W1,2)
              
                    
                            W{1,i}=W1{1,i}(1:size(data1{1,i},2),:);
                     end
                      
                      
                      %%
                      for numberview=1:size(data1,2);
                   
                          Wx=W{1,numberview};
                          U{numberview} = data1{1,numberview} * Wx;

                       end
                       t3 =U{1};
                       if fss==1
                           x=U{1};
                           for numview1=2:size(data1,2)
                               x=x+U{numview1};
                           end
                            t3 =x ;
                       else
                           x=U{1};
                           for numview1=2:size(data1,2)
                               x=[x,U{numview1}];
                           end
                            t3 =x ;
                           % Hypo{k} = [u,v];
                       end



                      train_mat=cat(2,t3,view{1,1}{1,4}); 

                     
                       % test data---------------------------------

                       clear U;
                       for numberview=1:size(data1,2)
                          Wx=W{1,numberview};
                          U{numberview} = datatest{1,numberview} * Wx;

                       end
                       t3 =U{1};
                       if fss==1
                           x=U{1};
                           for numview1=2:size(data1,2)
                               x=x+U{numview1};
                           end
                            t3 =x ;
                       else
                           x=U{1};
                           for numview1=2:size(data1,2)
                               x=[x,U{numview1}];
                           end
                            t3 =x ;
                           % Hypo{k} = [u,v];
                       end



                       test_mat_test=cat(2,t3,view{1,1}{1,5})   ;

                      %--------------------------------covert to instances array
                      R1=train_mat;

                      save ('E:/train.txt','R1','-ASCII');

                      

                      R3=test_mat_test;

                      save ('E:/testdata.txt','R3','-ASCII');
                     %...............................................

                       tablename1 = 'E:/train.txt';
                       tablename2 = 'E:/test.txt';
                       tablename3 = 'E:/testdata.txt';

                       loader = weka.core.converters.MatlabLoader();
                       loader.setFile( java.io.File(tablename1) );
                       train_data= loader.getDataSet();            
                       train_data.setClassIndex( train_data.numAttributes()-1 );




                       loader = weka.core.converters.MatlabLoader();
                       loader.setFile( java.io.File(tablename3) );
                       test_data_test = loader.getDataSet();            
                       test_data_test.setClassIndex( test_data_test.numAttributes()-1 );


                        fprintf('\n %f',i);
                       disp('traindata---------------------------------');
                       [Classifiers,pred1,pred2] = Ensemble_Classifier(train_data,train_data,test_data_test);
                       predicationlabel(:,1)=pred1;                      
                       predictiontest(:,1)=pred2; %test data
                      correct=0;
                             for k=1:s
                                 if predictiontest(k,1)==labeltestdata(k,1)
                                     correct=correct+1;
                                 end
                             end
                             correct1=correct/s;
                            fprintf('\n corrcet classify test  data in view. size(accuracy)(numCorrect): %f(%f)(%f)\n',s,correct1,correct);
                      
                      %%
                      clear dataRCE;
                      clear labelforce;
                      clear Setoflabel;
                      for numdata=1:size(data1,2)
                          dataRCE{numdata,1}=data1{1,numdata};
                          dataRCE{numdata,2}=data1{1,numdata}(1,:);
                          dataRCE{numdata,3}=datatest{1,numdata};
                      end
                          labelforrce{1,1}=view{1,1}{1,4};
                          labelforrce{1,2}=view{1,1}{1,4}(1,:);
                          labelforrce{1,3}=view{1,1}{1,5};
                         
                          Setoflabel(1,:)=labelforrce{1,1}';
                          Setoflabel(1,size(Setoflabel,2)+1)=labelforrce{1,2}';
                          Setoflabel(2,:)=1;
                          size(Setoflabel)
                          
                          
                          
                        %  [acc ,prevotingUnlabel,predictiontest]= MultiSemi_RCE( dataRCE,labelforrce,Setoflabel,dim,ensembelsize,flagsim,fss,t);
                                               
                           
                       predictionUnlabel{1,code}(:,1)=predictiontest(:,1);
                       prediction{1,code}(:,1)=predictiontest(:,1);
                       disp('------------------------!!!!!!!111');
                       size(WofClassifier)
                       size(predictionUnlabel)
                       
                       if(level==3)% level =3 in loan database that final
                           flag=0;
                           stop=0;
                           
                       end
                       
            end
            
    end
                 
             
                 %of percent of unlabel data 
                 predictionUnlabel;
                 WofClassifier
                 labelunlabel=view{1,1}{1,5};
                   numofUnlabel=size(labelunlabel,1);
                   
                   numClassifier=size(predictionUnlabel,2);
                   
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
                  
                  labeltrueTraindata=view{1,1}{1,4};
                  accinlabeladd=sum(view{1,1}{1,4}-labeltrueTraindata==0)/size(labeltrueTraindata,1);
                  accinlabeladd
                  
                  
                 % if size(index2<30 ) % condition not accurate and this if for go to greater levels
                      level=level+1;
                     
                 % end
                  
                  
                  %idea: add unlabel data that we give them label to train
                  %data of view that we extract correlated but do not
                  %delete from unlabel data and 
                 
      end
              
              