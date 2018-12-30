# class Log
# ---------
# a barebones implementation of a message log,
# yet to be expanded to what it needs to be

class Log
  attr_reader :entries

  def initialize
    @entries = []
  end

  def <<(entry)
    @entries << entry
  end

  def each(&block)
    @entries.each(&block)
  end

  def size
    @entries.size
  end
end