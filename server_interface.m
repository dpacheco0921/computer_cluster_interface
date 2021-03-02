function server_interface(funct2run, f2run, ...
    serverId, config_dir, jobsubdir, openterminal)
% server_interface: function to interface with the cluster/servers (spock or della)
%
% Usage:
%   server_interface(funct2run, f2run, ...
%       serverId, tDir, config_dir, jobsubdir)
%
% Args:
%   funct2run: task to run
%       (submit: submit slurm job)
%       (status: get status of submitted jobs)
%           (running: r)
%           (completed: cd)
%           (failed: f)
%           (timeout: to)
%           (node_fail: nf)
%       (clean: delete files from jobsubdir in the server)
%       (pull: pull files from the server (jobsubdir) to local copy of jobsubdir)
%       (cancel: cancel jobs)
%           (if f2run is not empty, it will only cancel jobs with the ID =
%           f2run)
%           (if f2run empty, it cancel all jobs associated with username)
%       (push_matlab_startup, pushes startup file to be read by matlab in the server)
%   f2run: file to submit
%   serverId: server ID (spock or della)
%       (needs to be defined in ssh_config)
%   config_dir: directory of ssh_config file to use for passwordless login to cluster
%   jobsubdir: folder within jobsub to save submitted jobs, related mat
%       files, and output txt files (impre, roirel, regrel)
%   openterminal: flag to open terminal
%
% Notes
% how to know what the default directory is
%   if ssh_config is not in the default directory you need to input the
%   directory, for example c:/Users/*/.ssh/ssh_config

% server to log in
if ~exist('serverId', 'var') || isempty(serverId)
    serverId = 'spock';
end

if ~exist('f2run', 'var')
    f2run = [];
end

if ~exist('jobsubdir', 'var') || isempty(jobsubdir)
    jobsubdir = [];
end

if ~exist('openterminal', 'var') || isempty(openterminal)
    openterminal = 0;
end

% get user-defined directories
[repoDir, jobsDir_local, jobsDir_server_o, jobsDir_server, ...
    matlab_startup_dir, username] = getlocaldirs(jobsubdir, serverId);

if ~exist('config_dir', 'var') || isempty(config_dir)
    
    if ispc
        config_dir = ['c:/Users/', ...
            getenv('USERNAME'), '/.ssh/ssh_config'];
    elseif ismac
        config_dir = [];
    end
    
end

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
        
        if exist([repoDir, 'slurm_files/', f2run, '.slurm'], 'file')
            % if a custom slurm file then update it from local drive (repoDir)
            str2run = [sshSCP, repoDir, 'slurm_files/', ...
                f2run, '.slurm ', jobsDir_server_o];
        elseif exist([jobsDir_local, f2run, '.slurm'], 'file')
            % if generated by server_interface
            str2run = [sshSCP, jobsDir_local, ...
                f2run, '.slurm ', jobsDir_server_o];
        end
        
        if openterminal
            eval(['!', str2run, ' &'])
        else
            coexecuter(str2run)
        end
        
        % submit this job
        str2run = [sshCo, '''cd ', jobsDir_server, ...
            '; sbatch ', f2run, '.slurm'''];
        
    case 'status'
                
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
        elseif strcmp(serverId, 'della')
            f2run = 'matlabpath_della.m';
        end
        
        % command to copy
        str2run{1} = [sshSCP, repoDir, 'utilities/startup_files/', ...
            f2run, ' ', eval(['matlab_startup_dir.', serverId])];
        
        % command to copy back to local to make sure the right file has
        %   been moved
        str2run{2} = [sshSCP, eval(['matlab_startup_dir.', serverId]), ...
            ' ', jobsDir_local, 'startup_copy.m'];
        
    otherwise
        
        fprintf('Unknown order\n')
        
end

% replace ' by " if PC
if ispc
   str2run = strrep(str2run, '''', '"');
end

% run command
if openterminal
    
    if iscell(str2run)
        for i = 1:numel(str2run)
            eval(['!', str2run{i}, ' &'])
        end
    else
        eval(['!', str2run, ' &'])
    end
    
else
    coexecuter(str2run)
end

% cd to folder where the jobs are save
switch funct2run
    
    case {'pull', 'push_matlab_startup'}
        cd(jobsDir_local)
    
end

end
