class SummaryData
  attr_reader :data

  def initialize(data)
    @data = data.transform_keys(&:downcase)
                .transform_keys(&:to_sym)
  end

  def attributes
    data
  end

  def init(code)
    code = code.downcase.to_sym
    @data[code] = 0.0
  end

  def to_json
    @data.to_json
  end

  def update_parent(code, amount_cents, operation)
    upcased_code = code.to_s.upcase
    parent = Entity.find_by(code: upcased_code).parent
    return if parent.nil?

    @data[code] = 0 if @data[code].nil?
    @data[code] = @data[code].send(operation, amount_cents)
    return if parent.root?

    update_parent(parent.code.downcase.to_sym, amount_cents, operation)
  end

  def method_missing(method, *args, &block)
    method_str = method.downcase.to_s
    amount = args[0].to_f

    code  = method_str.gsub(/\+=|-=|=|_cents/, '').to_sym

    if method_str.ends_with? '_cents+='
      @data[code] = 0 if @data[code].nil?
      @data[code] += amount
      update_parent(code, amount, :+)

    elsif method_str.ends_with? '+='
      @data[code] = 0 if @data[code].nil?
      @data[code] += amount
      update_parent(code, amount * 100, :+)

    elsif method_str.ends_with? '_cents-='
      @data[code] = 0 if @data[code].nil?
      @data[code] -= amount
      update_parent(code, amount, :-)

    elsif method_str.ends_with? '-='
      @data[code] = 0 if @data[code].nil?
      @data[code] -= amount
      update_parent(code, amount * 100, :-)

    elsif method_str.ends_with? '_cents='
      @data[code] = amount
      update_parent(code, amount, :+)

    elsif method_str.ends_with? '='
      @data[code] = amount * 100
      update_parent(code, amount * 100, :+)

    elsif method_str.ends_with? '_cents'
      @data[code] 

    else
      @data[method_str.to_sym]&.send(:/, 100)
    end
  end
end
