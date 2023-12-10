require 'rubyserial'

class NumatoGPIO

  attr_accessor :device
  attr_accessor :mock
  attr_accessor :verbose

  def initialize(params={})
    {
      mock: false,
      device: nil,
      verbose: false,
    }.merge(params).each { |k, v| send("#{k}=", v) }
    open_device
  end

  def open_device
    return if @mock
    raise "No device set!" unless @device
    begin
      @port = Serial.new(@device)
    rescue RubySerial::Error => e
      raise "Can't open device #{@device.inspect}: #{e}"
    end
    warn "connected to device #{@device}" if @verbose
  end

  def version
    command('ver')
  end

  def id
    command('id get')
  end

  def id=(id)
    #FIXME
    raise
  end

  def set(x)
    command("gpio set #{gpio_name(x)}", false)
  end

  def clear(x)
    command("gpio clear #{gpio_name(x)}", false)
  end

  def read(x)
    status = command("gpio read #{gpio_name(x)}", true)
    case status
    when '1'
      true
    when '0'
      false
    else
      raise "Unknown status on read from IO #{x.inspect}: #{status.inspect}"
    end
  end

  private

  def command(cmd, wait_for_response=true)
    warn "* #{cmd}" if @verbose
    return if @mock
    @port.write("#{cmd}\r")
    @port.gets # echo
    if wait_for_response
      response = @port.gets.strip
      #FIXME
      # prompt = @port.gets
      # prompt.strip!
      # if prompt != '>'
      #   raise "Expected prompt, but got #{prompt.inspect}"
      # end
      response
    end
  end

  GPIONames = ('0'..'9').to_a + ('A'..'V').to_a.freeze

  def gpio_name(x)
    GPIONames[x] or raise "Can't convert GPIO number #{x.inspect} to name"
  end

end

if $0 == __FILE__

  gpio = NumatoGPIO.new(device: '/dev/tty.usbmodem1101', verbose: true)

  puts "ID: #{gpio.id}"

  gpio.clear(0)
  gpio.clear(1)

  gpio.set(1)

  3.times do |i|
    puts i
    gpio.set(0)
    sleep 0.5
    gpio.clear(0)
    sleep 0.5
  end

  gpio.clear(1)

end