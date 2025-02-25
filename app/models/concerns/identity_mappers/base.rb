# frozen_string_literal: true

module IdentityMappers
  class Base
    attr_accessor :attributes

    ACCEPTED_ESTABLISHMENT_TYPES = %w[LYC LP].freeze
    FREDURNERESP_MAPPING = %i[uai type category activity tna_sym tty_code tna_code].freeze

    def initialize(attributes)
      Sentry.add_breadcrumb(Sentry::Breadcrumb.new(
                              data: attributes,
                              category: "auth",
                              message: "Trying to parse authentication data"
                            ))

      @attributes = normalize(attributes)
    end

    def map_responsibility(line)
      FREDURNERESP_MAPPING.zip(line.split("$")).to_h
    end

    def responsibilities
      return [] if attributes["FrEduRneResp"].blank?

      Array(attributes["FrEduRneResp"])
        .reject { |line| no_value?(line) }
        .map    { |line| map_responsibility(line) }
        .filter { |line| relevant?(line) }
    end

    def no_value?(line)
      line.blank? || line == "X"
    end

    def relevant?(attrs)
      ACCEPTED_ESTABLISHMENT_TYPES.include?(attrs[:tty_code])
    end

    def establishments
      responsibilities
        .pluck(:uai)
        .map { |uai| Establishment.find_or_create_by!(uai: uai) }
    end

    def create_all_establishments!
      establishments.each(&:fetch_data!)
    end
  end
end
