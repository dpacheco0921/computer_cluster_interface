% copy, edit and save this file as 'user_defined_directories.m'
% go through each drive directory and provide the right directory per
%   system (PC, mac, spock, or della)

% user defined directories of scratch and bucket drives
matlab_startup_dir.spock = 'spock:/usr/people/*/matlab/startup.m';
matlab_startup_dir.della = 'della:/home/*/Documents/MATLAB/startup.m';

username.spock = '*';
username.della = '*';

drive_dir = [];

% .tempfiledir directory to store temporary files
% .permfiledir directory to store permanent files

% PC
drive_dir(1).tempfiledir = 'X:\';
drive_dir(1).permfiledir = 'V:\';

% mac
drive_dir(2).tempfiledir = '/Volumes/*/';
drive_dir(2).permfiledir = '/Volumes/*/';

% della
drive_dir(3).tempfiledir = '/scratch/gpfs/*/';
drive_dir(3).permfiledir = '/tigress/*/';

% spock
drive_dir(4).tempfiledir = '/jukebox/scratch/*/';
drive_dir(4).permfiledir = '/jukebox/*/';

% pick directory suited to current environment
scratchdir = [];
bucketdir = [];

% detecting environment: PC, Mac, or servers

if ispc
    
    % PC
    scratchdir = drive_dir(1).tempfiledir;
    bucketdir = drive_dir(1).permfiledir;
    
else
    
    if ismac

        scratchdir = drive_dir(2).tempfiledir;
        bucketdir = drive_dir(2).permfiledir;

    elseif contains(pwd, 'della')

        scratchdir = drive_dir(3).tempfiledir;
        bucketdir = drive_dir(3).permfiledir;

    elseif contains(pwd, 'spock')

        scratchdir = drive_dir(4).tempfiledir;
        bucketdir = drive_dir(4).permfiledir;

    end
    
end
