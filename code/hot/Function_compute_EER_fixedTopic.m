function EERs  = Function_compute_EER_fixedTopic( Test,Train,Test_Label,Train_Label,no_repetitions,NumTopic)

H=[Train;Test];
no_topics=NumTopic;
hj_accn1 = bsxfun(@rdivide, H, eps+ mean(H,2));

train1= hj_accn1(1:size(Train_Label,1),:);
test1= hj_accn1(size(Train_Label,1)+1:end,:);

Accuracy = zeros(1,no_repetitions);
likelihoods = zeros(1,no_repetitions);
AucPlain = zeros(1,no_repetitions);
EERs = zeros(1,4);

close all
for rep=1:no_repetitions
    disp(['processing loop '  num2str(rep)])

    [wt,td,likelihoodTrain] = plsa(train1',no_topics,0.00001,0);
    likelihoods(rep) = sum( likelihoodTrain );
    
    [~,td,E] = plsa(test1',no_topics,0.00001,0,wt,0);

    
    [FPR, TPR, Thr, AUC, OPTROCPT] = perfcurve(Test_Label, E', 0);
    %         ROCOUT = roc([E',Test_Label]);
    % res(i) = AUC;
    AucPlain(rep) = AUC;
    
    diagx = 0:0.001:1;
    diagy = 1:-0.001:0;
    D = [diagx',diagy'];
    R = [FPR,TPR];
    
    distances = slmetric_pw(D', R', 'eucdist');
    [r,c] = ind2sub( size( distances), find( distances == min( distances(:)) ));
    %     figure, plot( FPR, TPR ,'r');
    %     hold on
    %     plot(diagx,diagy,'b');
    %     plot( D(r,1),D(r,2),'ok');
    %
    accuracyRoc = D(r,2);
    
    classif = zeros(1,length(E));
    for e=1:length(E)
        predict = double( E<=E(e) )';
        classif(e) = sum(Test_Label == predict) / length( predict);
    end
    [~,maxc] = min( abs(classif - accuracyRoc(1) ) );
    predict = double( E<E(maxc) )';
    tempSmooth = 30;
    mask = ones(1,tempSmooth);
    predictSmoothed = (conv(predict,mask,'same') / tempSmooth > 0.5 );
    Accuracy(rep) = sum(Test_Label == predictSmoothed ) / length(predictSmoothed );
end

[~,best_result] = max( Accuracy );
[~,best_likelihood] = max( likelihoods );

EERs(1) = 1- Accuracy(best_result); % fine
EERs(2) = 1- Accuracy(best_likelihood); % Superfair method
EERs(3) = 1 - AucPlain(best_result); % fine, without temporal smoothing (should be crappy)
EERs(4) = 1-mean( Accuracy); % Superfair

disp(['resul eer1 '  num2str(EERs)])

end
