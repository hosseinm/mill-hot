options_Hot;
addpath(options.addpath1)
vl_setup;
addpath(options.addpath2)
addpath(options.addpath3)
load(fullfile(options.input,'prespective'))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Data set ped1&ped2
UCSDped1;
[ImgGrandtruth,TestVideoFile_new] = Create_GT_UCSD_Frame(options,TestVideoFile);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for datanum = 1:1
    %%%%%%%%%%% tracklet length
     for trkcount= 2:2 %size(options.tracklet_length_cell,2)%%% nember of frame(tracklet length)
        trkcount
        options.tracklet_length = options.tracklet_length_cell(trkcount);
        options.trkcount =trkcount;

        %%Option--------------
        options.datasetcategory = (datanum);
        options.ImageName=(fullfile(options.input,sprintf('UCSDped%d',options.datasetcategory),'Test\Test001\001.tif'));
        [LabelPed,PedTest,PedTrain] = Load_Dataset( options );  %% load dataset and label
        options.max_magnitude_all = Make_Max_magnitude(options,prespective,PedTest);%options.max_magnitude_all_cell(trkcount);
        for sizecell = 3: 3%size(options.Xinput_all,2)%%patch size
            sizecell
            options.Xinput=options.Xinput_all(sizecell);
            options.Yinput=options.Yinput_all(sizecell);
            for bincount = 4:4%size(options.numbin_cell,2)-2%%%%%%size of the bin(into cell memory)
                bincount
                options.numbin = options.numbin_cell(bincount);
                options  = Makecellsize(options );%%% S [2x3,4x6,... ]
                
                %Train----------------
                Train = [];
                IndexLabelTrain = [];
                for seq = 1 : size(PedTrain,2)
                    
                    data_noisy = PedTrain{seq};
                    options.nFrame =    data_noisy(end,end)+1-(options.tracklet_length)+1;
                    data = rm_noisy_trk1(options, data_noisy);
                    [trk_magnitude,trk_orientation] = trk2magori1(data,prespective,options);
                    [Tracklets_matrix] = Tracklet2matrix(data);
                    %% Method
                    linear_index = seq2bin1(options,trk_magnitude,trk_orientation);
                    [hot_descriptor,P] = hot_cell(options,Tracklets_matrix,linear_index);
                    %%reshape train matrix
                    
                    Train = [Train;hot_descriptor];
                    P =[P,ones(size(P,1),1).*seq];
                    IndexLabelTrain = [IndexLabelTrain;P];
                    clear P
                end
                IndexLabelTrain(:,4) = zeros(size(IndexLabelTrain,1),1);
                IndexLabelTrain(:,5) = zeros(size(IndexLabelTrain,1),1);
                %Test---------------------
                IndexLabelTest = [];
                Test = [];
                for seq = 1:size(PedTest,2)
                   
                    data_noisy = PedTest{seq};
                    options.nFrame = PedTest{seq}(end,end)+1-(options.tracklet_length)+1;
                    data = rm_noisy_trk1(options, data_noisy);
                    [trk_magnitude,trk_orientation] = trk2magori1(data,prespective,options);
                    [Tracklets_matrix] = Tracklet2matrix(data);
                    %% Method
                    linear_index = seq2bin1(options,trk_magnitude,trk_orientation);
                    [hot_descriptor,P] = hot_cell(options,Tracklets_matrix,linear_index);
                    %%reshape test matrix
                    Test = [Test;hot_descriptor];
                    P1 = FunctionInstanceLable(P,seq,ImgGrandtruth,options);
                    IndexLabelTest = [IndexLabelTest;P1];
                end
                
%                                 EERs  = Function_compute_EER_fixedTopic( Test,Train,Test_Label,Train_Label,1,30);
%                                 final_result_EER_BW(1,:)=EERs;
%                                 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%LDA FS
%                                 EERs  = Function_compute_EER_fixedTopic( Test_Add,Train_Add,Test_Label,Train_Label,1,30);
%                                 final_result_EER_FS(1,:)=EERs;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%FIS
%                 [hj_accn2] = Function_compute_EER_Fis( Test,Train,Test_Label,Train_Label,1,10,options);
%                 hj_accn22 = hj_accn2';
%                 for i =1:size(hj_accn2,1)
%                     Local_frame(:,:,i) = reshape(hj_accn22(:,i),size(xx,1),size(xx,2));
%                 end
%                 
%                 Fname1 = ['Result-DatasetPed-[' num2str(datanum) ']-Trackletlength-[' num2str(options.tracklet_length)  ']-binsize-[' num2str(options.numbin) ']-cellsizeX-[' num2str(options.Xinput) ']-cellsizeY-[' num2str(options.Yinput) ,']',];
%                 mkdir(options.output,options.run_name);
%                 save([options.output,options.run_name,Fname1],'Test_Add','Train_Add','Train_Label','Test_Label','Test','Train')
            end
        end
    end
end






