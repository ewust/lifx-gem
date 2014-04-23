# Goes through the color wheel, given a time (seconds) period as argv[1]
#
# To run: bundle; bundle exec ruby wheel.rb

require 'bundler'
Bundler.require

lifx = LIFX::Client.lan
lifx.discover!
sleep 2 # Wait for tag data to come back

light = if lifx.tags.include?('CLI')
  lights = lifx.lights.with_tag('CLI')
  if lights.empty?
    puts "No lights in the CLI tag, using the first light found."
    lifx.lights.first
  else
    lights
  end
else
  lifx.lights.first
end

if !light
  puts "No LIFX lights found."
  exit 1
end

puts "Using light(s): #{light}"

period, = ARGV
period = period.to_i

step = 1

if period < 360
    step = 360.0/period
end

light.turn_on!
h = 0
while true do
    puts "h=#{h}"
    light.set_color(LIFX::Color.hsb(h.to_i, 1, 1), duration: 1)
    lifx.flush
    sleep (period/360.0).floor + 1
    h += step
    h %= 360.0
end




