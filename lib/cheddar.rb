class Cheddar

  attr_accessor :enabled_dialects

  def initialize
    @mapping = {}
    @enabled_dialects = []
  end

  def available_dialects
    @mapping.keys
  end

  def cheddarize
    String.send(:define_method, :human_to_number) do
      Cheddar.parse(self)
    end
  end

  def define(word, number)
    @mapping[@current_dialect] ||= {}
    @mapping[@current_dialect][word] = number
  end

  def dialect(dia)
    @current_dialect = dia
    yield self.class.instance if block_given?
    @mapping[dia]
  end

  def parse(string)
    str = string.downcase

    @enabled_dialects.each do |d|
      @mapping[d].each do |num_name, value|
        unless num_name.is_a? Regexp
          str.gsub!(Regexp.new("(^|\s)#{num_name.to_s}($|\s)"), "* #{value}")
        else
          str.gsub!(num_name, "* #{value}")
        end
      end
    end

    str.gsub!(/[^\d\*\.]/, '')

    eval(str)
  end

  def self.cheddarize
    self.instance.cheddarize
  end

  def self.config
    yield self.instance if block_given?
    self.instance
  end

  def self.instance
    @instance ||= new
  end

  def self.parse(string)
    self.instance.parse(string)
  end
end

Cheddar.config do |c|

  c.dialect(:en_us) do |d|
    d.define :hundred, 100
    d.define :thousand, 1000
    %w(m b tr quadr quint sext sept oct non dec undec duodec tredec quattuordec quindec sexdec septemdec octodec novemdec vigint).inject(1000) do |m,p|
      d.define "#{p}illion", 1000 * m
    end
  end

  c.dialect(:slang_us) do |d|
    %w(bacon bills bread buck cabbage cash cheddar cheese clams dolla dollar dough green greenback kale lettuce loot moolah paper potato potatoes scratch scrip).each { |p| d.define p, 1 }
    %w(benjamin c-note jackson twankie).each { |p| d.define p, 1 }
    d.define 'dead presidents', 1
    d.define 'long green', 1
    d.define 'fin', 5
    d.define 'sawbuck', 10
    d.define 'double sawbuck', 20
    d.define 'large', 1000
    d.define 'big ones', 1000
  end

  c.enabled_dialects = [:en_us, :slang_us]

end
