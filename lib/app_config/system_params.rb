# -*- encoding : utf-8 -*-
module AppConfig

  class SystemParamsHash < HashWithIndifferentAccess
    attr_accessor :group_prefix

    alias get_item []

    def [](symbol)
      if has_key?(symbol)
        get_item(symbol)
      elsif has_key?(method = (group_prefix.to_s + symbol.to_s).to_sym)
        get_item(method)
      else
        self.clone.add_group_prefix(symbol.to_s)
      end
    end

    def method_missing(symbol, *args)
      method = (self.group_prefix.to_s + symbol.to_s).to_sym

      if has_key?(method)
        get_item(method)
      else
        super
      end
    end

    def add_group_prefix(prefix)
      @group_prefix = @group_prefix.to_s + prefix.to_s + '_'
      self
    end
  end

  class SystemParams

    CHECK_UPDATES_PERIOD = 60.minutes

    def self.[](symbol)
      if (result = data[symbol])
        result
      else
        raise "Param #{symbol.to_s} is not defined"
      end
    end

    protected

    def self.data
      @@cache ||= init_cache
      check_updates if Time.now - @@last_update >= CHECK_UPDATES_PERIOD
      return @@cache
    end

    def self.init_cache
      @@last_update = Time.now
      @@state = current_state
      SystemParam.all.inject(SystemParamsHash.new) do |result, record|
        result.merge!(record.name.mb_chars.downcase.to_sym => record.value)
      end
    end

    def self.check_updates
      @@last_update = Time.now
      c_state = current_state
      if (c_state[:updated_at] > @@state[:updated_at]) || (c_state[:size] != @@state[:size])
        init_cache
      end
    end

    def self.current_state
      result = ActiveRecord::Base.connection.execute <<-SQL
        SELECT COUNT(*) as size, COALESCE(MAX(updated_at), now()) as updated_at FROM #{SystemParam.quoted_table_name}
      SQL
      {:size => result.first['size'], :updated_at => result.first['updated_at'].to_time}
    end

    def self.table_exists?
      ActiveRecord::Base.connection.table_exists?(SystemParam.quoted_table_name)
    end
  end
end