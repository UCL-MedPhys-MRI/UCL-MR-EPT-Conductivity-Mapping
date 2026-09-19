# UCL-MR-EPT-Conductivity-Mapping

This MATLAB package is a major re-write of the original UCL QCM algorithm that reconstructs the electrical conductivity map from (unwrapped) MR transmit/transceive phase acquired by various pulse sequences. 

This UCL MR-EPT (v2.3) package supports different phase-based methods that are conceptually consistent with the initial work of: [Karsa A and Shmueli K. 2021. ISMRM. Abstract 3774]. This implementation should produce improved conductivity maps with greater consistency across various MRI pulse sequences. Compared with the A. Karsa's implementation, it has the following new features:

- Accelerated reconstruction even without Parallel Computing Toolbox
- Support 2D EPT/conductivity reconstruction
- Improved reconstuction for data with low magnitude contrasts
- Support automatic magnitude weighting, based on estimation from the magnitude data, or by explicit noise map [Luo J, et al. ISMRM. 2024:3682]
- Support parallel computing acceleration (requires MATLAB Parallel Computing Toolbox)
- Post-reconstruction filtering option for unphysiological conductivities (<0 S/m or > 10 S/m)

The package has been tested on MATLAB 2022b, and should be compatible with later MATLAB versions. 
