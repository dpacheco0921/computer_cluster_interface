function server_interface(funct2run, f2run, ...
    serverId, config_dir, jobsubdir)
% server_interface: function to interface with the cluster/servers (spock or della)
%
% Usage:
%   server_interface(funct2run, f2run, ...
%       serverId, tDir, config_dir, jobsubdir)
%
% Args:
%   funct2run: task to run
%       (parse, submit, status, clean, pull)
%       (push_matlab_startup, pushes startup file to be read by matlab in the server)
%   f2run: file to submit
%   serverId: server ID (spock or della)
%       (needs to be defined in ssh_config)
%   config_dir: directory of ssh_config file to use for passwordless logint
%       to cluster
%   jobsubdir: folder within jobsub to save submitted jobs, related mat
%       files, and output txt files (impre, roirel, regrel)
%
% Notes
% how to know what the default directory is
%   if ssh_config is not in the default directory you need to input the
%   directory, for example c:/Users/*/.ssh/ssh_config

% server to log in
if ~exist('serverId', 'var') || isempty(serverId)
    serverId = 'spock';
end
if ~exist('f2run', 'var'); f2run = []; end
if ~exist('jobsubdir', 'var') || isempty(jobsubdir)
    jobsubdir = [];
end
if ~exist('config_dir', 'var') || isempty(config_dir)
    config_dir = [];
end

% get user-defined directories
[repoDir, jobsDir_local, jobsDir_server_o, jobsDir_server, ...
    matlab_startup_dir, username] = getlocaldirs(jobsubdir, serverId);

% ssh and scp commands
if ~isempty(config_dir)
    sshCo = ['ssh ', serverId, ' -F ', config_dir, ' '];
else
    sshCo = ['ssh ', serverId, ' '];
end

if ~isempty(config_dir)
    sshSCP = ['scp -v -F ', config_dir, ' '];
else
    sshSCP = 'scp -v ';
end

% run tasks
switch funct2run
    case 'submit'
        
        % if a custom slurm file then update it
        str2run = [sshSCP, repoDir, 'slurm_files/', ...
            f2run, '.slurm ', jobsDir_server_o];
        coexecuter(str2run)
        
        % submit this job
        str2run = [sshCo, '''cd ', jobsDir_server, ...
            '; sbatch ', f2run, '.slurm'''];
        
    case 'status'
        
        % running: r
        % completed: cd
        % failed: f
        % timeout: to
        % node_fail: nf
        
        str2run = [sshCo, '''sacct'];

        if ~isempty(f2run)
            str2run = [str2run, ' -s ', f2run];
        end
        
        str2run = [str2run, ''''];
        
    case 'cancel'
        
        str2run = [sshCo, '''scancel'];

        
        if ~isempty(f2run)
            str2run = [str2run, ' -b ', f2run];
        else
            str2run = [str2run, ' -u ', eval(['username.', serverId])];
        end
        
        str2run = [str2run, ''''];
        
    case 'pull'
        
        str2run = [sshSCP, jobsDir_server_o, '* ', jobsDir_local];
        
    case 'clean'
        
    	str2run = [sshCo, '''cd ', jobsDir_server, '; rm -vf ./*', f2run,'*'''];
    
    case 'push_matlab_startup'
        
        if strcmp(serverId, 'spock')
            f2run = 'matlabpath_spock.m';
        else
            f2run = 'matlabpath_della.m';
        end
        
        % command to copy
        str2run{1} = [sshSCP, repoDir, 'utilities/startup_files/', ...
            f2run, ' ', eval(['matlab_startup_dir.', serverId])];
        
        % command to copy back to local to make sure the right file has
        % been moved
        str2run{2} = [sshSCP, eval([matlab_startup_dir, '.serverId']), ...
            ' ', jobsDir_local, 'startup_copy.m'];
        
    otherwise
        
        fprintf('Unknown order\n')
        
end

% replace ' by " if PC
if ispc
   str2run = strrep(str2run, '''', '"');
end

% run command
coexecuter(str2run)

% cd to folder where the jobs are save
switch funct2run
    
    case 'pull'
        cd(jobsDir_local)
    
end

end
