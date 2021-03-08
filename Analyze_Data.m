%% Select Folder with Invidividual Session Data
% Run this block Per Treatment Group
close all
clear
PathName_Folder = uigetdir(); 
cd(PathName_Folder);
SessionFiles = dir('*.mat');
for session = 1:length(SessionFiles)
    load([SessionFiles(session).folder '\' SessionFiles(session).name])
    GCAMP.mouseID = SessionFiles(session).name(1:end-4);
    parts = strsplit(PathName_Folder, '\');
    DirPart = parts{7};
    GCAMP.treatment = DirPart;
    % Extract event timestamp variables
    [GCAMP] = GCAMP_Structure(photometry_data, beh_data, GCAMP);
    % Z-score peri-event data
    [GCAMP] = GCAMP_Zscore_All(GCAMP);
    % If it did not pass noise threshold, exclude % If more than 1 reward, save, if not, exclude
    if ~(GCAMP.pass == 0 || length(GCAMP.First_HE_ON_timestamps) < 2)
        % Save
        cd(['C:\Users\rrenteria\Desktop\For eLife\Raw\' GCAMP.treatment])
        save([GCAMP.mouseID '_Z.mat'], 'GCAMP');
    elseif GCAMP.pass == 0
        exclude_report{session,1} = GCAMP.mouseID;
    elseif length(GCAMP.First_HE_ON_timestamps) < 2
        exclude_report{session,2} = GCAMP.mouseID;
    end
    cd(PathName_Folder);
end
%% Group individual GCAMP sessions
% Run this block Per Treatment Group
close all
clear
selpath = uigetdir('C:\Users\rrenteria\Desktop\For eLife\Sessions\');
listing = dir(selpath);
GCAMPFiles = listing(3:end);
cd(selpath);
for i = 1:length(GCAMPFiles)
    load(GCAMPFiles(i).name)
    Grouped_GCAMP.Mouse{i} = GCAMP;
    %Grouped_GCAMP.training_day = GCAMP.training_day;
    parts = strsplit(selpath, '\');
    DirPart = parts{end};
    Grouped_GCAMP.treatment = DirPart;  
end
% Group Z-score data, apply inclusion criteria to sessions/trials
[Grouped_GCAMP] = zscore_Group(Grouped_GCAMP); 
% Peri-event averages
%[Grouped_GCAMP] = zscore_Perievent(Grouped_GCAMP); 
% Save
cd(['C:\Users\rrenteria\Desktop\For eLife\Grouped\' Grouped_GCAMP.treatment])
save(['Grouped_GCAMP_' Grouped_GCAMP.treatment], 'Grouped_GCAMP');
%cd(PathName_Folder);
%% Plot the data
% Select folder that includes both Air and CIE grouped data
selpath = uigetdir('C:\Users\Rafael\Desktop\Gcamp\Rafael\Data\');
listing = dir(selpath);
GroupedFolders = listing(3:end);
plot_Groups(GroupedFolders)
%% Average AUC




