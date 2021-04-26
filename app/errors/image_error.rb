module Invaders
  class ImageError < StandardError
    INVALID_COORDINATES = "Selected coordinates for the subimage are not valid"
    INVALID_IMAGE_DATA = "Image data must be an array"
    INVALID_IMAGE_ROW_SIZE = "All rows in the image data must have the same size"
    INVALID_IMAGE_COMPARE_SIZE = "Images to be compared must have the same size"
  end
end