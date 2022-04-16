require 'rubyserial'

class NumatoGPIO

  attr_accessor :device
  attr_accessor :io_map
  attr_accessor :mock
  attr_accessor :verbose

  def initialize(params={})
    {
      mock: false,
      verbose: false,
      io_map: {},
    }.merge(params).each { |k, v| send("#{k}=", v) }
    open_device
  end

  def open_device
    return if @mock
    unless @device
      devices = Dir.glob('/dev/tty.usbmodem*')
      raise "More than one device: #{devices.join(', ')}" if devices.length > 2
      @device = devices.first
    end
    @port = Serial.new(@device)
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
    command("gpio set #{gpio_str(io_id_to_num(x))}", false)
  end

  def clear(x)
    command("gpio clear #{gpio_str(io_id_to_num(x))}", false)
  end

  def read(x)
    status = command("gpio read #{gpio_str(io_id_to_num(x))}", true)
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

  IONames = ('0'..'9').to_a + ('A'..'V').to_a.freeze

  def gpio_str(x)
    IONames[x] or raise "Can't convert GPIO number #{x.inspect} to string"
  end

  def io_id_to_num(x)
    case x
    when Numeric
      x
    when Symbol
      @io_map[x] or raise "No IO ID #{x.inspect}"
    else
      raise "Can't convert #{x.class} to IO: #{x.inspect}"
    end
  end

end

if $0 == __FILE__

  gpio = NumatoGPIO.new(mock: true)

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