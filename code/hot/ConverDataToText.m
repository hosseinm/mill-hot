

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tmp = 1:size(DataAll,1);
TrainLabel =[tmp',DataAll(:,2:3)];
TrainData =[DataAll(:,4:99)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



a =[];
 for ii=1:size(TrainData,2)
      a = [a '%3.4f,'];             
 end
fid = fopen('train.matrix', 'wt'); % Open for writing
 for jj=1:size(TrainData,1)

  fprintf(fid,a,TrainData(jj,:));
  fprintf(fid, '\n');
 end
fclose(fid);

%----------------------
a =[];
 for ii=1:size(TrainLabel,2)
      a = [a '%d,'];             
 end
fid = fopen('train.label', 'wt'); % Open for writing
 for jj=1:size(TrainLabel,1)

  fprintf(fid,a,TrainLabel(jj,:));
  fprintf(fid, '\n');
 end
fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a =[];
 for ii=1:size(TestData,2)
      a = [a '%3.4f,'];             
 end
fid = fopen('test.matrix', 'wt'); % Open for writing
 for jj=1:size(TestData,1)

  fprintf(fid,a,TestData(jj,:));
  fprintf(fid, '\n');
 end
fclose(fid);

%----------------------
a =[];
 for ii=1:size(TestLabel,2)
      a = [a '%d,'];             
 end
fid = fopen('test.label', 'wt'); % Open for writing
 for jj=1:size(TestLabel,1)

  fprintf(fid,a,TestLabel(jj,:));
  fprintf(fid, '\n');
 end
fclose(fid);


% save([options.input,'\','Ped1'],'dataall','-v7.3')