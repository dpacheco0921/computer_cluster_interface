% copy, edit and save this function as 'user_defined_directories.m'
% go through each drive directory and provide the right directory per
%   system (PC, mac, spock, or della)

function [matlab_startup_dir, username, ...
    drive_dir, tempfiledir, permfiledir, userdomain] = ...
    user_defined_directories(serverid)
% user_defined_directories: function that provides user define directories
%   and username to use for interfacing with cluster
%
% Usage:
%   [matlab_startup_dir, username, ...
%       drive_dir, tempfiledir, permfiledir, userdomain] = ...
%       user_defined_directories(serverid)
%
% Args:
%   serverid: server or cluster name ('spock', 'della', etc)
%
% Output:
%   matlab_startup_dir: directories of startup.m file in the servers
%   username: user name to use
%   drive_dir: temporary and permantent directories
%   tempfiledir: selected temporary directory (for example scratch)
%   permfiledir: selected permantent directory (for example bucket)
%   userdomain: domain used for username

% user defined directories of scratch and bucket drives
matlab_startup_dir.spock = ...
    'spock:/usr/people/*/matlab/startup.m';
matlab_startup_dir.della = ...
    'della:/home/*/Documents/MATLAB/startup.m';

username.spock = '*';
username.della = '*';
userdomain = '@**.**';

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
tempfiledir = [];
permfiledir = [];

% detecting environment: PC, Mac, or servers

if ispc
    
    % PC
    tempfiledir = drive_dir(1).tempfiledir;
    permfiledir = drive_dir(1).permfiledir;
    
else
    
    if ismac

        tempfiledir = drive_dir(2).tempfiledir;
        permfiledir = drive_dir(2).permfiledir;

    elseif contains(serverid, 'della')

        tempfiledir = drive_dir(3).tempfiledir;
        permfiledir = drive_dir(3).permfiledir;

    elseif contains(serverid, 'spock')

        tempfiledir = drive_dir(4).tempfiledir;
        permfiledir = drive_dir(4).permfiledir;

    end
    
end

end
