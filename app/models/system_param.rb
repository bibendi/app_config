# -*- encoding : utf-8 -*-
class SystemParam < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => { :case_sensitive => false }, :length => 10..512
  validates :value, :presence => true, :length => 1..2000
  validates :comment, :presence => true, :length => 10..2000
end