# Turns light on, off, or sets its color
#
# To run: bundle; bundle exec ruby cli.rb [command]

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

cmd, = ARGV


if cmd == 'on'
    puts "Turning on"
    light.turn_on!
elsif cmd == 'off'
    puts "Turning off"
    light.turn_off!
elsif cmd == 'hsb'
    cmd, h, s, b = ARGV
    light.set_color(LIFX::Color.hsb(h.to_i, s.to_f, b.to_f), duration: 1.0)
else
    puts "Weird cmd: #{cmd}"
    exit 1
end

lifx.flush

