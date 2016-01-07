function [ImgGrandtruth,TestVideoFile_new] = Create_GT_UCSD_Frame(options,TestVideoFile)
filedir = fullfile('E:\MY CODE\Abnormality_Measure\segment_commosion\data\input\opticalflow1',options.nameofdataset,'abnormal_anotate');
dirlist = dir(fullfile(filedir,'**gt'));%%%'test***'
num_files = length(dirlist);
for numtext=1:num_files
    disp(['processing folder '  num2str(numtext)])
    filenames = cell(num_files, 1);
    filenames{numtext} = dirlist(numtext).name;
    filename= filenames{numtext};
    dirlist_img = dir(fullfile(filedir,filename,'***.bmp'));
    num_files_img = length(dirlist_img);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for iM=1:num_files_img
        %%%%%%%%%%%%%%%%%%%%%
        filenames_img = cell(num_files_img, 1);
        filenames_img {iM} = dirlist_img (iM).name;
        filename_img= filenames_img {iM};
        img = imread(fullfile(filedir,filename,filename_img));
        img(img~=0)=1;
        
        %------------------------------------------------
        ImgGrandtruth{numtext,iM}=double(img);
    end
end

%--------------------
for numtext=1:num_files
    TestVideoFile_new{1,numtext}.gt_frame(1,1:num_files_img)=0; 
    [m,n]=size(TestVideoFile{1,numtext}.gt_frame(:,:));
    for iM=1:n
        disp(['processing folder '  num2str(iM)])
        A=TestVideoFile{1,numtext}.gt_frame(1,iM);
        TestVideoFile_new{1,numtext}.gt_frame(1,A)=1;
    end
end


