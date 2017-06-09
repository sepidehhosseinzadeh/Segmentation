function [I, I_seg] = load_vessel12(params, patient_num)
% Function for loading 3D volume
%
% Parameters:
%   params:  the dictionary of the parameters
%   patient_num: the id of the patient
% Returns:
%   I:      the scan image
%   I_seg:  the lung mask

  % Load the 3D volume to a double matrix I
  I = double(mha_read_volume(sprintf('%s/VESSEL12_%02d.mhd',params.scansdir,patient_num)));

  % Contrast Normalization
  for i = 1:size(I,3)
    I(:,:,i) = map_image_to_256((I(:,:,i)+1024));
  end

  % Permute the data because mha data are stored as row major, whereas Matlab is column major
  I = mex_permute3D_imagedims(double(I),[2 1 3],[size(I,1) size(I,2) size(I,3)]);

  % Load the lung mask
  % The lungmask is a binary {0,1}, normalize it to {0,255}
  I_seg = 255*double(mha_read_volume(sprintf('%s/VESSEL12_%02d.mhd',params.masksdir,patient_num)));
  I_seg = mex_permute3D_imagedims(I_seg,[2 1 3],[size(I_seg,1) size(I_seg,2) size(I_seg,3)]);

end

