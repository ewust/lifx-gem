# Waits until a specified time then turns on the light
#
# To run: bundle; bundle exec ruby alarm.rb

require 'bundler'
Bundler.require

lifx = LIFX::Client.lan
lifx.discover!
sleep 2 # Wait for tag data to come back

light = if lifx.tags.include?('Alarm')
  lights = lifx.lights.with_tag('Alarm')
  if lights.empty?
    puts "No lights in the Build Light tag, using the first light found."
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

light.turn_on!
light.set_color(LIFX::Color.hsb(40, 1, 0), duration: 0.0)
light.turn_off!



def do_alarm(light, lifx)

    light.set_color(LIFX::Color.hsb(40, 1, 0), duration: 0.0)
    light.turn_on!
    light.set_color(LIFX::Color.hsb(40, 1, 0), duration: 0.0)
    lifx.flush
    for b in (0..1).step(0.05)
        light.set_color(LIFX::Color.hsb(40, 1, b), duration: 5.0)
        sleep 5
        lifx.flush
        puts "b=#{b}"
    end

    for s in 1.step(0.3,-0.05)
        light.set_color(LIFX::Color.hsb(43, s, 1), duration: 5.0)
        sleep 5
        lifx.flush
        puts "s=#{s}"
    end

end

alarm_time = Time.new(2014, 4, 22, 8, 30, 0)
puts "Setting alarm for #{alarm_time}"

while Time.now < alarm_time
    s = ((alarm_time - Time.now)/2).floor + 1
    puts "#{Time.now}: sleeping for #{s} seconds"
    sleep s
end

puts "#{Time.now}: alarm!"

do_alarm(light, lifx)


#begin
#    update_light(light)
#    lifx.flush
#    sleep 0.1
#end while 1

puts "#{Time.now}: Set light!"

lifx.flush
