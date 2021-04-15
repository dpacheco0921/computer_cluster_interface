function command2submit = syncDir(iDir, oDir, log_serverId, ...
    i_serverId, o_serverId, openterminal, config_dir, synctype)
% syncDir: Function to syncronize folders within servers
%
% Usage:
%   command2submit = syncDir(iDir, oDir, log_serverId, ...
%      i_serverId, o_serverId, openterminal, config_dir, synctype)
%
% Args:
%   iDir: source dir (in local server/cluster)
%   oDir: target dir (in target server/cluster)
%   log_serverId: server ID to which you connect (apps, spock, della, tigress)
%   i_serverId: source server ID (apps, spock, della, tigress)
%   o_serverId: target server ID (apps, spock, della, tigress)
%       (needs to be defined in ssh_config)
%   openterminal: flag to open terminal
%   config_dir: directory of ssh_config file to use for passwordless login to cluster
%   synctype: type of update
%       ('update', default, it updates target folder from input folder, does not delete missing files)
%       ('mirror', makes target folder match input folder, it deletes missing files)
%
% Example of bucket/scratch/tigress/della directories
% '/jukebox/scratch/', '/jukebox/murthy/'
% '/tigress/'
% '/home/username/'
%
% Example:
%   syncDir('/jukebox/scratch/improcessed/nsyb-S/', ...
%       '/jukebox/murthy/LabData/processedbrainCa/nsyb-S/')
%
% To do:
%   maybe include overwrite: cp -r

if ~exist('log_serverId', 'var') || isempty(log_serverId)
    log_serverId = 'apps';
end

if ~exist('i_serverId', 'var') || isempty(i_serverId)
    i_serverId = 'apps';
end

if ~exist('o_serverId', 'var') || isempty(o_serverId)
    o_serverId = 'apps';
end

if ~exist('openterminal', 'var') || isempty(openterminal)
    openterminal = 0;
end

if ~exist('config_dir', 'var') || isempty(config_dir)
    
    if ispc
        config_dir = ['c:/Users/', ...
            getenv('USERNAME'), '/.ssh/ssh_config'];
    elseif ismac
        config_dir = [];
    end
    
end

if ~exist('synctype', 'var') || isempty(synctype)
    synctype = 'update';
end

[~, username, ~, ~, ~, ~, host_name] = user_defined_directories;

eval(['username = username.', log_serverId]);

% target server
inputSerDir = '';

if ~isempty(log_serverId) && ~strcmp(log_serverId, i_serverId)
    selidx = contains(host_name, i_serverId);
    inputSerDir = [username, host_name{selidx}];
end

% target server
targetSerDir = '';

if ~isempty(log_serverId) && ~strcmp(log_serverId, o_serverId)
    selidx = contains(host_name, o_serverId);
    targetSerDir = [username, host_name{selidx}];
end

% server to log in
if ~isempty(config_dir)
    sshCo = ['ssh ', log_serverId, ' -F ', config_dir, ' '];
else
    sshCo = ['ssh ', log_serverId, ' '];
end

% Submit command
% v: verbose
% a: archive mode
% h: human readable numbers
% z: compress
% r: recursive
% --delete: delete extraneous files from destination dirs

if strcmp(synctype, 'update')
    command2submit = [sshCo, '"rsync -avhzr ', ...
        inputSerDir, iDir, ' ', targetSerDir, oDir, '"'];
elseif strcmp(synctype, 'mirror')
    command2submit = [sshCo, '"rsync -avhzr --delete ', ...
        inputSerDir, iDir, ' ', targetSerDir, oDir, '"'];
end

initT = tic;

if openterminal == 1
    eval(['!', command2submit, ' &'])
elseif openterminal == 0
    coexecuter(command2submit)
else
    fprintf('Generate command (not executed)')
end

toc(initT)

end
