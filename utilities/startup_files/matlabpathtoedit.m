% copy this *.m file, edit and rename to 
%   'matlabpath_della.m' or 'matlabpath_spock.m', for della or spock accordingly

% 1) default stuff to add (similar to what is described in the the wiki spock)

%------------ FreeSurfer -----------------------------%
fshome = getenv('FREESURFER_HOME');
fsmatlab = sprintf('%s/matlab',fshome);
if (exist(fsmatlab) == 7)
    path(path,fsmatlab);
end
clear fshome fsmatlab;
%-----------------------------------------------------%

%------------ FreeSurfer FAST ------------------------%
fsfasthome = getenv('FSFAST_HOME');
fsfasttoolbox = sprintf('%s/toolbox',fsfasthome);
if (exist(fsfasttoolbox) == 7)
    path(path,fsfasttoolbox);
end
clear fsfasthome fsfasttoolbox;
%-----------------------------------------------------%

addpath(genpath('/usr/pni/pkg/MATLAB/toolboxes_thirdparty/MVPA/mvpa'));
addpath(genpath('/usr/pni/pkg/SPM8'));

%-----------------------------------------------------%

% 2) add paths of folders/repositories to use

% example
addpath(genpath('/mnt/bucket/labfolder/userfolder/myRepos/fakecode'))
rmpath(genpath('/mnt/bucket/labfolder/userfolder/myRepos/fakecode/.git'))

% if using cvxpackage
run /mnt/bucket/labfolder/userfolder/cvxpackage/cvx_startup.m

% you might need to fix cvx bug with directories
% look at the following paths:

% global cvx___
% try 
%     for i = 1:numel(cvx___.solvers.list)
%         display(cvx___.solvers.list(i).fullpath)
%         display(cvx___.solvers.list(i).path)
%         display(cvx___.solvers.list(i).spath)
%     end
% end

% confirm they are correct otherwise fix/replace them
