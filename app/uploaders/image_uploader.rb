class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # storage :fog

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url
    "https://s3.eu-central-1.amazonaws.com/sybookstore/images/" + [version_name, "default.png"].compact.join('_')
    # "#{Rails.root}/spec/fixtures/16.png"
  end

  process resize_to_fit: [700, 700]

  version :thumb do
    process resize_to_fit: [70, 70]
  end

  version :small do
    process resize_to_fit: [120, 120]
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end
end
