clc;
clear all;

WEKA_HOME = 'E:\Arshad\Impelemention\weka-3-7-7\weka-3-7-7';
javaaddpath([WEKA_HOME '\weka.jar']);

% create SRG graph
%%
cm = [0,1,0,0,0,0,0;0,0,1,1,1,1,0;0,0,0,0,0,0,0;0,0,0,0,0,0,0;0,0,0,0,0,0,1;0,0,0,0,0,0,1;0,0,0,0,0,0,0];
%cm=cm+cm';


ids = {'loan','account','order','transaction','disp','district','client'};
SRG1 = biograph(cm,ids);
get(SRG1.nodes,'ID')
%view(SRG1)
allshortestpaths(SRG1)

%%
% load data from file

%load table loan
fName='E:/Arshad/Impelemention/DataFile-view/loan.arff';
loan_view= view_table(fName,'loan',1);


%load table account
fName1='E:/Arshad/Impelemention/DataFile-view/account.arff';
account_view= view_table(fName1,'account',2);

%load table client
fName1='E:/Arshad/Impelemention/DataFile-view/client.arff';
client_view= view_table(fName1,'client',7);

%load table disp
fName1='E:/Arshad/Impelemention/DataFile-view/disp.arff';
disp_view= view_table(fName1,'disp',5);

%load table district
fName1='E:/Arshad/Impelemention/DataFile-view/district.arff';

district_view= view_table(fName1,'district',6);
%for missing value

%{
x=district_view.train_data.numInstances()-1;

for i=0:x
        if(district_view.train_data.instance(i).hasMissingValue())   
           district_view.train_data.instance(i)
       district_view.train_data.delete(i);
       x=x-1;
        end
             
               if i>=x
                   break;
               end
end
x=district_view.test_data.numInstances()-1;
for i=0:x
        if(district_view.test_data.instance(i).hasMissingValue())        
       district_view.test_data.delete(i);
       x=x-1;
        end
        
        if i>=x             
            break;              
        end
end
%}
%district_view.train_data
    
%load table order
fName1='E:/Arshad/Impelemention/DataFile-view/order.arff';
order_view= view_table(fName1,'order',3);

%load table trans
fName1='E:/Arshad/Impelemention/DataFile-view/trans.txt';
trans_view= view_table(fName1,'trans',4);

%load table card
%fName1='E:/Arshad/Impelemention/DataFile-view/card.arff';
%card_view= view_table(fName1,'card');


%loan_view.createClassifier(loan_view.train_data,loan_view.test_data);
%{

account_view.createClassifier();
client_view.createClassifier();
disp_view.createClassifier();
district_view.createClassifier();
order_view.createClassifier();

%card_view.createClassifier();
%loan_view.train_data
%trans_view.train_data
%account_view.train_data
%client_view.train_data
%disp_view.train_data
%district_view.train_data
%order_view.train_data
%trans_view.train_data
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



%Classifier_HierarchicalBCorr(view,SRG1);
Classifier_HierarchicalBCorr_MultiRCE(view,SRG1);


%{
%Semi_loan_account_view=view_Semicorrelatedtable(loan_view.train_data,account_view.train_data,loan_view.test_data,account_view.test_data,'Semi_loan_account');
%Semi_loan_account_view.createClassifier();

Semi_loan_account_view=view_Semicorrelatedtable(loan_view.train_data,account_view.train_data,loan_view.test_data,account_view.test_data,'Semi_loan_account');
view1=Semi_loan_account_view.View;

Semi_loan_client_view=view_Semicorrelatedtable(loan_view.train_data,client_view.train_data,loan_view.test_data,client_view.test_data,'Semi_loan_client');
view2=Semi_loan_client_view.View;
%}

%{
Semi_account_client_view=view_Semicorrelatedtable(account_view.train_data,client_view.train_data,account_view.test_data,client_view.test_data,'Semi_clinet_account');
Semi_disp_client_view=view_Semicorrelatedtable(disp_view.train_data,client_view.train_data,disp_view.test_data,client_view.test_data,'Semi_clinet_disp');
Semi_district_client_view=view_Semicorrelatedtable(district_view.train_data,client_view.train_data,district_view.test_data,client_view.test_data,'Semi_clinet_district');


Semi_loan_disp_view=view_Semicorrelatedtable(loan_view.train_data,disp_view.train_data,loan_view.test_data,disp_view.test_data,'Semi_loan_disp');
Semi_account_disp_view=view_Semicorrelatedtable(account_view.train_data,disp_view.train_data,account_view.test_data,disp_view.test_data,'Semi_account_disp');


Semi_loan_district_view=view_Semicorrelatedtable(loan_view.train_data,district_view.train_data,loan_view.test_data,district_view.test_data,'Semi_loan_district');
Semi_account_district_view=view_Semicorrelatedtable(account_view.train_data,district_view.train_data,account_view.test_data,district_view.test_data,'Semi_account_district');


Semi_loan_order_view=view_Semicorrelatedtable(loan_view.train_data,order_view.train_data,loan_view.test_data,order_view.test_data,'Semi_loan_order');
Semi_account_order_view=view_Semicorrelatedtable(account_view.train_data,order_view.train_data,account_view.test_data,order_view.test_data,'Semi_account_order');
%}


% view that in SRG is not in order based on SRG and accuracy is bad
%Semi_disp_order_view=view_Semicorrelatedtable(disp_view.train_data,order_view.train_data,disp_view.test_data,order_view.test_data,'Semi_disp_order');
%Semi_district_order_view=view_Semicorrelatedtable(district_view.train_data,order_view.train_data,district_view.test_data,order_view.test_data,'Semi_district_order');
%Semi_district_disp_view=view_Semicorrelatedtable(district_view.train_data,disp_view.train_data,district_view.test_data,disp_view.test_data,'Semi_district_disp');


%Semi_loan_card_view=view_Semicorrelatedtable(loan_view.train_data,card_view.train_data,loan_view.test_data,card_view.test_data,'Semi_loan_card');


%{
Semi_loan_client_view=view_Semicorrelatedtable(loan_view.train_data,client_view.train_data,loan_view.test_data,client_view.test_data,'Semi_loan_client');
Semi_loan_client_view.createClassifier();

Semi_loan_disp_view=view_Semicorrelatedtable(loan_view.train_data,disp_view.train_data,loan_view.test_data,disp_view.test_data,'Semi_loan_disp');
Semi_loan_disp_view.createClassifier();

Semi_account_disp_view=view_Semicorrelatedtable(account_view.train_data,disp_view.train_data,account_view.test_data,disp_view.test_data,'Semi_account_disp');
Semi_account_disp_view.createClassifier();


Semi_account_district_view=view_Semicorrelatedtable(account_view.train_data,district_view.train_data,account_view.test_data,district_view.test_data,'Semi_account_district');
Semi_account_district_view.createClassifier();


Semi_loan_order_view=view_Semicorrelatedtable(order_view.train_data,loan_view.train_data,order_view.test_data,loan_view.test_data,'Semi_loan_order');
Semi_loan_order_view.createClassifier();

Semi_account_order_view=view_Semicorrelatedtable(order_view.train_data,account_view.train_data,order_view.test_data,account_view.test_data,'Semi_account_order');
Semi_account_order_view.createClassifier();

%}

%%
%correlated table

%{
%loan_account_view=view_correlatedtable(loan_view.train_data,account_view.train_data,loan_view.test_data,account_view.test_data,'loan_account');
%loan_account_view.createClassifier();


%loan_district_view=view_correlatedtable(loan_view.train_data,district_view.train_data,loan_view.test_data,district_view.test_data,'loan_district');
%loan_district_view.createClassifier();

loan_client_view=view_correlatedtable(loan_view.train_data,client_view.train_data,loan_view.test_data,client_view.test_data,'loan_client');
loan_client_view.createClassifier();

loan_disp_view=view_correlatedtable(loan_view.train_data,disp_view.train_data,loan_view.test_data,disp_view.test_data,'loan_disp');
loan_disp_view.createClassifier();

account_disp_view=view_correlatedtable(account_view.train_data,disp_view.train_data,account_view.test_data,disp_view.test_data,'account_disp');
account_disp_view.createClassifier();


account_district_view=view_correlatedtable(account_view.train_data,district_view.train_data,account_view.test_data,district_view.test_data,'account_district');
account_district_view.createClassifier();


loan_order_view=view_correlatedtable(order_view.train_data,loan_view.train_data,order_view.test_data,loan_view.test_data,'loan_order');
loan_order_view.createClassifier();

account_order_view=view_correlatedtable(order_view.train_data,account_view.train_data,order_view.test_data,account_view.test_data,'account_order');
account_order_view.createClassifier();



%loan_account_order_view=view_correlatedtable(account_order_view.train_data,loan_view.train_data,account_order_view.test_data,loan_view.test_data,'account_order');
%loan_account_order_view.train_data
%loan_account_order_view.createClassifier();

%loan_card_view=view_correlatedtable(loan_view.train_data,card_view.train_data,loan_view.test_data,card_view.test_data,'loan_card');
%loan_card_view.createClassifier();


%loan_trans_view=view_correlatedtable(loan_view.train_data,trans_view.train_data,loan_view.test_data,trans_view.test_data,'loan_trans');
%loan_trans_view.createClassifier();
%}