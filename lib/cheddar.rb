class String
  def human_to_number(slang_enabled=false)
    mapping = {hundred: 100, thousand: 1000}
    %w(m b tr quadr quint sext sept oct non dec undec duodec tredec quattuordec quindec sexdec septemdec octodec novemdec vigint).inject(1000) do |m,p|
      mapping["#{p}illion"] = 1000 * m
    end

    if slang_enabled ||
      (defined? String::SLANG_ENABLED &&
       String::SLANG_ENABLED)
      slang = {
        bacon: 1,
        benjamin: 100,
        'big ones' => 1000,
        bills: 1,
        bread: 1,
        buck: 1,
        cabbage: 1,
        cash: 1,
        cheddar: 1,
        cheese: 1,
        clams: 1,
        'c-note' => 100,
        'dead presidents' => 1,
        dolla: 1,
        dollar: 1,
        'double sawbuck' => 20,
        dough: 1,
        fin: 5,
        green: 1,
        greenback: 1,
        jackson: 100,
        kale: 1,
        large: 1000,
        lettuce: 1,
        'long green' => 1,
        loot: 1,
        moolah: 1,
        paper: 1,
        potato: 1,
        potatoes: 1,
        sawbuck: 10,
        scratch: 1,
        scrip: 1,
        twankie: 100
      }
      mapping.merge! slang
    end

    str = self.downcase

    mapping.each do |num_name, value|
      str.gsub!(num_name.to_s, "* #{value}")
    end

    str.gsub!(/[^\d\*\.]/, '')

    eval(str)
  end
end
