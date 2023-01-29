# frozen_string_literal: true

require_relative 'adapter'

module Sumaki
  module Config # :nodoc:
    singleton_class.attr_accessor :default_adapter

    self.default_adapter = Sumaki::Adapter::Hash.new
  end
end
