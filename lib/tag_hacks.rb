class Tag < ActiveRecord::Base

  def to_param
      "#{id}-#{name.gsub(/[^a-z0-9]+/i, '-')}"
    end

    def self.search_fields
      ['name']
    end

end