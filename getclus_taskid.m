function taskID = getclus_taskid(serverID)
% getclus_taskid: collects the environmental variable taskID from cluster
%   in use (compatible with spock and della)
% 
% Usage:
%   taskID = getclus_taskid(serverID)
%
% Args:
%   serverId: server ID (spock or della)

taskID = [];

if ~exist('serverID', 'var') || isempty(serverID)
    serverID = 'spock'; 
end

if contains(pwd, 'tigress') || contains(pwd, 'della')
    taskID = str2double(getenv('SLURM_ARRAY_TASK_ID'));
elseif strcmp(serverID, 'spock')
    taskID = str2double(getenv('SLURM_ARRAY_TASK_ID'));
end

end
