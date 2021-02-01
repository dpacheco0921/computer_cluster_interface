function syncDir(iDir, oDir, i_serverId, o_serverId)
% syncDir: Function to syncronize folders within servers
%
% Usage:
%   syncDir(iDir, oDir, i_serverId, o_serverId)
%
% Args:
%   iDir: source dir (in local server/cluster)
%   oDir: target dir (in target server/cluster)
%   i_serverId: source server ID (apps, spock, della, tigress)
%   o_serverId: target server ID (apps, spock, della, tigress)
%       (needs to be defined in ssh_config)
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

if ~exist('i_serverId', 'var') || isempty(i_serverId)
    i_serverId = 'apps';
end

if ~exist('o_serverId', 'var') || isempty(o_serverId)
    o_serverId = 'apps';
end

[~, username, ~, ~, ~, ~, host_name] = user_defined_directories;

eval(['username = username.', i_serverId]);

% target server
targetSerDir = '';

if ~isempty(i_serverId) && ~strcmp(i_serverId, o_serverId)
    selidx = contains(host_name, i_serverId);
    targetSerDir = host_name{selidx};
end

% server to log in
sshCo = ['ssh ', i_serverId, ' '];

% Submit command
% v: verbose
% a: archive mode
% h: human readable numbers
% z: compress
% r: recursive

CommandStr{1} = [sshCo, '''rsync -avhzr ', iDir, ' ', targetSerDir, oDir, ''''];
initT = tic;
coexecuter(CommandStr)
toc(initT)

end
