function [classifier,pred1,pred2,acctest] = Ensemble_Classifier(train_data,test_data1,test_data2)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
   %create classfier
   classifier = weka.classifiers.trees.J48();
        
        
         
  %classifier= weka.classifiers.bayes.NaiveBayes();
        %   classifier.setOptions( weka.core.Utils.splitOptions('-c last -C 0.25 -M 2') );
             % %# convert last attribute (class) from numeric to nominal-train
 % classifier = weka.classifiers.lazy.IBk();
          
%classifier = weka.classifiers.meta.AdaBoostM1();
% classifier = weka.classifiers.meta.Bagging();
 %   classifier.setOptions(weka.core.Utils.splitOptions( '-I 15 -W "weka.classifiers.bayes.NaiveBayes" '));
          
          
              %classifier.setOptions(weka.core.Utils.splitOptions( '-K 5 -W 0 -A "weka.core.neighboursearch.LinearNNSearch -A \"weka.core.EuclideanDistance  -R first-last\"" ') );
           %  classifier.setKNN(1);
              filter = weka.filters.unsupervised.attribute.NumericToNominal();
              filter.setOptions( weka.core.Utils.splitOptions('-R last') );
              filter.setInputFormat(train_data); 
              train_data = filter.useFilter(train_data, filter);

              %# convert last attribute (class) from numeric to nominal-test       
              filter.setInputFormat(test_data1);   
              test_data1 = filter.useFilter(test_data1, filter);
              
              filter.setInputFormat(test_data2);   
              test_data2 = filter.useFilter(test_data2, filter);

              classifier.buildClassifier( train_data );
                
                     
          
              if (~train_data.equalHeaders(test_data1))
                disp('header of train and test not equal');
                
              end
           
             numInst = test_data1.numInstances();
             pred1 = zeros(numInst,1);
             predProbs = zeros(numInst,test_data1.numClasses());
             for i=1:numInst
             
              pred1(i) = classifier.classifyInstance( test_data1.instance(i-1) );             
%              predProbs(i,:) = classifier.distributionForInstance( test_data1.instance(i-1) );
             
             end
             
             numInst = test_data2.numInstances();
              pred2 = zeros(numInst,1);
              
             if(numInst >0)
                 predProbs = zeros(numInst,test_data2.numClasses());
                 for i=1:numInst

                  pred2(i) = classifier.classifyInstance( test_data2.instance(i-1) );             
                %  predProbs(i,:) = classifier.distributionForInstance( test_data2.instance(i-1) );

                 end
             end
             
         
              eval = weka.classifiers.Evaluation(train_data);
              
              eval.evaluateModel(classifier, train_data, javaArray('java.lang.Object',1));
              disp('accuracy of train');
             acctrain=eval.pctCorrect()
             

             eval.evaluateModel(classifier, test_data1, javaArray('java.lang.Object',1));
              disp('accuracy of test data');
             acctest=eval.pctCorrect()
             
             
             eval = weka.classifiers.Evaluation(train_data);

             eval.evaluateModel(classifier, test_data2, javaArray('java.lang.Object',1));
             % disp('accuracy');
             acctest2=eval.pctCorrect()
             
              %{
             fprintf('=== Summary ===\n')
          
            disp( char(eval.toSummaryString()) )
            disp( char(eval.toClassDetailsString()) )
            disp( char(eval.toMatrixString()) )
            %}
            %{
              eval = weka.classifiers.Evaluation(train_data);

             eval.evaluateModel(classifier, test_data1, javaArray('java.lang.Object',1));
       
             fprintf('=== Summary of unlabel data ===\n')
          
            disp( char(eval.toSummaryString()) )
            disp( char(eval.toClassDetailsString()) )
            disp( char(eval.toMatrixString()) )
         
               %}   
               

end

