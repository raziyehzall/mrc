function [ correct ] = extendedtablebaseonCCA( view,SRG1 )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here



dim(1,1)=5;%3
 dim(1,2)=5;%3
 dim(1,3)=5;%
 dim(1,4)=17;%20
 dim(1,5)=5;%5%
 dim(1,6)=12;%20
 dim(1,7)=5;
 dim(1,8)=10;%10
 
 
 
dim(1,1)=6;%3
 dim(1,2)=6;%3
 dim(1,3)=6;%
 dim(1,4)=17;%20
 dim(1,5)=6;%5%
 dim(1,6)=6;%20
 dim(1,7)=6;
 dim(1,8)=6;%10
 
 
 
 dim(1,1)=6;%3
 dim(1,2)=6;%3
 dim(1,3)=6;%
 dim(1,4)=17;%20
 dim(1,5)=6;%5%
 dim(1,6)=13%20
 dim(1,7)=6;
 dim(1,8)=6;%10
 
 %mutagenesis
%{
 dim(1,1)=3;%3
 dim(1,2)=3;%3
 dim(1,3)=3;%
 dim(1,4)=3;%20
 dim(1,5)=3;%5%
 dim(1,6)=3;%20
 dim(1,7)=3;
 dim(1,8)=3;%10
 %}
fss=1;


 disp('sizeview');
            sizeview=size(view,2)
        
            for NumView=1:sizeview %based on code of each view
                   disp('___________________________________________________');
                   disp(view{1,NumView}{1});
                   disp(view{1,NumView}{8});
                         
                   train_mat=cat(2,view{1,NumView}{2},view{1,NumView}{4});   
                   
                                              
                   test_mat=cat(2,view{1,NumView}{3},view{1,NumView}{5})   ;
                   labelunlabel=view{1,NumView}{5};
        
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
                   [Classifiers{1,NumView},pred1,pred2,acctest] = Ensemble_Classifier(train_data{1,NumView},test_data{1,NumView},train_data{1,NumView});
                   WofClassifier{1,NumView}=1;
                  % predictionUnlabel{1,NumView}(:,1)=pred1; %unlabel data
                  predictiontrain1{1,NumView}=pred2;%train data for keep target table prediction
                  
                   prediction{1,NumView}(:,1)=pred1; %test data
                   WofClassifier{1,NumView}=acctest;
                
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
            
            
            
            
           
            %%
            %voting in multiple phase
            NumView=size(view,2)
            
            nCls = length(unique(view{1,1}{1,4}))  
            Numtestintaget=size(view{1,1}{1,3},1)
            
            
          
            
                
            dist=allshortestpaths(SRG1)%find path between relations
            
            
            nview=1;
            p=prediction{1,1};
            we=WofClassifier{1,1};
            
            
            predictionoftargettest=prediction{1,1};
            clear prediction;
            clear WofClassifier;
            prediction{1,1}=p;
            predictiontrain{1,1}=predictiontrain1{1,1};
            WofClassifier{1,1}=we;
            nview=2;% for target table
            
            
            
            
          %  NumView=2;
            
   for indexview=2:NumView% for each view expect target table we extract correlation in path of it relation 
                    
                 
                 
                 indexview
                 view{1,indexview}{1}
                 view{1,indexview}{8}
                 
                 dist(dist(:,:)==Inf)=0
                 backindexarr=find(dist(:,indexview)>0)'% index of dist>0!!!!!!
                 %{
                 for  x1=1:7
                     backindexarr(1,x1)=x1;
                 end
                 %}

%backindexarr=zeros(1,1);
%backindexarr(1,1)=1;
                sizecon=size(backindexarr,2)
                      
                   
                          
               %sizecon=sizecon-1;
                
                 clear dataDCCA;
                 clear datatest;
                 clear labeloft;
                 %data for multi dcca so data train of relation in path can be send 
               for numofpathrelation=1:sizecon
                   backindexarr(1,numofpathrelation)
                   dataDCCA{1,numofpathrelation}=view{1,backindexarr(1,numofpathrelation)}{2};
                   datatest{1,numofpathrelation}=view{1,backindexarr(1,numofpathrelation)}{3};
                   labeloft{1,numofpathrelation}=view{1,backindexarr(1,numofpathrelation)}{4};%for train data
                   labeloft{2,numofpathrelation}=view{1,backindexarr(1,numofpathrelation)}{5};% for test data
                   
                   
               end
               
               numofpathrelation
               dataDCCA{1,numofpathrelation+1}=view{1,indexview}{2};%self view
               datatest{1,numofpathrelation+1}=view{1,indexview}{3};
               labeloft{1,numofpathrelation+1}=view{1,indexview}{4};%for train data
               labeloft{2,numofpathrelation+1}=view{1,indexview}{5};% for test data
               
               
               
               %fill A matrix for multi dcca based on relation between two
               %view
               
               for in=1:size(dataDCCA,2)%num view in path
                   for jn=1:size(dataDCCA,2)%num view in path
                             A{in,jn}=zeros(size(dataDCCA{1,in},1),size(dataDCCA{1,jn},1));
                   end
               end
               A
               
               for i1=1:size(dataDCCA,2)% -1 for change new one   %num view in path
                   for i2=1:size(dataDCCA,2)%num view in path
                   %i2=i1+1;
                       A1=zeros(size(dataDCCA{1,i1},1),size(dataDCCA{1,i2},1));
                       if i1 ~= i2
                           for k1=1:size(labeloft{1,i1},1)
                               for k2=1:size(labeloft{1,i2},1)
                                   if labeloft{1,i1}(k1,1)==labeloft{1,i2}(k2,1)
                                       A1(k1,k2)=1;

                                   end
                               end
                           end
                           % sumofsum=sum(sum(A1,2))
                           
                       end
                   
                  % i2=i1+1;%change new  1 check shavad
                      %A1=zeros(size(dataDCCA{1,i1},1),size(dataDCCA{1,i2},1));
                       if i1 ~= i2       
                           numatt1=size(dataDCCA{1,i1},2);%index of  id of relation 1
                           numatt2=size(dataDCCA{1,i2},2);%index of id of relation 2
                           
                           % for each tuple in first relation fill A
                            for i3=1:size(dataDCCA{1,i1},1)
                                   idtar=dataDCCA{1,i1}(i3,numatt1);

                                   nontargetindex=find(dataDCCA{1,i2}(:,numatt2)==idtar);
                                   
                                   
                                   size(nontargetindex,1);
                                   for i4=1:size(nontargetindex,1)
                                      A1(i3,nontargetindex(i4,1))=A1(i3,nontargetindex(i4,1))+10; 
                                   end
                                  % t=input('hello','s')
                            end
                            
                           % A1
                          % sumnum=sum(A1,1)
                            
                         %  sumnum=sum(A1,2)'
                        % disp('2:------------------------');
                         %  sumofsum=sum(sum(A1,2))
                       end
                       
                      %A1(:,:)=1;
                       A{i1,i2}=A1;
                      % A{i2,i1}=A1';% for inverted order of matrics, ;%for change new 1
                  end
                   
               end
                         
                    Similarity=A;
                    %clear A
                    dataDCCA
                    datatest
                    labeloft
                    
                    for i5=1:size(dataDCCA,2)
                        dataDCCA1{1,i5}=dataDCCA{1,i5}';
                    end
                    dataDCCA1
                    %-----------------------------------------------------
                    nCls = 2
                    nCls = length(unique(view{1,1}{1,4}))  
                    t=1
                    
                    %%A = [];
                    numview=size(dataDCCA,2)
                    for j=1:numview


                        for i=0:nCls-1
                            r=find(labeloft{1,j}(:,1)==i);%label for each view



                        nj=size(r,1) ; 

                            srt1 = round(rand(t*nj,1)*(nj^2)+0.5);
                            rdx1 = floor((srt1-1)/nj)+1;
                            rdx1;
                            rdx{j,i+1}=rdx1;


                        end
                    end
                    disp('similarity');
                    Similarity;
                    %{
                    for j=1:numview
                        for i=1:numview


                        A{i,j}=zeros(size(labeloft{1,i},1),size(labeloft{1,j},1));

                          if (i~=j)

                            for clas=0:nCls-1
                            r1=find(labeloft{1,i}(:,1)==clas);
                            r2=find(labeloft{1,j}(:,1)==clas);

                            
                            r1
                            r2
                            rdx
                                m=size(r,1);

                                for k=1:m
                                    
                                    r1(rdx{i,clas+1}(k)),r2(rdx{j,clas+1}(k))

                                     u= Similarity(r1(rdx{i,clas+1}(k)),r2(rdx{j,clas+1}(k)));



                                    A{i,j}(r1(rdx{i,clas+1}(k)),r1(rdx{j,clas+1}(k))) = A{i,j}(r2(rdx{i,clas+1}(k)),r2(rdx{j,clas+1}(k)))+ u;


                                end
                            end
                          end
                          A{i,j} = A{i,j}+A{i,j}';
                        end
%}
                     R1=A;

                          save ('E:/A.txt','R1','-ASCII');

                   
                    %-------------------------------------------------------
                    %W1 = Multi_DCCA_2( dataDCCA1,A,5)%dim(1,indexview)  
                   W1 = Multi_DCCA_2( dataDCCA1,A,dim(1,indexview))
                   %W1  =Multi_RCA(  dataDCCA1, label,sizetraindata,Similarity, t, dim)%  
                    %calculate 
                  



W1{:,:}
                   
                 for i=1:size(W1,2)
                    
                    
                       W{1,i}=W1{1,i}(1:size(dataDCCA{1,i},2),:);% for zero extention
                 end
                % W{:,:}
                 
                 
                 
                 
                 % train classifier based on this view
                 % ?? ??? ??? ???? ??? ??? ?? ??? ????? ?????? ?????? ????
                 % ??????  ?? ???? ???? ?? ?? ?????? ????? ????? ?????? 
                 clear U;
                 for numberview=1:size(dataDCCA,2);
                   
                              Wx=W{1,numberview};
                              U{numberview} = dataDCCA{1,numberview} * Wx;

                 end
                 
                 
                 fss=2;
                           t3 =U{1};
                           if fss==1
                               x=U{1};% this is target table and do not need to sum multiple instances
                               for numview1=2:size(dataDCCA,2)
                                     
                                   
                                   numatt1=size(dataDCCA{1,1},2);%index of  id of relation target, data without label
                                   numatt2=size(dataDCCA{1,numview1},2);%index of id of relation non target, data without label
                                   for i3=1:size(dataDCCA{1,1},1)% in combine for each tuple we find 
                                       idtar=dataDCCA{1,1}(i3,numatt1);%target table

                                       nontargetindex=find(dataDCCA{1,numview1}(:,numatt2)==idtar);
                                       
                                        clear u1;
                                        %u1=U{numview1}(nontargetindex(1,1),:);
                                        if size(nontargetindex,1)>0
                                           for i4=1:size(nontargetindex,1)
                                              x(i3,:)=x(i3,:)+U{numview1}(nontargetindex(i4,1),:);
                                           end
                                        end
                                   end
                                   
                                   size(x)
                                  % size(u1)
                                   %x=x+u1;
                                   
                                   
                               end
                                t3 =x ;
                           else
                               disp('fss is 2');
                                 x=U{1};% this is target table and do not need to sum multiple instances
                                 
                                 x2=zeros(size(dataDCCA{1,1},1),size(U{1},2));%add for version 2
                               for numview1=2:size(dataDCCA,2)
                                     
                                   
                                   numatt1=size(dataDCCA{1,1},2);%index of  id of relation target, data without label
                                   numatt2=size(dataDCCA{1,numview1},2);%index of id of relation non target, data without label
                                   
                                   x1=zeros(size(dataDCCA{1,1},1),size(U{1},2));
                                   
                                   for i3=1:size(dataDCCA{1,1},1)% in combine for each tuple we find 
                                       idtar=dataDCCA{1,1}(i3,numatt1);%target table

                                       nontargetindex=find(dataDCCA{1,numview1}(:,numatt2)==idtar);
                                       
                                        
                                        %u1=U{numview1}(nontargetindex(1,1),:);
                                        if size(nontargetindex,1)>0
                                          % z1=size(x1(i3,:))
                                           %z2=size(U{numview1})
                                           for i4=1:size(nontargetindex,1)
                                              x1(i3,:)=x1(i3,:)+U{numview1}(nontargetindex(i4,1),:);
                                           end
                                        end
                                        
                                        
                                   end
                                   
                                 % sx= size(x)
                                  
                                   sizex1=size(x1)
                                     
                                   
                                   x2=x2+x1;%add for version 2
                                 % x=[x,x1];
                                 sizex2=size(x2)
                                  sizex=size(x)
                                   clear x1; 
                                  % size(u1)
                                   %x=x+u1;
                                  
                                   
                               end
                               
                               x=[x,x2];
                                t3 =x ;
                           end
                           
                           
                           
                           finalsizex=size(x)
                    

                          train_mat=cat(2,t3,labeloft{1,1});
                          
                          %save train_mat
                          
                          sizetrainmat=size(train_mat)
                          size(t3)
                          
                          %-----------------------------------test data
                          clear U;
                          
                           for numberview=1:size(datatest,2)
                              Wx=W{1,numberview};
                              U{numberview} = datatest{1,numberview} * Wx;

                           end
                          t3 =U{1};
                           if fss==1
                               x=U{1};% this is target table and do not need to sum multiple instances
                               for numview1=2:size(datatest,2)
                                     
                                   
                                   numatt1=size(datatest{1,1},2);%index of  id of relation target, data without label
                                   numatt2=size(datatest{1,numview1},2);%index of id of relation non target, data without label
                                   
                                    
                                   for i3=1:size(datatest{1,1},1)% in combine for each tuple we find 
                                       idtar=datatest{1,1}(i3,numatt1);%target table

                                       nontargetindex=find(datatest{1,numview1}(:,numatt2)==idtar);
                                       
                                        clear u1;
                                        %u1=U{numview1}(nontargetindex(1,1),:);
                                        if size(nontargetindex,1)>0
                                           for i4=1:size(nontargetindex,1)
                                              x(i3,:)=x(i3,:)+U{numview1}(nontargetindex(i4,1),:);
                                           end
                                        end
                                   end
                                   
                                  sx= size(x)
                                  % size(u1)
                                   %x=x+u1;
                                   
                                   
                               end
                                t3 =x ;
                           else
                                  x=U{1};% this is target table and do not need to sum multiple instances
                                   x2=zeros(size(datatest{1,1},1),size(U{1},2));%add for version 2
                                   
                               for numview1=2:size(datatest,2)
                                     
                                   
                                   numatt1=size(datatest{1,1},2);%index of  id of relation target, data without label
                                   numatt2=size(datatest{1,numview1},2);%index of id of relation non target, data without label
                                    x1=zeros(size(datatest{1,1},1),size(U{numview1},2));
                                    
                                   for i3=1:size(datatest{1,1},1)% in combine for each tuple we find 
                                       idtar=datatest{1,1}(i3,numatt1);%target table

                                       nontargetindex=find(datatest{1,numview1}(:,numatt2)==idtar);
                                       
                                        
                                        %u1=U{numview1}(nontargetindex(1,1),:);
                                        if size(nontargetindex,1)>0
                                          
                                           for i4=1:size(nontargetindex,1)
                                              x1(i3,:)=x1(i3,:)+U{numview1}(nontargetindex(i4,1),:);
                                           end
                                        end
                                   end
                                   
                                  sx= size(x)
                                 sx= size(x)
                                 sx1= size(x1)
                                  sx2=size(x2)
                                  
                                  sizex1= size(x1)
                                  
                                      x2=x2+x1;
                                      
                                       % x=[x,x1];
                                      sizex= size(x)
                                   
                               end
                              x=[x,x2];
                                t3 =x ;
                           end

                          test_mat=cat(2,t3,labeloft{2,1});
                         
                          

                            %----------------------------
                            %--------------------------------covert to instances array
                          R1=train_mat;

                          save ('E:/train.txt','R1','-ASCII');

                       

                          R3=test_mat;

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
                           test_data1 = loader.getDataSet();            
                           test_data1.setClassIndex( test_data1.numAttributes()-1 );


                            fprintf('\n %f',i);
                           disp('traindata---------------------------------');
                           [Classifiers,pred1,pred2,acctest] = Ensemble_Classifier(train_data,test_data1,train_data);
                           predicationUnlabel(:,1)=pred1;                      
                           predictiontest(:,1)=pred1; %test data
                           
                           WofClassifier{1,nview}=acctest;
                           predictiontrain{1,nview}=pred2;
                          
                           prediction{1,nview}(:,1)=pred1; %test data
                          
                            nview=nview+1;
                            s=size(predictiontest,1);
                            labeltestdata=labeloft{2,1};%labeloft{1,1}
                             correct=0;
                             for k=1:s
                                 if predictiontest(k,1)==labeltestdata(k,1)
                                     correct=correct+1;
                                 end
                             end
                              nCls = length(unique(predictiontest)) 
                             
                              
                              
                             correct1=correct/s;
                            fprintf('\n corrcet classify test  data in view. size(accuracy)(numCorrect): %f(%f)(%f)\n',s,correct1,correct);

                
              
                            
                            clear dataDCCA1;
                            clear A;
                             clear W;
                              clear W1;
                            
             
   end
             
   
   prediction{1,1};
   
   %prediction{1,1}=predictionoftargettest(:,:);
   
   predictiontrain{1,1};
   
   numClassifier=size(prediction,2)
   %for i=1:numClassifier
    %   WofClassifier{1,i}=1;
   %end
  % nCls=length(unique(prediction{1,1}));
    nCls = length(unique(view{1,1}{1,4}))  
   con=0;
   for i=1:size(prediction{1,1},1)
                 
                  randomnum(i,1)=i;
   end
             
     % prediction{:,:}
     [index,index2,predvoting] = Voting_multipleClassifer( 1, numClassifier,nCls,prediction,randomnum,con, WofClassifier);
     
     predvoting
                   size(index)
                  size(prediction)
                  size(predvoting)
                  labelunlabel=view{1,1}{5}(:,:);
                  [predvoting(:,1),labelunlabel(:,1)];
                  accaddinunlabeladd=sum(predvoting(:,1)-labelunlabel(:,1)==0)/size(index,2);
                  accaddinunlabeladd
          
                  
                  
                  
       %-------------------------------------------------------------meta learner           
                  %use meta learner for voting
                  %train data for meta learner
                  size(predictiontrain{1,1},1)
                  size(predictiontrain,2)
                  ptrain1=zeros(size(predictiontrain{1,1},1),size(predictiontrain,2));
         
                  
                  size(ptrain1)
                  
        for i=1:size(predictiontrain,2)
            ptrain1(:,i)=predictiontrain{1,i}(:,1);
            
            
        end
       ptrain2= [ptrain1,labeloft{1,1}];
       
       ptrainsize=size(ptrain2)
       
       ptest1=zeros(size(prediction{1,1},1),size(prediction,2));
         
                  
                  
                  
        for i=1:size(prediction,2)
            ptest1(:,i)=prediction{1,i}(:,1);
            
            
        end
       ptest2= [ptest1,labeloft{2,1}];
        ptestsize=size(ptest2)
        ptrain2;
        ptest2;

        
        
        R1=ptrain2;

                          save ('E:/train.txt','R1','-ASCII');

                       

                          R3=ptest2;

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
                           test_data1 = loader.getDataSet();            
                           test_data1.setClassIndex( test_data1.numAttributes()-1 );
             
         [Classifiers,pred1,pred2,acctest] = Ensemble_Classifier2(train_data,test_data1,test_data1);     
              
              
         
          accaddinunlabeladd=sum(pred1(:,1)-labelunlabel(:,1)==0)/size(pred1,1);
                  accaddinunlabeladd
          
              
               
            
            
            
            
end

