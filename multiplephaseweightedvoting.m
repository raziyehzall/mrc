clc;
clear all;
WEKA_HOME = 'E:\Arshad\Impelemention\weka-3-7-7\weka-3-7-7';
javaaddpath([WEKA_HOME '\weka.jar']);


%A=laod('E:/A.txt');
% create SRG graph
%%
%cm = [0,1,0,0,0,0,0,0;0,0,1,1,1,0,0,1;0,0,0,0,0,0,0,0;0,0,0,0,0,1,1,0;0,0,0,0,0,1,0,0;0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0];
%cm=cm+cm';
cm = [0,1,0,0,0,0,0,0;0,0,1,1,1,1,0,0;0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0;0,0,0,0,0,0,1,1;0,0,0,0,0,0,1,0;0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0];

%ids = {'loan','account','order','disp','district','client','card','trans'};

ids = {'loan','account','order','transaction','disp','district','client','card'};
SRG1 = biograph(cm,ids);
get(SRG1.nodes,'ID')
%view(SRG1)
allshortestpaths(SRG1)

%%
% load data from file

%load table loan
fName='E:/Arshad/Impelemention/DataFile-viewnonagg/loan.arff';
%fName='E:/Arshad/Impelemention/DataFile-view/loan.arff';
for i=1:1
    
    
loan_view= view_table2(fName,'loan',1);

%% dar halate non agg bayad loan taghsim shavad bad baghiye jadavel bar asase an taghsim shavand chon aggregate anjam nadadim ke model 
%load table account


fName1='E:/Arshad/Impelemention/DataFile-viewnonagg/account.arff';
%fName1='E:/Arshad/Impelemention/DataFile-view/account.arff';

account_view= Viewtablenonagg(fName1,'account',2,loan_view.View);
%accountview= view_table2(fName1,'account',2);
%account_view=accountview.View;



%load table client
fName1='E:/Arshad/Impelemention/DataFile-viewnonagg/client.arff';
%fName1='E:/Arshad/Impelemention/DataFile-view/client.arff';
client_view= Viewtablenonagg(fName1,'client',7,loan_view.View);


%clinetview= view_table2(fName1,'client',7);
%client_view=clinetview.View;



%load table disp
fName1='E:/Arshad/Impelemention/DataFile-viewnonagg/disp.arff';
%fName1='E:/Arshad/Impelemention/DataFile-view/disp.arff';
disp_view= Viewtablenonagg(fName1,'disp',5,loan_view.View);


%dispview= view_table2(fName1,'disp',5);
%disp_view=dispview.View;




%load table district
fName1='E:/Arshad/Impelemention/DataFile-viewnonagg/district.arff';
%fName1='E:/Arshad/Impelemention/DataFile-view/district.arff';
district_view= Viewtablenonagg(fName1,'district',6,loan_view.View);


%districtview= view_table2(fName1,'district',6);
%district_view=districtview.View;

    
%load table order
fName1='E:/Arshad/Impelemention/DataFile-viewnonagg/order.arff';
%fName1='E:/Arshad/Impelemention/DataFile-view/order.arff';
order_view= Viewtablenonagg(fName1,'order',3,loan_view.View);

%orderview= view_table2(fName1,'order',3);
%order_view=orderview.View;


%load table card
fName1='E:/Arshad/Impelemention/DataFile-viewnonagg/card.arff';
%fName1='E:/Arshad/Impelemention/DataFile-view/card.arff';
card_view= Viewtablenonagg(fName1,'card',8,loan_view.View);

%cardview= view_table2(fName1,'card',8);
%card_view=cardview.View;

%load table trans
fName1='E:/Arshad/Impelemention/DataFile-view/trans.txt';
%fName1='E:/Arshad/Impelemention/DataFile-view/trans.txt';
trans_view= Viewtablenonagg(fName1,'trans',4,loan_view.View);

view{1}=loan_view.View;


cols2remove=[1 2];
%cols2remove=[];

% ignore id of nontargettabeles in learning process
account_view{2}(:,cols2remove)=[];
account_view{3}(:,cols2remove)=[];

account_view{3}

view{2}=account_view;


cols2remove=[1 2];
%cols2remove=[];

order_view{2}(:,cols2remove)=[];
order_view{3}(:,cols2remove)=[];


view{3}=order_view;

view{4}=trans_view;

cols2remove=[1 2 3];
%cols2remove=[];

disp_view{2}(:,cols2remove)=[];
disp_view{3}(:,cols2remove)=[];


view{5}=disp_view;

cols2remove=[1];
%cols2remove=[];

district_view{2}(:,cols2remove)=[];
district_view{3}(:,cols2remove)=[];

view{6}=district_view;

cols2remove=[1 3];
%cols2remove=[];

client_view{2}(:,cols2remove)=[];
client_view{3}(:,cols2remove)=[];

view{7}=client_view;

cols2remove=[1 2];
%cols2remove=[];

card_view{2}(:,cols2remove)=[];
card_view{3}(:,cols2remove)=[];

%view{8}=card_view;

view{:}
extendedtablebaseonCCA( view,SRG1 )

%[c1,c2]=weightedvotingfinancial( view,SRG1 );

c11(1,i)=c1;
c22(1,i)=c2;

end
c11
c22


