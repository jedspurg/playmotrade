# Patch for ransack (https://github.com/ernie/ransack) to use scopes
# Helps migrating from Searchlogic or MetaSearch
# Place this file into config/initializer/ransack.rb of your Rails 3.2 project
#
# Usage:
#   class Debt < ActiveRecord::Base
#     scope :overdue, lambda { where(["status = 'open' AND due_date < ?", Date.today]) }
#   end
#
#   Ransack out of the box ignores scopes. Example:
#     Debt.ransack(:overdue => true, :amount_gteq => 10).result.to_sql
#      => "SELECT `debts`.* FROM `debts` AND (`debts`.`amount` >= 10.0)"
#
#   This is changed by the patch. Example:
#     Debt.ransack_with_scopes(:overdue => true).result.to_sql
#     => "SELECT `debts`.* FROM `debts`  WHERE `debts`.`status` = 'open' AND (due_date < '2012-11-23') AND (`debts`.`amount` >= 10.0)"
#
# BEWARE: Every scope (and class method) of the model is available. This may be a security issue!
#
module Ransack
  module Adapters
    module ActiveRecord
      module Base
        def ransack_with_scopes(params = {}, options = {})
          ransack_scope = self
          ransack_params = {}

          # Extract params which refer to a scope
          (params||{}).each_pair do |k,v|
            if ransack_scope.respond_to_with_joined_scope?(k)
              ransack_scope = if (v == true || v == 'true')
                ransack_scope.send(k)
              else
                v.blank? ? ransack_scope : ransack_scope.send(k, v)
              end
            else
              ransack_params.merge!(k => v) unless v.blank? && v != false
            end
          end

          ransack_scope.ransack_without_scopes(ransack_params, options)
        end

        alias_method_chain :ransack, :scopes
        # alias_method :search, :ransack
      end
    end
  end
end


# Keep until ransack PR 205 is merged into upstream
module Ransack
  module Adapters
    module ActiveRecord
      module Base
        def ransackable_search_term?(term)
          Ransack::Nodes::Grouping.new(Ransack::Context.for(self), "and").attribute_method?(term.to_s)
        end
      end
    end
  end

  module Configuration
    self.options[:ignore_unknown_conditions] = true

    def ignore_unknown_conditions=(value)
      self.options[:ignore_unknown_conditions] = value
    end
  end

  class UnknownConditionError < StandardError; end;

  class Search
    def build(params)
      collapse_multiparameter_attributes!(params).each do |key, value|
        case key
        when 's', 'sorts'
          send("#{key}=", value)
        else
          if base.attribute_method?(key)
            base.send("#{key}=", value) if base.attribute_method?(key)
          else
            raise UnknownConditionError, "Unknown search condition: #{key}" unless Ransack.options[:ignore_unknown_conditions]
          end
        end
      end
      self
    end
  end
end

Ransack.configure do |config|
  # https://github.com/ernie/ransack/wiki/Custom-Predicates
  config.add_predicate 'gte', :arel_predicate => 'gteq'
  config.add_predicate 'lte', :arel_predicate => 'lteq'
  config.add_predicate 'is', :arel_predicate => 'eq'
  config.add_predicate 'is_not', :arel_predicate => 'not_eq'
  config.add_predicate 'not_is', :arel_predicate => 'not_eq'
  config.add_predicate 'any', :arel_predicate => 'in'
  config.add_predicate 'not_any', :arel_predicate => 'not_in'
  config.add_predicate 'is_any', :arel_predicate => 'in'
  config.add_predicate 'is_not_any', :arel_predicate => 'not_in'
  config.add_predicate 'like', :arel_predicate => 'matches', :formatter => proc {|v| "%#{Ransack::Constants.escape_wildcards(v)}%"}
  config.add_predicate 'not_like', :arel_predicate => 'does_not_match', :formatter => proc {|v| "%#{Ransack::Constants.escape_wildcards(v)}%"}
  config.add_predicate 'begins_with', :arel_predicate => 'matches', :formatter => proc {|v| "#{Ransack::Constants.escape_wildcards(v)}%"}
  config.add_predicate 'ends_with', :arel_predicate => 'matches', :formatter => proc {|v| "%#{Ransack::Constants.escape_wildcards(v)}"}

  config.ignore_unknown_conditions = false
end
