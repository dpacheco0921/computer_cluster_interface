% main input variables of server_interface

% server_interface(funct2run, f2run, ...
%     serverId, config_dir, jobsubdir)

% funct2run: task to run
%       (submit: submit slurm job)
%       (status: get status of submitted jobs)
%       (clean: delete files from jobsubdir in the server)
%       (pull: pull files from the server (jobsubdir) to local copy of jobsubdir)
%       (cancel: cancel jobs)
%       (push_matlab_startup, pushes startup file to be read by matlab in the server)
funct2run = '';

%   serverId: server ID (spock or della)
server_id = 'o2';

%   config_dir: directory of ssh_config file 
%       to use for passwordless login to cluster
config_dir = 'c:/Users/Diego/.ssh/ssh_config';

%   jobsubdir: folder within 'jobsub' to save submitted jobs and related mat
subdirectory = 'impre_hu';

% flag to open or not a terminal
terminal_flag = 1;

% check storage in scratch folder
server_interface('storage', [], server_id, config_dir, subdirectory, terminal_flag)

% submit a job to the cluster
% create slurm files in ./slurm_files/ folder
copyfile('./example_pu.slurm', './slurm_files/example_pu.slurm')
slurm_file = 'example_pu';
server_interface('submit', slurm_file, server_id, config_dir, subdirectory, terminal_flag)

% status get status of submitted jobs
% job_type: type of jobs to check, if empty it display all jobs per user
%   (running: r)
%   (completed: cd)
%   (failed: f)
%   (timeout: to)
%   (node_fail: nf)
job_type = [];
server_interface('status', job_type, server_id, config_dir, subdirectory, terminal_flag)

% pull files from the server (jobsubdir) to local copy of jobsubdir 
server_interface('pull', [], server_id, config_dir, subdirectory, terminal_flag)

% delete files in scratch subdurectory
% file_str: is the string pattern of files to delete, if empty it deletes
%   all files within */jobsub/subdirectory
file_str = '';
server_interface('clean', file_str, server_id, config_dir, subdirectory, terminal_flag)

% cancel jobs
% if job_id is empty, then it cancels all jobs
job_id = '';
server_interface('cancel', job_id, server_id, config_dir, subdirectory, terminal_flag)

% push matlab startup file
% make 'matlabpath_o2.m' for o2 cluster
server_interface('push_matlab_startup', [], server_id, config_dir, subdirectory, terminal_flag)
