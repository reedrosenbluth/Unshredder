require 'rubygems'
require 'chunky_png'
class Array; def sum; inject( nil ) { |sum,x| sum ? sum+x : x }; end; end

image = ChunkyPNG::Image.from_file('input.png')


width = image.dimension.width
height = image.dimension.height
currentWidth = 0
strips = []
x = 0
distancesR = []
distancesL = []
counter = 0
sequence = []
offset = 0

20.times do
	image2 = image.crop(currentWidth, 0, 32, height)
	strips << image2
	currentWidth += 32
end

#puts strips.size

module ChunkyPNG::Color
  def self.hue(pixel)
    r, g, b = r(pixel), g(pixel), b(pixel)
    return 0 if r == b and b == g
     ((180 / Math::PI * Math.atan2((2 * r) - g - b, Math.sqrt(3) * (g - b))) - 90) % 360
  end

  def self.distance(pixel, poxel)
    hue_pixel, hue_poxel = hue(pixel), hue(poxel)
    [(hue_pixel - hue_poxel) % 360, (hue_poxel - hue_pixel) % 360].min
  end
end

index = 0
index2 = 0

sequence << strips[0]
strips.delete_at(0)

19.times do |j|
  distancesR = []
  distancesL = []
  (19-j).times do |z|
    distanceR = []
    distanceL = []
    359.times do |y|
      pixel = sequence[j].get_pixel(31,y)
      pixel2 = strips[z].get_pixel(0,y)
      distanceR << ChunkyPNG::Color.distance(pixel, pixel2)
      pixel3 = sequence[0].get_pixel(0,y)
      pixel4 = strips[z].get_pixel(31,y)
      distanceL << ChunkyPNG::Color.distance(pixel3, pixel4)
    end
    puts distanceR.sum
    puts distanceL.sum
    distancesR << distanceR.sum
    distancesL << distanceL.sum
  end
  print "Right Min = "
  puts distancesR.min
  index = distancesR.index(distancesR.min)
  print "Left Min = "
  puts distancesL.min
  index2 = distancesL.index(distancesL.min)

  puts index
  puts index2

  if distancesR.min < distancesL.min
    sequence << strips[index]
    strips.delete_at(index)
  else
    sequence.insert(0, strips[index2])
    strips.delete_at(index2)
  end
end

#puts sequence

newImage = ChunkyPNG::Image.new(width, height, ChunkyPNG::Color::TRANSPARENT)

w = 0
20.times do
  newImage.replace!(sequence[w], offset_x = offset, offset_y = 0)
  offset += 32
  w += 1
end

output = newImage.save("output.png")
