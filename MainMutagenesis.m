clc;
clear all;

WEKA_HOME = 'E:\Arshad\Impelemention\weka-3-7-7\weka-3-7-7';
javaaddpath([WEKA_HOME '\weka.jar']);

% create SRG graph
%%
cm = [0,1,1;0,0,1;0,1,0];
%cm=cm+cm';


ids = {'mol','atom','bond'};
SRG1 = biograph(cm,ids);
get(SRG1.nodes,'ID')
%view(SRG1)
allshortestpaths(SRG1)



%%
%{
fName='E:/Arshad/Impelemention/DataMutagenesis-view/molBk2.arff';

        Data= loadARFF(fName);
        
      
       train_data_cv=Data;
       train_data_cv.setClassIndex(train_data_cv.numAttributes()-1 );

           %create label and unlabel data in this view and label of them
                   
           
             Data.numInstances()
             Data.numAttributes()                     
             numInst1 = train_data_cv.numInstances()
             numAtt1 = train_data_cv.numAttributes()             
             
             
             train_mat1=zeros(numAtt1,numInst1);
            
              h1=numAtt1-2;  
               if  h1==0
                   h1=1;
               end
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
             Bk2Data=x';
           
            label=label';
 %----------------------------------------------------------------------------------------------
 
 fName='E:/Arshad/Impelemention/DataMutagenesis-view/molBk1.arff';

        Data= loadARFF(fName);
        
      
       train_data_cv=Data;
       train_data_cv.setClassIndex(train_data_cv.numAttributes()-1 );

           %create label and unlabel data in this view and label of them
                   
           
             Data.numInstances()
             Data.numAttributes()                     
             numInst1 = train_data_cv.numInstances()
             numAtt1 = train_data_cv.numAttributes()             
             
             
             train_mat1=zeros(numAtt1,numInst1);
            
              h1=numAtt1-2;  
               if  h1==0
                   h1=1;
               end
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
             Bk1Data=x';
           
            label=label';
            ID=ID';
            
           DataBk2final=cat(2,Bk1Data,Bk2Data);
           
           DataBk2final=cat(2,DataBk2final,ID);
           DataBk2final=cat(2,DataBk2final,label);
           
           
           R1=DataBk2final;
           
                   save ('E:/DataBk2final.txt','R1','-ASCII');
                   
                   
                   loader = weka.core.converters.MatlabLoader();
                   loader.setFile( java.io.File('E:/DataBk2final.txt') );
                   data1 = loader.getDataSet();
                 save ('E:/DataBk2final.ARFF','R1'); 
                  Data= loadARFF('E:/DataBk2final.ARFF');
                  
                  
                  
                  
          %-------------------Bk2 :ghablan BK2 eshtbah kardam be hamin
          %dalil in ja an ra misazam
          
          
     %}     
                   
           
           
%%
% load data from file

%load table mol
fName='E:/Arshad/Impelemention/DataMutagenesis-view/molBK2.arff';
mol_view= view_table(fName,'mol',1);


%load table atom
fName1='E:/Arshad/Impelemention/DataMutagenesis-view/atom.arff';
atom_view= view_table(fName1,'atom',2);

%load table bond
fName1='E:/Arshad/Impelemention/DataMutagenesis-view/bond.arff';
bond_view= view_table(fName1,'bond',3);



%% Semi correlated table
% view consist data and label in data  and train data and test data in each
% view
view{1}=mol_view.View;
view{2}=atom_view.View;
view{3}=bond_view.View;

                              fss=2;
                              t=5;
     
                              
 %BK2
 dim(1,1)=10;
 dim(1,2)=3;%
 dim(1,3)=4;%code=4
 dim(1,4)=3;%code=3

                              

% dim=3;
Classifier_HierarchicalBCorr_Muta_MultiRCE(view,SRG1,fss,t,dim);



