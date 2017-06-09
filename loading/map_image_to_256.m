function I = map_image_to_256(I)
% Contrast normalization to [0:255]
% New_intensity = 
% 255 * (old_intensity - low) / (high - low)
% where 
% high and low are the higher and lower bound of the intensity of the
% original image, respectively
% Parameters: 
%   I: image
% Returns:
%   I: normalized image

  temp_idx = find(I ~= 0);

  if (~isempty(temp_idx))
    LOW = min(I(temp_idx));HIGH = max(I(temp_idx));
  else
    LOW = 0;HIGH = 0;
  end
 
  if ((HIGH-LOW) ~= 0)
    I(temp_idx) = (ceil(255.*((I(temp_idx)-LOW)/(HIGH-LOW))));
  else
    I(temp_idx) = 0;
  end