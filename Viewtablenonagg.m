function View =Viewtablenonagg( tablename1,name,code,targetview )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
 % loan train table
            tablename=name;
            disp('\n ----------------------------------');
            disp(name);
            numberofFolds=10;

            Data= loadARFF(tablename1);


           train_data_cv=Data;
           train_data_cv.setClassIndex(train_data_cv.numAttributes()-1 );


             Data.numInstances()
             Data.numAttributes()

                 numInst1 = train_data_cv.numInstances()
                 numAtt1 = train_data_cv.numAttributes()             


                 train_mat1=zeros(numAtt1,numInst1);
                  h1=numAtt1-1;
%{
                  h1=numAtt1-2;  
                   if  h1==0
                       h1=1;
                   end
                 %}
             x=zeros(h1,numInst1);
             %convert instaces data to matrix data             
             for j=0:numInst1-1
                                 
                 
                         train_mat1(:,j+1)=train_data_cv.instance(j).toDoubleArray();
                        
                         
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
            
           
              %for financial database 
            la=find(label==2);
             
            label(la(:,1),:)=0;
                     
           
            
            la=find(label==3);
             
            label(la(:,1),:)=1;
           
          
            
            
            
            
            train_data=x;
            labeldata=label;
            c=1;
            disp('target table num attribute');
            
            indexid=size(targetview{2},2)
            
            
            
            numinstance=size(x,1)
            size(targetview{2},1)
            size(targetview{3},1)
            
            c=0;
            d=0;
            for i =1 :numinstance
                flag=0;
                %search in train data of target table
                
                for j=1 :size(targetview{2},1)
                    if targetview{2}(j,indexid)==x(i,size(x,2))%moghayeseye target table id ba id of target table in nontarget table
                          % disp('yaftam');
                         
                           flag=1;
                           c=c+1;
                            x1(c,:)=x(i,:);
                            label1(c,1)=label(i,1);
                      
                           
                    end
                end
                 %search in test data of target table
                if flag==0
                    for j=1 :size(targetview{3},1)
                        if targetview{3}(j,indexid)==x(i,size(x,2))
                           %  disp('yaftam in test data');
                             d=d+1;
                              x2(d,:)=x(i,:);
                              label2(d,1)=label(i,1);
                             
                             
                        end

                    end
                end
                
                 
                
            end
            c
            d
           size(x1)
           size(x2)
           size(label1)
           size(label2)
            %supervised learning ten fold cross validation
            View{1}=name;
            View{2}=x1;
            View{3}=x2;
            View{4}=label1;
            View{5}=label2;
            View{6}=x2;
            View{7}=label2;
            View{8}=code;
            
              nCls = length(unique(label1));  
             k=size(x1,1);
             fprintf('\n distributed label in test data: %f(%f)\n',k,nCls);
             for j=0:nCls-1 % our label begin from 0    
	            nj = sum(label1==j); 
                fprintf('\n size of lable: %f(%f)\n',j,nj);
             end
            %______________________________________________________
                        
              %___________________________________________________
             nCls = length(unique(label2));  
             k=size(x2,1);
             fprintf('\n distributed label in label data: %f(%f)\n',k,nCls);
             for j=0:nCls-1 % our label begin from 0    
	            nj = sum(label2==j); 
                fprintf('\n size of  label lable: %f(%f)\n',j,nj);
             end
            %______________________________________________________

end

