%% Neal Ramseier 09.18.2025 
%This code uses the X and Y coordinates from ThunderSTORM reconstruction and clusters the data using DBSCAN. The values are then exported in .csv file format. 


%% Close all and Import Data 
clear variables; close all; clc; close all hidden;
disp("Previous Data Cleared"); 
if not(isfolder('MATLABData'))
    mkdir('MATLABData')
end
folder = string(pwd)+'\MATLABData\';
[fname,directory] = uigetfile('*.csv','Please choose a .csv file'); %the user selects a file
tic;
fileName = fullfile(directory, fname); %takes directory/filename.txt and stores to fullname var
Data = readmatrix(fileName);%reads in file to Data var
dataID = Data(:,1);
frameNumber = Data(:,2);
RawXData = Data(:,3); %separate X data
RawYData = Data(:,4); %separate Y data
RawXYData = [RawXData,RawYData]; 
sigma = Data(:,5);
intensity = Data(:,6);
offset = Data(:,7);
bkgstd = Data(:,8);
uncertainty = Data(:,9);
Xmin = min(RawXData); Xmax = max(RawXData); Ymin = min(RawYData); Ymax = max(RawYData); 
figure(); %create figure of unclustered data
scatter(RawXData, RawYData,6,'filled'); 
axis equal; xlim([Xmin-1000 Xmax+1000]); ylim([Ymin-1000 Ymax+1000]); 
disp("Data Loaded");
%% Cluser using DBSCAN
%This section of code clusters the data using DBSCAN. The clustered data is then denoised, then organized into a struct for grouping. 

%Change these two values below to tweak the clustering of the data.
minPTS = 6; %Set to the minimum nuber of points you want in a single cluster
Epsilon = 50; %Set the search radius to find those minimum number of points

Clusters = struct; clusterLabel = [];
disp("Begin Clustering");
ClusterID = dbscan(RawXYData,Epsilon,minPTS); %perform the DBSCAN clustering of the X and Y data
StructData = [dataID,frameNumber,RawXData,RawYData,sigma,intensity,offset,bkgstd,uncertainty,ClusterID]; %set up for removing noise points
[ClusterID2,val]=find(StructData==-1); %find noise points
StructData(ClusterID2,:)=[]; % remove noise points
DataID = StructData(:,1);FrameNumber = StructData(:,2);X = StructData(:,3); Y = StructData(:,4);Sigma = StructData(:,5);
Intensity = StructData(:,6); Offset = StructData(:,7); Bkgstd =StructData(:,8);Uncertainty = StructData(:,9); ID = StructData(:,10); q=1;dataHoldForExport = [];
for n = 1:max(ClusterID)
    temp = ID(StructData(:,10)==n);
    for iii =  1:length(temp)
        clusterLabel(iii,1) = q;
    end
    holdData = horzcat(DataID(StructData(:,10)==n),FrameNumber(StructData(:,10)==n),X(StructData(:,10)==n), Y(StructData(:,10)==n),Sigma(StructData(:,10)==n),Intensity(StructData(:,10)==n),Offset(StructData(:,10)==n),Bkgstd(StructData(:,10)==n),Uncertainty(StructData(:,10)==n),clusterLabel); %find clusters of 1:X and sort into XY
    j=strcat('Cluster ',num2str(q)); 
    q = q+1; 
    Clusters.(j) = holdData;
    clear clusterLabel
    dataHoldForExport = [dataHoldForExport;holdData];
end
figure() 
pl = gscatter(X,Y,ID,[],[],10);
TheLegend = legend({' '}); 
set(TheLegend,'visible','off'); 
xlabel("X"); ylabel("Y"); title("Clusters");
axis equal; xlim([Xmin-1000 Xmax+1000]); ylim([Ymin-1000 Ymax+1000]); 
dataHoldForExport(:,10) = [];


%% Import csv and write into it
disp('Prepare for Export');disp(' '); 
fid = fopen(folder+"ClusteredDataFile.csv", 'w'); % open new file
fprintf(fid, 'id,frame,x [nm],y [nm],sigma [nm],intensity [photon],offset [photon],bkgstd [photon],uncertainty [nm]'); % write header
fclose(fid);
writematrix(dataHoldForExport, folder+"ClusteredDataFile.csv", 'WriteMode', 'append'); % Append matrix data
disp('All Done.');

toc; %Time
