require 'rubygems'
require 'chunky_png'

image = ChunkyPNG::Image.from_file('inputS.png')

width = image.dimension.width
height = image.dimension.height
currentWidth = 0
strips = []
offset = 0

20.times do
  image2 = image.crop(currentWidth, 0, 32, height)
  strips << image2
  currentWidth += 32
end

class Array
  def shuffle
    sort_by { rand }
  end

  def shuffle!
    self.replace shuffle
  end
end

strips.shuffle!

newImage = ChunkyPNG::Image.new(width, height, ChunkyPNG::Color::TRANSPARENT)

w = 0
20.times do
  newImage.replace!(strips[w], offset_x = offset, offset_y = 0)
  offset += 32
  w += 1
end

newImage.save("input.png")
