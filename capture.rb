#!/usr/bin/env ruby

require 'opencv'

QUALITY = 30
FPS=10
DIFF_THRESHOLD = 3

Dir.mkdir("data") unless Dir.exists?("data")

capture = OpenCV::CvCapture.open
sleep(1)

font = OpenCV::CvFont.new(:duplex, :hscale => 0.8, :vslace => 0.8, :italic => false, :thickness => 1)

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
  text_location = OpenCV::CvPoint.new(10, image.height - 10)
  image.put_text!("#{Time.now}", text_location, font, OpenCV::CvColor::Purple)
  image.save("data/#{fname}") if write_image
  sleep(1/FPS)
end

capture.close

