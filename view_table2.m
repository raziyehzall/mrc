classdef view_table2 
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
 
    properties
       tablename='';      
       train_data_cv;
       test_data_cv;
       train_data;
       test_data;
       train_mat;
       test_mat;
      meowCount = 0; 

      numberofFolds;
      Data;
      View;
        
    end
  
    methods
        %%...............................................................................
        %%
     
        %load test and train data
        function c=view_table2(tablename1,name,code)
            % loan train table
            c.tablename=name;
            disp('\n ----------------------------------');
            disp(name);
            c.numberofFolds=10;

            c.Data= loadARFF(tablename1);


           c.train_data_cv=c.Data;
           c.train_data_cv.setClassIndex(c.train_data_cv.numAttributes()-1 );


             c.Data.numInstances()
             c.Data.numAttributes()

                 numInst1 = c.train_data_cv.numInstances()
                 numAtt1 = c.train_data_cv.numAttributes()             


                 train_mat1=zeros(numAtt1,numInst1);
                  h1=numAtt1-1;
%{
ignore id of target table
                  h1=numAtt1-2;  
                   if  h1==0
                       h1=1;
                   end
                 %}
             x=zeros(h1,numInst1);
             %convert instaces data to matrix data             
             for j=0:numInst1-1
                                    
                         train_mat1(:,j+1)=c.train_data_cv.instance(j).toDoubleArray();
                         
             end 
             
             % for RCE reorder according to ID
                                  
            
             label=zeros(1,numInst1);
             ID=zeros(1,numInst1);
             
             
             for j=1:numInst1
               
                     x(:,j)=train_mat1(1:h1,j);
                     label(1,j)=train_mat1(numAtt1,j);
                     ID(1,j)=train_mat1(numAtt1-1,j);
                     
                                                  
             end
            
             
            x=x';
           
            label=label';
            
            size(x)
            size(label)
            
            train_data=x;
            labeldata=label;
            
          % end
           disp('-------------------size of train data----');
          size(train_data,1)
            
            t=9;
            m=floor(numInst1/(t+1))+1
             
            fprintf('\n size of traindata and labeled data: %f(%f)\n', numInst1, m);
            %{
             la=find(label==2);
             
            label(la(:,1),:)=[];
            x(la(:,1),:)=[];
          
           la=find(label==3);
             
            label(la(:,1),:)=[];
            x(la(:,1),:)=[];
            
            %}
           
              %for financial database 
            la=find(label==2);
             
            label(la(:,1),:)=0;
                     
           
            
            la=find(label==3);
             
            label(la(:,1),:)=1;
           
          
            class0=find(label==0);
             class0=class0(1:324,1);
           
            c0=size(class0,1)
            
            if code==1
                randnum1=randperm(c0)';
              % randnum1=load('E:/RandomnumSupervised1.txt');
                srand1=size(randnum1)
               save ('E:/RandomnumSupervised1.txt','randnum1','-ASCII');

            else
                randnum1=load('E:/RandomnumSupervised1.txt');
            end
             
            
            k=1;
            m=floor(c0/10)
            
            
            label0=label(class0(randnum1(1:floor(c0/10),1),1),1);
            label(class0(randnum1(1:floor(c0/10),1),1),1)=label(class0(randnum1(k*m+1:(k+1)*m,1),1),1);
            label(class0(randnum1(k*m+1:(k+1)*m,1),1),1)=label0;
            
            x00=x(class0(randnum1(1:floor(c0/10),1),1),1);
            x(class0(randnum1(1:floor(c0/10),1),1),1)=x(class0(randnum1(k*m+1:(k+1)*m,1),1),1);
            x(class0(randnum1(k*m+1:(k+1)*m,1),1),1)=x00;
            
            
         
            t=1;
            label1=label(class0(randnum1(1:floor(c0/10),1),1),1);
            x1=x(class0(randnum1(1:floor(c0/10),1),1),:);
            
            label2=label(class0(randnum1(floor(c0/10)+1:size(randnum1,1)),1),1);
            x2=x(class0(randnum1(floor(c0/10)+1:size(randnum1,1),1),1),:);
            
            
            sx1=size(x1)
            sx2=size(x2)
           
            
            
            class1=find(label==1);           
            c1=size(class1,1)
            
            
            if code==1
                randnum2=randperm(c1)';
              %randnum2=load('E:/RandomnumSupervised2.txt');
                srand2=size(randnum2)
               save ('E:/RandomnumSupervised2.txt','randnum2','-ASCII');

            else
                randnum2=load('E:/RandomnumSupervised2.txt');
            end
                
            
            m=floor(c1/10)
            
            
            
            label01=label(class1(randnum2(1:floor(c1/10),1),1),1);
            label(class1(randnum2(1:floor(c1/10),1),1),1)=label(class1(randnum2(k*m+1:(k+1)*m,1),1),1);
            label(class1(randnum2(k*m+1:(k+1)*m,1),1),1)=label01;
            
            x01=x(class1(randnum2(1:floor(c1/10),1),1),1);
            x(class1(randnum2(1:floor(c1/10),1),1),1)=x(class1(randnum2(k*m+1:(k+1)*m,1),1),1);
            x(class1(randnum2(k*m+1:(k+1)*m,1),1),1)=x01;
            
            
            
            
            label11=label(class1(randnum2(1:floor(c1/10)+t,1),1),1);
            x11=x(class1(randnum2(1:floor(c1/10)+t,1),1),:);
            
            label12=label(class1(randnum2(floor(c1/10)+1+t:size(randnum2,1)),1),1);
            x12=x(class1(randnum2(floor(c1/10)+1+t:size(randnum2,1),1),1),:);
            
            label1=cat(1,label1,label11);
            label2=cat(1,label2,label12);
            
            x1=cat(1,x1,x11);
            x2=cat(1,x2,x12);
           
            %{
             la=find(label2==1);
             
            label2(la(:,1),:)=[];
            x2(la(:,1),:)=[];
          
           la=find(label1==1);
             
            label1(la(:,1),:)=[];
            x1(la(:,1),:)=[];
            
            la=find(label2==3);
             
            label2(la(:,1),:)=[];
            x2(la(:,1),:)=[];
          
           la=find(label1==3);
             
            label1(la(:,1),:)=[];
            x1(la(:,1),:)=[];
            
            la=find(label2==2);
             
            label2(la(:,1),:)= label2(la(:,1),:)-1;
            
            la=find(label1==2);
             
            label1(la(:,1),:)= label1(la(:,1),:)-1;
%}
           
          
           
            
            %{
             la=find(label2==0);
             
             
            label2(la(1:244,1),:)=[];
            x2(la(1:244,1),:)=[];
          
            
            
             la=find(label1==0);
             
            label1(la(1:20,1),:)=[];
            x1(la(1:20,1),:)=[];
           
          %}
            
            
             size(x2)
             size(label2)
             size(x1)
             size(label1)
             %___________________________________________________
             nCls = length(unique(label1));  
             k=size(x1,1);
             fprintf('\n distributed label in train data: %f(%f)\n',k,nCls);
             for j=0:nCls-1 % our label begin from 0    
	            nj = sum(label1==j); 
                fprintf('\n size of lable: %f(%f)\n',j,nj);
             end
            %______________________________________________________
                        
              %___________________________________________________
             nCls = length(unique(label2));  
             k=size(x2,1);
             fprintf('\n distributed label in unlabel data: %f(%f)\n',k,nCls);
             for j=0:nCls-1 % our label begin from 0    
	            nj = sum(label2==j); 
                fprintf('\n size of un label lable: %f(%f)\n',j,nj);
             end
            %______________________________________________________
            
          
            %{
            c.View{1}=name;
            c.View{2}=x1;
            c.View{3}=x2;
            c.View{4}=label1;
            c.View{5}=label2;
            c.View{6}=x2;
            c.View{7}=label2;
            c.View{8}=code;
            %}
            %supervised learning ten fold cross validation
            c.View{1}=name;
            c.View{2}=x2;
            c.View{3}=x1;
            c.View{4}=label2;
            c.View{5}=label1;
            c.View{6}=x2;
            c.View{7}=label2;
            c.View{8}=code;
            
           
            %{
            %supervised learning for multi DCCA-financial supervised
            c.View{1}=name;
            c.View{2}=x2;
            c.View{3}=x1;
            c.View{4}=label2;
            c.View{5}=label1;
            c.View{6}=x1;
            c.View{7}=label1;
            c.View{8}=code;
            %}
            
        end
        %-----------------------------------
              function [tr,te,labelTr,labelTe]= ConvertInstanceToDoubleArray(obj)
                 numInst = obj.train_data.numInstances();
                 numAtt = obj.train_data.numAttributes()-1;
                obj.train_mat=zeros(numAtt,numInst);
            
            
                for i=1:numInst-1
                                    obj. train_mat(:,i)=obj.train_data.instance(i).toDoubleArray();
                 
                end
                    
                 tr=obj.train_mat;
                 %%test data
                  numInstT = obj.test_data.numInstances();
                 numAttT = obj.test_data.numAttributes()-1;
                obj.test_mat=zeros(numAttT,numInstT);
              
                for i=1:numInstT-1
                                    obj. test_mat(:,i)=obj.test_data.instance(i).toDoubleArray();
                 
                end
                    
                 te=obj.test_mat;
                labelTr=obj.train_data.classAttribute();
                labelTe=obj.test_data.classAttribute();
                
        end
       %-------------------------------------------------------------------------
        function  accuracy= createClassifier(traindata,testdata)

         classifier = weka.classifiers.trees.J48();
       
        classifier.setOptions( weka.core.Utils.splitOptions('-c last -C 0.25 -M 2') );
        
        %-----------------------------------------
         %# convert last attribute (class) from numeric to nominal-train
        filter = weka.filters.unsupervised.attribute.NumericToNominal();
        filter.setOptions( weka.core.Utils.splitOptions('-R last') );
        filter.setInputFormat(traindata);   
        traindata = filter.useFilter(traindata, filter);
        
          
        filter.setInputFormat(testdata);   
        testdata = filter.useFilter(testdata, filter);
        %-------------------------------------------------------
        
        classifier.buildClassifier( traindata );
        %# classify test instances
        numInst =testdata.numInstances();
        pred = zeros(numInst,1);
        predProbs = zeros(numInst,testdata.numClasses());
        for i=1:numInst
             pred(i) = classifier.classifyInstance( testdata.instance(i-1) );
             predProbs(i,:) = classifier.distributionForInstance( testdata.instance(i-1) );
        end
       
        eval = weka.classifiers.Evaluation(traindata);

        eval.evaluateModel(classifier, testdata, javaArray('java.lang.Object',1));
    
        accuracy=evla.correct();
        fprintf('=== Summary ===\n')
        disp(obj.tablename)
        disp( char(eval.toSummaryString()) )
        disp( char(eval.toClassDetailsString()) )
        disp( char(eval.toMatrixString()) )


        
        end
    end
    
end

