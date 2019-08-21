% copy, edit and save this file as 'user_defined_directories.m'
% go through each drive directory and provide the right directory per
%   system (PC, mac, spock, or della)

% user defined directories of scratch and bucket drives
matlab_startup_dir.spock = 'spock:/usr/people/*/matlab/startup.m';
matlab_startup_dir.della = 'della:/home/*/Documents/MATLAB/startup.m';

username.spock = '*';
username.della = '*';

drive_dir = [];

% PC
drive_dir(1).scratchdir = 'X:\';
drive_dir(1).bucketdir = 'V:\';

% mac
drive_dir(2).scratchdir = '/Volumes/*/';
drive_dir(2).bucketdir = '/Volumes/*/';

% della
drive_dir(3).scratchdir = '/tigress/*/';
drive_dir(3).bucketdir = [];

% spock
drive_dir(4).scratchdir = '/jukebox/scratch/*/';
drive_dir(4).bucketdir = '/jukebox/*/';

% pick directory suited to current environment
scratchdir = [];
bucketdir = [];

% detecting environment: PC, Mac, or servers

if ispc
    
    % PC
    scratchdir = drive_dir(1).scratchdir;
    bucketdir = drive_dir(1).bucketdir;
    
else
    
    if ismac

        scratchdir = drive_dir(2).scratchdir;
        bucketdir = drive_dir(2).bucketdir;

    elseif contains(pwd, 'tigress')

        scratchdir = drive_dir(3).scratchdir;
        bucketdir = drive_dir(3).bucketdir;

    else

        scratchdir = drive_dir(4).scratchdir;
        bucketdir = drive_dir(4).bucketdir;

    end
    
end
