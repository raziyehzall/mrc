function [ correct1,correct2 ] = weightedvotingfinancial( view,SRG1 )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
            disp('sizeview');
            sizeview=size(view,2)
        
            for NumView=1:sizeview %based on code of each view
                   disp('___________________________________________________');
                   disp(view{1,NumView}{1,1});
                   disp(view{1,NumView}{1,8});
                         
                   train_mat=cat(2,view{1,NumView}{1,2},view{1,NumView}{1,4});   
                   
                   
                   train_matview{1,NumView}=train_mat;
                                              
                   test_mat=cat(2,view{1,NumView}{1,3},view{1,NumView}{1,5})   ;
                   labelunlabel=view{1,NumView}{1,5};
        
                   test_matview{1,NumView}=test_mat;
                   
                   
                   
                %--------------------------------covert to instances array
                   R1=train_mat;
                   save ('E:/train.txt','R1','-ASCII');

                   R2=test_mat;
                   save ('E:/test.txt','R2','-ASCII');

                  
                  
                   tablename1 = 'E:/train.txt';
                   tablename2 = 'E:/test.txt';
                   
                   loader = weka.core.converters.MatlabLoader();
                   loader.setFile( java.io.File(tablename1) );
                   train_data{1,NumView} = loader.getDataSet();            
                   train_data{1,NumView}.setClassIndex( train_data{1,NumView}.numAttributes()-1 );


                   loader = weka.core.converters.MatlabLoader();
                   loader.setFile( java.io.File(tablename2) );
                   test_data{1,NumView} = loader.getDataSet();
                   test_data{1,NumView}.setClassIndex( test_data{1,NumView}.numAttributes()-1 );


                  
                   %--------------------------------------------------------------------
                   [Classifiers{1,NumView},pred1,pred2,acctraintdata] = Ensemble_Classifier(train_data{1,NumView},test_data{1,NumView},train_data{1,NumView});
                   
                   
                   WofClassifier{1,NumView}=acctraintdata;
                   
                   
                   predictionlabel{1,NumView}(:,1)=pred2; %label data
                  
                   prediction{1,NumView}(:,1)=pred1; %test data
                
                    %_________________________________________________________________________accuracy
                    %in each view individual
                    %of classifier in level one(each classfier run on each
                    %view without extraction
                    
                     s=size(prediction{1,NumView},1);
        
                   
                     
                     correct=0;
                     for k=1:s
                         if prediction{1,NumView}(k,1)==labelunlabel(k,1)
                             correct=correct+1;
                         end
                     end
                      nCls = length(unique(prediction{1,NumView})) 
                     correct1=correct/s;
                    fprintf('\n corrcet classify test data in  view . size(accuracy)(numCorrect): %f(%f)(%f)\n',s,correct1,correct);
                    
                    
            end
            
            % for imbalance class
            Priority=zeros(sizeview,1);
            for i=1:sizeview
                 nCls = length(unique(prediction{1,i}))
                 if nCls>1
                     Priority(i,1)=1;
                 else
                     Priority(i,1)=1;
                 end

                
            end
            
            Priority
            WofClassifier
            %%
            %voting in multiple phase
            NumView=size(view,2)
            
            nCls = length(unique(view{1,1}{1,4}))  
            Numtestintaget=size(view{1,1}{1,3},1)
            
            
            for indextarget=1:Numtestintaget
                for indexview=1:NumView
                    for classindex=1:nCls
                        ViewPred{1,indexview}(classindex,indextarget)=0;
                        ViewPred{2,indexview}(1,indextarget)=0;
                        
                        
                        
                    end
                end
            end
            
            
                
            for indextarget=1:Numtestintaget
                
                for indexview=2:NumView
                    
                    numatt=size(test_matview{1,1},2)-1;%index of target id in target tabel, -1 chon label ham dar dade ha hast
                    numattnontar=size(test_matview{1,indexview},2)-1;%index of id of non target tuple
                    
                    idtar=test_matview{1,1}(indextarget,numatt);
                    test_matview{1,indexview}(:,numattnontar);
                    
                    
                    
                    nontargetindex=find(test_matview{1,indexview}(:,numattnontar)==idtar);
                   % size(nontargetindex)
                                                              
                    classindex=prediction{1,indexview}(nontargetindex(:,:),1)+1;
                    for k=1:size(classindex,1)
                    
                        ViewPred{1,indexview}(classindex(k,1),indextarget)= ViewPred{1,indexview}(classindex(k,1),indextarget)+1;
                        ViewPred{2,indexview}(1,indextarget)=ViewPred{2,indexview}(1,indextarget)+1;

                    end
                   
                        
                        
                    
                end
                
            end
            %{
            ViewPred{1,:}
            
            for i=1:6
                sum(ViewPred{1,i},2)
            end
            ViewPred{2,:}
            %}
            ViewPred{:,:};
            
            dist=allshortestpaths(SRG1)%fasele har view az target table and use it for voting
            
            weight=zeros(nCls,Numtestintaget);
            
            
            
            
            
            
            
            
            for indextarget=1:Numtestintaget
                
                
                classpred=prediction{1,1}(:,1)+1;
                weight(classpred(indextarget,1),indextarget)=1*Priority(1,1);%*WofClassifier{1,1}; %max weight
                    
                for class=1:nCls
                    
                   for indexview=2:NumView
                       indexview;
                       ViewPred{1,indexview}(class,indextarget);
                       
                       m=ViewPred{1,indexview}(class,indextarget)/ViewPred{2,indexview}(1,indextarget);
                    %   dist(1,indexview)+1;
                    %(1/(dist(1,indexview)+1))
                       m=m*Priority(indexview,1);%*WofClassifier{1,indexview};
                       if ViewPred{2,indexview}(1,indextarget)>0
                        weight(class,indextarget)=weight(class,indextarget)+m;
                       end
                      % t=0;
                       %t=input('hello','s')
                      
                       
                   end
                    
                    
                end
                
                
            end
            
            weight
            %voting nad final predication
           predVoted=zeros(Numtestintaget,1);
           for i=1:Numtestintaget
               weightmax=weight(1,i);
               indexmax=1;
               for class=2:nCls
                   if(weightmax<=weight(class,i))
                       weightmax=weight(class,i);
                       indexmax=class;
                   end
               end
               predVoted(i,1)=indexmax;
               
               
               
           end
           predVoted=predVoted-1;
           [predVoted,view{1,1}{1,5}(:,1)]
           %accuracy
           
           
           s=size(prediction{1,1},1);
        
                   
                     
           correct=0;
             for k=1:Numtestintaget
                   if view{1,1}{1,5}(k,1)==predVoted(k,1)
                        correct=correct+1;
                   end
            end
           
          correct1=correct/Numtestintaget;
          fprintf('\n corrcet classify test data in  view . size(accuracy)(numCorrect): %f(%f)(%f)\n',s,correct1,correct);
            
          
          
          %meta   %learner--------------------------------------------------- ------------------------------------------------------
          %test data for meta learner
            testmetalearner=ViewPred{1,1}';
            for i=2:NumView
                testmetalearner=[testmetalearner,ViewPred{1,i}'];
            end
            
            for i=1:size(prediction{1,1},1)
              testmetalearner(i, prediction{1,1}(i,1)+1)=1; 
            end
            
            
            testmetalearner=[testmetalearner,view{1,1}{1,5}];
            
            %testmetalearner
            
            %voting in train data for meta learner 
            
             %voting in multiple phase
            NumView=size(view,2)
            
            nCls = length(unique(view{1,1}{1,4}))  
            Numtraintintarget=size(view{1,1}{1,2},1)
            
            
            for indextarget=1:Numtraintintarget
                for indexview=1:NumView
                    for classindex=1:nCls
                        ViewPred1{1,indexview}(classindex,indextarget)=0;
                        ViewPred1{2,indexview}(1,indextarget)=0;
                        
                        
                        
                    end
                end
            end
            
            
                
            for indextarget=1:Numtraintintarget
                
                for indexview=2:NumView
                    
                    numatt=size(train_matview{1,1},2)-1;%index of target id in target tabel, -1 chon label ham dar dade ha hast
                    numattnontar=size(train_matview{1,indexview},2)-1;%index of id of non target tuple
                    
                    idtar=train_matview{1,1}(indextarget,numatt);
                    train_matview{1,indexview}(:,numattnontar);
                    
                    
                    
                    nontargetindex=find(train_matview{1,indexview}(:,numattnontar)==idtar);
                   % size(nontargetindex)
                                                              
                    classindex=predictionlabel{1,indexview}(nontargetindex(:,:),1)+1;
                    for k=1:size(classindex,1)
                    
                        ViewPred1{1,indexview}(classindex(k,1),indextarget)= ViewPred1{1,indexview}(classindex(k,1),indextarget)+1;
                        ViewPred1{2,indexview}(1,indextarget)=ViewPred1{2,indexview}(1,indextarget)+1;

                    end
                   
                        
                        
                    
                end
                
            end
            
            
            trainmetalearner=ViewPred1{1,1}';
            for i=2:NumView
                trainmetalearner=[trainmetalearner,ViewPred1{1,i}'];
            end
            
            for i=1:size(predictionlabel{1,1},1)
              trainmetalearner(i, predictionlabel{1,1}(i,1)+1)=1; 
            end
            
            trainmetalearner=[trainmetalearner,view{1,1}{1,4}];
            trainmetalearner
          %  trainmetalearner
            
            
            
                    R1=trainmetalearner;
                   save ('E:/train.txt','R1','-ASCII');

                   R2=testmetalearner;
                   save ('E:/test.txt','R2','-ASCII');

                  
                  
                   tablename1 = 'E:/train.txt';
                   tablename2 = 'E:/test.txt';
                   
                   loader = weka.core.converters.MatlabLoader();
                   loader.setFile( java.io.File(tablename1) );
                   train_datameta = loader.getDataSet();            
                   train_datameta.setClassIndex( train_datameta.numAttributes()-1 );


                   loader = weka.core.converters.MatlabLoader();
                   loader.setFile( java.io.File(tablename2) );
                   test_datameta = loader.getDataSet();
                   test_datameta.setClassIndex( test_datameta.numAttributes()-1 );
            
            
             [c,pred1,pred2,acctraintdata] = Ensemble_Classifier2(train_datameta,test_datameta,test_datameta);
            
             [pred1,view{1,1}{1,5}(:,1)]
            correct=0;
              for k=1:Numtestintaget
                   if view{1,1}{1,5}(k,1)==pred1(k,1)
                        correct=correct+1;
                   end
              end
           
          correct2=correct/Numtestintaget;
          fprintf('\n corrcet classify test data in  view by using meta learner . size(accuracy)(numCorrect): %f(%f)(%f)\n',s,correct2,correct);
            
            
            
            

end

