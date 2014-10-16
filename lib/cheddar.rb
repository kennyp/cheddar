#
# The +Cheddar+ class converts human input strings to numbers.
#
class Cheddar
  attr_accessor :enabled_dialects

  def initialize #:notnew: nothing special going on here
    @mapping = {}
    @enabled_dialects = []
  end

  #
  # Get the list of currently available dialects
  #
  def available_dialects
    mapping.keys
  end

  #
  # Add human_to_number method to the String class
  #
  def cheddarize
    String.send(:define_method, :human_to_number) do
      Cheddar.parse(self)
    end
  end

  # Define a word to number mapping for the current dialect
  #
  # :call-seq:
  #   define(word, number) -> number
  #
  # ==== Parameters
  #
  # * +word+ - string to be mapped to number
  # * +number+ - Number to return when an occurrence of string is found
  #
  def define(word, number)
    mapping[current_dialect] ||= {}
    mapping[current_dialect][word] = number
  end

  # Set the current dialect being operated on when using the define method
  # and optionally pass in a block to define the dialect
  #
  # :call-seq:
  #   dialect(dialect_name) -> {'word' => value...}
  #   dialect(dialect_name){ block } -> {'word' => value...}
  #
  # ==== Parameters
  #
  # * +dialect_name+ - symbol for dialect being worked on
  #
  # ==== Example
  #
  #   ch = Cheddar.new
  #   ch.dialect(:example) do |d|
  #     d.define 'e', 20
  #   end
  #   ch.parse('1 e') #=> 20
  #
  def dialect(dia)
    self.current_dialect = dia
    yield self.class.instance if block_given?
    mapping[dia]
  end

  #
  # convert the given string to it's numeric equivalent
  #
  # ==== Parameters
  #
  # * +string+ - string to be parsed as a number
  #
  def parse(string)
    str = string.downcase

    enabled_dialects.each do |d|
      mapping[d].each { |num_name, value| apply_mapping(num_name, value, str) }
    end

    str.gsub!(/[^\d\*\.]/, '')

    Kernel.eval(str)
  end

  #
  # Add human_to_number method to the String class using the Cheddar singleton
  #
  def self.cheddarize
    instance.cheddarize
  end

  # Get/Configure the Cheddar instance
  #
  # :call-seq:
  #   Cheddar.config -> instance
  #   Cheddar.config { block } -> instance
  #
  # ==== Example
  #
  #   Cheddar.config do |c|
  #     ch.dialect(:example) do |d|
  #       d.define 'e', 20
  #     end
  #   end
  #
  def self.config
    yield instance if block_given?
    instance
  end

  #
  # Get the singleton instance of cheddar applied by cheddarize
  #
  def self.instance
    @instance ||= new
  end

  #
  # Parse using the singleton instance
  #
  def self.parse(string)
    instance.parse(string)
  end

  private

  attr_reader :mapping
  attr_accessor :current_dialect

  def apply_mapping(num_name, value, str)
    if num_name.is_a? Regexp
      str.gsub!(num_name, "* #{value}")
    else
      str.gsub!(Regexp.new("(^|\s)#{num_name}($|\s)"), "* #{value}")
    end
  end
end

Cheddar.config do |c|

  c.dialect(:en_us) do |d|
    d.define :hundred, 100
    d.define :thousand, 1000
    %w(m b tr quadr quint sext sept oct non dec undec duodec tredec quattuordec
       quindec sexdec septemdec octodec novemdec vigint).reduce(1000) do |m, p|
      d.define "#{p}illion", 1000 * m
    end
  end

  c.dialect(:slang_us) do |d|
    %w(bacon bills bread buck cabbage cash cheddar cheese clams dolla dollar
       dough green greenback kale lettuce loot moolah paper potato
       potatoes scratch scrip).each { |p| d.define p, 1 }
    %w(benjamin c-note jackson twankie).each { |p| d.define p, 100 }
    d.define 'dead presidents', 1
    d.define 'long green', 1
    d.define 'fin', 5
    d.define 'sawbuck', 10
    d.define 'double sawbuck', 20
    d.define 'large', 1000
    d.define 'big ones', 1000
  end

  c.dialect(:slang_gb) do |d|
    %w(alan cherry maggie nicker nugget pound quid sov).each do |p|
      d.define p, 1
    end
    %w(plenty purple score).each { |p| d.define p, 20 }
    %w(bullseye mcgarret nifty pinky thrifty).each { |p| d.define p, 50 }
    %w(cenny century longun oneer).each { |p| d.define p, 100 }
    %w(bag gorilla grand large rio).each { |p| d.define p, 1000 }
    d.define 'pony', 25
  end

  c.enabled_dialects = [:en_us, :slang_us, :slang_gb]

end
