function [repoDir, jobsDir_local, ...
    jobsDir_server_o, jobsDir_server, ...
    matlab_startup_dir, username] = ...
    getlocaldirs(targetdir, serverid)
% getlocaldirs: collect all local & server directories used by the server_interface.m files
%
% Usage:
%   getlocaldirs(targetdir, serverid)
%
% Args:
%   targetdir: target hardcoded directory (needs to exist on all temporary file folders)
%   serverid: server or cluster name
%
% Output:
%   repoDir: directory of the pu_cluster_interface repository
%       (linux format required to work with openssh)
%   jobsDir_local: directory where to store submitted slurm files, related .mat
%       files, and output text files
%   bDir: local bucket directory (from outside)
%   jobsDir_server: jobsDir_local but in the server
%   jobsDir_server_o: jobsDir_server directory (from outside)
%   matlab_startup_dir: directories of startup.m file in the servers

% 1) define which cluster/server to use
if ~exist('serverid', 'var') || isempty(serverid)
    serverid = 'spock';
end

% 2) find repository directory (need to be in matlab paths)
repoDir = which('server_interface');
repoDir = strrep(repoDir, 'server_interface.m', '');

% 3) define folder where to save submitted slurm files, related .mat
%   files, and output text files
jobsDir_local = [repoDir, 'jobsub', filesep];
if ~isempty(targetdir)
    jobsDir_local = [jobsDir_local, targetdir, filesep];
end

% 4) make repoDir and jobsDir_local linux compatible (correct drive name)
if ispc
    spattern = '\w*(?=:)';
    replace = '${lower($0)}';
    
    repoDir = strrep(repoDir, filesep, '/');
    repoDir = regexprep(repoDir, spattern, replace);

    jobsDir_local = strrep(jobsDir_local, filesep, '/');
    jobsDir_local = regexprep(jobsDir_local, spattern, replace);

end

if ~exist(jobsDir_local, 'dir')
    mkdir(jobsDir_local);
end

% 5) define directory in the sever where to move jobs 
%   to run - which were locally generated and saved at jobsDir_local 
%   (assumes it is in scratch drive)

% get scratch (temporary) and bucket (permanent) directories
[matlab_startup_dir, username, ...
    drive_dir, ~, ~, ~] = ...
    user_defined_directories(serverid);
% this generates:
%   scratchdir & bucketdir & drive_dir & matlab_startup_dir

switch serverid
    case 'della'
        jobsDir_server = [drive_dir(3).tempfiledir, 'jobsub/', targetdir];        
        jobsDir_server_o = ['della:', jobsDir_server, '/'];
    case 'spock'
        jobsDir_server = [drive_dir(4).tempfiledir, 'jobsub/', targetdir];
        jobsDir_server_o = ['spock:', jobsDir_server, '/'];
    case 'o2'
        jobsDir_server = [drive_dir(5).tempfiledir, 'jobsub/', targetdir];        
        jobsDir_server_o = ['o2:', jobsDir_server, '/'];
    case 'tranfer'
        jobsDir_server = [drive_dir(6).tempfiledir, 'jobsub/', targetdir];        
        jobsDir_server_o = ['tranfer:', jobsDir_server, '/'];
end

end
