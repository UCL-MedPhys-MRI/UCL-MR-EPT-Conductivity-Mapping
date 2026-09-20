# UCL-MR-EPT-Conductivity-Mapping

UCL MR-EPT Conductivity Mapping is a free MATLAB toolbox for phase-based Magnetic Resonance Electrical Properties Tomography (MR-EPT), that can reconstruct electrical conductivity maps from unwrapped, 2D or 3D MR transmit/transceive phase based on the truncated Helmholtz equation. This toolbox supports various conductivity mapping methods (Karsa A and Shmueli K. 2021. ISMRM. 3774) and allows for advanced noise-suppressed and edge-preserved EPT using image magnitude and tissue segmentations. This implementation enables accelerated EPT reconstruction with parallel computing and produces consistent conductivity maps across various MRI pulse sequences.

This MATLAB package is a major rewrite of the original UCL Conductivity Mapping algorithm (https://xip.uclventures.com/product/MRI_conductivity). 

The current UCL MR-EPT (v2.3) package supports different phase-based methods that are conceptually consistent with the initial work of: [Karsa A and Shmueli K. 2021. ISMRM. Abstract 3774]. This implementation should produce improved conductivity maps with greater consistency across various MRI pulse sequences. Compared with the A. Karsa's implementation, it has the following new features:

- Accelerated reconstruction even without Parallel Computing Toolbox
- Support 2D EPT/conductivity reconstruction
- Improved reconstruction for data with low magnitude contrasts
- Support automatic magnitude weighting, based on estimation from the magnitude data, or by explicit noise map [Luo J, et al. ISMRM. 2024:3682]
- Support parallel computing acceleration (requires MATLAB Parallel Computing Toolbox)
- Post-reconstruction filtering option for unphysiological conductivities (<0 S/m or > 10 S/m)

The package has been tested on MATLAB 2022b, and should be compatible with later MATLAB versions. 
