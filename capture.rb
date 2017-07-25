#!/usr/bin/env ruby

require 'opencv'
include OpenCV

QUALITY = 30
FPS=10
DIFF_THRESHOLD = 3

Dir.mkdir("data") unless Dir.exists?("data")

capture = OpenCV::CvCapture.open
sleep(1)

last_image = nil

while true do
  image = capture.query
  fname = "#{Time.now.strftime('%Y%m%d%H%M%S%L')}.jpeg"

  write_image = true

  unless last_image.nil?
    diff = image.abs_diff(last_image)
    write_image = diff.avg[0] > DIFF_THRESHOLD
  end

  last_image = image
  image = OpenCV::IplImage::decode_image(image.encode(".jpg", OpenCV::CV_IMWRITE_JPEG_QUALITY => QUALITY))
  image.save("data/#{fname}") if write_image
  sleep(1/FPS)
end

capture.close

