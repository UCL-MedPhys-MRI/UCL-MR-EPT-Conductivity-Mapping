%% Demo script to run conductivity mapping using UCL MR-EPT v2.3
% This MATLAB package is a major re-write of the original UCL QCM algorithm
% that reconstructs electrical conductivity map from (unwrapped) MR 
% transmit/transceive phase acquired by various pulse sequences.
% 
% This UCL MR-EPT (v2.3) package supports different phase-based methods 
% that are conceptionally consistent with the initial work of:
% [Karsa A and Shmueli K. 2021. ISMRM. Abstract 3774].
% This implementation should produce improved conductivity maps
% with greater consistency across various MRI pulse sequences.
% Compared with the A. Karsa's implementation, it has the following 
% main new features:
%
% - Accelerated reconstruction even without Parallel Computing Toolbox
% - Support 2D EPT/conductivity reconstruction
% - Improved reconstuction for data with low magnitude contrasts
% - Support automatic magnitude weight, based on estimation from the
%   magnitude data, or by explicit noise map [Luo J, et al. ISMRM. 2024:3682]
% - Support parallel computing acceleration (requires MATLAB Parallel Computing Toolbox)
% - Post-reconstruction filtering option for unphysiological conductivities (<0 S/m or > 10 S/m)
% 
%
% The package has been tested on MATLAB 2022b, and should be compatible to
% later MATLAB versions. Please report any issue to jierong.luo@ucl.ac.uk
%
% Last update: 
% Jierong Luo (jierong.luo@ucl.ac.uk)
% 16th-Sep-2026
% University College London
%

%% ===================== Dependencies and paths =====================
cd('.')
addpath(genpath(pwd, 'functions'))

%% ===================== Load data =====================
b1plus_phase   = ; % [2D/3D double] measured or estimated TRANSMIT (B1+) phase, i.e. phi0 / 2
mask           = ; % [2D/3D double] binary brain mask, same size as phase

segmentation   = ; % (OPTIONAL) [2D/3D double] tissue segmentations for Seg/Mag+Seg EPT
magnitude      = ; % (OPTIONAL) [2D/3D double] load magnitude image for Mag/Mag+Seg EPT
noisemap       = ; % (OPTIONAL) [2D/3D double] phase noisemap for automatic weighting for Mag/Mag+Seg EPT

%% ===================== Scan and reconstruction parameters =====================
% parameter struct for EPT reconstruction
parameters.B0 = ; % scaler external magnetic field strength in [Tesla]
parameters.VoxelSize = ; % 3D [x,y,z] voxel size (resolution) in [MILLI-meter]
parameters.kDiffSize = ; % 3D [x,y,z] kernel size (diameter) for differentiation in [VOXEL]
parameters.kIntegralSize = ; % (for surface integral-form reconstruction) 3D [x,y,z] kernel size (diameter) for integration in [VOXEL]
% Alternatively, provide kernel size(s) in radius [MILLI-meter] in
% following fields:
% parameters.kDiffRadius = ; % 3D [x,y,z] kernel radius for differentiation in [MILLI-meter]
% parameters.kIntegralRadius = ; % 3D [x,y,z] kernel radius for integration in [MILLI-meter]

% For 2D EPT, the image slice must be arranged along z-/3rd-direction and kernel size(s) defined as [x,y,1].

%% ===================== EPT =====================
% EPT reconstruction by the main function call
% [conductivity, varargout] = conductivityMapping(TransmitPhase, Mask, Parameters, OPTIONAL_INPUTS)
% with TransmitPhase, Mask, Parameters defined above
% OPTIONAL_INPUTS accepted as MATLAB Name-Value arguements

% Optional inputs
% 'segmentation' {mustBeNumericOrLogical} % tissue segmentations (labels), non-brain must be 0, same size as txPhase
% 'magnitude' {mustBeNumeric} % magnitude image, same size as txPhase
% 'noise' {mustBeNumeric} % phase noisemap, same size as txPhase, or explicit magnitude noise level (scalar). This controls the magnitude weight of polynomial fitting, and the smoothness of the output conductivity map.
% 'estimatenoise' {mustBeNumericOrLogical} default [false]; % estimate noise level from the magnitude image
% 'isfilter' default [false]; % replace unphysiological conductivity (<0 or >10 S/m) by 3D interpolation and output filtered conductivity map(s)

%% Below are some examples to call different EPT reconstruction methods 
% >>>>>>>>>>> Integral-form Mag+Seg EPT (RECOMMENDED)
conductivity = conductivityMapping(b1plus_phase, mask, parameters, ...
    'magnitude', magnitude, 'segmentation', segmentation);

% >>>>>>>>>>> Laplacian-form Mag+Seg EPT
% Laplacian-form EPT is evoked with the same function call, automatically,
% when no integral kernel information is provided as a parameter, i.e. 
% parameters.kIntegralSize and parameters.kIntegralRadius do not exist or
% left empty:
% parameters.kIntegralSize = [];
% parameters.kIntegralRadius = [];
conductivity = conductivityMapping(b1plus_phase, mask, parameters, ...
    'magnitude', magnitude, 'segmentation', segmentation);

% >>>>>>>>>>> Integral-form EPT with ellipsoid kernels
conductivity = conductivityMapping(b1plus_phase, mask, parameters);

% >>>>>>>>>>> Integral-form  Mag EPT with explicit magnitude noise level (Gaussian noise standard deviation)
conductivity = conductivityMapping(b1plus_phase, mask, parameters, ...
    'magnitude', magnitude, 'noisemap', 0.5);

% >>>>>>>>>>> Integral-form  Mag EPT with automatic magnitude weighting
% using phase noisemap
conductivity = conductivityMapping(b1plus_phase, mask, parameters, ...
    'magnitude', magnitude, 'noisemap', noisemap);

% >>>>>>>>>>> Integral-form  Mag EPT with automatic magnitude weighting
% using estimated noise level from the data
conductivity = conductivityMapping(b1plus_phase, mask, parameters, ...
    'magnitude', magnitude, 'estimatenoise', true);

% >>>>>>>>>>> Integral-form Seg EPT
conductivity = conductivityMapping(b1plus_phase, mask, parameters, ...
    'segmentation', segmentation);

% >>>>>>>>>>> Integral-form Mag+Seg EPT with simple post-prcess filtering
conductivity = conductivityMapping(b1plus_phase, mask, parameters, ...
    'magnitude', magnitude, 'segmentation', segmentation, 'isfilter', true);

% >>>>>>>>>>> EPT with additional output
[conductivity, options] = conductivityMapping(...);

% OPTIONAL output 'options' is a structure that contains paramters and
% reconstruction methods used for MR-EPT.
% It has following fields:
%    .Parameters      = effective EPT reconstruction parameters
%    .unphysioMap     = binary mask of conductivity < 0 S/m or >10 S/m
%    .isFilter        = True/False filter/interpolation option for unpysiological conductivity
%    .isSeg           = True/False segmentation option
%    .isMag           = True/False magnitude weighted option
%    .voxelwiseNoise  = noise estimation options or voxelwise noisemap (if provided)
%    .runtime         = total processing time


